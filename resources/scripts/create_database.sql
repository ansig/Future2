CREATE TABLE units (
uid Varchar(512)  NOT NULL  PRIMARY KEY DEFAULT '-1',
name Varchar(512),
abbreviation Varchar(512),
metre REAL,
kilogram REAL,
second REAL,
exponent INTEGER  NOT NULL DEFAULT 1,
system INTEGER  NOT NULL  DEFAULT 0,
quantity INTEGER NOT NULL DEFAULT 8,
created TEXT,
modified TEXT);

INSERT INTO units (uid, name, abbreviation, quantity) VALUES ('system_0_1', 'Millimoles per litre', 'mmol/L', 0);
INSERT INTO units (uid, name, abbreviation, quantity) VALUES ('system_0_2', 'Milligrams per decilitre', 'mg/dl', 0);

INSERT INTO units (uid, name, abbreviation, metre, quantity) VALUES ('system_0_3', 'Metre', 'm', 1, 2);
INSERT INTO units (uid, name, abbreviation, metre, quantity) VALUES ('system_0_4', 'Millimetre', 'mm', 0.001, 2);
INSERT INTO units (uid, name, abbreviation, metre, quantity) VALUES ('system_0_5', 'Centimetre', 'cm', 0.01, 2);
INSERT INTO units (uid, name, abbreviation, metre, quantity) VALUES ('system_0_6', 'Decimetre', 'dm', 0.1, 2);
INSERT INTO units (uid, name, abbreviation, metre, quantity) VALUES ('system_0_7', 'Kilometre', 'km', 1000, 2);

INSERT INTO units (uid, name, abbreviation, metre, system, quantity) VALUES ('system_0_8', 'Inch', 'in', 0.0254, 1, 2);
INSERT INTO units (uid, name, abbreviation, metre, system, quantity) VALUES ('system_0_9', 'Foot', 'ft', 0.3048, 1, 2);
INSERT INTO units (uid, name, abbreviation, metre, system, quantity) VALUES ('system_0_10', 'Yard', 'yd', 0.9144, 1, 2);
INSERT INTO units (uid, name, abbreviation, metre, system, quantity) VALUES ('system_0_11', 'Mile', 'mi', 1609.34, 1, 2);

INSERT INTO units (uid, name, abbreviation, kilogram, quantity) VALUES ('system_0_12', 'Kilogram', 'kg', 1, 7);
INSERT INTO units (uid, name, abbreviation, kilogram, quantity) VALUES ('system_0_13', 'Gram', 'g', 0.001, 7);
INSERT INTO units (uid, name, abbreviation, kilogram, quantity) VALUES ('system_0_14', 'Milligram', 'mg', 0.000001, 7);

INSERT INTO units (uid, name, abbreviation, kilogram, system, quantity) VALUES ('system_0_15', 'Ounce', 'oz', 0.028349523125, 1, 7);
INSERT INTO units (uid, name, abbreviation, kilogram, system, quantity) VALUES ('system_0_16', 'Pound', 'lb', 0.45359237, 1, 7);

INSERT INTO units (uid, name, abbreviation, second, quantity) VALUES ('system_0_17', 'Second', 'sec', 1, 5);
INSERT INTO units (uid, name, abbreviation, second, quantity) VALUES ('system_0_18', 'Minute', 'min', 60, 5);
INSERT INTO units (uid, name, abbreviation, second, quantity) VALUES ('system_0_19', 'Hour', 'h', 3600, 5);
INSERT INTO units (uid, name, abbreviation, second, quantity) VALUES ('system_0_20', 'Day', 'days', 86400, 5);

INSERT INTO units (uid, name, abbreviation, metre, exponent, quantity) VALUES ('system_0_21', 'Litre', 'L', 0.001, 3, 6);
INSERT INTO units (uid, name, abbreviation, metre, exponent, quantity) VALUES ('system_0_22', 'Millilitre', 'ml', 0.000001, 3, 6);
INSERT INTO units (uid, name, abbreviation, metre, exponent, quantity) VALUES ('system_0_23', 'Centilitre', 'cl', 0.00001, 3, 6);
INSERT INTO units (uid, name, abbreviation, metre, exponent, quantity) VALUES ('system_0_24', 'Decilitre', 'dl', 0.0001, 3, 6);

