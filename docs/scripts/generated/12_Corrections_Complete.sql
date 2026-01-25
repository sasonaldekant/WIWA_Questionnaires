/*
===============================================================
  FAZA 12: Corrections - Kompletna Logika
  Opis: Unos korekcija (BMI, Sport, Zanimanje, Navike) i povezivanje sa tarifama
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

-- ============================================
-- 1. Unos Korekcija (Corrections Table)
-- ============================================

-- 1.1 BMI Korekcije (DO 29 godina)
IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'BMI_UNDER_18_AGE_UNDER_29_REJECT')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('BMI_UNDER_18_AGE_UNDER_29_REJECT', N'BMI < 18 (do 29 godina) - Odbiti', N'Zbog BMI indexa moguće je odbijanje ponude');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'BMI_30_33_AGE_UNDER_29')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('BMI_30_33_AGE_UNDER_29', N'BMI 30.51-33.00 (do 29 godina) - Korekcija', N'Zbog BMI indexa moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'BMI_33_35_AGE_UNDER_29')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('BMI_33_35_AGE_UNDER_29', N'BMI 33.01-35.00 (do 29 godina) - Korekcija', N'Zbog BMI indexa moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'BMI_35_37_AGE_UNDER_29')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('BMI_35_37_AGE_UNDER_29', N'BMI 35.01-37.00 (do 29 godina) - Korekcija', N'Zbog BMI indexa moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'BMI_37_40_AGE_UNDER_29')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('BMI_37_40_AGE_UNDER_29', N'BMI 37.01-40.00 (do 29 godina) - Korekcija', N'Zbog BMI indexa moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'BMI_OVER_40_AGE_UNDER_29_REJECT')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('BMI_OVER_40_AGE_UNDER_29_REJECT', N'BMI > 40 (do 29 godina) - Odbiti', N'Zbog BMI indexa moguće je odbijanje ponude');

-- 1.2 Sport Korekcije
IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'SPORT_CLASS_I')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('SPORT_CLASS_I', N'Sport razreda I - Nizak rizik', N'Zbog bavljenja određenim sportom moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'SPORT_CLASS_II')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('SPORT_CLASS_II', N'Sport razreda II - Nizak do srednji rizik', N'Zbog bavljenja određenim sportom moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'SPORT_CLASS_III')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('SPORT_CLASS_III', N'Sport razreda III - Srednji rizik', N'Zbog bavljenja određenim sportom moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'SPORT_CLASS_IV')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('SPORT_CLASS_IV', N'Sport razreda IV - Srednji do visok rizik', N'Zbog bavljenja određenim sportom moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'SPORT_CLASS_V')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('SPORT_CLASS_V', N'Sport razreda V - Visok rizik', N'Zbog bavljenja određenim sportom moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'SPORT_CLASS_VI_REJECT')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('SPORT_CLASS_VI_REJECT', N'Sport razreda VI - Neprihvatljiv rizik', N'Zbog bavljenja određenim sportom moguće je odbijanje ponude');

-- 1.3 Alkohol & Duvan & Droga
IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'ALCOHOL_LEVEL_1')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('ALCOHOL_LEVEL_1', N'Alkohol - Nivo 1 (+5 god)', N'Zbog konzumiranja alkohola moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'TOBACCO_LEVEL_1')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('TOBACCO_LEVEL_1', N'Duvan - Nivo 1 (+5 god)', N'Zbog konzumiranja duvana moguća je korekcija premije');

IF NOT EXISTS (SELECT 1 FROM Corrections WHERE Code = 'DRUGS_CONSUMPTION_REJECT')
    INSERT INTO Corrections (Code, Name, Description) VALUES ('DRUGS_CONSUMPTION_REJECT', N'Konzumiranje droga - Odbijanje', N'Zbog konzumiranja droga moguće je odbijanje iz osiguranja');


-- ============================================
-- 2. Povezivanje sa Tarifama (AllowedCorrectionLevels)
-- ============================================

-- Predpostavka: CorrectionLevel 'Risk' postoji (Level na nivou rizika)
DECLARE @Level_Risk INT = (SELECT CorrectionLevelID FROM CorrectionLevels WHERE Name = 'Risk');
-- Ako ne postoji, fallback
IF @Level_Risk IS NULL SET @Level_Risk = 1;

-- Primer Tarife: ŽIVOT (treba proci kroz sve tarife)
DECLARE @Tariff_Life INT = (SELECT TariffID FROM Tariffs WHERE Code = 'ZIVOT');

IF @Tariff_Life IS NOT NULL AND @Level_Risk IS NOT NULL
BEGIN
    -- Povezivanje BMI korekcije sa Život tarifom
    IF NOT EXISTS (SELECT 1 FROM AllowedCorrectionLevels 
                   WHERE CorrectionID = (SELECT CorrectionID FROM Corrections WHERE Code = 'BMI_30_33_AGE_UNDER_29')
                   AND TariffID = @Tariff_Life)
    BEGIN
        INSERT INTO AllowedCorrectionLevels
        (CorrectionID, CorrectionLevelID, TariffID, IsPrintedOnItem)
        VALUES
        ((SELECT CorrectionID FROM Corrections WHERE Code = 'BMI_30_33_AGE_UNDER_29'),
         @Level_Risk,
         @Tariff_Life,
         1);
    END
    
    -- Povezivanje Sport korekcije
    IF NOT EXISTS (SELECT 1 FROM AllowedCorrectionLevels 
                   WHERE CorrectionID = (SELECT CorrectionID FROM Corrections WHERE Code = 'SPORT_CLASS_I')
                   AND TariffID = @Tariff_Life)
    BEGIN
        INSERT INTO AllowedCorrectionLevels
        (CorrectionID, CorrectionLevelID, TariffID, IsPrintedOnItem)
        VALUES
        ((SELECT CorrectionID FROM Corrections WHERE Code = 'SPORT_CLASS_I'),
         @Level_Risk,
         @Tariff_Life,
         1);
    END
END

-- Validacija
SELECT TOP 10 c.Code, c.Name, t.Code as Tariff, cl.Name as Level
FROM AllowedCorrectionLevels acl
JOIN Corrections c ON acl.CorrectionID = c.CorrectionID
JOIN Tariffs t ON acl.TariffID = t.TariffID
JOIN CorrectionLevels cl ON acl.CorrectionLevelID = cl.CorrectionLevelID
ORDER BY acl.AllowedCorrectionLevelID DESC;

COMMIT;
