# BA-DBA Analysis Session - Validacija Postojećeg Modela

**Datum**: 2026-01-24  
**Sesija**: Detaljnavaldacija poklevenosti modela za upitnike

---

## 1. BA: Prezentacija Zahteva

### Zahtev: Sistem Upitnika za Životno Osiguranje

#### Klijent
WIWA Life - Implementacija 5 upitnika iz specifikacije

#### Opis
Potrebno je implementirati kompletan sistem upitnika sa:
- 5 tipova upitnika (Veliki, Skraćeni,  Izjava, Funkcioner, Procena Rizika)
- 50+ pitanja sa podpitanjima i grananjem
- 100+ korekcija (BMI, sport, zanimanje, alkohol, duvan)
- UW i AML pravila
- Validacije i dokumentaciju

#### Tip procesa
- [x] Upitnik
- [x] UW proces
- [ ] Workflow
- [ ] Test/Anketa

### Pitanja (draft)

**Veliki Upitnik**:
1. Medicinska pitanja (1-3) - grananje prema odgovorima
2. BMI (visina/težina) - automatska kalkulacija
3. Sport - autocomplete sa lookup, 6 razreda opasnosti
4. Zanimanje - povezano sa tab Partneri, korekcije
5. Alkohol - 4 nivoa, povečanje starosti
6. Duvan - 4 nivoa, povećanje starosti
7. Droge - boolean, odbijanje
8. BMI validacija - korekcije prema rangu

**Skraćeni Upitnik**:
1-6 pitanja (agregovana medicinska, sport, rizici)

**Upitnik Funkcioner**:
1-5 AML pitanja (PEP, funkcija)

**Procena Rizika**:
Bodovanje → N/S/V (0-5 / 6-9 / 10+)

### Očekivani ishod
- Dinamički prikaz upitnika prema OS, karenci, dopunskim rizicima
- Automatske korekcije i kalkulacije
- Integracija sa UW i AML procesom
- Prenos u DMS

---

## 2. DBA: Validacija Modela

### QuestionnaireTypes
- **Postojeći tip koji odgovara**: ✅ DA - Tabela `QuestionnaireTypes` postoji (pregled potreban)
- **Potreban novi tip**: ⚠️ DA - Potrebno dodati 5 novih tipova

**Analiza**:
```sql
-- Tabela postoji u modelu
-- Potrebno proveriti DATA.sql da vidimo koje tipove već imamo
```

### Questions
| Pitanje | Postoji tabela? | Potrebna modifikacija? |
|---------|-----------------|------------------------|
| Questions | ✅ DA | ⚠️ DA - Dodati `IsRequired`, `ValidationPattern` |
| PredefinedAnswers | ✅ DA | ⚠️ DA - Dodati `DisplayOrder` |
| PredefinedAnswerSubQuestions | ✅ DA | ✅ NE - Potpuno pokriva grananje |
| QuestionFormats | ✅ DA | ? - Potrebna provera |
| ComputedQuestions | ✅ DA | ? - Za BMI kalkulacije |

**Analiza**:
```sql
-- DOBRO: Core upitnik infrastruktura POSTOJI!
-- Questions - postoji
-- PredefinedAnswers - postoji SA StatisticalWeight kolonom!
-- PredefinedAnswerSubQuestions - potpuno pokriva grananje
```

### Korekcije - **KLJUČNO OTKRIĆE** ✅

| Tabela | Postoji? | Pokrivenost |
|--------|----------|-------------|
| **AllowedCorrectionLevels** | ✅ DA | Veze između korekcija, nivoa i akcija |
| **CorrectionLevels** | ✅ DA (FK) | Nivoi aplikacije korekcija |
| **Corrections** | ✅ DA (FK) | Šifarnik korekcija |
| **CorrectionPackageRisks** | ✅ DA | Korekcije paketa i rizika |
| **TariffRiskApprovalCorrectionSurcharges** | ✅ DA | Surcharge korekcije |
| **TariffRiskApprovalCorrectionTypes** | ✅ DA | Tipovi korekcija |
| **TariffRisks** | ✅ DA | Ima `MainEventCoeficient` |

**Analiza**:
```sql
-- ODLIČNO: KOMPLETAN SISTEM KOREKCIJA VEĆ POSTOJI!
-- AllowedCorrectionLevels omogućava:
--   - CorrectionID → koje korekcije
--   - CorrectionLevelID → na kom nivou (polisa/rizik/paket)
--   - ActionID/TariffID → za koje akcije/tarife
--
-- Ovo znači da možemo:
-- 1. Dodati nove Corrections za: BMI, Sport, Occupation, Alcohol, Tobacco
-- 2. Povezati ih preko AllowedCorrectionLevels sa tarifama
-- 3. NIJE potrebna nova tabela CorrectionRules!
```

