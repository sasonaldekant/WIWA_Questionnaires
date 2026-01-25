# Faza 12: Corrections - BMI, Sport, Occupation, Alkohol, Duvan

**Trajanje**: 4-6 sati  
**Prioritet**: HIGH  
**Dependencies**: Faza 1, 9 (Sports/DangerClass)

## Opis

Ovo je **najkompleksnija faza** - unos svih korekcija prema odgovorima na pitanja.

Koristimo postojeću infrastrukturu:
- `Corrections` - šifarnik korekcija
- `CorrectionLevels` - nivoi primene
- `AllowedCorrectionLevels` - veza correction-level-tariff

## 12.1: Corrections - BMI Ranges

**12 pravila** prema BMI rangu i starosti:

```sql
-- 12a_Corrections_BMI.sql

BEGIN TRANSACTION;

-- ============================================
-- BMI Corrections - Pristupna starost DO 29 godina
-- ============================================

INSERT INTO Corrections (Code, Name, Description)
VALUES
('BMI_UNDER_18_AGE_UNDER_29_REJECT', 
    N'BMI < 18 (do 29 godina) - Odbiti', 
    N'Zbog BMI indexa moguće je odbijanje ponude'),

('BMI_30_33_AGE_UNDER_29', 
    N'BMI 30.51-33.00 (do 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_33_35_AGE_UNDER_29', 
    N'BMI 33.01-35.00 (do 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_35_37_AGE_UNDER_29', 
    N'BMI 35.01-37.00 (do 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_37_40_AGE_UNDER_29', 
    N'BMI 37.01-40.00 (do 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_OVER_40_AGE_UNDER_29_REJECT', 
    N'BMI > 40 (do 29 godina) - Odbiti', 
    N'Zbog BMI indexa moguće je odbijanje ponude');

-- ============================================
-- BMI Corrections - Pristupna starost PREKO 29 godina
-- ============================================

INSERT INTO Corrections (Code, Name, Description)
VALUES
('BMI_UNDER_18_AGE_OVER_29_REJECT', 
    N'BMI < 18 (preko 29 godina) - Odbiti', 
    N'Zbog BMI indexa moguće je odbijanje ponude'),

('BMI_30_33_AGE_OVER_29', 
    N'BMI 30.51-33.00 (preko 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_33_35_AGE_OVER_29', 
    N'BMI 33.01-35.00 (preko 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_35_37_AGE_OVER_29', 
    N'BMI 35.01-37.00 (preko 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_37_40_AGE_OVER_29', 
    N'BMI 37.01-40.00 (preko 29 godina) - Korekcija', 
    N'Zbog BMI indexa moguća je korekcija premije'),

('BMI_OVER_40_AGE_OVER_29_REJECT', 
    N'BMI > 40 (preko 29 godina) - Odbiti', 
    N'Zbog BMI indexa moguće je odbijanje ponude');

COMMIT;
```

**Napomena**: Vrednosti korekcija (‰, %, starosti) se definišu preko **matrice** - ne ovde!

---

## 12.2: Corrections - Sport (prema Danger Class)

**6 pravila** - po razredu opasnosti:

```sql
-- 12b_Corrections_Sport.sql

BEGIN TRANSACTION;

INSERT INTO Corrections (Code, Name, Description)
VALUES
('SPORT_CLASS_I', 
    N'Sport razreda I - Nizak rizik', 
    N'Zbog bavljenja određenim sportom moguća je korekcija premije'),

('SPORT_CLASS_II', 
    N'Sport razreda II - Nizak do srednji rizik', 
    N'Zbog bavljenja određenim sportom moguća je korekcija premije'),

('SPORT_CLASS_III', 
    N'Sport razreda III - Srednji rizik', 
    N'Zbog bavljenja određenim sportom moguća je korekcija premije'),

('SPORT_CLASS_IV', 
    N'Sport razreda IV - Srednji do visok rizik', 
    N'Zbog bavljenja određenim sportom moguća je korekcija premije'),

('SPORT_CLASS_V', 
    N'Sport razreda V - Visok rizik', 
    N'Zbog bavljenja određenim sportom moguća je korekcija premije'),

('SPORT_CLASS_VI_REJECT', 
    N'Sport razreda VI - Neprihvatljiv rizik', 
    N'Zbog bavljenja određenim sportom moguće je odbijanje ponude. Za eventualno razmatranje prijema u osiguranje potrebno je priložiti Saglasnost osiguranika za isključenje obaveze osiguravača ukoliko osigurani slučaj nastane za vreme bavljenja određenim sportom');

COMMIT;
```

