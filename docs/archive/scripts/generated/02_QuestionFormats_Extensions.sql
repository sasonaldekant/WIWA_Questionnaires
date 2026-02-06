/*
===============================================================
  FAZA 2: QuestionFormats
  Opis: Provera i dopuna formata pitanja
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

SET IDENTITY_INSERT QuestionFormats ON;

-- 1. Boolean (Da/Ne)
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Boolean')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (10, N'Boolean', N'Da/Ne izbor');
END

-- 2. String (Slobodan unos)
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'String')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (11, N'String', N'Slobodan tekstualni unos');
END

-- 3. Integer (Ceo broj)
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Integer')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (12, N'Integer', N'Celobrojna vrednost');
END

-- 4. Decimal (Decimalni broj)
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Decimal')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (13, N'Decimal', N'Decimalna vrednost');
END

-- 5. Dropdown (Jedan izbor iz liste)
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Dropdown')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (14, N'Dropdown', N'Padajući meni - jedan izbor');
END

-- 6. Multiple Choice (Više izbora)
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Multiple Choice')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (15, N'Multiple Choice', N'Checkboxes - više mogućih izbora');
END

-- 7. Autocomplete (Pretraga)
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Autocomplete')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (16, N'Autocomplete', N'Polje sa pretragom (za sportove, zanimanja)');
END

-- 8. Date
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Date')
BEGIN
    INSERT INTO QuestionFormats (QuestionFormatID, Name, Description)
    VALUES (17, N'Date', N'Datumsko polje');
END

SET IDENTITY_INSERT QuestionFormats OFF;

-- Validacija
SELECT * FROM QuestionFormats;

COMMIT;
