CREATE OR REPLACE FUNCTION util.GetEdFiOdsVersion()
RETURNS VARCHAR(60) AS $$
BEGIN	
   RETURN '3.4.0';
END;
$$ LANGUAGE plpgsql;