---

## 12.3: Corrections - Occupation (15+ pravila)

**15+ korekcija** za zanimanja:

```sql
-- 12c_Corrections_Occupation.sql

BEGIN TRANSACTION;

INSERT INTO Corrections (Code, Name, Description)
VALUES
('OCCUPATION_CONSTRUCTION', 
    N'Građevinarstvo - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_MINERS', 
    N'Rudarstvo - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_PILOTS_REJECT', 
    N'Letačko osoblje - Odbijanje', 
    N'Zbog rizika zanimanja moguće je odbijanje ponude. Za eventualno razmatranje prijema u osiguranje potrebno je priložiti Saglasnost osiguranika za isključenje obaveze osiguravača ukoliko osigurani slučaj nastane za vreme obavljanja redovnog zanimanja'),

('OCCUPATION_SECURITY_BASIC', 
    N'Obezbeđenje objekata - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_SECURITY_MONEY', 
    N'Obezbeđenje novca i vrednosti - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_SECURITY_PERSONAL_REJECT', 
    N'Lična pratnja i zaštita - Odbijanje', 
    N'Zbog rizika zanimanja moguće je odbijanje ponude'),

('OCCUPATION_EXPLOSIVES_LAB', 
    N'Rad sa gasovima/eksplozivom - Laboranti - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_EXPLOSIVES_PRODUCTION', 
    N'Proizvodnja baruta, municije - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_RADIOACTIVE_REJECT', 
    N'Rad sa radioaktivnim materijama - Odbijanje', 
    N'Zbog rizika zanimanja moguće je odbijanje ponude'),

('OCCUPATION_DIVERS_REJECT', 
    N'Ronioci - Odbijanje', 
    N'Zbog rizika zanimanja moguće je odbijanje ponude'),

('OCCUPATION_STUNTMEN', 
    N'Kaskaderi - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_FIREFIGHTERS', 
    N'Vatrogasci - Korekcija', 
    N'Zbog rizika zanimanja moguća je korekcija premije'),

('OCCUPATION_MILITARY_SPECIAL_REJECT', 
    N'Vojska i policija - Specijalne jedinice - Odbijanje', 
    N'Zbog rizika zanimanja moguće je odbijanje ponude');

-- ... još ~5-10 kategorija

COMMIT;
```

---

## 12.4: Corrections - Alkohol

**4 nivoa** konzumacije:

```sql
-- 12d_Corrections_Alcohol.sql

BEGIN TRANSACTION;

INSERT INTO Corrections (Code, Name, Description)
VALUES
('ALCOHOL_LEVEL_1', 
    N'Alkohol - Nivo 1 (do 1.5L piva) - Korekcija', 
    N'Zbog konzumiranja alkohola moguća je korekcija premije'),

('ALCOHOL_LEVEL_2', 
    N'Alkohol - Nivo 2 (do 2L piva) - Korekcija', 
    N'Zbog konzumiranja alkohola moguća je korekcija premije'),

('ALCOHOL_LEVEL_3_REJECT', 
    N'Alkohol - Nivo 3 (preko 2L piva) - Odbijanje', 
    N'Zbog konzumiranja alkohola moguće je odbijanje ponude');

COMMIT;
```

---

## 12.5: Corrections - Duvan

**4 nivoa** konzumacije:

```sql
-- 12e_Corrections_Tobacco.sql

BEGIN TRANSACTION;

INSERT INTO Corrections (Code, Name, Description)
VALUES
('TOBACCO_LEVEL_1', 
    N'Duvan - Nivo 1 (do 30 cigareta) - Korekcija', 
    N'Zbog konzumiranja duvana moguća je korekcija premije'),

('TOBACCO_LEVEL_2', 
    N'Duvan - Nivo 2 (do 40 cigareta) - Korekcija', 
    N'Zbog konzumiranja duvana moguća je korekcija premije'),

('TOBACCO_LEVEL_3_REJECT', 
    N'Duvan - Nivo 3 (preko 40 cigareta) - Odbijanje', 
    N'Zbog konzumiranja duvana moguće je odbijanje ponude');

COMMIT;
```