### Branching Logic
| Veza | Postoji u PredefinedAnswerSubQuestions? |
|------|----------------------------------------|
| P1 → A1 → P3 (medicinska podpitanja) | ✅ DA - Tabela postoji |
| BMI → Validacija → Korekcija | ⚠️ Validacija preko Computed, Korekcija preko Corrections |
| Sport → Razred → Korekcija | ⚠️ Potrebna lookup tabela Sports + DangerClass |

**Analiza**:
```sql
-- PredefinedAnswerSubQuestions potpuno pokriva branching!
-- Struktura:
-- PredefinedAnswer (ID=1, Answer="Da", QuestionID=1)
--   → PredefinedAnswerSubQuestion (PredefinedAnswerID=1, SubQuestionID=3)
--     → Question (ID=3, "Detalji o bolesti")
```

### Reference Tabele

| Tabela | Postoji? | Potrebna? | Status |
|--------|----------|-----------|--------|
| Sports | ❌ NE | ✅ DA | **Dodati** |
| DangerClass | ❌ NE | ✅ DA | **Dodati** |
| OccupationRisks | ❌ NE | ⚠️ Možda | Provera potrebna - možda se koristi IndustryCodes |
| IndustryCodes | ✅ DA | ✅ DA | Već postoji - provera da li pokriva |
| BeneficialOwners | ❌ NE | ✅ DA | **Dodati** (pravna lica) |
| AMLMarkers | ❌ NE | ✅ DA | **Dodati** |
| RiskAssessmentResults | ❌ NE | ✅ DA | **Dodati** |
| DeclarationTemplates | ❌ NE | ⚠️ Možda | Možda nije potrebna kao tabela |

**Analiza**:
```sql
-- IndustryCodes - Vec postoji sa 4 nivoa (Oblast, Grana, Grupa, Podgrupa)
-- Ima LevelOfRiskID kolonu - moguće da već pokriva zanimanja!
-- Potrebno pregledati DATA.sql
```

### Zaključak

**Model pokriva**: ~65-70%

**Potpuno pokriveno** ✅:
1. Core upitnik infrastruktura (Questions, PredefinedAnswers, SubQuestions)
2. Sistem korekcija (AllowedCorrectionLevels, Corrections, CorrectionLevels)
3. Computed questions (za BMI)
4. Grananje (branching) logika
5. Statistical weights (u PredefinedAnswers)
6. TariffRisks sa koeficijentima

**Delimično pokriveno** ⚠️:
1. Zanimanja - IndustryCodes možda pokriva, treba proveriti
2. Validacije - postoji infrastruktura, ali možda treba proširiti

**Nedostaje** ❌:
1. Sports lookup tabela (+ DangerClass)
2. BeneficialOwners (stvarni vlasnici - pravna lica)
3. AML infrastruktura (AMLMarkers, RiskAssessmentResults)
4. QuestionnaireDisplayRules (pravila prikazivanja)
5. Documenta requirements veza

**Potrebna proširenja**:
1. `Questions` - dodati: `IsRequired BIT`, `ValidationPattern NVARCHAR(500)`
2. `PredefinedAnswers` - dodati: `DisplayOrder INT`
3. `QuestionnaireTypes` - dodati: `HasQuestions BIT`, `RequiresSignature BIT`
4. Novi QuestionnaireTypes (5 tipova)
5. Nove lookup tabele (Sports, DangerClass, možda BeneficialOwners)
6. AML tabele (AMLMarkers, RiskAssessmentResults, RiskLevelRules)

---

## 3. Zajednički: Rešavanje Gaps

### Gap 1: Sports i DangerClass Lookup

**BA perspektiva**: 
Sport pitanje zahteva:
- Autocomplete pretragu (po prva 3 slova)
- 6 razreda opasnosti (I-VI)
- Različite korekcije po tipu rizika (Život, MAK, Nezgoda)
- Odbijanje za razred VI

