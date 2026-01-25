# GAP ANALIZA - Poređenje Spec ifikacije i Postojećeg Modela

## Executive Summary

Ovaj dokument sadrži detaljnu gap analizu između:
1. Zahteva iz specifikacije (`Sp_Cleaned.docx`)
2. Postojećeg modela baze (`WIWA_DB_NEW_MODEL_18_01_2026.sql`)
3. Postojećih podataka (`WIWA_DB_NEW_DATA_18_01_2026.sql`)

## Identifikovani Upitnici

| # | Naziv Upitnika | Code | Status u Bazi | Prioritet |
|---|----------------|------|---------------|-----------|
| 1 | Veliki Upitnik | `GREAT_QUEST` | ⚠️ Potrebno kreirati | Visok |
| 2 | Skraćeni Upitnik | `SHORT_QUEST` | ⚠️ Potrebno kreirati | Visok |
| 3 | Izjava | `DECLARATION` | ⚠️ Potrebno kreirati | Srednji |
| 4 | Upitnik za Funkcionera | `FUNCTIONARY_QUEST` | ⚠️ Potrebno kreirati | Visok |
| 5 | Obrazac za Procenu Rizika | `RISK_ASSESSMENT` | ⚠️ Potrebno kreirati | Visok |

## Postojeće Tabele - Analiza Pokrivenosti

### ✅ Core Tabele - Adekvatne

| Tabela | Status | Napomena |
|--------|--------|----------|
| `QuestionnaireTypes` | ✅ Postoji | Potrebno dodati 5 novih tipova |
| `Questions` | ✅ Postoji | Potrebno dodati pitanja za sve upitnike |
| `PredefinedAnswers` | ✅ Postoji | Uključuje `StatisticalWeight` - dobro! |
| `PredefinedAnswerSubQuestions` | ✅ Postoji | Podržava grananje (branching) |
| `QuestionFormats` | ✅ Postoji | Potrebno proveriti tipove |
| `SpecificQuestionTypes` | ✅ Postoji | Za specijalne tipove pitanja |
| `QuestionReferenceTables` | ✅ Postoji | Za lookup tabele |
| `ComputedQuestions` | ✅ Postoji | Za BMI i slične kalkulacije |
| `ComputeMethods` | ✅ Postoji | Metode za kalkulacije |
| `ComputedOutputModes` | ✅ Postoji | Output modovi |

### ⚠️ Tabele sa Ograničenjima

| Tabela | Problem | Predloženo Rešenje |
|--------|---------|-------------------|
| `Questions` | Nema polje za `Required` | Dodati kolonu `IsRequired BIT` |
| `Questions` | Nema polje za `ValidationRegex` | Dodati kolonu `ValidationPattern NVARCHAR(500)` |
| `PredefinedAnswers` | Nema vezu sa dokumentacijom | Kreirati `AnswerDocumentRequirements` |

### ❌ Nedostajuće Tabele

| Tabela | Svrha | Prioritet |
|--------|-------|-----------|
| `QuestionnaireDisplayRules` | Pravila prikazivanja upitnika prema OS, karenci, dopunskim rizicima | **Kritično** |
| `ValidationRules` | Validaciona pravila za odgovore | **Visok** |
| `CorrectionRules` | Korekcije prema odgovorima (BMI, sport, zanimanje...) | **Visok** |
| `DocumentRequirements` | Zahtevana dokumentacija prema odgovorima | **Visok** |
| `NotificationTemplates` | Templates za poruke prema odgovorima | **Srednji** |
| `DeclarationTemplates` | Text template-i za Izjavu | **Srednji** |
| `CarencyClauses` | Klauzule za karencu | **Srednji** |
| `BeneficialOwners` | Stvarni vlasnici (pravna lica) | **Visok** |
| `AMLMarkers` | AML flagovi i markeri | **Visok** |
| `QuestionnaireInstances` | Više instanci upitnika (napola više vlasnika) | **Visok** |
| `RiskAssessmentResults` | Rezultati procene rizika | **Visok** |
| `RiskLevelRules` | Pravila za određivanje nivoa rizika | **Visok** |
| `Sports` | Lookup - Sportovi i razredi opasnosti | **Visok** |
| `DangerClass` | Razredi opasnosti (I-VI) | **Visok** |
| `OccupationRisks` | Zanimanja i rizici | **Visok** |

## Detaljne DDL Skripte - Predlozi

### 1. Proširenje Postojećih Tabela

