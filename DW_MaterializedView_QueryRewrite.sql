--9 Formularea în limbaj natural a unei cereri SQL complexe care va fi optimizată în următoarea  etapă,   
--folosind   tehnici   specifice   bazelor   de   date   depozit

--Cerere SQL in limbaj natural:
--"Sa se afiseze pentru fiecare client suma medie a tuturor tranzactiilor efectuate la fiecare comerciant in parte."

select t.ID_Client as ID_CLIENT, c.Nume as NUME_CLIENT, co.Nume as NUME_COMERCIANT, AVG(ABS(t.SUMA)) as SUMA_MEDIE
from FACT_TRANZACTII t, DIM_CLIENT c, DIM_COMERCIANT co
where t.ID_Client=c.ID_Client
    and t.ID_Comerciant=co.ID_Comerciant
group by t.ID_CLIENT, c.Nume, co.Nume  
order by t.ID_Client

--Cerarea vizualizarii materializate
CREATE MATERIALIZED VIEW vm_clienti_comercianti_suma_medie_tranzactie
BUILD IMMEDIATE
REFRESH COMPLETE
ON DEMAND
ENABLE QUERY REWRITE
AS 
select t.ID_Client as ID_CLIENT, c.Nume as NUME_CLIENT, co.Nume as NUME_COMERCIANT, AVG(ABS(t.SUMA)) as SUMA_MEDIE
from FACT_TRANZACTII t, DIM_CLIENT c, DIM_COMERCIANT co
where t.ID_Client=c.ID_Client
    and t.ID_Comerciant=co.ID_Comerciant
group by t.ID_CLIENT, c.Nume, co.Nume  
order by t.ID_Client

--Colectare statistici
ANALYZE TABLE FACT_TRANZACTII COMPUTE STATISTICS;

BEGIN DBMS_STATS.GATHER_TABLE_STATS ('DW','VM_CLIENTI_COMERCIANTI_SUMA_MEDIE_TRANZACTIE', 
	estimate_percent=>20,block_sample=>TRUE,cascade=>TRUE); 
END;

--Setare parametrii pt rescriere
ALTER SESSION SET QUERY_REWRITE_ENABLED = TRUE;
ALTER SESSION SET QUERY_REWRITE_INTEGRITY = enforced;

--Afisare plan executie
EXPLAIN PLAN
SET STATEMENT_ID ='st_clienti_comercianti_suma' 
FOR 
select t.ID_Client as ID_CLIENT, c.Nume as NUME_CLIENT, co.Nume as NUME_COMERCIANT, AVG(ABS(t.SUMA)) as SUMA_MEDIE
from FACT_TRANZACTII t, DIM_CLIENT c, DIM_COMERCIANT co
where t.ID_Client=c.ID_Client
    and t.ID_Comerciant=co.ID_Comerciant
group by t.ID_CLIENT, c.Nume, co.Nume  
order by t.ID_Client;

SELECT plan_table_output
FROM table(dbms_xplan.display('plan_table','st_clienti_comercianti_suma','serial'));

--Rescriere cerere
select ID_CLIENT, NUME_CLIENT, NUME_COMERCIANT, SUMA_MEDIE
from VM_CLIENTI_COMERCIANTI_SUMA_MEDIE_TRANZACTIE