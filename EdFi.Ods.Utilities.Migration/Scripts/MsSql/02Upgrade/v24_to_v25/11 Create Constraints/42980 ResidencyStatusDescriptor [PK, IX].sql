-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating primary key [ResidencyStatusDescriptor_PK] on [edfi].[ResidencyStatusDescriptor]'
GO
ALTER TABLE [edfi].[ResidencyStatusDescriptor] ADD CONSTRAINT [ResidencyStatusDescriptor_PK] PRIMARY KEY CLUSTERED  ([ResidencyStatusDescriptorId])
GO
PRINT N'Creating index [FK_ResidencyStatusDescriptor_Descriptor] on [edfi].[ResidencyStatusDescriptor]'
GO
CREATE NONCLUSTERED INDEX [FK_ResidencyStatusDescriptor_Descriptor] ON [edfi].[ResidencyStatusDescriptor] ([ResidencyStatusDescriptorId])
GO
PRINT N'Creating index [FK_ResidencyStatusDescriptor_ResidencyStatusType] on [edfi].[ResidencyStatusDescriptor]'
GO
CREATE NONCLUSTERED INDEX [FK_ResidencyStatusDescriptor_ResidencyStatusType] ON [edfi].[ResidencyStatusDescriptor] ([ResidencyStatusTypeId])
GO

