﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using DbUp.Engine;
using DbUp.Helpers;
using EdFi.Ods.Utilities.Migration.Configuration;
using EdFi.Ods.Utilities.Migration.Enumerations;
using EdFi.Ods.Utilities.Migration.Helpers;
using EdFi.Ods.Utilities.Migration.Logging;
using EdFi.Ods.Utilities.Migration.Providers;
using log4net;

namespace EdFi.Ods.Utilities.Migration.MigrationManager
{
    public abstract class OdsVersionSpecificMigrationManager<TConfiguration> : IOdsVersionSpecificMigrationManager
        where TConfiguration : MigrationConfigurationVersionSpecific
    {
        private readonly ILog _logger = LogManager.GetLogger(typeof(OdsVersionSpecificMigrationManager<TConfiguration>));

        protected readonly TConfiguration Configuration;
        private readonly DatabaseEngine _engine;
        private readonly IUpgradeEngineBuilderProvider _upgradeEngineBuilderProvider;
        private bool _configurationValidated;
        public UpgradeVersionConfiguration UpgradeVersionConfiguration { get; }
        public string UpgradeJournalTableName => Configuration.ToVersion.UpgradeJournalTableName;


        protected OdsVersionSpecificMigrationManager(TConfiguration configuration,
            UpgradeVersionConfiguration upgradeVersionConfiguration, IUpgradeEngineBuilderProvider upgradeEngineBuilderProvider)
        {
            Configuration = configuration;
            _engine = DatabaseEngine.TryParseEngine(Configuration.Engine);
            _upgradeEngineBuilderProvider = upgradeEngineBuilderProvider;
            UpgradeVersionConfiguration = upgradeVersionConfiguration;
        }

        protected abstract Dictionary<string, string> GetSqlSubstitutionVariables();

        public void ValidateConfigurationState()
        {
            if (!_configurationValidated)
            {
                var commonConfiguration = (MigrationConfigurationVersionSpecific) Configuration;

                RaiseErrorIfMissingOrInvalidScriptLocation(commonConfiguration);
                RaiseErrorIfLoggingRequirementsNotMet(commonConfiguration);
                ValidateVersionSpecificConfigurationState(Configuration);
            }

            _configurationValidated = true;
        }

        public OdsUpgradeResult PerformUpgrade()
        {
            var upgradeResult = new OdsUpgradeResult();

            try
            {
                foreach (var step in MigrationStep.GetAll().OrderBy(x => x.ExecutionOrder))
                {
                    var stepUpgradeResult = PerformUpgradeStep(step);
                    upgradeResult.AddUpgradeResult(stepUpgradeResult);
                    if (!upgradeResult.Successful)
                    {
                        break;
                    }

                    if (!stepUpgradeResult.ScriptsExecuted.Any())
                    {
                        _logger.Info($"No upgrade scripts for this version found in directory {step.FolderName}");
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.Error($"Migration halted due to the following error: {ex.Message}");
                throw;
            }

            return upgradeResult;
        }

        private OdsUpgradeResult PerformUpgradeStep(MigrationStep step, params UpgradeOption[] upgradeOptions)
        {
            var stepUpgradeResult = new OdsUpgradeResult();
            var upgradeStepDirectories = GetUpgradeStepDirectories(step);

            foreach (var directory in upgradeStepDirectories)
            {
                stepUpgradeResult.AddStepResult(directory, ExecuteUpgradeScriptsInDirectory(directory, upgradeOptions));
                if (!stepUpgradeResult.Successful)
                {
                    return stepUpgradeResult;
                }
            }

            return stepUpgradeResult;
        }

        public OdsUpgradeResult RunDatabaseCompatibilityCheck()
        {
            var compatibilityCheckResult = new OdsUpgradeResult();

            try
            {
                var setupResult = PerformUpgradeStep(MigrationStep.Setup, UpgradeOption.NullJournal);
                compatibilityCheckResult.AddUpgradeResult(setupResult);

                if (setupResult.Successful)
                {
                    compatibilityCheckResult.AddUpgradeResult(PerformUpgradeStep(MigrationStep.CompatibilityCheck,
                        UpgradeOption.NullJournal));
                }
            }
            finally
            {
                PerformUpgradeStep(MigrationStep.Cleanup, UpgradeOption.NullJournal);
            }

            return compatibilityCheckResult;
        }

        private IEnumerable<string> GetUpgradeStepDirectories(MigrationStep step)
        {
            var upgradeStepDirectories = new List<string>();

            var baseDirectory =
                Path.GetFullPath(Path.Combine(Configuration.BaseMigrationScriptFolderPath, _engine.ScriptsFolderName,
                    step.FolderName));

            if (Directory.GetFiles(baseDirectory, "*.sql").Length > 0)
            {
                upgradeStepDirectories.Add(baseDirectory);
            }

            var versionDirectory =
                Path.Combine(baseDirectory, Configuration.MigrationScriptVersionSpecificDirectoryName);

            if (Directory.Exists(versionDirectory))
            {
                if (Directory.GetFiles(versionDirectory, "*.sql").Length > 0)
                {
                    upgradeStepDirectories.Add(versionDirectory);
                }

                upgradeStepDirectories.AddRange(Directory
                    .GetDirectories(versionDirectory, "*", SearchOption.AllDirectories)
                    .OrderBy(d => d)
                    .ToList());
            }

            foreach (var previouslyInstalledFeature in UpgradeVersionConfiguration.FeaturesBeforeUpgrade)
            {
                var featureVersionDirectory = Path.Combine(baseDirectory,
                    Configuration.MigrationScriptFeatureVersionSpecificDirectoryName(previouslyInstalledFeature));

                if (Directory.Exists(featureVersionDirectory))
                {
                    if (Directory.GetFiles(featureVersionDirectory, "*.sql").Length > 0)
                    {
                        upgradeStepDirectories.Add(featureVersionDirectory);
                    }

                    upgradeStepDirectories.AddRange(Directory
                        .GetDirectories(featureVersionDirectory, "*", SearchOption.AllDirectories)
                        .OrderBy(d => d)
                        .ToList());
                }
            }

            return upgradeStepDirectories;
        }

        private DatabaseUpgradeResult ExecuteUpgradeScriptsInDirectory(string fullPath, params UpgradeOption[] upgradeOptions)
        {
            _logger.Info($"Executing scripts in directory {fullPath}");

            var upgradeEngine = _upgradeEngineBuilderProvider
                .Get(Configuration.DatabaseConnectionString)
                .WithScriptsFromFileSystem(fullPath, Encoding.UTF8)
                .WithTransactionPerScript()
                .WithExecutionTimeout(TimeSpan.FromSeconds(Configuration.Timeout))
                .LogScriptOutput()
                .LogTo(new DbUpLogger());

            if (_engine == DatabaseEngine.SqlServer)
            {
                upgradeEngine.WithVariables(GetSqlSubstitutionVariables());
            }
            else
            {
                upgradeEngine.WithVariablesDisabled();
            }

            if (upgradeOptions.Contains(UpgradeOption.NullJournal))
            {
                upgradeEngine.JournalTo(new NullJournal());
            }
            else
            {
                _upgradeEngineBuilderProvider.SetupJournalTable(upgradeEngine, UpgradeJournalTableName);
            }

            upgradeEngine.Build();

            var result = upgradeEngine.Build().PerformUpgrade();

            return result;
        }

        protected virtual void ValidateVersionSpecificConfigurationState(TConfiguration configuration)
        {
        }

        private void RaiseErrorIfMissingOrInvalidScriptLocation(MigrationConfigurationVersionSpecific configuration)
        {
            var baseScriptDirectory = configuration.BaseMigrationScriptFolderPath;
            if (!Directory.Exists(baseScriptDirectory))
            {
                throw new DirectoryNotFoundException($"Base script directory not found: {baseScriptDirectory}.");
            }

            var engineSpecificDirectory = Path.Combine(baseScriptDirectory, _engine.ScriptsFolderName);
            if (!Directory.Exists(engineSpecificDirectory))
            {
                throw new DirectoryNotFoundException($"Engine specific script directory not found: {engineSpecificDirectory}");
            }

            var requiredMigrationStepDirectories = MigrationStep.GetAll()
                .Select(s => Path.Combine(engineSpecificDirectory, s.FolderName))
                .ToList();

            var missingDirectoryExceptions =
                requiredMigrationStepDirectories
                    .Where(d => !Directory.Exists(d))
                    .Select(d => new DirectoryNotFoundException($"{nameof(MigrationStep)} Directory Not Found: {d}"))
                    .OrderBy(x => x.Message)
                    .ToList();

            missingDirectoryExceptions.ForEach(x => _logger.Error(x.Message));

            if (missingDirectoryExceptions.Any())
            {
                throw new AggregateException(
                    $"Missing required directory for {nameof(MigrationStep)}. See inner exception for details:{Environment.NewLine}",
                    missingDirectoryExceptions);
            }

            var optionalVersionSpecificDirectories =
                MigrationStep.GetAll()
                    .Where(s => s.ScriptVersionTarget == MigrationStep.VersionTarget.VersionSpecific)
                    .Select(s => Path.Combine(
                        engineSpecificDirectory,
                        s.FolderName,
                        Configuration.MigrationScriptVersionSpecificDirectoryName))
                    .ToList();

            var missingVersionSpecificDirectories =
                optionalVersionSpecificDirectories
                    .Where(d => !Directory.Exists(d))
                    .Select(d => $"{nameof(MigrationStep)} Directory Not Found: {d}.  Skipping Directory.")
                    .OrderBy(x => x)
                    .ToList();

            missingVersionSpecificDirectories.ForEach(x => _logger.Info(x));

            // Must have at least one version specific directory
            if (missingVersionSpecificDirectories.Count == MigrationStep.GetAll()
                .Count(s => s.ScriptVersionTarget == MigrationStep.VersionTarget.VersionSpecific))
            {
                throw new AggregateException(
                    $"Version Specific Directories Not Found. At least one '{Configuration.MigrationScriptVersionSpecificDirectoryName}' directory must exist.");
            }
        }

        private void RaiseErrorIfLoggingRequirementsNotMet(MigrationConfigurationVersionSpecific configuration)
        {
            var duplicateScriptExceptions =
                GetScriptList(configuration)
                    .GroupBy(scriptName => scriptName)
                    .Where(g => g.Count() > 1)
                    .Select(g => new Exception($"Found {g.Count()} scripts with the name {g.Key} "))
                    .ToList();

            foreach (var exception in duplicateScriptExceptions.OrderBy(x => x.Message))
            {
                _logger.Error(exception.Message);
            }

            if (duplicateScriptExceptions.Any())
            {
                throw new AggregateException(
                    "Found one or more scripts with the same name: see inner exception for details.  All script names must be unique, even if they exist in different subdirectories.  This is required in order to accurately track the history of executed scripts.",
                    duplicateScriptExceptions);
            }
        }

        private static IEnumerable<string> GetScriptList(MigrationConfigurationVersionSpecific configuration)
        {
            DatabaseEngine engine = DatabaseEngine.TryParseEngine(configuration.Engine);

            var path = Path.Combine(configuration.BaseMigrationScriptFolderPath, engine.ScriptsFolderName);

            return Directory.GetFiles(path, "*.sql", SearchOption.AllDirectories)
                .Select(Path.GetFileName);
        }

        private enum UpgradeOption
        {
            NullJournal
        }
    }
}