```sql
-- Questions - Dodavanje novih kolona
ALTER TABLE Questions
ADD IsRequired BIT NULL DEFAULT 0,
    ValidationPattern NVARCHAR(500) NULL,
    TooltipText NVARCHAR(1000) NULL,
    PlaceholderText NVARCHAR(200) NULL;
GO

-- PredefinedAnswers - Dodavanje kolone za priority
ALTER TABLE PredefinedAnswers
ADD DisplayOrder INT NULL,
    IsEnabledByDefault BIT NULL DEFAULT 1;
GO

-- QuestionnaireTypes - Dodavanje kolona
ALTER TABLE QuestionnaireTypes
ADD HasQuestions BIT NULL DEFAULT 1,
    RequiresSignature BIT NULL DEFAULT 0,
    IsPrintedWithApplication BIT NULL DEFAULT 1,
    IsInfoOnly BIT NULL DEFAULT 0;
GO
```

### 2. Nove Tabele - Core Questionnaire Logic

```sql
-- QuestionnaireDisplayRules
CREATE TABLE QuestionnaireDisplayRules (
    DisplayRuleID INT PRIMARY KEY IDENTITY(1,1),
    ProductTypeID INT NULL,
    SumInsuredFrom DECIMAL(18,2) NULL,
    SumInsuredTo DECIMAL(18,2) NULL,
    CarencyYears INT NULL,
    AdditionalRiskCode NVARCHAR(50) NULL,
    QuestionnaireTypeID SMALLINT NOT NULL,
    Priority INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NULL,
    CONSTRAINT FK_QuestionnaireDisplayRules_QuestionnaireTypes
        FOREIGN KEY (QuestionnaireTypeID) REFERENCES QuestionnaireTypes(QuestionnaireTypeID)
);
GO

CREATE INDEX IDX_QuestionnaireDisplayRules_Lookup 
ON QuestionnaireDisplayRules(ProductTypeID, SumInsuredFrom, SumInsuredTo, CarencyYears, IsActive);
GO

-- ValidationRules
CREATE TABLE ValidationRules (
    ValidationRuleID INT PRIMARY KEY IDENTITY(1,1),
    QuestionID INT NOT NULL,
    RuleType NVARCHAR(50) NOT NULL, -- 'REGEX', 'RANGE', 'REQUIRED', 'CROSS_FIELD'
    RuleExpression NVARCHAR(MAX) NOT NULL,
    ErrorMessage NVARCHAR(500) NOT NULL,
    Priority INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_ValidationRules_Questions
        FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)
);
GO

-- CorrectionRules
CREATE TABLE CorrectionRules (
    CorrectionRuleID INT PRIMARY KEY IDENTITY(1,1),
    RuleName NVARCHAR(200) NOT NULL,
    RuleType NVARCHAR(50) NOT NULL, -- 'BMI', 'SPORT', 'OCCUPATION', 'ALCOHOL', 'TOBACCO', etc.
    QuestionID INT NULL,
    PredefinedAnswerID INT NULL,
    ProductRiskType NVARCHAR(50) NULL, -- 'LIFE', 'MAK', 'ACCIDENT', 'SURGICAL', 'SEVERE_ILLNESS'
    CorrectionType NVARCHAR(50) NOT NULL, -- 'AGE_INCREASE', 'PREMIUM_PERMILLE', 'PREMIUM_PERCENT', 'ABSOLUTE', 'REJECT'
    CorrectionValue DECIMAL(18,6) NULL,
    MinValue DECIMAL(18,2) NULL,
    MaxValue DECIMAL(18,2) NULL,
    Message NVARCHAR(1000) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_CorrectionRules_Questions
        FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID),
    CONSTRAINT FK_CorrectionRules_PredefinedAnswers
        FOREIGN KEY (PredefinedAnswerID) REFERENCES PredefinedAnswers(PredefinedAnswerID)
);
GO

-- DocumentRequirements
CREATE TABLE DocumentRequirements (
    DocumentRequirementID INT PRIMARY KEY IDENTITY(1,1),
    RequirementName NVARCHAR(200) NOT NULL,
    RequirementType NVARCHAR(50) NOT NULL, -- 'MANDATORY', 'CONDITIONAL', 'OPTIONAL'
    QuestionID INT NULL,
    PredefinedAnswerID INT NULL,
    ProductTypeID INT NULL,
    DocumentDescription NVARCHAR(1000) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_DocumentRequirements_Questions
        FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID),
    CONSTRAINT FK_DocumentRequirements_PredefinedAnswers
        FOREIGN KEY (PredefinedAnswerID) REFERENCES PredefinedAnswers(PredefinedAnswerID)
);
GO
```

### 3. Nove Tabele - Lookup & Reference Data

