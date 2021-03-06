CREATE OR REPLACE FUNCTION edfi.SetCurrentSchoolYear(
    newSchoolYear integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $$
DECLARE
    rowCount integer;
    newSchoolYear ALIAS FOR $1;
BEGIN
    UPDATE edfi.SchoolYearType
    SET CurrentSchoolYear = 'true'
    WHERE SchoolYear = newSchoolYear;
    
    GET DIAGNOSTICS rowCount = ROW_COUNT;
    
    IF rowCount = 0 THEN
        RAISE EXCEPTION 'Specified school year does not exist.' USING ERRCODE = '50000';
    END IF;
    
    UPDATE edfi.SchoolYearType
    SET CurrentSchoolYear = 'false'
    WHERE SchoolYear <> newSchoolYear;
END;
$$;

ALTER FUNCTION edfi.SetCurrentSchoolYear(integer)
    OWNER TO postgres;
