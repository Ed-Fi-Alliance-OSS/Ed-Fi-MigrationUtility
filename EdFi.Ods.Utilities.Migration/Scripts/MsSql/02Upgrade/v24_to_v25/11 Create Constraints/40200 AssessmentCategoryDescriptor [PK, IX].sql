-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating primary key [AssessmentCategoryDescriptor_PK] on [edfi].[AssessmentCategoryDescriptor]'
GO
ALTER TABLE [edfi].[AssessmentCategoryDescriptor] ADD CONSTRAINT [AssessmentCategoryDescriptor_PK] PRIMARY KEY CLUSTERED  ([AssessmentCategoryDescriptorId])
GO
PRINT N'Creating index [FK_AssessmentCategoryDescriptor_Descriptor] on [edfi].[AssessmentCategoryDescriptor]'
GO
CREATE NONCLUSTERED INDEX [FK_AssessmentCategoryDescriptor_Descriptor] ON [edfi].[AssessmentCategoryDescriptor] ([AssessmentCategoryDescriptorId])
GO
PRINT N'Creating index [FK_AssessmentCategoryDescriptor_AssessmentCategoryType] on [edfi].[AssessmentCategoryDescriptor]'
GO
CREATE NONCLUSTERED INDEX [FK_AssessmentCategoryDescriptor_AssessmentCategoryType] ON [edfi].[AssessmentCategoryDescriptor] ([AssessmentCategoryTypeId])
GO

