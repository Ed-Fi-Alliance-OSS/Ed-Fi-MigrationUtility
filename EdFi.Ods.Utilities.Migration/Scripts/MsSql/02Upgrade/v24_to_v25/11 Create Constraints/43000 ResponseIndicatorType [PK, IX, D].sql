-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Creating primary key [ResponseIndicatorType_PK] on [edfi].[ResponseIndicatorType]'
GO
ALTER TABLE [edfi].[ResponseIndicatorType] ADD CONSTRAINT [ResponseIndicatorType_PK] PRIMARY KEY CLUSTERED  ([ResponseIndicatorTypeId])
GO
PRINT N'Creating index [UX_ResponseIndicatorType_Id] on [edfi].[ResponseIndicatorType]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_ResponseIndicatorType_Id] ON [edfi].[ResponseIndicatorType] ([Id]) WITH (FILLFACTOR=100, PAD_INDEX=ON)
GO

PRINT N'Adding constraints to [edfi].[ResponseIndicatorType]'
GO
ALTER TABLE [edfi].[ResponseIndicatorType] ADD CONSTRAINT [ResponseIndicatorType_DF_CreateDate] DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [edfi].[ResponseIndicatorType] ADD CONSTRAINT [ResponseIndicatorType_DF_LastModifiedDate] DEFAULT (getdate()) FOR [LastModifiedDate]
GO
ALTER TABLE [edfi].[ResponseIndicatorType] ADD CONSTRAINT [ResponseIndicatorType_DF_Id] DEFAULT (newid()) FOR [Id]
GO

