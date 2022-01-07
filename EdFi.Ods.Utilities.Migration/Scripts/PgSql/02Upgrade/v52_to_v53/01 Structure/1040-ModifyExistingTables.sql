-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

ALTER TABLE edfi.credential
    ALTER COLUMN credentialfielddescriptorid DROP NOT NULL;

COMMENT ON COLUMN edfi.credential.credentialfielddescriptorid
    IS 'The field of certification for the certificate (e.g., Mathematics, Music).';

ALTER TABLE edfi.credential
    ALTER COLUMN teachingcredentialdescriptorid DROP NOT NULL;

COMMENT ON COLUMN edfi.credential.teachingcredentialdescriptorid
    IS 'An indication of the category of a legal document giving authorization to perform teaching assignment services.';

COMMENT ON COLUMN edfi.coursetranscriptpartialcoursetranscriptawards.courseattemptresultdescriptorid
    IS 'The result from the student''s attempt to take the course, for example:
        Pass
        Fail
        Incomplete
        Withdrawn.';

COMMENT ON TABLE edfi.internetaccesstypeinresidencedescriptor
  IS 'The primary type of internet service used in the student’s primary place of residence.';

COMMENT ON TABLE edfi.staffeducationorganizationassignmentassociation
  IS 'This association indicates the education organization to which a staff member provides services.';

COMMENT ON COLUMN edfi.staffeducationorganizationassignmentassociation.begindate
    IS 'Month, day, and year of the start or effective date of a staff member''s employment, contract, or relationship with the education organization.';

COMMENT ON COLUMN edfi.staffeducationorganizationassignmentassociation.enddate
    IS 'Month, day, and year of the end or termination date of a staff member''s employment, contract, or relationship with the education organization.';

ALTER TABLE edfi.staffeducationorganizationassignmentassociation
    ADD COLUMN fulltimeequivalency numeric(5, 4);

COMMENT ON COLUMN edfi.staffeducationorganizationassignmentassociation.fulltimeequivalency
    IS 'The ratio between the hours of work expected in a position and the hours of work normally expected in a full-time position in the same setting.';


ALTER TABLE edfi.studenteducationorganizationassociation
    ADD COLUMN barriertointernetaccessinresidencedescriptorid integer;

COMMENT ON COLUMN edfi.studenteducationorganizationassociation.barriertointernetaccessinresidencedescriptorid
    IS 'An indication of the barrier to having internet access in the student’s primary place of residence.';

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD COLUMN internetaccessinresidence boolean;

COMMENT ON COLUMN edfi.studenteducationorganizationassociation.internetaccessinresidence
    IS 'An indication of whether the student is able to access the internet in their primary place of residence.';

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD COLUMN internetaccesstypeinresidencedescriptorid integer;

COMMENT ON COLUMN edfi.studenteducationorganizationassociation.internetaccesstypeinresidencedescriptorid
    IS 'The primary type of internet service used in the student’s primary place of residence.';

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD COLUMN internetperformanceinresidencedescriptorid integer;

COMMENT ON COLUMN edfi.studenteducationorganizationassociation.internetperformanceinresidencedescriptorid
    IS 'An indication of whether the student can complete the full range of learning activities, including video streaming and assignment upload, without interruptions caused by poor internet performance in their primary place of residence.';

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD COLUMN primarylearningdeviceaccessdescriptorid integer;

COMMENT ON COLUMN edfi.studenteducationorganizationassociation.primarylearningdeviceaccessdescriptorid
    IS 'An indication of whether the primary learning device is shared or not shared with another individual.';

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD COLUMN primarylearningdeviceawayfromschooldescriptorid integer;

COMMENT ON COLUMN edfi.studenteducationorganizationassociation.primarylearningdeviceawayfromschooldescriptorid
    IS 'The type of device the student uses most often to complete learning activities away from school.';

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD COLUMN primarylearningdeviceproviderdescriptorid integer;

