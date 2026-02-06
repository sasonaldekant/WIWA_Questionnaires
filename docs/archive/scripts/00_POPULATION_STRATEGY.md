# Strategija Punjenja Upitnika - Faz ni Pristup

## Pregled Strategije

**Cilj**: Iterativno punjenje baze sa 5 tipova upitnika kroz kontrolisane faze

**Pristup**: Bottom-up - prvo lookup tabele i šifarnici, pa onda upitnici

## ✅ Potvrđeno - Postoje u Modelu

### SpecificQuestionTypes (Ključno otkriće!)

```sql
-- VEĆ POSTOJE:
1. 'AlwaysVisible' - Pitanje uvek vidljivo
2. 'ConditionallyVisible' - Vidljivo pod uslovom  
3. 'Computed' - Kalkulisano (BMI, etc.)

-- DODATI (opciono):
4. 'BMI_Computation' - Specifična BMI logika
5. 'Sport_Autocomplete' - Autocomplete sport lookup
6. 'Declaration' - Izjava (samo tekst)
7. 'PEP_Check' - PEP funkč ioner logika
8. 'Risk_Scoring' - Bodovanje rizika
```

**Predlog**: Koristiti postojeće 3 tipa + dodati specifične samo ako je logika VEOMA kompleksna. Većinu logike implementirati u kodu, ne u bazi!

---

## Faza 0: Priprema - SpecificQuestionTypes (OPCIONO)

**Trajanje**: 30 min  
**Prioritet**: LOW - možda nije ni potrebno

```sql
-- 00_SpecificQuestionTypes_Extensions.sql (OPCIONO - verovatno nije potrebno!)
-- ✅ COMPUTED već postoji i radi sa matricom - pokriva BMI!

-- Dodaj SAMO ako treba specijalna UI logika:
-- INSERT INTO SpecificQuestionTypes (Name) VALUES
-- ('Sport_Autocomplete'),     -- Autocomplete sports (ali možda Dropdown + lookup dovoljno)
-- ('Declaration_Display');    -- Samo prikaz teksta (ali možda AppLogic bolje)
```

**Decision Point 0**: 
- ❓ Da li dodajemo nove SpecificQuestionTypes?
- 🎯 **Preporuka**: **NE** - Computed sa matricom pokriva BMI, ConditionallyVisible + PredefinedAnswerSubQuestions pokriva grananje
- 💡 **Napomena**: Za Sport i Occupation koristiti reference tabele (QuestionReferenceTables), ne novi tip!

---

## Faza 1: QuestionnaireTypes (5 tipova)

**Trajanje**: 15 min  
**Prioritet**: CRITICAL  
**Dependencies**: None

```sql
-- 01_QuestionnaireTypes.sql

SET IDENTITY_INSERT QuestionnaireTypes ON;

INSERT INTO QuestionnaireTypes 
(QuestionnaireTypeID, Name, Description, Code)
VALUES
(1, N'Veliki upitnik', 
    N'Detaljan zdravstveni upitnik za veće osigurane sume', 
    N'GREAT_QUEST'),
    
(2, N'Skraćeni upitnik', 
    N'Skraćeni zdravstveni upitnik za srednje osigurane sume', 
    N'SHORT_QUEST'),
    
(3, N'Izjava', 
    N'Izjava o zdravstvenom stanju - bez detaljnih pitanja', 
    N'DECLARATION'),
    
(4, N'Upitnik za funkcionera', 
    N'AML upitnik za identifikaciju politički eksponiranih osoba', 
    N'FUNCTIONARY_QUEST'),
    
(5, N'Obrazac za procenu rizika', 
    N'AML obrazac za procenu nivoa rizika klijenta', 
    N'RISK_ASSESSMENT');

SET IDENTITY_INSERT QuestionnaireTypes OFF;
```

**Validacija**:
```sql
SELECT * FROM QuestionnaireTypes WHERE Code LIKE '%QUEST%';
-- Expected: 5 rows
```

---

## Faza 2: QuestionFormats (Provera + Dodavanje)

**Trajanje**: 30 min  
**Prioritet**: HIGH  
**Dependencies**: None

**Korak 2.1**: Provera postojećih

```sql
-- 02a_Check_QuestionFormats.sql
SELECT * FROM QuestionFormats ORDER BY QuestionFormatID;
```

**Korak 2.2**: Dodavanje nedostajućih (ako treba)

