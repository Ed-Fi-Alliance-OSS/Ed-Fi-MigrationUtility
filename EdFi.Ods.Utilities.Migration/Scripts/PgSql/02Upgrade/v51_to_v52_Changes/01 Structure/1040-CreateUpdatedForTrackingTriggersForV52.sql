-- SPDX-License-Identifier: Apache-2.0
-- Licensed to the Ed-Fi Alliance under one or more agreements.
-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
-- See the LICENSE and NOTICES files in the project root for more information.

CREATE TRIGGER UpdateChangeVersion BEFORE UPDATE ON edfi.StudentDisciplineIncidentNonOffenderAssociation
FOR EACH ROW EXECUTE PROCEDURE changes.UpdateChangeVersion();

CREATE TRIGGER UpdateChangeVersion BEFORE UPDATE ON edfi.AssessmentScoreRangeLearningStandard
FOR EACH ROW EXECUTE PROCEDURE changes.UpdateChangeVersion();

CREATE TRIGGER UpdateChangeVersion BEFORE UPDATE ON edfi.StudentDisciplineIncidentBehaviorAssociation
FOR EACH ROW EXECUTE PROCEDURE changes.UpdateChangeVersion();
