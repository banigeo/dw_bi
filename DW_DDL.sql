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
) PARTITION by list (oras) (
    PARTITION TM
    VALUES
        ('Timisoara'),
        PARTITION B
    VALUES
        ('Bucuresti'),
        PARTITION CT
    VALUES
        ('Constanta'),
        PARTITION BV
    VALUES
        ('Brasov'),
        PARTITION nedefinit
    VALUES
        (DEFAULT)
);
drop index tara_idx;
create index tara_idx on dim_locatie (tara) local;

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

drop index calendar_idx;
create index calendar_idx on dim_calendar (luna) global partition by hash(luna) partitions 12;

DROP TABLE FACT_TRANZACTII;

CREATE TABLE FACT_TRANZACTII (
    ID_Tranzactie NUMBER(10) NOT NULL,
    ID_Client NUMBER(10) NOT NULL,
    ID_Cont NUMBER(10) NOT NULL,
    ID_Comerciant NUMBER(10) NOT NULL,
    ID_Canal_Plata NUMBER(10) NOT NULL,
    ID_Stare NUMBER(10) NOT NULL,
    ID_Locatie NUMBER(10) NOT NULL,
    ID_Data NUMBER(8) NOT NULL,
    Suma NUMBER(10, 2) NOT NULL,
    Durata NUMBER(7, 2) DEFAULT NULL,
    PRIMARY KEY(ID_Tranzactie, ID_Client, ID_Cont)
) PARTITION by RANGE(id_data) INTERVAL(1) (
    PARTITION partitie_initiala
    VALUES
        less than (20220101)
);

  CREATE TABLE DIM_CLIENT 
   (
    ID_Client NUMBER(10,0) PRIMARY KEY, 
	Nume VARCHAR2(100) NOT NULL, 
	Tip_Client VARCHAR2(50) NOT NULL, 
	Status VARCHAR2(15) NOT NULL
   );
   CREATE bitmap INDEX dim_client_bmp ON dim_client (tip_client);
