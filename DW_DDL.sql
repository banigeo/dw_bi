-- DROP TABLE FACT_TRANZACTII;
-- DROP TABLE DIM_CALENDAR;
-- DROP TABLE DIM_CANAL_PLATA;
-- DROP TABLE DIM_LOCATIE;
-- DROP TABLE DIM_COMERCIANT;
-- DROP TABLE DIM_DETALII_PLATA;
-- DROP TABLE DIM_CLIENT;
-- DROP TABLE DIM_STARE;


CREATE TABLE DIM_STARE (
    ID_Stare NUMBER(10) NOT NULL PRIMARY KEY,
    Stare VARCHAR2(50 BYTE) NOT NULL
);

CREATE TABLE DIM_LOCATIE (
    ID_Locatie NUMBER(10) PRIMARY KEY,
    Strada VARCHAR(100) DEFAULT NULL,
    Oras VARCHAR(100) DEFAULT NULL,
    Tara VARCHAR(100) DEFAULT NULL,
    Site VARCHAR(100) DEFAULT NULL
)    
partition by list (oras) 
( partition TM values ('Timisoara')
, partition B values ('Bucuresti')
, partition CT values ('Constanta')
, partition BV values ('Brasov')
, partition nedefinit values (default)
);

create bitmap index dim_client_bmp  on dim_client (tip_client);

CREATE TABLE DIM_DETALII_PLATA (
    ID_Cont NUMBER(10) PRIMARY KEY,
    Tip_Card VARCHAR(10) NOT NULL,
    Tip_Cont VARCHAR(10) NOT NULL
);

CREATE TABLE DIM_COMERCIANT (
    ID_Comerciant NUMBER(10) PRIMARY KEY,
    Nume VARCHAR(100),
    STATUS VARCHAR(15)
);

CREATE TABLE DIM_LOCATIE (
    ID_Locatie NUMBER(10) PRIMARY KEY,
    Strada VARCHAR(100) DEFAULT NULL,
    Oras VARCHAR(100) DEFAULT NULL,
    Tara VARCHAR(100) DEFAULT NULL,
    Site VARCHAR(100) DEFAULT NULL
);

CREATE TABLE DIM_CANAL_PLATA (
    ID_Canal_Plata NUMBER(10) NOT NULL,
    Tip_Canal_Plata VARCHAR(10) NOT NULL
);

DROP TABLE DIM_CALENDAR;

CREATE TABLE DIM_CALENDAR AS
SELECT
    TO_NUMBER(
        TO_CHAR(
            TO_DATE('31/12/2020', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'),
            'YYYYMMDD'
        )
    ) AS ID_Data,
    TO_DATE('31/12/2020', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day') AS Data,
    TO_CHAR(
        TO_DATE('31/12/2020', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'),
        'DD'
    ) AS Ziua,
    TO_CHAR(
        TO_DATE('31/12/2020', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'),
        'Month'
    ) AS Luna,
    TO_CHAR(
        TO_DATE('31/12/2020', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'),
        'YYYY'
    ) AS Anul
FROM
    (
        SELECT
            LEVEL n
        FROM
            dual connect by LEVEL <= 2000
    );

drop table FACT_TRANZACTII;
CREATE TABLE FACT_TRANZACTII (
    ID NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT by 1) PRIMARY KEY,
    ID_Tranzactie NUMBER(10) NOT NULL,
    ID_Client NUMBER(10) NOT NULL,
    ID_Cont NUMBER(10) NOT NULL,
    ID_Comerciant NUMBER(10) NOT NULL,
    ID_Canal_Plata NUMBER(10) NOT NULL,
    ID_Stare NUMBER(10) NOT NULL,
    ID_Locatie NUMBER(10) NOT NULL,
    ID_Data NUMBER(8) NOT NULL,
    Suma NUMBER(10, 2) NOT NULL,
    Durata NUMBER(7, 2) DEFAULT NULL)
    partition by range(id_data)
    interval(1) 
    (partition partitie_initiala values less than (20220101));
