CREATE DATABASE IF NOT EXISTS customer_order;
USE customer_order;

CREATE TABLE kunden (
    kundennr        INT             PRIMARY KEY,
    kunden_name     VARCHAR(100)    NOT NULL,
    kunden_adresse  VARCHAR(200)    NOT NULL
);

CREATE TABLE artikel (
    artikelnr       INT             PRIMARY KEY,
    bezeichnung     VARCHAR(100)    NOT NULL,
    preis           DECIMAL(10,2)   NOT NULL
);

CREATE TABLE auftragspositionen (
    auftragsnr      INT             NOT NULL,
    artikelnr       INT             NOT NULL,
    menge           INT             NOT NULL,
    kundennr        INT             NOT NULL,

    PRIMARY KEY (auftragsnr, artikelnr),

    CONSTRAINT fk_artikel
        FOREIGN KEY (artikelnr)  REFERENCES artikel(artikelnr),

    CONSTRAINT fk_kunden
        FOREIGN KEY (kundennr)   REFERENCES kunden(kundennr)
);

INSERT INTO kunden VALUES (1, 'Maier GmbH', 'Wienerstr. 1, 9020 Klagenfurt');
INSERT INTO kunden VALUES (2, 'Hirsch AG',  'Linzerstr. 102, 1140 Wien');
INSERT INTO kunden VALUES (3, 'Kamm KG',    'Grazerweg 1, 1220 Wien');

INSERT INTO artikel VALUES (9001, 'Blue Ray DVD Laufwerk', 180.00);
INSERT INTO artikel VALUES (9002, '1.5 TB HDD',            160.00);
INSERT INTO artikel VALUES (9003, 'DVD Rohlinge',           18.00);
INSERT INTO artikel VALUES (9004, 'Notebook',             1200.00);

INSERT INTO auftragspositionen VALUES (1001, 9001,  9, 1);
INSERT INTO auftragspositionen VALUES (1001, 9002,  2, 1);
INSERT INTO auftragspositionen VALUES (1002, 9002,  2, 2);
INSERT INTO auftragspositionen VALUES (1002, 9004,  2, 2);
INSERT INTO auftragspositionen VALUES (1003, 9003, 30, 3);
