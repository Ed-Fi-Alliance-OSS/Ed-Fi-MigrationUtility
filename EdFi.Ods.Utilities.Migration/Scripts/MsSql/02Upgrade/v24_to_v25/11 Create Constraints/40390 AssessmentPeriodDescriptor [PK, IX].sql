-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating primary key [AssessmentPeriodDescriptor_PK] on [edfi].[AssessmentPeriodDescriptor]'
GO
ALTER TABLE [edfi].[AssessmentPeriodDescriptor] ADD CONSTRAINT [AssessmentPeriodDescriptor_PK] PRIMARY KEY CLUSTERED  ([AssessmentPeriodDescriptorId])
GO
PRINT N'Creating index [FK_AssessmentPeriodDescriptor_Descriptor] on [edfi].[AssessmentPeriodDescriptor]'
GO
CREATE NONCLUSTERED INDEX [FK_AssessmentPeriodDescriptor_Descriptor] ON [edfi].[AssessmentPeriodDescriptor] ([AssessmentPeriodDescriptorId])
GO

