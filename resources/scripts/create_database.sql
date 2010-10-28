CREATE TABLE units (
uid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
name Varchar(512),
abbreviation Varchar(512),
metre REAL,
kilogram REAL,
second REAL,
exponent INTEGER  NOT NULL DEFAULT 1,
system INTEGER  NOT NULL  DEFAULT 0,
created TEXT,
modified TEXT);

INSERT INTO units (uid, name, abbreviation) VALUES ('system_0_1', 'Millimoles per litre', 'mmol/L');
INSERT INTO units (uid, name, abbreviation) VALUES ('system_0_2', 'Milligrams per decilitre', 'mg/dl');

INSERT INTO units (uid, name, abbreviation, metre) VALUES ('system_0_3', 'Metre', 'm', 1);
INSERT INTO units (uid, name, abbreviation, metre) VALUES ('system_0_4', 'Millimetre', 'mm', 0.001);
INSERT INTO units (uid, name, abbreviation, metre) VALUES ('system_0_5', 'Centimetre', 'cm', 0.01);
INSERT INTO units (uid, name, abbreviation, metre) VALUES ('system_0_6', 'Decimetre', 'dm', 0.1);
INSERT INTO units (uid, name, abbreviation, metre) VALUES ('system_0_7', 'Kilometre', 'km', 1000);

INSERT INTO units (uid, name, abbreviation, metre, system) VALUES ('system_0_8', 'Inch', 'in', 0.0254, 1);
INSERT INTO units (uid, name, abbreviation, metre, system) VALUES ('system_0_9', 'Foot', 'ft', 0.3048, 1);
INSERT INTO units (uid, name, abbreviation, metre, system) VALUES ('system_0_10', 'Yard', 'yd', 0.9144, 1);
INSERT INTO units (uid, name, abbreviation, metre, system) VALUES ('system_0_11', 'Mile', 'mi', 1609.34, 1);

INSERT INTO units (uid, name, abbreviation, kilogram) VALUES ('system_0_12', 'Kilogram', 'kg', 1);
INSERT INTO units (uid, name, abbreviation, kilogram) VALUES ('system_0_13', 'Gram', 'g', 0.001);

INSERT INTO units (uid, name, abbreviation, kilogram, system) VALUES ('system_0_14', 'Ounce', 'oz', 0.028349523125, 1);
INSERT INTO units (uid, name, abbreviation, kilogram, system) VALUES ('system_0_15', 'Pound', 'lb', 0.45359237, 1);

INSERT INTO units (uid, name, abbreviation, second) VALUES ('system_0_16', 'Second', 's', 1);
INSERT INTO units (uid, name, abbreviation, second) VALUES ('system_0_17', 'Minute', 'm', 60);
INSERT INTO units (uid, name, abbreviation, second) VALUES ('system_0_18', 'Hour', 'h', 3600);
INSERT INTO units (uid, name, abbreviation, second) VALUES ('system_0_19', 'Day', 'd', 86400);

INSERT INTO units (uid, name, abbreviation, metre, exponent) VALUES ('system_0_20', 'Litre', 'L', 0.001, 3);
INSERT INTO units (uid, name, abbreviation, metre, exponent) VALUES ('system_0_21', 'Millilitre', 'ml', 0.000001, 3);
INSERT INTO units (uid, name, abbreviation, metre, exponent) VALUES ('system_0_22', 'Centilitre', 'cl', 0.00001, 3);
INSERT INTO units (uid, name, abbreviation, metre, exponent) VALUES ('system_0_23', 'Decilitre', 'dl', 0.0001, 3);

INSERT INTO units (uid, name, abbreviation, metre, exponent, system) VALUES ('system_0_24', 'Ounce', 'fl oz (Imp)', 0.0000284130625, 3, 1);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system) VALUES ('system_0_25', 'Pint', 'pt (Imp)', 0.00056826125, 3, 1);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system) VALUES ('system_0_26', 'Gallon', 'gal (Imp)', 0.00454609, 3, 1);

INSERT INTO units (uid, name, abbreviation, metre, exponent, system) VALUES ('system_0_27', 'Ounce (fluid, US food nutrition labeling)', 'US fl oz', 0.00003, 3, 2);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system) VALUES ('system_0_28', 'Pint (fluid)', 'pt (US fl)', 0.000473176473, 3, 2);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system) VALUES ('system_0_29', 'Gallon (fluid)', 'gal (US)', 0.003785411784, 3, 2);

INSERT INTO units (uid, name, abbreviation, metre, exponent) VALUES ('system_0_30', 'Insulin unit (U-100)', 'units', 0.00000001, 3);