```sql
-- Sports
CREATE TABLE Sports (
    SportID INT PRIMARY KEY IDENTITY(1,1),
    SportName NVARCHAR(200) NOT NULL,
    DangerClassID SMALLINT NOT NULL,
    LifeIncrease_Permille DECIMAL(10,4) NULL,
    MAK_Increase_Permille DECIMAL(10,4) NULL,
    Accident_Increase_Percent DECIMAL(10,4) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Sports_DangerClass
        FOREIGN KEY (DangerClassID) REFERENCES DangerClass(DangerClassID)
);
GO

CREATE INDEX IDX_Sports_Name ON Sports(SportName);
GO

-- DangerClass
CREATE TABLE DangerClass (
    DangerClassID SMALLINT PRIMARY KEY,
    ClassName NVARCHAR(10) NOT NULL, -- 'I', 'II', 'III', 'IV', 'V', 'VI'
    Description NVARCHAR(500) NULL,
    DefaultAction NVARCHAR(50) NULL, -- 'ACCEPT', 'CORRECT', 'REJECT'
    CONSTRAINT CHK_DangerClass_ClassName CHECK (ClassName IN ('I', 'II', 'III', 'IV', 'V', 'VI'))
);
GO

-- OccupationRisks
CREATE TABLE OccupationRisks (
    OccupationRiskID INT PRIMARY KEY IDENTITY(1,1),
    OccupationArea NVARCHAR(200) NOT NULL, -- 'Građevinarstvo', 'Rudarstvo', etc.
    OccupationName NVARCHAR(500) NOT NULL,
    LifeIncrease_Permille DECIMAL(10,4) NULL,
    MAK_Increase_Permille DECIMAL(10,4) NULL,
    Accident_Increase_Percent DECIMAL(10,4) NULL,
    ActionType NVARCHAR(50) NOT NULL, -- 'CORRECT', 'REJECT', 'EXCLUDE'
    Message NVARCHAR(1000) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE INDEX IDX_OccupationRisks_Name ON OccupationRisks(OccupationName);
GO
```

### 4. Nove Tabele - AML & Compliance

```sql
-- AMLMarkers
CREATE TABLE AMLMarkers (
    AMLMarkerID INT PRIMARY KEY IDENTITY(1,1),
    ConcernID INT NOT NULL,
    MarkerType NVARCHAR(100) NOT NULL,
    MarkerSource NVARCHAR(100) NOT NULL,
    MarkerDate DATETIME NOT NULL DEFAULT GETDATE(),
    ResolvedDate DATETIME NULL,
    IsResolved BIT NOT NULL DEFAULT 0,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AMLMarkers_Concerns
        FOREIGN KEY (ConcernID) REFERENCES Concerns(ConcernID)
);
GO

CREATE INDEX IDX_AMLMarkers_Concern ON AMLMarkers(ConcernID, IsResolved);
GO

-- BeneficialOwners
CREATE TABLE BeneficialOwners (
    BeneficialOwnerID INT PRIMARY KEY IDENTITY(1,1),
    ConcernID INT NOT NULL,
    OwnerName NVARCHAR(500) NOT NULL,
    BirthPlace NVARCHAR(200) NOT NULL,
    OwnershipPercentage DECIMAL(5,2) NOT NULL,
    QuestionnaireInstanceID INT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_BeneficialOwners_Concerns
        FOREIGN KEY (ConcernID) REFERENCES Concerns(ConcernID),
    CONSTRAINT CHK_BeneficialOwners_Ownership 
        CHECK (OwnershipPercentage >= 0 AND OwnershipPercentage <= 100)
);
GO

-- QuestionnaireInstances
CREATE TABLE QuestionnaireInstances (
    QuestionnaireInstanceID INT PRIMARY KEY IDENTITY(1,1),
    ConcernID INT NOT NULL,
    QuestionnaireTypeID SMALLINT NOT NULL,
    InstanceNumber INT NOT NULL DEFAULT 1,
    BeneficialOwnerID INT NULL,
    CompletedDate DATETIME NULL,
    UploadedDocumentPath NVARCHAR(500) NULL,
    DMSDocumentID NVARCHAR(100) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_QuestionnaireInstances_Concerns
        FOREIGN KEY (ConcernID) REFERENCES Concerns(ConcernID),
    CONSTRAINT FK_QuestionnaireInstances_QuestionnaireTypes
        FOREIGN KEY (QuestionnaireTypeID) REFERENCES QuestionnaireTypes(QuestionnaireTypeID),
    CONSTRAINT FK_QuestionnaireInstances_BeneficialOwners
        FOREIGN KEY (BeneficialOwnerID) REFERENCES BeneficialOwners(BeneficialOwnerID),
    CONSTRAINT UQ_QuestionnaireInstances_Concern_Type_Instance
        UNIQUE (ConcernID, QuestionnaireTypeID, InstanceNumber)
);
GO

-- RiskAssessmentResults
CREATE TABLE RiskAssessmentResults (
    RiskAssessmentResultID INT PRIMARY KEY IDENTITY(1,1),
    ConcernID INT NOT NULL,
    QuestionnaireInstanceID INT NULL,
    TotalScore INT NOT NULL,
    RiskLevel CHAR(1) NOT NULL,
    AssessmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    ReviewedByAML BIT NOT NULL DEFAULT 0,
    AMLReviewDate DATETIME NULL,
    AMLDecision NVARCHAR(50) NULL,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_RiskAssessmentResults_Concerns
        FOREIGN KEY (ConcernID) REFERENCES Concerns(ConcernID),
    CONSTRAINT FK_RiskAssessmentResults_QuestionnaireInstances
        FOREIGN KEY (QuestionnaireInstanceID) REFERENCES QuestionnaireInstances(QuestionnaireInstanceID),
    CONSTRAINT CHK_RiskAssessmentResults_RiskLevel
        CHECK (RiskLevel IN ('N', 'S', 'V'))
);
GO

-- RiskLevelRules
CREATE TABLE RiskLevelRules (
    RiskLevelRuleID INT PRIMARY KEY IDENTITY(1,1),
    RiskLevel CHAR(1) NOT NULL,
    MinScore INT NOT NULL,
    MaxScore INT NULL,
    Description NVARCHAR(500) NULL,
    RequiresAMLReview BIT NOT NULL DEFAULT 0,
    RequiresUWNotification BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_RiskLevelRules_RiskLevel
        CHECK (RiskLevel IN ('N', 'S', 'V'))
);
GO
```

