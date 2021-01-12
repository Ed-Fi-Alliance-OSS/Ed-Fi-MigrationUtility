﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

namespace EdFi.Ods.Utilities.Migration.PostgreSql.Tests.MigrationTests.Models.v51
{
    public class SchoolYearType : Version51DbModel
    {
        [Key]
        public short SchoolYear { get; set; }
        public string SchoolYearDescription { get; set; }
    }
}
