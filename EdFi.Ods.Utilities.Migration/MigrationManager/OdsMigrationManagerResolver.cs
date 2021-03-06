﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using EdFi.Ods.Utilities.Migration.Configuration;
using EdFi.Ods.Utilities.Migration.Enumerations;

namespace EdFi.Ods.Utilities.Migration.MigrationManager
{
    public class OdsMigrationManagerResolver : IOdsMigrationManagerResolver
    {
        private readonly List<OdsMigrationManagerResolverConfiguration> _allMigrationManagerResolverConfigurations =
            new List<OdsMigrationManagerResolverConfiguration>();

        private class OdsMigrationManagerResolverConfiguration
        {
            public OdsMigrationVersionRange VersionRange;
            public Type MigrationManagerType;
            public Type ConfigurationType;
            public List<string> SupportedEngines;
        }

        public OdsMigrationManagerResolver()
        {
            RegisterMigrationManagers(typeof(OdsVersionSpecificMigrationManager<>));
        }

        private void RegisterMigrationManagers(Type migrationManagerBaseType)
        {
            var migrationManagers = Assembly
                .GetExecutingAssembly()
                .GetExportedTypes()
                .Where(t =>
                    t.BaseType != null
                    && t.BaseType.IsGenericType
                    && migrationManagerBaseType.IsAssignableFrom(t.BaseType.GetGenericTypeDefinition()))
                .ToList();

            migrationManagers.ForEach(RegisterMigrationManagerResolver);
            _allMigrationManagerResolverConfigurations
                .Sort((x, y) => x.VersionRange.FromVersion.CompareTo(y.VersionRange.FromVersion));
        }

        private void RegisterMigrationManagerResolver(Type migrationManager)
        {
            var configurationType = migrationManager
                .BaseType
                .GetGenericArguments()
                .First(t => t.BaseType == typeof(MigrationConfigurationVersionSpecific));

            var configuration = (MigrationConfigurationVersionSpecific) Activator.CreateInstance(configurationType);

            var resolverConfiguration = new OdsMigrationManagerResolverConfiguration
            {
                VersionRange = new OdsMigrationVersionRange
                {
                    FromVersion = configuration.FromVersion,
                    ToVersion = configuration.ToVersion,
                },
                MigrationManagerType = migrationManager,
                ConfigurationType = configurationType,
                SupportedEngines = configuration.SupportedEngines,
            };

            _allMigrationManagerResolverConfigurations.Add(resolverConfiguration);
            Validate(resolverConfiguration);
        }

        private void Validate(OdsMigrationManagerResolverConfiguration configuration)
        {
            if (configuration.VersionRange.FromVersion.ApiVersion >= configuration.VersionRange.ToVersion.ApiVersion)
            {
                throw new InvalidOperationException(
                    $"OdsMigrationManagerResolver configuration error:  Cannot upgrade API version {configuration.VersionRange.FromVersion.ApiVersion} to {configuration.VersionRange.ToVersion.ApiVersion}");
            }

            var registeredFromVersions = _allMigrationManagerResolverConfigurations
                .Count(x => x.VersionRange.FromVersion == configuration.VersionRange.FromVersion);

            if (registeredFromVersions != 1)
            {
                throw new InvalidOperationException(
                    $"Found {registeredFromVersions} registered upgrade configurations from version {configuration.VersionRange.FromVersion}, but expected only 1");
            }

            var registeredToVersions = _allMigrationManagerResolverConfigurations
                .Count(x => x.VersionRange.ToVersion == configuration.VersionRange.ToVersion);

            if (registeredToVersions != 1)
            {
                throw new InvalidOperationException(
                    $"Found {registeredToVersions} registered upgrade configurations to version {configuration.VersionRange.ToVersion}, but expected only 1");
            }
        }

        public List<OdsMigrationVersionRange> GetVersionRanges(EdFiOdsVersion fromVersion, EdFiOdsVersion toVersion) =>
            _allMigrationManagerResolverConfigurations
                .SkipWhile(x => x.VersionRange.FromVersion != fromVersion)
                .TakeWhile(x => x.VersionRange.ToVersion != toVersion)
                .Union(_allMigrationManagerResolverConfigurations.Where(x => x.VersionRange.ToVersion == toVersion))
                .Select(x => x.VersionRange)
                .ToList();

        public Type GetConfigurationType(EdFiOdsVersion fromVersion, EdFiOdsVersion toVersion) =>
            GetResolverConfiguration(fromVersion, toVersion)?.ConfigurationType;

        public Type GetMigrationManagerType(EdFiOdsVersion fromVersion, EdFiOdsVersion toVersion) =>
            GetResolverConfiguration(fromVersion, toVersion)?.MigrationManagerType;

        private OdsMigrationManagerResolverConfiguration GetResolverConfiguration(EdFiOdsVersion fromVersion, EdFiOdsVersion _) =>
            _allMigrationManagerResolverConfigurations
                .First(x => x.VersionRange.FromVersion == fromVersion);

        public List<EdFiOdsVersion> GetAllUpgradableVersions(string engine) =>
            _allMigrationManagerResolverConfigurations
                .Where(x => x.SupportedEngines.Contains(engine, StringComparer.InvariantCultureIgnoreCase))
                .Select(x => x.VersionRange.FromVersion)
                .ToList();

        public List<EdFiOdsVersion> GetSupportedUpgradeVersions(EdFiOdsVersion fromVersion, string engine) =>
            _allMigrationManagerResolverConfigurations
                .Where(x => x.SupportedEngines.Contains(engine, StringComparer.InvariantCultureIgnoreCase))
                .SkipWhile(x => x.VersionRange.FromVersion != fromVersion)
                .Select(x => x.VersionRange.ToVersion)
                .ToList();

        public EdFiOdsVersion GetLatestSupportedUpgradeVersion(string engine) =>
            _allMigrationManagerResolverConfigurations
                .Where(x => x.SupportedEngines.Contains(engine, StringComparer.InvariantCultureIgnoreCase))
                .Select(x => x.VersionRange.ToVersion)
                .LastOrDefault();

        public EdFiOdsVersion GetLatestSupportedUpgradeVersion(EdFiOdsVersion fromVersion, string engine) =>
            GetSupportedUpgradeVersions(fromVersion, engine)
                .LastOrDefault();

        public bool VersionCanBeUpgraded(EdFiOdsVersion version, string engine) =>
            _allMigrationManagerResolverConfigurations
                .Where(x => x.SupportedEngines.Contains(engine, StringComparer.InvariantCultureIgnoreCase))
                .Select(x => x.VersionRange.FromVersion)
                .Contains(version);
    }
}