-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Updating [dbo].[VersionLevel]'
GO

IF OBJECT_ID(N'[dbo].[VersionLevel]', 'U') IS NULL
CREATE TABLE [dbo].[VersionLevel]
(
[ScriptSource] [varchar] (256) NOT NULL,
[ScriptType] [varchar] (256) NOT NULL,
[DatabaseType] [varchar] (256) NOT NULL,
[SubType] [varchar] (1024) NULL,
[VersionLevel] [int] NOT NULL
) 
GO

-- Ensure SubTypes that are null are set to empty string to handle potential migration utility error in v24 to v25 and v25 to v31 migrations
UPDATE [dbo].[VersionLevel]
SET [SubType] = ''
WHERE [SubType] IS NULL
GO

DECLARE @EdFiVersionLevel TABLE
(
[ScriptSource] [varchar] (256) NOT NULL,
[ScriptType] [varchar] (256) NOT NULL,
[DatabaseType] [varchar] (256) NOT NULL,
[SubType] [varchar] (1024) NULL,
[VersionLevel] [int] NOT NULL
)

INSERT @EdFiVersionLevel ([ScriptSource], [ScriptType], [DatabaseType], [SubType], [VersionLevel])
VALUES
('ED-FI-ODS','STRUCTURE', 'EDFI', '', $EdFiOdsStructureVersionLevel$),
('ED-FI-ODS','DATA', 'EDFI', '', $EdFiOdsDataVersionLevel$)

INSERT [dbo].[VersionLevel] ([ScriptSource], [ScriptType], [DatabaseType], [SubType], [VersionLevel])
SELECT e.[ScriptSource], e.[ScriptType], e.[DatabaseType], e.[SubType], e.[VersionLevel]
FROM @EdFiVersionLevel e
LEFT JOIN [dbo].[VersionLevel] v
    ON e.[ScriptSource] = v.[ScriptSource]
    AND e.[ScriptType] = v.[ScriptType]
    AND e.[DatabaseType] = v.[DatabaseType]
    AND e.[SubType] = v.[SubType]
WHERE v.[ScriptSource] IS NULL

UPDATE [dbo].[VersionLevel]
SET [VersionLevel] = e.[VersionLevel]
FROM [dbo].[VersionLevel] v
INNER JOIN @EdFiVersionLevel e
    ON e.[ScriptSource] = v.[ScriptSource]
    AND e.[ScriptType] = v.[ScriptType]
    AND e.[DatabaseType] = v.[DatabaseType]
    AND e.[SubType] = v.[SubType]