CREATE TABLE owners (
oid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
name Varchar(512));

INSERT INTO owners (oid, name) VALUES ('system_0_1', 'Glucose');
INSERT INTO owners (oid, name) VALUES ('system_0_2', 'Insulin');
INSERT INTO owners (oid, name) VALUES ('system_0_3', 'Documents');
INSERT INTO owners (oid, name) VALUES ('system_0_4', 'Profile');
INSERT INTO owners (oid, name) VALUES ('system_0_5', 'Tags');

CREATE TABLE icons (
iid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
name Varchar(512),
created TEXT(512),
modified TEXT(512));

INSERT INTO icons (iid, name) VALUES ('system_0_1', 'glucoseIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_2', 'rapidIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_3', 'basalIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_4', 'tagIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_5', 'noteIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_6', 'photoIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_7', 'audioIcon.png');

CREATE TABLE datatypes (
did Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
name Varchar(512)  NOT NULL DEFAULT 'string');

INSERT INTO datatypes (did, name) VALUES ('system_0_1', 'string');
INSERT INTO datatypes (did, name) VALUES ('system_0_2', 'integer');
INSERT INTO datatypes (did, name) VALUES ('system_0_3', 'decimal');
INSERT INTO datatypes (did, name) VALUES ('system_0_4', 'photo');
INSERT INTO datatypes (did, name) VALUES ('system_0_5', 'audio');

CREATE TABLE locations (
lid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
latitude Double,
longitude Double,
altitude Double,
horizontal_accuracy Double,
vertical_accuracy Double,
timestamp TEXT,
created TEXT,
modified TEXT);

CREATE TABLE categories (
cid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
name Varchar(512),
minimum INTEGER,
maximum INTEGER,
decimals INTEGER,
created TEXT,
modified TEXT,
deleted Boolean  NOT NULL DEFAULT FALSE,
lid Varchar(512),
uid Varchar(512),
did Varchar(512),
iid Varchar(512),
oid Varchar(512)  NOT NULL DEFAULT 'system_0_5');

INSERT INTO categories (cid, name, minimum, maximum, decimals, uid, did, iid, oid) VALUES ('system_0_1', 'Glucose', 0, 34, 1, 'system_0_1', 'system_0_3', 'system_0_1', 'system_0_1');

INSERT INTO categories (cid, name, minimum, maximum, uid, did, iid, oid) VALUES ('system_0_2', 'Rapid insulin', 1, 151, 'system_0_30', 'system_0_2', 'system_0_2', 'system_0_2');
INSERT INTO categories (cid, name, minimum, maximum, uid, did, iid, oid) VALUES ('system_0_3', 'Basal insulin', 1, 151, 'system_0_30', 'system_0_2', 'system_0_3', 'system_0_2');

INSERT INTO categories (cid, name, did, iid, oid) VALUES ('system_0_4', 'Note', 'system_0_1', 'system_0_5', 'system_0_3');
INSERT INTO categories (cid, name, did, iid, oid) VALUES ('system_0_5', 'Photo', 'system_0_4', 'system_0_6', 'system_0_3');

INSERT INTO categories (cid, name, minimum, maximum, decimals, uid, did, iid, oid) VALUES ('system_0_6', 'Weight', 1, 200, 1, 'system_0_12', 'system_0_3', 'system_0_4', 'system_0_4');

CREATE TABLE entries (
eid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
title Varchar(512),
string TEXT,
integer INTEGER,
decimal REAL,
timestamp TEXT,
created TEXT,
modified TEXT,
deleted Boolean  NOT NULL  DEFAULT FALSE,
cid Varchar(512)  NOT NULL DEFAULT 'system_0_4',
uid Varchar(512),
lid Varchar(512));

CREATE TABLE attachments (
aid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
owner_eid Varchar(512)  NOT NULL DEFAULT '-1',
attachment_eid Varchar(512)  NOT NULL DEFAULT '-1',
created TEXT,
modified TEXT,
deleted Boolean  NOT NULL DEFAULT FALSE);

CREATE TABLE sequences (
serial integer  PRIMARY KEY AUTOINCREMENT,
name Varchar(512),
sequence INTEGER  NOT NULL  DEFAULT 0);

INSERT INTO sequences (name) VALUES ('units');
INSERT INTO sequences (name) VALUES ('owners');
INSERT INTO sequences (name) VALUES ('icons');
INSERT INTO sequences (name) VALUES ('datatypes');
INSERT INTO sequences (name) VALUES ('locations');
INSERT INTO sequences (name) VALUES ('categories');
INSERT INTO sequences (name) VALUES ('entries');
INSERT INTO sequences (name) VALUES ('attachments');