```sql
-- 02b_QuestionFormats_Extensions.sql

-- Tipovi koje MOŽDA već imamo:
-- Boolean (Da/Ne)
-- String (free text)
-- Integer
-- Decimal  
-- Dropdown (select)
-- Multiple Choice (checkboxes)
-- Date
-- Computed

-- Dodaj samo one koji NE postoje:
INSERT INTO QuestionFormats (Name, Description) 
VALUES 
(N'Autocomplete', N'Autocomplete dropdown sa pretragom'),
(N'BMI_Computed', N'BMI kalkulacija - visina i težina'),
(N'Composite', N'Kompozitno pitanje - više pod-pitanja');
```

**Decision Point 1**:
- ❓ Koje QuestionFormats već postoje?
- 🎯 **Akcija**: Prvo run 02a, pa odluči da li treba 02b

---

## Faza 3: Questions - Veliki Upitnik

**Trajanje**: 2-3 sata  
**Prioritet**: HIGH  
**Dependencies**: Faza 1, 2

**Pitanja** (8 glavnih + podpitanja):
1. Medicinska pitanja (1-3) - sa grananjem
2. BMI (visina/težina)
3. Sport
4. Zanimanje (povezano sa tab Partneri)
5. Alkohol
6. Duvan
7. Droge
8. BMI validacija

```sql
-- 03_Questions_GreatQuestionnaire.sql

-- QuestionnaireID = 1 (Veliki upitnik)

SET IDENTITY_INSERT Questions ON;

-- ============================================
-- Pitanje 0: BMI Kalkulacija (Visina i Težina)
-- ============================================
INSERT INTO Questions 
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES
(100, N'Unesite vašu visinu (cm)', 0.1, 
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Integer'), 
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'Computed'),
    0), -- Visina - input polje

(101, N'Unesite vašu težinu (kg)', 0.2,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Integer'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'Computed'),
    0), -- Težina - input polje

(102, N'BMI Index', 0.3,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Computed'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'Computed'),
    1); -- BMI - readonly, kalkulisano

-- ============================================
-- Pitanje 1: Bolesti srca i krvnih sudova
-- ============================================
INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES
(110, N'Da li ste ikada bolovali ili sada bolujete od bolesti srca i krvnih sudova?', 1.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0);

-- Pod-opcije (multiple choice kad je Da)
INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly)
VALUES
(111, N'Povišen krvni pritisak', 1.1,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Multiple Choice'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible'),
    110, -- Parent = Pitanje 110
    0),

(112, N'Bolesti srčanih zalistaka', 1.2,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Multiple Choice'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible'),
    110,
    0),

(113, N'Koronarna bolest', 1.3,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Multiple Choice'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible'),
    110,
    0);

-- ============================================
-- Pitanje 5: Sport
-- ============================================
INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES
(150, N'Sport koji praktikujete', 5.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Autocomplete'), -- ili Dropdown
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0);

-- Napomena: Sport lookup tabela Sports - popunjena u Fazi 9

-- ============================================
-- Pitanje 6: Alkohol, Droga, Duvan (Composite)
-- ============================================
INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES
(160, N'Dnevna količina alkohola', 6.1,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Dropdown'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0),

(161, N'Broj cigareta/gr. duvana dnevno', 6.2,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Dropdown'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0),

(162, N'Da li konzumirate drogu/narkotike?', 6.3,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0);

SET IDENTITY_INSERT Questions OFF;

-- Povezivanje sa QuestionnaireTypes
INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID)
SELECT QuestionID, 1 -- Veliki upitnik
FROM Questions
WHERE QuestionID BETWEEN 100 AND 199;
```

**Decision Point 2**:
- ❓ Da li QuestionQuestionnaireTypes tabela postoji?
- 🎯 **Akcija**: Proveri MODEL - možda je many-to-many veza već definisana drugačije

---

## Faza 4: PredefinedAnswers - Veliki Upitnik

**Trajanje**: 3-4 sata  
**Prioritet**: HIGH  
**Dependencies**: Faza 3