### 5. Nove Tabele - Templates & Messages

```sql
-- DeclarationTemplates
CREATE TABLE DeclarationTemplates (
    DeclarationTemplateID INT PRIMARY KEY IDENTITY(1,1),
    TemplateName NVARCHAR(200) NOT NULL,
    TemplateText NVARCHAR(MAX) NOT NULL,
    ProductTypeID INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NULL
);
GO

-- CarencyClauses
CREATE TABLE CarencyClauses (
    CarencyClauseID INT PRIMARY KEY IDENTITY(1,1),
    ClauseName NVARCHAR(200) NOT NULL,
    ClauseText NVARCHAR(MAX) NOT NULL,
    CarencyYears INT NOT NULL,
    AppliesTo NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CHK_CarencyClauses_AppliesTo
        CHECK (AppliesTo IN ('OFFER', 'CONTRACT', 'PRECONTRACTUAL_INFO'))
);
GO

-- NotificationTemplates
CREATE TABLE NotificationTemplates (
    NotificationTemplateID INT PRIMARY KEY IDENTITY(1,1),
    TemplateName NVARCHAR(200) NOT NULL,
    TemplateType NVARCHAR(50) NOT NULL, -- 'UW', 'AGENT', 'AML', 'MANAGER', 'DOCTOR'
    TriggerEvent NVARCHAR(100) NOT NULL,
    SubjectTemplate NVARCHAR(500) NULL,
    BodyTemplate NVARCHAR(MAX) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO
```

## Primer Podataka - Initial Seeds

### QuestionnaireTypes

```sql
SET IDENTITY_INSERT QuestionnaireTypes ON;

INSERT INTO QuestionnaireTypes (QuestionnaireTypeID, Name, Description, Code, HasQuestions, RequiresSignature, IsPrintedWithApplication, IsInfoOnly)
VALUES
(1, 'Veliki upitnik', 'Detaljan zdravstveni upitnik za veće osigurane sume', 'GREAT_QUEST', 1, 1, 1, 0),
(2, 'Skraćeni upitnik', 'Skraćeni zdravstveni upitnik za srednje osigurane sume', 'SHORT_QUEST', 1, 1, 1, 0),
(3, 'Izjava', 'Izjava o zdravstvenom stanju - bez detaljnih pitanja', 'DECLARATION', 0, 1, 1, 1),
(4, 'Upitnik za funkcionera', 'AML upitnik za identifikaciju politički eksponiranih osoba', 'FUNCTIONARY_QUEST', 1, 1, 0, 0),
(5, 'Obrazac za procenu rizika', 'AML obrazac za procenu nivoa rizika klijenta', 'RISK_ASSESSMENT', 1, 0, 0, 0);

SET IDENTITY_INSERT QuestionnaireTypes OFF;
GO
```