INSERT INTO units (uid, name, abbreviation, metre, exponent, system, quantity) VALUES ('system_0_25', 'Ounce', 'fl oz [Imp]', 0.0000284130625, 3, 1, 6);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system, quantity) VALUES ('system_0_26', 'Pint', 'pt [Imp]', 0.00056826125, 3, 1, 6);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system, quantity) VALUES ('system_0_27', 'Gallon', 'gal [Imp]', 0.00454609, 3, 1, 6);

INSERT INTO units (uid, name, abbreviation, metre, exponent, system, quantity) VALUES ('system_0_28', 'Ounce [fluid, US food nutrition labeling]', 'US fl oz', 0.00003, 3, 0, 3);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system, quantity) VALUES ('system_0_29', 'Pint [fluid]', 'pt [US fl]', 0.000473176473, 3, 2, 6);
INSERT INTO units (uid, name, abbreviation, metre, exponent, system, quantity) VALUES ('system_0_30', 'Gallon [fluid]', 'gal [US]', 0.003785411784, 3, 2, 6);

INSERT INTO units (uid, name, abbreviation, metre, exponent, quantity) VALUES ('system_0_31', 'Insulin unit [U-100]', 'units', 0.00000001, 3, 1);

INSERT INTO units (uid, name, abbreviation, kilogram, quantity) VALUES ('system_0_32', 'Carbohydrates [grams]', 'carbs [g]', 0.001, 3);
INSERT INTO units (uid, name, abbreviation, kilogram, quantity) VALUES ('system_0_33', 'Protein [grams]', 'prot [g]', 0.001, 3);
INSERT INTO units (uid, name, abbreviation, kilogram, quantity) VALUES ('system_0_34', 'Fat [grams]', 'fat [g]', 0.001, 3);

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

INSERT INTO icons (iid, name) VALUES ('system_0_1', 'battery1Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_2', 'battery2Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_3', 'ballIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_4', 'bikeIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_5', 'bottle1Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_6', 'bottle2Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_7', 'cameraIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_8', 'cartonIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_9', 'catIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_10', 'clockIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_11', 'cloudIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_12', 'cogIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_13', 'computerIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_14', 'cutlery1Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_15', 'cutlery2Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_16', 'dropIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_17', 'face1Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_18', 'face2Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_19', 'face3Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_20', 'face4Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_21', 'face5Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_22', 'figure1Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_23', 'figure2Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_24', 'figure3Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_25', 'figure4Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_26', 'flakeIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_27', 'flowerIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_28', 'fruitIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_29', 'glassIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_30', 'hangerIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_31', 'heartIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_32', 'houseIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_33', 'luggageIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_34', 'mugIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_35', 'pageIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_36', 'pillIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_37', 'planeIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_38', 'potIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_39', 'scale1Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_40', 'scale2Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_41', 'starIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_42', 'sunIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_43', 'tankardIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_44', 'tiyIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_45', 'treesIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_46', 'trolleyIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_47', 'tubeIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_48', 'weightIcon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_49', 'wrench1Icon.png');
INSERT INTO icons (iid, name) VALUES ('system_0_50', 'wrench2Icon.png');

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
color INTEGER,
created TEXT,
modified TEXT,
deleted Boolean  NOT NULL DEFAULT FALSE,
lid Varchar(512),
uid Varchar(512),
did Varchar(512),
iid Varchar(512),
oid Varchar(512)  NOT NULL DEFAULT 'system_0_5');

INSERT INTO categories (cid, name, minimum, maximum, decimals, uid, did, iid, oid) VALUES ('system_0_1', 'Glucose', 0, 34, 1, 'system_0_1', 'system_0_3', 'system_0_16', 'system_0_1');

INSERT INTO categories (cid, name, minimum, maximum, uid, did, iid, oid) VALUES ('system_0_2', 'Rapid insulin', 1, 151, 'system_0_31', 'system_0_2', 'system_0_39', 'system_0_2');
INSERT INTO categories (cid, name, minimum, maximum, uid, did, iid, oid) VALUES ('system_0_3', 'Basal insulin', 1, 151, 'system_0_31', 'system_0_2', 'system_0_40', 'system_0_2');

INSERT INTO categories (cid, name, did, iid, oid) VALUES ('system_0_4', 'Note', 'system_0_1', 'system_0_35', 'system_0_3');
INSERT INTO categories (cid, name, did, iid, oid) VALUES ('system_0_5', 'Photo', 'system_0_4', 'system_0_7', 'system_0_3');

INSERT INTO categories (cid, name, minimum, maximum, decimals, uid, did, iid, oid) VALUES ('system_0_6', 'Weight', 1, 200, 1, 'system_0_12', 'system_0_3', 'system_0_44', 'system_0_4');

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