```sql
-- 04_PredefinedAnswers_GreatQuestionnaire.sql

SET IDENTITY_INSERT PredefinedAnswers ON;

-- ============================================
-- Odgovori za Pitanje 110: Bolesti srca - Boolean
-- ============================================
INSERT INTO PredefinedAnswers
(PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES
(1100, 110, N'Da', N'YES', 0, NULL),
(1101, 110, N'Ne', N'NO', 0, NULL);

-- ============================================
-- Odgovori za Pitanje 160: Alkohol - Dropdown
-- ============================================
INSERT INTO PredefinedAnswers
(PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES
(1600, 160, N'do 1 lit. piva ILI do 0.5 lit. vina ILI do 0.1 lit. žestokog', N'ALCOHOL_LEVEL_0', 1, 0),
(1601, 160, N'do 1.5 lit. piva ILI do 0.75 lit. vina ILI do 0.15 lit. žestokog', N'ALCOHOL_LEVEL_1', 0, 5),
(1602, 160, N'do 2 lit. piva ILI do 1 lit. vina ILI do 0.2 lit. žestokog', N'ALCOHOL_LEVEL_2', 0, 10),
(1603, 160, N'preko 2 lit. piva ILI preko 1 lit. vina ILI preko 0.2 lit. žestokog', N'ALCOHOL_LEVEL_3_REJECT', 0, NULL); -- Reject

-- ============================================
-- Odgovori za Pitanje 161: Duvan - Dropdown
-- ============================================
INSERT INTO PredefinedAnswers
(PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES
(1610, 161, N'manje od 20 cigareta ILI manje od 20 gr. duvana', N'TOBACCO_LEVEL_0', 1, 0),
(1611, 161, N'do 30 cigareta ILI do 30 gr. duvana', N'TOBACCO_LEVEL_1', 0, 5),
(1612, 161, N'do 40 cigareta ILI do 40 gr. duvana', N'TOBACCO_LEVEL_2', 0, 10),
(1613, 161, N'preko 40 cigareta ILI preko 40 gr. duvana', N'TOBACCO_LEVEL_3_REJECT', 0, NULL); -- Reject

-- ============================================
-- Odgovori za Pitanje 162: Droge - Boolean
-- ============================================
INSERT INTO PredefinedAnswers
(PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES
(1620, 162, N'Da', N'DRUGS_YES_REJECT', 0, NULL), -- Reject
(1621, 162, N'Ne', N'DRUGS_NO', 1, NULL);

SET IDENTITY_INSERT PredefinedAnswers OFF;
```

**Napomena**: StatisticalWeight se koristi za:
- Bodovanje u Risk Assessment
- Indikaciju povećanja starosti (0, 5, 10 godina)
- NULL = odbijanje ili neutralno

---

## Faza 5: PredefinedAnswerSubQuestions - Branching

**Trajanje**: 1-2 sata  
**Prioritet**: MEDIUM  
**Dependencies**: Faza 3, 4

```sql
-- 05_PredefinedAnswerSubQuestions_GreatQuestionnaire.sql

-- ============================================
-- Grananje: Pitanje 110 (Bolesti srca) → Pod-pitanja 111, 112, 113
-- ============================================

-- Ako je odgovor "Da" na pitanje 110, prikaži pod-opcije
INSERT INTO PredefinedAnswerSubQuestions
(PredefinedAnswerID, SubQuestionID)
VALUES
(1100, 111), -- Da → Povišen pritisak
(1100, 112), -- Da → Bolesti zalistaka
(1100, 113); -- Da → Koronarna bolest
```

---

## Faza 6: Questions - Skraćeni Upitnik

**Trajanje**: 1-2 sata  
**Prioritet**: MEDIUM  
**Dependencies**: Faza 1, 2

```sql
-- 06_Questions_ShortQuestionnaire.sql

SET IDENTITY_INSERT Questions ON;

-- QuestionnaireID = 2 (Skraćeni upitnik)

-- ============================================
-- BMI (iste kao u Velikom - reuse!)
-- ============================================
-- Questions 100, 101, 102 već postoje - povezati sa QuestionnaireTypeID = 2

-- ============================================
-- Pitanje 1: Agregovana medicinska pitanja
-- ============================================
INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES
(200, N'Da li ste ikada bolovali ili sada bolujete te da li vam je postavljena sumnja...', 1.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0);

-- Pod-pitanje: Detalji o bolesti
INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly)
VALUES
(201, N'Navedite koje oboljenje', 1.1,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'String'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible'),
    200,
    0);

-- ... ostala pitanja 2-6

SET IDENTITY_INSERT Questions OFF;

-- Povezivanje sa QuestionnaireTypes
INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID)
SELECT QuestionID, 2 -- Skraćeni upitnik
FROM Questions
WHERE QuestionID BETWEEN 200 AND 299;

-- TAKOĐE: BMI pitanja reuse
INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID)
VALUES
(100, 2), -- Visina
(101, 2), -- Težina  
(102, 2); -- BMI
```