**DBA rešenje**:
```sql
CREATE TABLE DangerClass (
    DangerClassID SMALLINT PRIMARY KEY,
    ClassName NVARCHAR(10) NOT NULL, -- 'I','II','III','IV','V','VI'
    Description NVARCHAR(500),
    DefaultAction NVARCHAR(50) -- 'CORRECT' or 'REJECT'
);

CREATE TABLE Sports (
    SportID INT PRIMARY KEY IDENTITY(1,1),
    SportName NVARCHAR(200) NOT NULL,
    DangerClassID SMALLINT NOT NULL,
    -- Ne treba LifeIncrease jer to ide preko Corrections!
    FOREIGN KEY (DangerClassID) REFERENCES DangerClass(DangerClassID)
);

-- Korekcije za sportove dodati u Corrections tabelu
INSERT INTO Corrections (...) VALUES ('SPORT_CLASS_I', ...);
INSERT INTO Corrections (...) VALUES ('SPORT_CLASS_II', ...);
-- etc.
```

**Odluka**: ✅ Kreirati Sports i DangerClass, ali koristiti postojeći Corrections sistem

### Gap 2: Zanimanja (OccupationRisks)

**BA perspektiva**:
- 15+ kategorija zanimanja (građevinarstvo, rudarstvo, letači...)
- Različite korekcije po tipu rizika
- Poruke (korekcija ili odbijanje)

**DBA rešenje**:
Provera IndustryCodes:
```sql
-- IndustryCodes već postoji sa:
-- - 4 nivoa hijerarhije
-- - LevelOfRiskID kolona
--
-- Opcija 1: Koristiti IndustryCodes + dodati OccupationRiskCorrections vezu
-- Opcija 2: Kreirati OccupationRisks kao zasebnu tabelu
```

**Odluka**: ⚠️ NEEDS REVIEW - Prvo pregledati IndustryCodes u DATA.sql, pa odlučiti

### Gap 3: BMI, Alkohol, Duvan Korekcije

**BA perspektiva**:
- BMI: 12 pravila (prema starosti i BMI rangu)
- Alkohol: 4 nivoa → povećanje starosti (0, 5, 10, Odbijanje)
- Duvan: 4 nivoa → povećanje starosti (0, 5, 10, Odbijanje)

**DBA rešenje**:
Koristiti postojeći Corrections sistem:
```sql
-- Dodati u Corrections tabelu:
INSERT INTO Corrections VALUES ('BMI_UNDER_18_REJECT', ...);
INSERT INTO Corrections VALUES ('BMI_30_33_AGE_UNDER_29', ...);
-- etc.

-- Povezati preko AllowedCorrectionLevels sa tarifama
INSERT INTO AllowedCorrectionLevels 
(CorrectionID, CorrectionLevelID, TariffID, ...) 
VALUES (...);
```

**Odluka**: ✅ Koristiti postojeći sistem - NIJE potrebna nova tabela!

### Gap 4: AML Infrastruktura

**BA perspektiva**:
- Upitnik za funkcionera (PEP)
- Obrazac za procenu rizika (bodovanje)
- AML markeri i flagovi
- Više stvarnih vlasnika (pravna lica)

**DBA rešenje**:
```sql
-- Nove tabele potrebne:
CREATE TABLE AMLMarkers (...);
CREATE TABLE BeneficialOwners (...); -- Stvarni vlasnici
CREATE TABLE RiskAssessmentResults (...);
CREATE TABLE RiskLevelRules (...);
CREATE TABLE QuestionnaireInstances (...); -- Za više instanci
```

**Odluka**: ✅ Kreirati nove AML tabele - nema alternative u modelu

### Gap 5: QuestionnaireDisplayRules

**BA perspektiva**:
Logika prikazivanja upitnika prema:
- Osiguranaoj sumi (< 3.000, 3.001-X, >X)
- Karenci (0 ili 1 godina)
- Dopunskim rizicima (U0, ostali)
- Tipu proizvoda

**DBA rešenje**:
```sql
CREATE TABLE QuestionnaireDisplayRules (
    DisplayRuleID INT PRIMARY KEY IDENTITY(1,1),
    ProductTypeID INT NULL,
    SumInsuredFrom DECIMAL(18,2),
    SumInsuredTo DECIMAL(18,2),
    CarencyYears INT,
    AdditionalRiskCode NVARCHAR(50),
    QuestionnaireTypeID SMALLINT NOT NULL,
    Priority INT NOT NULL,
    FOREIGN KEY ...
);
```

**Odluka**: ✅ Kreirati - nema alternative u modelu

---

## 4. Output

### SQL Skripte Potrebne

