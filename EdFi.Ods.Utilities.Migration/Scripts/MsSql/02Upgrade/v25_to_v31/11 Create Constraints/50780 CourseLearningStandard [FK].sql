-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Adding foreign keys to [edfi].[CourseLearningStandard]'
GO
ALTER TABLE [edfi].[CourseLearningStandard] ADD CONSTRAINT [FK_CourseLearningStandard_Course] FOREIGN KEY ([CourseCode], [EducationOrganizationId]) REFERENCES [edfi].[Course] ([CourseCode], [EducationOrganizationId]) ON DELETE CASCADE
GO
ALTER TABLE [edfi].[CourseLearningStandard] ADD CONSTRAINT [FK_CourseLearningStandard_LearningStandard] FOREIGN KEY ([LearningStandardId]) REFERENCES [edfi].[LearningStandard] ([LearningStandardId])
GO
