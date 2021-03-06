-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Adding foreign keys to [edfi].[EducationOrganizationAddress]'
GO
ALTER TABLE [edfi].[EducationOrganizationAddress] ADD CONSTRAINT [FK_EducationOrganizationAddress_AddressTypeDescriptor] FOREIGN KEY ([AddressTypeDescriptorId]) REFERENCES [edfi].[AddressTypeDescriptor] ([AddressTypeDescriptorId])
GO
ALTER TABLE [edfi].[EducationOrganizationAddress] ADD CONSTRAINT [FK_EducationOrganizationAddress_EducationOrganization] FOREIGN KEY ([EducationOrganizationId]) REFERENCES [edfi].[EducationOrganization] ([EducationOrganizationId]) ON DELETE CASCADE
GO
ALTER TABLE [edfi].[EducationOrganizationAddress] ADD CONSTRAINT [FK_EducationOrganizationAddress_StateAbbreviationDescriptor] FOREIGN KEY ([StateAbbreviationDescriptorId]) REFERENCES [edfi].[StateAbbreviationDescriptor] ([StateAbbreviationDescriptorId])
GO