#### 1. Proširenja Postojećih Tabela (HIGH PRIORITY)
```sql
-- Questions
ALTER TABLE Questions
ADD IsRequired BIT NULL DEFAULT 0,
    ValidationPattern NVARCHAR(500) NULL,
    TooltipText NVARCHAR(1000) NULL;

-- PredefinedAnswers
ALTER TABLE PredefinedAnswers
ADD DisplayOrder INT NULL;

-- QuestionnaireTypes
ALTER TABLE QuestionnaireTypes
ADD HasQuestions BIT NULL DEFAULT 1,
    RequiresSignature BIT NULL DEFAULT 0,
    IsPrintedWithApplication BIT NULL DEFAULT 1;
```

#### 2. Nove Lookup Tabele (MEDIUM PRIORITY)
```sql
-- DangerClass
CREATE TABLE DangerClass (...);

-- Sports
CREATE TABLE Sports (...);

-- MOŽDA: OccupationRisks (nakon review IndustryCodes)
```

#### 3. AML Tabele (HIGH PRIORITY)
```sql
CREATE TABLE BeneficialOwners (...);
CREATE TABLE AMLMarkers (...);
CREATE TABLE RiskAssessmentResults (...);
CREATE TABLE RiskLevelRules (...);
CREATE TABLE QuestionnaireInstances (...);
```

#### 4. Display Rules (MEDIUM PRIORITY)
```sql
CREATE TABLE QuestionnaireDisplayRules (...);
```

#### 5. Data Inserts (HIGH PRIORITY)
```sql
-- QuestionnaireTypes (5 novih)
INSERT INTO QuestionnaireTypes VALUES 
('Veliki upitnik', 'GREAT_QUEST', ...),
('Skraćeni upitnik', 'SHORT_QUEST', ...),
-- ...

-- Corrections (100+ novih korekcija)
INSERT INTO Corrections VALUES 
('BMI_UNDER_18_REJECT', ...),
('SPORT_CLASS_I', ...),
('OCCUPATION_CONSTRUCTION', ...),
-- ...

-- DangerClass
INSERT INTO DangerClass VALUES 
(1, 'I', 'Nizak rizik', 'CORRECT'),
-- ...

-- Sports (naći kompletnu listu)
INSERT INTO Sports VALUES 
('Alpinizam', 5), -- Razred V
-- ...
```

### Revised Estimate - Broj Novih Tabela

**Originalna procena**: 14 novih tabela  
**Revidirana procena**: **6-8 novih tabela**

#### Definitivno Nove (6):
1. `Sports`
2. `DangerClass`
3. `BeneficialOwners`
4. `AMLMarkers`
5. `RiskAssessmentResults`
6. `RiskLevelRules`

#### Možda Nove (2):
7. `QuestionnaireInstances` (ako ne možemo koristiti postojeću strukturu)
8. `QuestionnaireDisplayRules` (ili logika u aplikaciji?)

#### NIJE Potrebno (6):
~~1. CorrectionRules~~ → Koristiti `Corrections` + `AllowedCorrectionLevels`  
~~2. ValidationRules~~ → Možda aplikaciona logika  
~~3. DocumentRequirements~~ → Možda aplikaciona logika  
~~4. NotificationTemplates~~ → Aplikaciona logika  
~~5. DeclarationTemplates~~ → Možda config/application  
~~6. CarencyClauses~~ → Možda config/application

### Sledeći Koraci

1. ✅ **Review DATA.sql** - proveriti:
   - Koje QuestionnaireTypes već postoje
   - Koje Corrections već postoje
   - Da li IndustryCodes pokriva zanimanja
   - Koje TariffRisks postoje

2. **Kreirati DML skripte** za:
   - 5 novih QuestionnaireTypes
   - 100+ novih Corrections (BMI, Sport, Occupation, Alcohol, Tobacco)
   - Sports podatke (kompletan listing)
   - DangerClass podaci (6 razreda)

3. **Kreirati DDL skripte** za:
   - 6 definitivno novih tabela
   - Proširenja 3 postojeće tabele

4. **Validacija sa BA**:
   - Da li IndustryCodes pokriva zanimanja?
   - Da li QuestionnaireDisplayRules ide u bazu ili aplikaciju?
   - Kompletan listing sportova

---

## Checklist za Sesiju

- [x] BA je pripremio zahtev dokument (7 dokumenata)
- [x] DBA je pregledao MODEL.sql
- [ ] DBA je pregledao DATA.sql (U TOKU)
- [/] Svi gaps su identifikovani (VEĆINA)
- [/] Rešenja su dogovorena (Correction sistem ✅)
- [ ] Output je dokumentovan (U TOKU)

---

**Status**: 🟡 U toku - Potreban review DATA.sql i finalizacija
