-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Updating [edfi].[AssessmentFamilyContentStandardAuthor]'
GO
ALTER TABLE [edfi].[AssessmentFamilyContentStandardAuthor] ALTER COLUMN [AssessmentFamilyTitle] [nvarchar] (100) NOT NULL
GO