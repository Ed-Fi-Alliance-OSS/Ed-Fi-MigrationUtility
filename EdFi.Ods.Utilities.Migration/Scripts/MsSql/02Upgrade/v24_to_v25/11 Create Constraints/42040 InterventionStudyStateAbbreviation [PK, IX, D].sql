-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating primary key [InterventionStudyStateAbbreviation_PK] on [edfi].[InterventionStudyStateAbbreviation]'
GO
ALTER TABLE [edfi].[InterventionStudyStateAbbreviation] ADD CONSTRAINT [InterventionStudyStateAbbreviation_PK] PRIMARY KEY CLUSTERED  ([InterventionStudyIdentificationCode], [EducationOrganizationId], [StateAbbreviationTypeId])
GO
PRINT N'Creating index [FK_InterventionStudyStateAbbreviation_InterventionStudy] on [edfi].[InterventionStudyStateAbbreviation]'
GO
CREATE NONCLUSTERED INDEX [FK_InterventionStudyStateAbbreviation_InterventionStudy] ON [edfi].[InterventionStudyStateAbbreviation] ([InterventionStudyIdentificationCode], [EducationOrganizationId])
GO
PRINT N'Creating index [FK_InterventionStudyStateAbbreviation_StateAbbreviationType] on [edfi].[InterventionStudyStateAbbreviation]'
GO
CREATE NONCLUSTERED INDEX [FK_InterventionStudyStateAbbreviation_StateAbbreviationType] ON [edfi].[InterventionStudyStateAbbreviation] ([StateAbbreviationTypeId])
GO

PRINT N'Adding constraints to [edfi].[InterventionStudyStateAbbreviation]'
GO
ALTER TABLE [edfi].[InterventionStudyStateAbbreviation] ADD CONSTRAINT [InterventionStudyStateAbbreviation_DF_CreateDate] DEFAULT (getdate()) FOR [CreateDate]
GO

