-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating primary key [CredentialEndorsement_PK] on [edfi].[CredentialEndorsement]'
GO
ALTER TABLE [edfi].[CredentialEndorsement] ADD CONSTRAINT [CredentialEndorsement_PK] PRIMARY KEY CLUSTERED  ([CredentialEndorsement], [CredentialIdentifier], [StateOfIssueStateAbbreviationDescriptorId])
GO

PRINT N'Creating index [FK_CredentialEndorsement_Credential] on [edfi].[CredentialEndorsement]'
GO
CREATE NONCLUSTERED INDEX [FK_CredentialEndorsement_Credential] ON [edfi].[CredentialEndorsement] ([CredentialIdentifier], [StateOfIssueStateAbbreviationDescriptorId])
GO

PRINT N'Adding constraints to [edfi].[CredentialEndorsement]'
GO
ALTER TABLE [edfi].[CredentialEndorsement] ADD CONSTRAINT [CredentialEndorsement_DF_CreateDate] DEFAULT (getdate()) FOR [CreateDate]
GO
