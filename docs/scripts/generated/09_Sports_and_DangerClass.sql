/*
===============================================================
  FAZA 9: Sports & DangerClass
  Opis: Kreiranje i punjenje lookup tabela za sportove i razrede opasnosti
  Autor: Antigravity Agent
  Datum: 2026-01-24
  
  Napomena: User je napomenuo da ove tabele verovatno već postoje.
  Skripta prvo proverava i kreira tabele ako ne postoje, pa onda puni podatke.
===============================================================
*/

BEGIN TRANSACTION;

-- ============================================================
-- 1. DangerClass - Razredi opasnosti (I - VI)
-- ============================================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DangerClass]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[DangerClass](
        [DangerClassID] [smallint] PRIMARY KEY,
        [ClassName] [nvarchar](10) NOT NULL, -- 'I', 'II', 'III', 'IV', 'V', 'VI'
        [Description] [nvarchar](500) NULL,
        [DefaultAction] [nvarchar](50) NULL -- 'CORRECT' or 'REJECT'
    );
END

-- Punjenje podataka
DELETE FROM DangerClass; -- Reset za demo (ili koristiti MERGE)

INSERT INTO DangerClass (DangerClassID, ClassName, Description, DefaultAction)
VALUES
(1, N'I', N'Nizak rizik - minimalno povećanje premije', N'CORRECT'),
(2, N'II', N'Nizak do srednji rizik', N'CORRECT'),
(3, N'III', N'Srednji rizik', N'CORRECT'),
(4, N'IV', N'Srednji do visok rizik', N'CORRECT'),
(5, N'V', N'Visok rizik - značajno povećanje premije', N'CORRECT'),
(6, N'VI', N'Neprihvatljiv rizik - odbijanje', N'REJECT');


-- ============================================================
-- 2. Sports - Lista sportova
-- ============================================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sports]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Sports](
        [SportID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [SportName] [nvarchar](200) NOT NULL,
        [DangerClassID] [smallint] NOT NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [FK_Sports_DangerClass] FOREIGN KEY([DangerClassID])
        REFERENCES [dbo].[DangerClass] ([DangerClassID])
    );
    
    CREATE INDEX [IDX_Sports_Name] ON [dbo].[Sports]([SportName]);
END

-- Punjenje sportova (Reprezentativna lista)
-- VAŽNO: Kompletan spisak od ~200 sportova učitati iz: 
-- docs/specification/Upitnici i obrasci/Sports.xlsx
-- 
-- Ovde su navedeni samo primeri za svaki razred:

-- Razred I (Nizak rizik)
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Fudbal') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Fudbal', 1);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Košarka') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Košarka', 1);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Tenis') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Tenis', 1);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Plivanje') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Plivanje', 1);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Trčanje') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Trčanje', 1);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Odbojka') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Odbojka', 1);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Rukomet') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Rukomet', 1);

-- Razred II
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Biciklizam (amaterski)') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Biciklizam (amaterski)', 2);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Klizanje') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Klizanje', 2);

-- Razred III
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Skijanje') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Skijanje', 3);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Snowboarding') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Snowboarding', 3);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Planinarenje (< 2500m)') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Planinarenje (< 2500m)', 3);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Hokej na ledu') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Hokej na ledu', 3);

-- Razred IV
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Boks (amaterski)') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Boks (amaterski)', 4);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Borilačke veštine') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Borilačke veštine', 4);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Jahanje') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Jahanje', 4);

-- Razred V (Visok rizik)
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Alpinizam') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Alpinizam', 5);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Padobranstvo (sportsko)') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Padobranstvo (sportsko)', 5);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Ronjenje') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Ronjenje', 5);

-- Razred VI (Odbijanje)
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'BASE jumping') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'BASE jumping', 6);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Bungee jumping') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Bungee jumping', 6);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Slobodno penjanje (Free solo)') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Slobodno penjanje (Free solo)', 6);
IF NOT EXISTS (SELECT 1 FROM Sports WHERE SportName = N'Automobilizam (trke)') INSERT INTO Sports (SportName, DangerClassID) VALUES (N'Automobilizam (trke)', 6);

-- Validacija
SELECT 'DangerClass count' as Label, COUNT(*) as Cnt FROM DangerClass
UNION ALL
SELECT 'Sports count', COUNT(*) FROM Sports;

COMMIT;
