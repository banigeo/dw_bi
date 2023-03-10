-- DIM_STARE
TRUNCATE TABLE DIM_STARE;
INSERT INTO
    DIM_STARE
SELECT
    DISTINCT CASE
        WHEN Stare = 'Initiat' THEN 1
        WHEN Stare = 'Procesat' THEN 2
        WHEN Stare = 'Eroare' THEN 3
        ELSE NULL
    END AS ID_Stare,
    Stare
FROM
    db.Tranzactii;

-- DIM_CLIENT
TRUNCATE TABLE DIM_CLIENT;
INSERT INTO
    DIM_CLIENT
SELECT
    ID_Client,
    Nume,
    Tip_Client,
    CASE
        WHEN Data_Incetare IS NOT NULL THEN 'Incetat'
        ELSE 'Inscris'
    END AS STATUS
FROM
    db.client;

-- DIM_COMERCIANT
TRUNCATE TABLE DIM_COMERCIANT;
INSERT INTO
    DIM_COMERCIANT
SELECT
    ID_Comerciant,
    Nume,
    CASE
        WHEN Data_Incetare IS NOT NULL THEN 'Incetat'
        ELSE 'Inscris'
    END AS STATUS
FROM
    db.comerciant;

-- DIM_DETALII_PLATA
TRUNCATE TABLE DIM_DETALII_PLATA;
INSERT INTO
    DIM_DETALII_PLATA
SELECT
    ID_Cont,
    Tip_Cont,
    Tip_Card
FROM
    db.cont ct
    INNER JOIN db.card cd ON ct.ID_Cont = cd.COD_Cont;

-- DIM_Locatie
TRUNCATE TABLE DIM_LOCATIE;
INSERT INTO
    DIM_LOCATIE
SELECT
    ID_Locatie,
    Strada,
    Oras,
    Tara,
    Site
FROM
    db.locatie;

-- DIM_CANAL_PLATA
TRUNCATE TABLE DIM_CANAL_PLATA;
INSERT INTO 
    DIM_CANAL_PLATA
SELECT
    DISTINCT CASE
        WHEN Tip_Echipament = 'POS' THEN 1
        WHEN Tip_Echipament = 'ONLINE' THEN 2
        ELSE NULL
    END AS ID_Canal_Plata,
    Tip_Echipament AS Tip_Canal_Plata
FROM
    db.canal_plata;

-- FACT_TRANZACTII
INSERT INTO
    FACT_TRANZACTII (
        ID_Tranzactie,
        ID_Client,
        ID_Cont,
        ID_Comerciant,
        ID_Canal_Plata,
        ID_Stare,
        ID_Locatie,
        ID_Data,
        Suma,
        Durata
    )
SELECT
    ID_Tranzactie,
    ID_Client,
    ID_Cont,
    ID_Comerciant,
    CASE
        WHEN Tip_Echipament = 'POS' THEN 1
        WHEN Tip_Echipament = 'ONLINE' THEN 2
        ELSE NULL
    END AS ID_Canal_Plata,
    CASE
        WHEN Stare = 'Initiat' THEN 1
        WHEN Stare = 'Procesat' THEN 2
        WHEN Stare = 'Eroare' THEN 3
        ELSE NULL
    END AS ID_Stare,
    ID_Locatie,
    TO_CHAR(DATA_INITIERE, 'YYYYMMDD') AS ID_Data,
    - SUMA,
    TO_CHAR(
        (DATA_PROCESARE - DATA_INITIERE) * 1440,
        '99999.99'
    ) AS Durata
FROM
    db.tranzactii t
    LEFT JOIN db.cont co ON t.COD_CONT_DEBITOR = co.ID_CONT
    LEFT JOIN db.client cl ON co.COD_CLIENT = cl.ID_CLIENT
    LEFT JOIN db.canal_plata cp ON co.ID_CONT = cp.COD_CONT
    LEFT JOIN db.locatie loc ON cp.COD_LOCATIE = loc.ID_LOCATIE
    LEFT JOIN db.comerciant cm ON cp.COD_COMERCIANT = cm.ID_COMERCIANT
UNION
ALL
SELECT
    ID_Tranzactie,
    ID_Client,
    ID_Cont,
    ID_Comerciant,
    CASE
        WHEN Tip_Echipament = 'POS' THEN 1
        WHEN Tip_Echipament = 'ONLINE' THEN 2
        ELSE NULL
    END AS ID_Canal_Plata,
    CASE
        WHEN Stare = 'Initiat' THEN 1
        WHEN Stare = 'Procesat' THEN 2
        WHEN Stare = 'Eroare' THEN 3
        ELSE NULL
    END AS ID_Stare,
    ID_Locatie,
    TO_CHAR(DATA_INITIERE, 'YYYYMMDD') AS ID_Data,
    SUMA,
    TO_CHAR(
        (DATA_PROCESARE - DATA_INITIERE) * 1440,
        '99999.99'
    ) AS Durata
FROM
    db.tranzactii t
    LEFT JOIN db.cont co ON t.COD_CONT_CREDITOR = co.ID_CONT
    LEFT JOIN db.client cl ON co.COD_CLIENT = cl.ID_CLIENT
    LEFT JOIN db.canal_plata cp ON co.ID_CONT = cp.COD_CONT
    LEFT JOIN db.locatie loc ON cp.COD_LOCATIE = loc.ID_LOCATIE
    LEFT JOIN db.comerciant cm ON cp.COD_COMERCIANT = cm.ID_COMERCIANT;