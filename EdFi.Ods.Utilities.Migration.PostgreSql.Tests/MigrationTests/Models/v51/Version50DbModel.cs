﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using EdFi.Ods.Utilities.Migration.Enumerations;

namespace EdFi.Ods.Utilities.Migration.PostgreSql.Tests.MigrationTests.Models.v51
{
    public abstract class Version51DbModel : DbModelBase
    {
        public override EdFiOdsVersion Version => EdFiOdsVersion.V51;
    }
}
