-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE TABLE [auth].[EducationOrganizationIdToEducationOrganizationId] (
    [SourceEducationOrganizationId] INT NOT NULL,
    [TargetEducationOrganizationId] INT NOT NULL,
    CONSTRAINT [EducationOrganizationIdToEducationOrganizationId_PK] PRIMARY KEY CLUSTERED ([SourceEducationOrganizationId] ASC, [TargetEducationOrganizationId] ASC)
);


GO

CREATE TABLE [edfi].[BarrierToInternetAccessInResidenceDescriptor] (
    [BarrierToInternetAccessInResidenceDescriptorId] INT NOT NULL,
    CONSTRAINT [BarrierToInternetAccessInResidenceDescriptor_PK] PRIMARY KEY CLUSTERED ([BarrierToInternetAccessInResidenceDescriptorId] ASC)
);


GO

CREATE TABLE [edfi].[CourseTranscriptPartialCourseTranscriptAwards] (
    [AwardDate]                       DATE           NOT NULL,
    [CourseAttemptResultDescriptorId] INT            NOT NULL,
    [CourseCode]                      NVARCHAR (60)  NOT NULL,
    [CourseEducationOrganizationId]   INT            NOT NULL,
    [EducationOrganizationId]         INT            NOT NULL,
    [SchoolYear]                      SMALLINT       NOT NULL,
    [StudentUSI]                      INT            NOT NULL,
    [TermDescriptorId]                INT            NOT NULL,
    [EarnedCredits]                   DECIMAL (9, 3) NOT NULL,
    [MethodCreditEarnedDescriptorId]  INT            NULL,
    [LetterGradeEarned]               NVARCHAR (20)  NULL,
    [NumericGradeEarned]              NVARCHAR (20)  NULL,
    [CreateDate]                      DATETIME2 (7)  NOT NULL,
    CONSTRAINT [CourseTranscriptPartialCourseTranscriptAwards_PK] PRIMARY KEY CLUSTERED ([AwardDate] ASC, [CourseAttemptResultDescriptorId] ASC, [CourseCode] ASC, [CourseEducationOrganizationId] ASC, [EducationOrganizationId] ASC, [SchoolYear] ASC, [StudentUSI] ASC, [TermDescriptorId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [FK_CourseTranscriptPartialCourseTranscriptAwards_CourseTranscript]
    ON [edfi].[CourseTranscriptPartialCourseTranscriptAwards]([CourseAttemptResultDescriptorId] ASC, [CourseCode] ASC, [CourseEducationOrganizationId] ASC, [EducationOrganizationId] ASC, [SchoolYear] ASC, [StudentUSI] ASC, [TermDescriptorId] ASC);


GO

CREATE NONCLUSTERED INDEX [FK_CourseTranscriptPartialCourseTranscriptAwards_MethodCreditEarnedDescriptor]
    ON [edfi].[CourseTranscriptPartialCourseTranscriptAwards]([MethodCreditEarnedDescriptorId] ASC);


GO

CREATE TABLE [edfi].[InternetAccessTypeInResidenceDescriptor] (
    [InternetAccessTypeInResidenceDescriptorId] INT NOT NULL,
    CONSTRAINT [InternetAccessTypeInResidenceDescriptor_PK] PRIMARY KEY CLUSTERED ([InternetAccessTypeInResidenceDescriptorId] ASC)
);


GO

CREATE TABLE [edfi].[InternetPerformanceInResidenceDescriptor] (
    [InternetPerformanceInResidenceDescriptorId] INT NOT NULL,
    CONSTRAINT [InternetPerformanceInResidenceDescriptor_PK] PRIMARY KEY CLUSTERED ([InternetPerformanceInResidenceDescriptorId] ASC)
);


GO

CREATE TABLE [edfi].[PrimaryLearningDeviceAccessDescriptor] (
    [PrimaryLearningDeviceAccessDescriptorId] INT NOT NULL,
    CONSTRAINT [PrimaryLearningDeviceAccessDescriptor_PK] PRIMARY KEY CLUSTERED ([PrimaryLearningDeviceAccessDescriptorId] ASC)
);


GO

CREATE TABLE [edfi].[PrimaryLearningDeviceAwayFromSchoolDescriptor] (
    [PrimaryLearningDeviceAwayFromSchoolDescriptorId] INT NOT NULL,
    CONSTRAINT [PrimaryLearningDeviceAwayFromSchoolDescriptor_PK] PRIMARY KEY CLUSTERED ([PrimaryLearningDeviceAwayFromSchoolDescriptorId] ASC)
);


GO

CREATE TABLE [edfi].[PrimaryLearningDeviceProviderDescriptor] (
    [PrimaryLearningDeviceProviderDescriptorId] INT NOT NULL,
    CONSTRAINT [PrimaryLearningDeviceProviderDescriptor_PK] PRIMARY KEY CLUSTERED ([PrimaryLearningDeviceProviderDescriptorId] ASC)
);


GO

CREATE TABLE [edfi].[StudentSectionAttendanceEventClassPeriod] (
    [AttendanceEventCategoryDescriptorId] INT            NOT NULL,
    [ClassPeriodName]                     NVARCHAR (60)  NOT NULL,
    [EventDate]                           DATE           NOT NULL,
    [LocalCourseCode]                     NVARCHAR (60)  NOT NULL,
    [SchoolId]                            INT            NOT NULL,
    [SchoolYear]                          SMALLINT       NOT NULL,
    [SectionIdentifier]                   NVARCHAR (255) NOT NULL,
    [SessionName]                         NVARCHAR (60)  NOT NULL,
    [StudentUSI]                          INT            NOT NULL,
    [CreateDate]                          DATETIME2 (7)  NOT NULL,
    CONSTRAINT [StudentSectionAttendanceEventClassPeriod_PK] PRIMARY KEY CLUSTERED ([AttendanceEventCategoryDescriptorId] ASC, [ClassPeriodName] ASC, [EventDate] ASC, [LocalCourseCode] ASC, [SchoolId] ASC, [SchoolYear] ASC, [SectionIdentifier] ASC, [SessionName] ASC, [StudentUSI] ASC)
);


GO

CREATE NONCLUSTERED INDEX [FK_StudentSectionAttendanceEventClassPeriod_ClassPeriod]
    ON [edfi].[StudentSectionAttendanceEventClassPeriod]([ClassPeriodName] ASC, [SchoolId] ASC);


GO

CREATE NONCLUSTERED INDEX [FK_StudentSectionAttendanceEventClassPeriod_StudentSectionAttendanceEvent]
    ON [edfi].[StudentSectionAttendanceEventClassPeriod]([AttendanceEventCategoryDescriptorId] ASC, [EventDate] ASC, [LocalCourseCode] ASC, [SchoolId] ASC, [SchoolYear] ASC, [SectionIdentifier] ASC, [SessionName] ASC, [StudentUSI] ASC);


GO

ALTER TABLE [edfi].[CourseTranscriptPartialCourseTranscriptAwards]
    ADD CONSTRAINT [CourseTranscriptPartialCourseTranscriptAwards_DF_CreateDate] DEFAULT (getdate()) FOR [CreateDate];


GO

ALTER TABLE [edfi].[StudentSectionAttendanceEventClassPeriod]
    ADD CONSTRAINT [StudentSectionAttendanceEventClassPeriod_DF_CreateDate] DEFAULT (getdate()) FOR [CreateDate];


GO

ALTER TABLE [edfi].[BarrierToInternetAccessInResidenceDescriptor] WITH CHECK
    ADD CONSTRAINT [FK_BarrierToInternetAccessInResidenceDescriptor_Descriptor] FOREIGN KEY ([BarrierToInternetAccessInResidenceDescriptorId]) REFERENCES [edfi].[Descriptor] ([DescriptorId]) ON DELETE CASCADE;


GO

ALTER TABLE [edfi].[CourseTranscriptPartialCourseTranscriptAwards] WITH CHECK
    ADD CONSTRAINT [FK_CourseTranscriptPartialCourseTranscriptAwards_CourseTranscript] FOREIGN KEY ([CourseAttemptResultDescriptorId], [CourseCode], [CourseEducationOrganizationId], [EducationOrganizationId], [SchoolYear], [StudentUSI], [TermDescriptorId]) REFERENCES [edfi].[CourseTranscript] ([CourseAttemptResultDescriptorId], [CourseCode], [CourseEducationOrganizationId], [EducationOrganizationId], [SchoolYear], [StudentUSI], [TermDescriptorId]) ON DELETE CASCADE;


GO

ALTER TABLE [edfi].[CourseTranscriptPartialCourseTranscriptAwards] WITH CHECK
    ADD CONSTRAINT [FK_CourseTranscriptPartialCourseTranscriptAwards_MethodCreditEarnedDescriptor] FOREIGN KEY ([MethodCreditEarnedDescriptorId]) REFERENCES [edfi].[MethodCreditEarnedDescriptor] ([MethodCreditEarnedDescriptorId]);


GO

ALTER TABLE [edfi].[InternetAccessTypeInResidenceDescriptor] WITH CHECK
    ADD CONSTRAINT [FK_InternetAccessTypeInResidenceDescriptor_Descriptor] FOREIGN KEY ([InternetAccessTypeInResidenceDescriptorId]) REFERENCES [edfi].[Descriptor] ([DescriptorId]) ON DELETE CASCADE;


GO

ALTER TABLE [edfi].[InternetPerformanceInResidenceDescriptor] WITH CHECK
    ADD CONSTRAINT [FK_InternetPerformanceInResidenceDescriptor_Descriptor] FOREIGN KEY ([InternetPerformanceInResidenceDescriptorId]) REFERENCES [edfi].[Descriptor] ([DescriptorId]) ON DELETE CASCADE;


GO

ALTER TABLE [edfi].[PrimaryLearningDeviceAccessDescriptor] WITH CHECK
    ADD CONSTRAINT [FK_PrimaryLearningDeviceAccessDescriptor_Descriptor] FOREIGN KEY ([PrimaryLearningDeviceAccessDescriptorId]) REFERENCES [edfi].[Descriptor] ([DescriptorId]) ON DELETE CASCADE;


GO

ALTER TABLE [edfi].[PrimaryLearningDeviceAwayFromSchoolDescriptor] WITH CHECK
    ADD CONSTRAINT [FK_PrimaryLearningDeviceAwayFromSchoolDescriptor_Descriptor] FOREIGN KEY ([PrimaryLearningDeviceAwayFromSchoolDescriptorId]) REFERENCES [edfi].[Descriptor] ([DescriptorId]) ON DELETE CASCADE;


GO

ALTER TABLE [edfi].[PrimaryLearningDeviceProviderDescriptor] WITH CHECK
    ADD CONSTRAINT [FK_PrimaryLearningDeviceProviderDescriptor_Descriptor] FOREIGN KEY ([PrimaryLearningDeviceProviderDescriptorId]) REFERENCES [edfi].[Descriptor] ([DescriptorId]) ON DELETE CASCADE;


GO

ALTER TABLE [edfi].[StudentSectionAttendanceEventClassPeriod] WITH CHECK
    ADD CONSTRAINT [FK_StudentSectionAttendanceEventClassPeriod_ClassPeriod] FOREIGN KEY ([ClassPeriodName], [SchoolId]) REFERENCES [edfi].[ClassPeriod] ([ClassPeriodName], [SchoolId]) ON UPDATE CASCADE;


GO

ALTER TABLE [edfi].[StudentSectionAttendanceEventClassPeriod] WITH CHECK
    ADD CONSTRAINT [FK_StudentSectionAttendanceEventClassPeriod_StudentSectionAttendanceEvent] FOREIGN KEY ([AttendanceEventCategoryDescriptorId], [EventDate], [LocalCourseCode], [SchoolId], [SchoolYear], [SectionIdentifier], [SessionName], [StudentUSI]) REFERENCES [edfi].[StudentSectionAttendanceEvent] ([AttendanceEventCategoryDescriptorId], [EventDate], [LocalCourseCode], [SchoolId], [SchoolYear], [SectionIdentifier], [SessionName], [StudentUSI]) ON DELETE CASCADE ON UPDATE CASCADE;


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An indication of the barrier to having internet access in the student’s primary place of residence.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'BarrierToInternetAccessInResidenceDescriptor';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique identifier used as Primary Key, not derived from business logic, when acting as Foreign Key, references the parent table.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'BarrierToInternetAccessInResidenceDescriptor', @level2type = N'COLUMN', @level2name = N'BarrierToInternetAccessInResidenceDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A collection of partial credits and/or grades a student earned against the course over the session, used when awards of credit are incremental.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The date the partial credits and/or grades were awarded or earned.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'AwardDate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique alphanumeric code assigned to a course.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'CourseCode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The identifier assigned to an education organization.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'CourseEducationOrganizationId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The identifier assigned to an education organization.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'EducationOrganizationId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The identifier for the school year.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'SchoolYear';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique alphanumeric code assigned to a student.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'StudentUSI';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The term for the session during the school year.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'TermDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The number of credits a student earned for completing a given course.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'EarnedCredits';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The method the credits were earned.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'MethodCreditEarnedDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The indicator of student performance as submitted by the instructor.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'LetterGradeEarned';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The indicator of student performance as submitted by the instructor.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'CourseTranscriptPartialCourseTranscriptAwards', @level2type = N'COLUMN', @level2name = N'NumericGradeEarned';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The primary type of internet service used in the student’s primary place of residence.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'InternetAccessTypeInResidenceDescriptor';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique identifier used as Primary Key, not derived from business logic, when acting as Foreign Key, references the parent table.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'InternetAccessTypeInResidenceDescriptor', @level2type = N'COLUMN', @level2name = N'InternetAccessTypeInResidenceDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An indication of whether the student can complete the full range of learning activities, including video streaming and assignment upload, without interruptions caused by poor internet performance in their primary place of residence.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'InternetPerformanceInResidenceDescriptor';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique identifier used as Primary Key, not derived from business logic, when acting as Foreign Key, references the parent table.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'InternetPerformanceInResidenceDescriptor', @level2type = N'COLUMN', @level2name = N'InternetPerformanceInResidenceDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An indication of whether the primary learning device is shared or not shared with another individual.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'PrimaryLearningDeviceAccessDescriptor';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique identifier used as Primary Key, not derived from business logic, when acting as Foreign Key, references the parent table.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'PrimaryLearningDeviceAccessDescriptor', @level2type = N'COLUMN', @level2name = N'PrimaryLearningDeviceAccessDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The type of device the student uses most often to complete learning activities away from school.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'PrimaryLearningDeviceAwayFromSchoolDescriptor';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique identifier used as Primary Key, not derived from business logic, when acting as Foreign Key, references the parent table.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'PrimaryLearningDeviceAwayFromSchoolDescriptor', @level2type = N'COLUMN', @level2name = N'PrimaryLearningDeviceAwayFromSchoolDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The provider of the primary learning device.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'PrimaryLearningDeviceProviderDescriptor';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique identifier used as Primary Key, not derived from business logic, when acting as Foreign Key, references the parent table.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'PrimaryLearningDeviceProviderDescriptor', @level2type = N'COLUMN', @level2name = N'PrimaryLearningDeviceProviderDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Class Period(s) to which the Section Attendance Event applies.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code describing the attendance event, for example:
        Present
        Unexcused absence
        Excused absence
        Tardy.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'AttendanceEventCategoryDescriptorId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An indication of the portion of a typical daily session in which students receive instruction in a specified subject (e.g., morning, sixth period, block period, or AB schedules).', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'ClassPeriodName';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date for this attendance event.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'EventDate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The local code assigned by the School that identifies the course offering provided for the instruction of students.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'LocalCourseCode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The identifier assigned to a school.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'SchoolId';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The identifier for the school year.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'SchoolYear';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The local identifier assigned to a section.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'SectionIdentifier';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The identifier for the calendar for the academic session (e.g., 2010/11, 2011 Summer).', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'SessionName';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A unique alphanumeric code assigned to a student.', @level0type = N'SCHEMA', @level0name = N'edfi', @level1type = N'TABLE', @level1name = N'StudentSectionAttendanceEventClassPeriod', @level2type = N'COLUMN', @level2name = N'StudentUSI';


GO

ALTER TABLE [edfi].[BarrierToInternetAccessInResidenceDescriptor] WITH CHECK CHECK CONSTRAINT [FK_BarrierToInternetAccessInResidenceDescriptor_Descriptor];

ALTER TABLE [edfi].[CourseTranscriptPartialCourseTranscriptAwards] WITH CHECK CHECK CONSTRAINT [FK_CourseTranscriptPartialCourseTranscriptAwards_CourseTranscript];

ALTER TABLE [edfi].[CourseTranscriptPartialCourseTranscriptAwards] WITH CHECK CHECK CONSTRAINT [FK_CourseTranscriptPartialCourseTranscriptAwards_MethodCreditEarnedDescriptor];

ALTER TABLE [edfi].[InternetAccessTypeInResidenceDescriptor] WITH CHECK CHECK CONSTRAINT [FK_InternetAccessTypeInResidenceDescriptor_Descriptor];

ALTER TABLE [edfi].[InternetPerformanceInResidenceDescriptor] WITH CHECK CHECK CONSTRAINT [FK_InternetPerformanceInResidenceDescriptor_Descriptor];

ALTER TABLE [edfi].[PrimaryLearningDeviceAccessDescriptor] WITH CHECK CHECK CONSTRAINT [FK_PrimaryLearningDeviceAccessDescriptor_Descriptor];

ALTER TABLE [edfi].[PrimaryLearningDeviceAwayFromSchoolDescriptor] WITH CHECK CHECK CONSTRAINT [FK_PrimaryLearningDeviceAwayFromSchoolDescriptor_Descriptor];

ALTER TABLE [edfi].[PrimaryLearningDeviceProviderDescriptor] WITH CHECK CHECK CONSTRAINT [FK_PrimaryLearningDeviceProviderDescriptor_Descriptor];

ALTER TABLE [edfi].[StudentSectionAttendanceEventClassPeriod] WITH CHECK CHECK CONSTRAINT [FK_StudentSectionAttendanceEventClassPeriod_ClassPeriod];

ALTER TABLE [edfi].[StudentSectionAttendanceEventClassPeriod] WITH CHECK CHECK CONSTRAINT [FK_StudentSectionAttendanceEventClassPeriod_StudentSectionAttendanceEvent];

GO
