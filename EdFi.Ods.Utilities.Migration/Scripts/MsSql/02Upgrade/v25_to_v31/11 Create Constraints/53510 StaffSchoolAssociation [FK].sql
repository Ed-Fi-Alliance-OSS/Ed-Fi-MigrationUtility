-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

PRINT N'Adding foreign keys to [edfi].[StaffSchoolAssociation]'
GO
ALTER TABLE [edfi].[StaffSchoolAssociation] ADD CONSTRAINT [FK_StaffSchoolAssociation_Calendar] FOREIGN KEY ([CalendarCode], [SchoolId], [SchoolYear]) REFERENCES [edfi].[Calendar] ([CalendarCode], [SchoolId], [SchoolYear])
GO
ALTER TABLE [edfi].[StaffSchoolAssociation] ADD CONSTRAINT [FK_StaffSchoolAssociation_ProgramAssignmentDescriptor] FOREIGN KEY ([ProgramAssignmentDescriptorId]) REFERENCES [edfi].[ProgramAssignmentDescriptor] ([ProgramAssignmentDescriptorId])
GO
ALTER TABLE [edfi].[StaffSchoolAssociation] ADD CONSTRAINT [FK_StaffSchoolAssociation_School] FOREIGN KEY ([SchoolId]) REFERENCES [edfi].[School] ([SchoolId])
GO
ALTER TABLE [edfi].[StaffSchoolAssociation] ADD CONSTRAINT [FK_StaffSchoolAssociation_SchoolYearType] FOREIGN KEY ([SchoolYear]) REFERENCES [edfi].[SchoolYearType] ([SchoolYear])
GO
ALTER TABLE [edfi].[StaffSchoolAssociation] ADD CONSTRAINT [FK_StaffSchoolAssociation_Staff] FOREIGN KEY ([StaffUSI]) REFERENCES [edfi].[Staff] ([StaffUSI])
GO