COMMENT ON COLUMN edfi.studenteducationorganizationassociation.primarylearningdeviceproviderdescriptorid
    IS 'The provider of the primary learning device.';

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD CONSTRAINT fk_8e1257_barriertointernetaccessinresidencedescriptor FOREIGN KEY (barriertointernetaccessinresidencedescriptorid)
    REFERENCES edfi.barriertointernetaccessinresidencedescriptor (barriertointernetaccessinresidencedescriptorid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD CONSTRAINT fk_8e1257_internetaccesstypeinresidencedescriptor FOREIGN KEY (internetaccesstypeinresidencedescriptorid)
    REFERENCES edfi.internetaccesstypeinresidencedescriptor (internetaccesstypeinresidencedescriptorid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD CONSTRAINT fk_8e1257_internetperformanceinresidencedescriptor FOREIGN KEY (internetperformanceinresidencedescriptorid)
    REFERENCES edfi.internetperformanceinresidencedescriptor (internetperformanceinresidencedescriptorid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD CONSTRAINT fk_8e1257_primarylearningdeviceaccessdescriptor FOREIGN KEY (primarylearningdeviceaccessdescriptorid)
    REFERENCES edfi.primarylearningdeviceaccessdescriptor (primarylearningdeviceaccessdescriptorid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD CONSTRAINT fk_8e1257_primarylearningdeviceawayfromschooldescriptor FOREIGN KEY (primarylearningdeviceawayfromschooldescriptorid)
    REFERENCES edfi.primarylearningdeviceawayfromschooldescriptor (primarylearningdeviceawayfromschooldescriptorid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

ALTER TABLE edfi.studenteducationorganizationassociation
    ADD CONSTRAINT fk_8e1257_primarylearningdeviceproviderdescriptor FOREIGN KEY (primarylearningdeviceproviderdescriptorid)
    REFERENCES edfi.primarylearningdeviceproviderdescriptor (primarylearningdeviceproviderdescriptorid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


CREATE INDEX fk_8e1257_primarylearningdeviceaccessdescriptor
    ON edfi.studenteducationorganizationassociation USING btree
    (primarylearningdeviceaccessdescriptorid ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX fk_8e1257_barriertointernetaccessinresidencedescriptor
    ON edfi.studenteducationorganizationassociation USING btree
    (barriertointernetaccessinresidencedescriptorid ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX fk_8e1257_primarylearningdeviceawayfromschooldescriptor
    ON edfi.studenteducationorganizationassociation USING btree
    (primarylearningdeviceawayfromschooldescriptorid ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX fk_8e1257_internetaccesstypeinresidencedescriptor
    ON edfi.studenteducationorganizationassociation USING btree
    (internetaccesstypeinresidencedescriptorid ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX fk_8e1257_primarylearningdeviceproviderdescriptor
    ON edfi.studenteducationorganizationassociation USING btree
    (primarylearningdeviceproviderdescriptorid ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX fk_8e1257_internetperformanceinresidencedescriptor
    ON edfi.studenteducationorganizationassociation USING btree
    (internetperformanceinresidencedescriptorid ASC NULLS LAST)
    TABLESPACE pg_default;

COMMENT ON COLUMN edfi.studenteducationorganizationassociationcohortyear.schoolyear
    IS 'The school year associated with the cohort; for example, the intended school year of graduation.';

ALTER TABLE edfi.studenteducationorganizationassociationcohortyear
    ADD COLUMN termdescriptorid integer;

COMMENT ON COLUMN edfi.studenteducationorganizationassociationcohortyear.termdescriptorid
    IS 'The term associated with the cohort year; for example, the intended term of graduation.';

ALTER TABLE edfi.studenteducationorganizationassociationcohortyear
    ADD CONSTRAINT fk_69dd58_termdescriptor FOREIGN KEY (termdescriptorid)
    REFERENCES edfi.termdescriptor (termdescriptorid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX fk_69dd58_termdescriptor
    ON edfi.studenteducationorganizationassociationcohortyear USING btree
    (termdescriptorid ASC NULLS LAST)
    TABLESPACE pg_default;

COMMENT ON COLUMN edfi.studentschoolassociation.fulltimeequivalency
    IS 'The full-time equivalent ratio for the student’s assignment to a school for services or instruction. For example, a full-time student would have an FTE value of 1 while a half-time student would have an FTE value of 0.5.';
COMMENT ON COLUMN edfi.studentsectionattendanceeventclassperiod.attendanceeventcategorydescriptorid
    IS 'A code describing the attendance event, for example:
        Present
        Unexcused absence
        Excused absence
        Tardy.';
    