---

## Faza 7: Questions - Upitnik za Funkcionera

**Trajanje**: 1 sat  
**Prioritet**: MEDIUM  
**Dependencies**: Faza 1, 2

```sql
-- 07_Questions_FunctionaryQuestionnaire.sql

SET IDENTITY_INSERT Questions ON;

-- QuestionnaireID = 4 (Upitnik za funkcionera)

INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES
(400, N'Da li ste politički eksponirana osoba ili član porodice...', 1.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0),

(401, N'Da li obavljate ili ste obavljali istaknutu javnu funkciju u međunarodnoj organizaciji?', 2.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0),

-- ... itd

(404, N'Navedite detalje o funkciji', 4.0, -- Podpitanje
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'String'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible'),
    NULL,
    0),

(405, N'Izvori prihoda/sredstava', 5.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Multiple Choice'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0);

SET IDENTITY_INSERT Questions OFF;
```

---

## Faza 8: Questions - Obrazac za Procenu Rizika

**Trajanje**: 2-3 sata (zavisno od broja pitanja)  
**Prioritet**: MEDIUM  
**Dependencies**: Faza 1, 2

```sql
-- 08_Questions_RiskAssessment.sql

-- QuestionnaireID = 5 (Obrazac za procenu rizika)

-- Pitanja za bodovanje - svaki odgovor ima StatisticalWeight (bodove)
-- Specifičan set pitanja sa specifikacije (nije kompletno definisan)

INSERT INTO Questions
(QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES
(500, N'Zemlja državljanstva', 1.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Dropdown'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0),

(501, N'Tip klijenta', 2.0,
    (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Dropdown'),
    (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible'),
    0);

-- ... ostala pitanja
```

**Napomena**: Pitanja za Obrazac nisu detaljno specificirana - potreban input od BA!

---

## Faza 9: Lookup Tabele - Sports & DangerClass

**Trajanje**: 2 sata  
**Prioritet**: MEDIUM  
**Dependencies**: None (ali treba Sports lista!)

```sql
-- 09_Sports_and_DangerClass.sql

-- ============================================
-- DangerClass
-- ============================================
INSERT INTO DangerClass (DangerClassID, ClassName, Description, DefaultAction)
VALUES
(1, N'I', N'Nizak rizik - minimalno povećanje premije', N'CORRECT'),
(2, N'II', N'Nizak do srednji rizik', N'CORRECT'),
(3, N'III', N'Srednji rizik', N'CORRECT'),
(4, N'IV', N'Srednji do visok rizik', N'CORRECT'),
(5, N'V', N'Visok rizik - značajno povećanje premije', N'CORRECT'),
(6, N'VI', N'Neprihvatljiv rizik - odbijanje', N'REJECT');

-- ============================================
-- Sports (Parcijalna lista - potrebna potpuna!)
-- ============================================
INSERT INTO Sports (SportName, DangerClassID)
VALUES
(N'Fudbal', 1),
(N'Košarka', 1),
(N'Tenis', 1),
(N'Plivanje', 1),
(N'Trčanje', 1),
(N'Biciklizam', 2),
(N'Skijanje', 3),
(N'Snowboarding', 3),
(N'Planinarenje', 3),
(N'Alpinizam', 5),
(N'Padobranstvo', 6),
(N'Bungee jumping', 6),
(N'BASE jumping', 6);

-- ❗ VAŽNO: Potrebna KOMPLETNA lista sportova iz specifikacije!
```

**Decision Point 3**:
- ❓ Gde je kompletna lista sportova?
- 🎯 **Akcija**: Pribaviti od BA ili iz dodatne dokumentacije

---

## Faza 10: ComputedQuestions - BMI Logika (✅ VEĆ POSTOJI!)

**Trajanje**: 15 min (samo konfiguracija)  
**Prioritet**: LOW  
**Dependencies**: Faza 3

**✅ Potvrđeno**: Logika i matrice za `Computed` pitanja već postoje!

