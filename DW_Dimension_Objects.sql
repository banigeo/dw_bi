-- create dimensions
DROP DIMENSION locatie;
CREATE DIMENSION locatie
LEVEL locatie_id  IS (dim_locatie.id_locatie)
LEVEL strada  IS (dim_locatie.strada)
LEVEL oras  IS (dim_locatie.oras)
LEVEL tara  IS (dim_locatie.tara)
HIERARCHY ierarhie_locatie (locatie_id CHILD OF strada  CHILD OF oras  CHILD OF tara)
ATTRIBUTE locatie_info LEVEL locatie_id DETERMINES 
(dim_locatie.strada, dim_locatie.oras, dim_locatie.tara, dim_locatie.site);

DROP DIMENSION timp;
CREATE DIMENSION timp
LEVEL data_id  IS (dim_calendar.id_data)
LEVEL data  IS (dim_calendar.data)
LEVEL anul  IS (dim_calendar.anul)
HIERARCHY ierarhie_timp (data_id CHILD OF data CHILD OF anul)
ATTRIBUTE timp_id_info LEVEL data_id DETERMINES
(dim_calendar.id_data, dim_calendar.data, dim_calendar.ziua, dim_calendar.luna, dim_calendar.anul)
ATTRIBUTE timp_id_info LEVEL data DETERMINES
(dim_calendar.data, dim_calendar.ziua, dim_calendar.luna, dim_calendar.anul);

-- display dimensions
SET SERVEROUTPUT ON FORMAT WRAPPED;  --to improve the display of info
EXECUTE DBMS_DIMENSION.DESCRIBE_DIMENSION('locatie');
EXECUTE DBMS_DIMENSION.DESCRIBE_DIMENSION('timp');

-- stergerea exceptiilor vechi (doar daca este necesar)
DELETE (SELECT * FROM dimension_exceptions);

-- validate dimensions
-- used to create dimensions exceptions table
@utldim.sql
EXECUTE DBMS_DIMENSION.VALIDATE_DIMENSION ('locatie', FALSE, TRUE, 'validare locatie');
EXECUTE DBMS_DIMENSION.VALIDATE_DIMENSION ('timp', FALSE, TRUE, 'validare timp');

-- verificarea exceptiilor
SELECT * FROM dimension_exceptions;

-- match-uirea exceptiilor in tabela pentru identificarea randurilor cu probleme
SELECT * FROM dim_locatie
WHERE rowid IN (SELECT bad_rowid
                FROM dimension_exceptions
                WHERE statement_id = 'validare locatie');
                
SELECT * FROM dim_calendar
WHERE rowid IN (SELECT bad_rowid
                FROM dimension_exceptions
                WHERE statement_id = 'validare timp');