﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection;
using CommandLine;
using EdFi.Ods.Utilities.Migration.Configuration;
using EdFi.Ods.Utilities.Migration.MigrationManager;
using EdFi.Ods.Utilities.Migration.Queries;
using EdFi.Ods.Utilities.Migration.Validation;
using log4net;
using log4net.Config;

namespace EdFi.Ods.Utilities.Migration
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            ConfigureLogging();

            var logger = LogManager.GetLogger(typeof(Program));

            try
            {
                int exitCode = 0;

                var parserResult = new Parser(
                    config =>
                    {
                        config.CaseInsensitiveEnumValues = true;
                        config.CaseSensitive = false;
                    }).ParseArguments<Options>(args);

                parserResult
                    .WithParsed(globalConfiguration => exitCode = Run(globalConfiguration))
                    .WithNotParsed(
                        errors =>
                        {
                            logger.Error(Options.BuildHelpText(parserResult, errors));
                            exitCode = -1;
                        });

                Environment.Exit(exitCode);
            }
            catch (Exception e)
            {
                logger.Error(e.Message);
                Environment.Exit(-1);
            }

            int Run(Options options)
            {
                var optionsValidator = new OptionsValidator(new SqlServerConnectionStringValidator());

                if (!optionsValidator.IsValid(options))
                {
                    return -1;
                }

                logger.Info("Checking Version");
                var currentOdsApiVersion = new GetCurrentOdsApiVersion().Execute(options.DatabaseConnectionString);
                logger.Info($"Current version of the database {currentOdsApiVersion.CurrentVersion}");

                if (currentOdsApiVersion.CurrentVersion.ApiVersion.ToString() == options.RequestedFinalUpgradeVersion)
                {
                    logger.Info($"ODS is already at version {options.RequestedFinalUpgradeVersion}");
                    Environment.Exit(0);
                }

                logger.Info("Building version configuration");

                var upgradeVersionConfiguration = UpgradeVersionConfiguration.BuildValidUpgradeConfiguration(
                    options.DatabaseConnectionString,
                    options.CurrentOdsVersionCommandLineOverride,
                    options.RequestedFinalUpgradeVersion);

                upgradeVersionConfiguration.ApplyFeatures(currentOdsApiVersion.ExistingFeatures.ToList());

                var migrationManager = new OdsMigrationManager(upgradeVersionConfiguration, options);

                OdsUpgradeResult result;
                if (options.CompatibilityCheckOnly)
                {
                    logger.Info(
                        $"Checking compatibility for upgrade to version {upgradeVersionConfiguration.RequestedFinalUpgradeVersion}");
                    result = migrationManager.RunCompatibilityCheck();
                }
                else
                {
                    logger.Info(
                        $"Initializing upgrade to version {upgradeVersionConfiguration.RequestedFinalUpgradeVersion}");
                    result = migrationManager.PerformUpgrade();
                }

                if (result.Error is SqlException sqlException)
                {
                    logger.Error(sqlException);
                    return sqlException.Number == 0 ? -1 : sqlException.Number;
                }

                return result.Successful ? 0 : 1;
            }

            void ConfigureLogging()
            {
                var assembly = typeof(Program).GetTypeInfo().Assembly;

                string configPath = Path.Combine(Path.GetDirectoryName(assembly.Location), "log4net.config");

                XmlConfigurator.Configure(LogManager.GetRepository(assembly), new FileInfo(configPath));
            }
        }
    }
}