```sql
-- 10_ComputedQuestions_BMI.sql

-- Povezivanje BMI pitanja sa metodom kalkulacije
-- Computed tip + matrica već pokriva kalkulaciju!

INSERT INTO ComputedQuestions
(QuestionID, ComputeMethodID, OutputModeID)
VALUES
(102, -- BMI pitanje (ID iz Faze 3)
    (SELECT ComputeMethodID FROM ComputeMethods WHERE Code = 'BMI_CALC'), -- ili koji već postoji
    (SELECT OutputModeID FROM ComputedOutputModes WHERE Code = 'READONLY_DISPLAY'));

-- Matrica za BMI validaciju će se definisati u Fazi 12 (Corrections)
```

**Decision Point 4**:
- ✅ ComputedQuestions infrastruktura već postoji!
- 🎯 **Akcija**: Samo povezati Question 102 (BMI) sa postojećom metodom
- 💡 **Napomena**: Validacija BMI rangova ide preko Corrections (Faza 12), ne ovde!

---

## Faza 11: QuestionReferenceTables - Linkovi ka Lookup Tabelama

**Trajanje**: 30 min  
**Prioritet**: LOW  
**Dependencies**: Faza 3, 9

```sql
-- 11_QuestionReferenceTables.sql

-- Povezivanje Sport pitanja sa Sports lookup tabelom

INSERT INTO QuestionReferenceTables
(QuestionID, ReferenceTableName, ReferenceTableKeyColumn, ReferenceTableDisplayColumn)
VALUES
(150, -- Sport pitanje
    N'Sports',
    N'SportID',
    N'SportName');

-- Slično za Occupation ako koristimo IndustryCodes
```

---

## Decision Points & Next Steps

### Prije Pokretanja - Odluke Potrebne:

1. ⏸️ **SpecificQuestionTypes**: Dodavati ili ne? → **Preporuka: NE**
2. ⏸️ **QuestionFormats**: Proveri postojeće, dodaj samo nedostajuće
3. ⏸️ **QuestionQuestionnaireTypes**: Proveri da li tabela postoji u MODEL
4. ⏸️ **ComputeMethods**: Proveri da li postoji 'BMI_CALC'
5. ⏸️ **Sports lista**: Pribaviti kompletnu listu iz specifikacije
6. ⏸️ **Obrazac rizika pitanja**: Pribaviti detaljnu strukturu pitanja

### Redosled Izvršavanja:

```
Faza 1 (QuestionnaireTypes) → obavezno prvo
  ↓
Faza 2 (QuestionFormats check)
  ↓  
Faza 9 (Sports/DangerClass) → nezavisno, može paralelno
  ↓
Faza 3 (Questions - Veliki) → osnova
  ↓
Faza 4 (PredefinedAnswers - Veliki)
  ↓
Faza 5 (Branching - Veliki)
  ↓
Faza 6-8 (Questions - Ostali upitnici) → mogu paralelno
  ↓
Faza 10-11 (Computed, References) → finalizacija
```

### Backup & Rollback:

Svaka faza ima:
```sql
-- Na početku svakog fajla:
BEGIN TRANSACTION;

-- ... INSERT statements ...

-- Na kraju:
-- ROLLBACK; -- Za testiranje
COMMIT; -- Za produkciju
```

---

## Validation Queries

Nakon svake faze:

```sql
-- Faza 1
SELECT * FROM QuestionnaireTypes;
-- Expected: 5 rows

-- Faza 3
SELECT COUNT(*) FROM Questions WHERE QuestionID BETWEEN 100 AND 199;
-- Expected: ~15-20 pitanja za Veliki upitnik

-- Faza 4
SELECT COUNT(*) FROM PredefinedAnswers 
WHERE PredefinedAnswerID BETWEEN 1000 AND 1999;
-- Expected: ~40-50 odgovora za Veliki upitnik

-- Faza 5
SELECT COUNT(*) FROM PredefinedAnswerSubQuestions
WHERE PredefinedAnswerID BETWEEN 1000 AND 1999;
-- Expected: ~10-15 grananja

-- Konačna validacija
SELECT 
    qt.Name AS Questionnaire,
    COUNT(DISTINCT q.QuestionID) AS TotalQuestions,
    COUNT(DISTINCT pa.PredefinedAnswerID) AS TotalAnswers
FROM QuestionnaireTypes qt
LEFT JOIN QuestionQuestionnaireTypes qqt ON qt.QuestionnaireTypeID = qqt.QuestionnaireTypeID
LEFT JOIN Questions q ON qqt.QuestionID = q.QuestionID
LEFT JOIN PredefinedAnswers pa ON q.QuestionID = pa.QuestionID
GROUP BY qt.Name;
```

---

*Status: Plan Ready - Čeka odluke i execution*
