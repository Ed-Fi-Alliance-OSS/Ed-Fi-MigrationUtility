-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating [edfi].[CredentialGradeLevel]'
GO

CREATE TABLE [edfi].[CredentialGradeLevel]
(
[CredentialIdentifier] [nvarchar] (60) NOT NULL,
[GradeLevelDescriptorId] [int] NOT NULL,
[StateOfIssueStateAbbreviationDescriptorId] [int] NOT NULL,
[CreateDate] [datetime] NOT NULL 
)
GO

;WITH [StaffCredentialGradeLevels] AS
(
SELECT
	[StaffUSI],
	[CredentialFieldDescriptorId],
	[CredentialTypeId],
	[LevelDescriptorId],
	[TeachingCredentialDescriptorId],
	[CredentialIssuanceDate],
	[migration_tempdata].[leveldescriptor_to_gradeleveldescriptor] ([LevelDescriptorId]) AS [GradeLevelDescriptorId],
	[StateOfIssueStateAbbreviationTypeId]
	FROM [edfi].[StaffCredential]
)
INSERT [edfi].[CredentialGradeLevel]
(
	[CredentialIdentifier],
	[GradeLevelDescriptorId],
	[StateOfIssueStateAbbreviationDescriptorId],
	[CreateDate]
)
SELECT DISTINCT
	s.[CredentialIdentifier],
	g.[GradeLevelDescriptorId],
	s.[StateOfIssueStateAbbreviationDescriptorId],
	GETDATE()
FROM StaffCredentialGradeLevels g
INNER JOIN [migration_tempdata].[StaffCredentialIdentityMapping] s
ON g.[StaffUSI] = s.[StaffUSI]
	AND g.[CredentialFieldDescriptorId] = s.[CredentialFieldDescriptorId]
	AND g.[CredentialTypeId] = s.[CredentialTypeId]
	AND g.[LevelDescriptorId] = s.[LevelDescriptorId]
	AND g.[TeachingCredentialDescriptorId] = s.[TeachingCredentialDescriptorId]
	AND g.[CredentialIssuanceDate] = s.[CredentialIssuanceDate]
WHERE g.[GradeLevelDescriptorId] IS NOT NULL