﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.IO;
using System.Linq;
using Dapper;
using EdFi.Ods.Utilities.Migration.Configuration;
using EdFi.Ods.Utilities.Migration.Enumerations;
using EdFi.Ods.Utilities.Migration.MigrationManager;
using EdFi.Ods.Utilities.Migration.Tests.Models;
using EdFi.Ods.Utilities.Migration.Tests.Models.v50;
using NUnit.Framework;
using Shouldly;

namespace EdFi.Ods.Utilities.Migration.Tests.MsSql.MigrationTests.v34_to_v50
{
    public abstract class V34ToV50SqlServerMigrationTest : SqlServerMigrationTestBase
    {
        protected override EdFiOdsVersion FromVersion => EdFiOdsVersion.V34;
        protected override EdFiOdsVersion ToVersion => EdFiOdsVersion.V50;
        protected override string TestDataDirectoryName => "v34_to_v50";

        protected OdsUpgradeResult PerformTestMigration(string sourceDataScriptName = null, DynamicParameters scriptParameters = null, string calendarConfigurationFileName = null, string namespacePrefix = null)
        {
            if (sourceDataScriptName != null)
            {
                InsertTestRecords(sourceDataScriptName, scriptParameters);
            }

            var options = new Options {DatabaseConnectionString = ConnectionString, Engine = DatabaseEngine.SQLServer };
            var versionConfiguration =
                SqlServerMigrationTestsGlobalSetup.MigrationConfigurationProvider.Get(options, FromVersion.ToString(), ToVersion.ToString());

            var config = new MigrationConfigurationV34ToV50
            {
                DatabaseConnectionString = ConnectionString,
                BaseMigrationScriptFolderPath = Path.GetFullPath(SqlServerMigrationTestSettingsProvider.GetConfigVariable("BaseMigrationScriptFolderPath")),
                BaseDescriptorXmlDirectoryPath = Path.GetFullPath(SqlServerMigrationTestSettingsProvider.GetConfigVariable("BaseDescriptorXmlDirectoryPath")),
                BypassExtensionValidationCheck = false,
                Timeout = SqlCommandTimeout,
                Engine = DatabaseEngine.SQLServer
            };

            var migrationManager = new OdsMigrationManagerV34ToV50(config, versionConfiguration, SqlServerMigrationTestsGlobalSetup.UpgradeEngineBuilderProvider);
            return RunMigration(migrationManager);
        }

        protected IEnumerable<T> GetV50UpgradeResult<T>() where T : Version50DbModel
        {
            return GetTableContents<T>(ToVersion);
        }

        [Test]
        public void ValidateJournalEntries()
        {
            var databaseReferencesJournalEntries = FetchDatabaseReferencesJournalEntries().ToHashSet();

            PerformTestMigration();

            var deployJournalList = GetTableContents<DeployJournal>("[dbo].[DeployJournal]").Select(
                x => x.ScriptName).ToList().ToHashSet();

            databaseReferencesJournalEntries.SetEquals(deployJournalList).ShouldBeTrue(
                $"The JournalEntries scripts did not match the scripts available to the Migration Utility for  version {ToVersion.DisplayName}.");
        }
    }
}
