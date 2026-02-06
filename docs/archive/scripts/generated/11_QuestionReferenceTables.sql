/*
===============================================================
  FAZA 11: QuestionReferenceTables
  Opis: Povezivanje pitanja sa lookup tabelama (Sport, itd.)
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

-- 1. Provera/Kreiranje tabele (Defanzivno)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionReferenceTables]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[QuestionReferenceTables](
        [QuestionReferenceTableID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [QuestionID] [int] NOT NULL,
        [ReferenceTableName] [nvarchar](100) NOT NULL,
        [ReferenceTableKeyColumn] [nvarchar](100) NOT NULL,
        [ReferenceTableDisplayColumn] [nvarchar](100) NOT NULL,
        [AdditionalCondition] [nvarchar](500) NULL,
        FOREIGN KEY ([QuestionID]) REFERENCES [dbo].[Questions]([QuestionID])
    );
END

-- 2. Povezivanje Pitanja 150 (Sport - Veliki upitnik)
-- Brisanje ako postoji
DELETE FROM QuestionReferenceTables WHERE QuestionID = 150;

INSERT INTO QuestionReferenceTables
(QuestionID, ReferenceTableName, ReferenceTableKeyColumn, ReferenceTableDisplayColumn)
VALUES
(150, N'Sports', N'SportID', N'SportName');

-- 3. Povezivanje Pitanja 231 (Sport - Skraćeni upitnik)
IF EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 231)
BEGIN
    DELETE FROM QuestionReferenceTables WHERE QuestionID = 231;

    INSERT INTO QuestionReferenceTables
    (QuestionID, ReferenceTableName, ReferenceTableKeyColumn, ReferenceTableDisplayColumn)
    VALUES
    (231, N'Sports', N'SportID', N'SportName');
END

-- Validacija
SELECT q.QuestionText, qrt.ReferenceTableName, qrt.ReferenceTableDisplayColumn
FROM QuestionReferenceTables qrt
JOIN Questions q ON qrt.QuestionID = q.QuestionID;

COMMIT;