### DangerClass

```sql
INSERT INTO DangerClass (DangerClassID, ClassName, Description, DefaultAction)
VALUES
(1, 'I', 'Nizak rizik - minimalno povećanje premije', 'CORRECT'),
(2, 'II', 'Nizak do srednji rizik', 'CORRECT'),
(3, 'III', 'Srednji rizik', 'CORRECT'),
(4, 'IV', 'Srednji do visok rizik', 'CORRECT'),
(5, 'V', 'Visok rizik - značajno povećanje premije', 'CORRECT'),
(6, 'VI', 'Neprihvatljiv rizik - odbijanje', 'REJECT');
GO
```

### RiskLevelRules

```sql
INSERT INTO RiskLevelRules (RiskLevel, MinScore, MaxScore, Description, RequiresAMLReview, RequiresUWNotification)
VALUES
('N', 0, 5, 'Nizak AML rizik', 0, 0),
('S', 6, 9, 'Srednji AML rizik', 1, 1),
('V', 10, NULL, 'Visok AML rizik', 1, 1);
GO
```

## Kompleksnost Implementacije

### Faza 1 - Core Questionnaire Infrastructure (2-3 nedelje)

**Prioritet**: Kritično

**Zadaci**:
1. Kreirati nedostajuće tabele:
   - `QuestionnaireDisplayRules`
   - `ValidationRules`
   - `CorrectionRules`
   - `DocumentRequirements`
2. Proširiti postojeće tabele
3. Kreirati lookup tabele:
   - `Sports` + `DangerClass`
   - `OccupationRisks`
4. Seed initial data

### Faza 2 - Questionnaire Data Entry (3-4 nedelje)

**Prioritet**: Visok

**Zadaci**:
1. Unos svih pitanja za:
   - Veliki upitnik (8+ pitanja sa podpitanjima)
   - Skraćeni upitnik (6+ pitanja)
   - Upitnik za funkcionera (5 pitanja)
   - Obrazac za procenu rizika (TBD pitanja)
2. Unos svih predefinisanih odgovora
3. Unos Sub-question veza
4. Unos validacionih pravila
5. Unos korekcija prema odgovorima

### Faza 3 - AML & Compliance (1-2 nedelje)

**Prioritet**: Visok

**Zadaci**:
1. Kreirati AML tabele:
   - `AMLMarkers`
   - `BeneficialOwners`
   - `QuestionnaireInstances`
   - `RiskAssessmentResults`
2. Implementirati AML pravila
3. Unos template-a i klauzula

### Faza 4 - Business Logic & Integration (2-3 nedelje)

**Prioritet**: Srednji-Visok

**Zadaci**:
1. Implementacija stored procedures za:
   - Određivanje upitnika prema pravilima
   - Kalkulaciju korekcija
   - AML provere
   - UW provere
2. Integration sa KING-om (provere polisa)
3. Notification system

## Očekivani Izazovi

### 1. Kompleksnost Pravila

**Problem**: Pravila ugovaranja i provera su veoma kompleksna sa mnogo međuzavisnosti.

**Rešenje**:
- Rule engine pattern
- Prioritizacija pravila
- Testiranje sa realnim podacima

### 2. Grananje Pitanja (Branching Logic)

**Problem**: Dinamičko prikazivanje podpitanja prema odgovorima.

**Rešenje**:
- Iskoristiti postojeću `PredefinedAnswerSubQuestions` tabelu
- Proširiti sa condition logikom
- Frontend mora podržavati dinamičko učitavanje

### 3. Korekcije i Kalkulacije

**Problem**: Različite vrste korekcija (‰, %, apsolutno, starost) prema različitim rizicima.

**Rešenje**:
- Fleksibilna `CorrectionRules` tabela
- Stored procedure za svaki tip korekcije
- Unit testovi za sve kombinacije

### 4. Integracija sa KING-om

**Problem**: Provere polisa, suma, šteta iz eksternog sistema.

**Rešenje**:
- Web service/API pozivi
- Caching za performance
- Error handling za nedostupnost sistema

## Metrika Uspeha

| Metrika | Cilj |
|---------|------|
| Pokrivenost pravila | 100% svih pravila iz specifikacije |
| Broj upitnika | 5 (svi implementirani) |
| Broj pitanja | 50+ (sva uneta) |
| Broj korekcija | 100+ pravila |
| Performanse (load upitnika) | <  2s |
| Performanse (validacija) | < 1s |

---

*Status: Finalized - Zahteva Review od DBA i BA tima*
