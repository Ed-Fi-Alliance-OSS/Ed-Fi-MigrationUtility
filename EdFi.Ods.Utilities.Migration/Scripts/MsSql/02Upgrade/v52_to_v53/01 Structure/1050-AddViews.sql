-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE   VIEW auth.EducationOrganizationIdToParentUSI 
    WITH SCHEMABINDING AS
    SELECT  edOrgs.SourceEducationOrganizationId, spa.ParentUSI
    FROM    auth.EducationOrganizationIdToEducationOrganizationId edOrgs
            INNER JOIN edfi.StudentSchoolAssociation ssa 
                ON edOrgs.TargetEducationOrganizationId = ssa.SchoolId
            INNER JOIN edfi.StudentParentAssociation spa 
                ON ssa.StudentUSI = spa.StudentUSI
    GROUP BY edOrgs.SourceEducationOrganizationId, spa.ParentUSI
GO

-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE   VIEW auth.EducationOrganizationIdToStudentUSIThroughResponsibility
    WITH SCHEMABINDING AS
    SELECT  edOrgs.SourceEducationOrganizationId, seora.StudentUSI
    FROM    auth.EducationOrganizationIdToEducationOrganizationId edOrgs
            INNER JOIN edfi.StudentEducationOrganizationResponsibilityAssociation seora
                ON edOrgs.TargetEducationOrganizationId = seora.EducationOrganizationId
    GROUP BY edOrgs.SourceEducationOrganizationId, seora.StudentUSI
GO
