-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE TEMP TABLE EdFiDeployJournal (
ScriptName VARCHAR(255) NOT NULL
);

INSERT INTO EdFiDeployJournal (ScriptName)
VALUES
('EdFi.Ods.Standard.Artifacts.PgSql.Data.Ods.0020-SchoolYears.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Data.Ods.1010-OperationalContexts.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Data.Ods.1040-Set-Default-SchoolYear.sql'),

('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.0010-Schemas.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.0011-Extensions.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.0020-Tables.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.0030-ForeignKeys.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.0040-IdColumnUniqueIndexes.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.0050-ExtendedProperties.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1002-AuthViews.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1003-CompositesHierarchicalViews.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1020-Interoperability-Extension.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1021-OperationalContextView.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1022-SetVersion.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1030-AddSessionCascadeSupport.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1031-Create-SetSchoolYear-stored-procedure.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1040-MissingSecurityViews.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1100-AddMoreContextToEducationIdentifiersView.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1100-CorrectCommunityOrganizationAuthViews.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1120-RemoveCompositesHierarchicalViews.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1150-UpdatedAuthViewsToPreventDuplicatesFromStaffEdOrgAssignmentsAndEmployments.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1160-UpdateVersionTo510.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1170-UpdatedAuthViewsToRemoveJoin.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1180-Add-OrgDeptId-to-EdOrgIdentifiers.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1190-UpdateVersionTo520.sql'),
('EdFi.Ods.Standard.Artifacts.PgSql.Structure.Ods.1200-AuthViewsSupportOrgDeptId.sql');


INSERT INTO public."DeployJournal" (scriptname, applied)
SELECT e.scriptname, NOW()
FROM EdFiDeployJournal e
LEFT JOIN public."DeployJournal" dj
    ON e.ScriptName = dj.scriptname
WHERE dj.scriptname IS NULL;