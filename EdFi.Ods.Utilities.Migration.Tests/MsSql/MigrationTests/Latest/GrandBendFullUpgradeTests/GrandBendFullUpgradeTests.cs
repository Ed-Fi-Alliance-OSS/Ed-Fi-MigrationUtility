﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using System.Linq;
using EdFi.Ods.Utilities.Migration.Enumerations;
using EdFi.Ods.Utilities.Migration.Tests.Models.v53;
using NUnit.Framework;
using Shouldly;

namespace EdFi.Ods.Utilities.Migration.Tests.MsSql.MigrationTests.Latest.GrandBendFullUpgradeTests
{
    public class GrandBendFullUpgradeTests : GrandBendTests
    {
        protected override EdFiOdsVersion FromVersion => EdFiOdsVersion.V2UpTo24;
        protected override EdFiOdsVersion ToVersion => SqlServerMigrationTestsGlobalSetup.OdsMigrationManagerResolver.GetLatestSupportedUpgradeVersion(FromVersion, DatabaseEngine.SQLServer);

        protected override void UpdateBackupData()
        {
            InsertTestRecords("GrandBendCompatibilityUpdate.sql", null);
        }

        [Test]
        public void SchoolYearTypesShouldBeUpdated()
        {
            var expectedSchoolYearTypes = new List<SchoolYearType>();

            for (short y = 1991; y == 2050; y++)
            {
                expectedSchoolYearTypes.Add(new SchoolYearType
                {
                    SchoolYear = y,
                    SchoolYearDescription = $"{y - 1}-{y}"
                });
            }

            var grandBendSchoolYearTypes = GetTableContents<SchoolYearType>(ToVersion).ToList();

            foreach (var expected in expectedSchoolYearTypes)
            {
                grandBendSchoolYearTypes.Single(y => y == expected).SchoolYearDescription.ShouldBe(expected.SchoolYearDescription);
            }
        }
    }
}