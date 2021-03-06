-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating primary key [StudentCTEProgramAssociation_PK] on [edfi].[StudentCTEProgramAssociation]'
GO
ALTER TABLE [edfi].[StudentCTEProgramAssociation] ADD CONSTRAINT [StudentCTEProgramAssociation_PK] PRIMARY KEY CLUSTERED  ([BeginDate], [EducationOrganizationId], [ProgramEducationOrganizationId], [ProgramName], [ProgramTypeDescriptorId], [StudentUSI])
GO

PRINT N'Creating index [FK_StudentCTEProgramAssociation_TechnicalSkillsAssessmentDescriptor] on [edfi].[StudentCTEProgramAssociation]'
GO
CREATE NONCLUSTERED INDEX [FK_StudentCTEProgramAssociation_TechnicalSkillsAssessmentDescriptor] ON [edfi].[StudentCTEProgramAssociation] ([TechnicalSkillsAssessmentDescriptorId])
GO