---

## 12.6: Corrections - Droge

**1 pravilo** - automatsko odbijanje:

```sql
-- 12f_Corrections_Drugs.sql

BEGIN TRANSACTION;

INSERT INTO Corrections (Code, Name, Description)
VALUES
('DRUGS_CONSUMPTION_REJECT', 
    N'Konzumiranje droga - Odbijanje', 
    N'Devido konzumiranja droga moguće je odbijanje iz osiguranja');

COMMIT;
```

---

## 12.7: AllowedCorrectionLevels - Povezivanje

**Kritično**: Povezivanje Corrections sa TariffRisks preko `AllowedCorrectionLevels`

```sql
-- 12g_AllowedCorrectionLevels.sql

-- Za svaku TariffID i svaku Correction, definisati:
-- - Na kom CorrectionLevel se primenjuje (polisa/rizik/paket)
-- - Vrednosti korekcija će biti u MAT RICI

BEGIN TRANSACTION;

-- Primer: BMI_30_33_AGE_UNDER_29 za Život
INSERT INTO AllowedCorrectionLevels
(CorrectionID, CorrectionLevelID, TariffID, ActionID, OrdinalNumber, IsPrintedOnItem)
VALUES
((SELECT CorrectionID FROM Corrections WHERE Code = 'BMI_30_33_AGE_UNDER_29'),
 (SELECT CorrectionLevelID FROM CorrectionLevels WHERE Name = 'Risk'), -- ili koji nivo
 (SELECT TariffID FROM Tariffs WHERE Code = 'ZIVOT'), -- Život
 NULL, -- ActionID ako treba
 1,
 1); -- Print na polisi

-- Slično za sve kombinacije:
-- - BMI korekcije × Rizici (Život, MAK, Nezgoda, Hirurške, Teže bolesti)
-- - Sport korekcije × Rizici
-- - Occupation korekcije × Rizici
-- - Alkohol korekcije × Rizici
-- - Duvan korekcije × Rizici

COMMIT;
```

**Napomena**: Ovo je **najdugotrajniji deo** - potrebno ~100-200 redova za sve kombinacije!

---

## 12.8: Matrica Korekcija (Važno!)

**Vrednosti** korekcija se definišu van ovih INSERT-ova, kroz **matricu** koja postoji u sistemu.

Matrica sadrži:
- Za BMI: ‰ po OS (Život), ‰ po RK (MAK/Sinergija), % premije (Hirurške), godine (Teže bolesti)
- Za Sport: ‰ po razredu
- Za Occupation: ‰ po zanimanju
- Za Alkohol/Duvan: Povećanje starosti (godine)

**Decision Point 5**:
- ❓ Kako se definiše matrica vrednosti?
- 🎯 **Akcija**: Konsultovati sa DBA - možda posebna tabela `CorrectionValues` ili direktno u aplikaciji?

---

## Validacija - Faza 12

```sql
-- Provera broja Corrections
SELECT COUNT(*) FROM Corrections WHERE Code LIKE 'BMI%';
-- Expected: 12

SELECT COUNT(*) FROM Corrections WHERE Code LIKE 'SPORT%';
-- Expected: 6

SELECT COUNT(*) FROM Corrections WHERE Code LIKE 'OCCUPATION%';
-- Expected: 15+

SELECT COUNT(*) FROM Corrections WHERE Code LIKE 'ALCOHOL%';
-- Expected: 3

SELECT COUNT(*) FROM Corrections WHERE Code LIKE 'TOBACCO%';
-- Expected: 3

SELECT COUNT(*) FROM Corrections WHERE Code LIKE 'DRUGS%';
-- Expected: 1

-- Total: ~40+ Corrections

-- Provera AllowedCorrectionLevels
SELECT COUNT(*) FROM AllowedCorrectionLevels 
WHERE CorrectionID IN (SELECT CorrectionID FROM Corrections WHERE Code LIKE 'BMI%');
-- Expected: Mnogo - svaka BMI korekcija × broj rizika
```

---

**Napomena**: Ova faza je najkompleksnija i može se podeliti na pod-faze (12a, 12b, 12c...) za lakše praćenje!
