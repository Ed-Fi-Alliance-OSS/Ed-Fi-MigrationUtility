﻿// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System.Collections.Generic;
using EdFi.Ods.Utilities.Migration.Enumerations;

namespace EdFi.Ods.Utilities.Migration.Configuration
{
    public class MigrationConfigurationV51ToV52 : MigrationConfigurationVersionSpecific
    {
        public override EdFiOdsVersion FromVersion => EdFiOdsVersion.V51;
        public override EdFiOdsVersion ToVersion => EdFiOdsVersion.V52;

        public override string MigrationScriptVersionSpecificDirectoryName => "v51_to_v52";

        public override List<string> SupportedEngines => new List<string> {DatabaseEngine.SQLServer, DatabaseEngine.PostgreSQL};
    }
}