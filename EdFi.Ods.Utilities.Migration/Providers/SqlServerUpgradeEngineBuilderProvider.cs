// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using DbUp;
using DbUp.Builder;

namespace EdFi.Ods.Utilities.Migration.Providers
{
    public class SqlServerUpgradeEngineBuilderProvider : IUpgradeEngineBuilderProvider
    {
        public UpgradeEngineBuilder Get(string connectionString) => DeployChanges.To.SqlDatabase(connectionString);

        public void SetupJournalTable(UpgradeEngineBuilder upgradeEngine, string upgradeJournalTableName) =>
            upgradeEngine.JournalToSqlTable("dbo", upgradeJournalTableName);
    }
}