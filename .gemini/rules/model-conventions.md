---
description: Naming konvencije i strukturni standardi za WIWA model
priority: high
applies_to: [ba_agent, dba_agent]
version: 1.0
---

# Model Konvencije i Standardi

## 1. Naming Konvencije

### 1.1 Tabele

| Pravilo | Primer | Anti-primer |
|---------|--------|-------------|
| PascalCase | `QuestionnaireTypes` | `questionnaire_types` |
| Množina za kolekcije | `Questions` | `Question` |
| Jednina za lookup | (važi isto PascalCase) | |
| Prefiks za grupisanje | `Questionnaire*`, `Question*` | |

### 1.2 Kolone

| Pravilo | Primer | Anti-primer |
|---------|--------|-------------|
| PascalCase | `QuestionID` | `question_id` |
| Sufiks `ID` za PK/FK | `QuestionnaireTypeID` | `QuestionnaireType` |
| Sufiks `Name` za tekst | `Name`, `QuestionText` | |
| Prefix tabele za FK | `QuestionFormatID` (FK ka QuestionFormats) | |

### 1.3 Constrainti

| Tip | Format | Primer |
|-----|--------|--------|
| Primary Key | `PK_<Table>_<Column>` | `PK_Questions_QuestionID` |
| Foreign Key | `FK_<Table>_<RefTable>` | `FK_Questions_QuestionFormats` |
| Unique | `UQ_<Table>_<Columns>` | `UQ_QuestionnaireTypes_Code` |
| Default | `DF_<Table>_<Column>` | `DF_Questions_ReadOnly` |

## 2. Tipovi Podataka

### 2.1 Standardni tipovi u modelu

| Svrha | Tip | Primer korišćenja |
|-------|-----|-------------------|
| ID (primarni ključ) | `INT IDENTITY(1,1)` | `QuestionID` |
| ID (mali lookup) | `SMALLINT` | `QuestionFormatID` |
| Kratki tekst | `NVARCHAR(50-200)` | `Name`, `Code` |
| Dugi tekst | `NVARCHAR(2000)` | `QuestionText` |
| Boolean | `BIT` | `ReadOnly`, `PreSelected` |
| Decimalni | `DECIMAL(18,4)` | `StatisticalWeight` |
| Datum/vreme | `DATETIME2` | `StartDateTime` |

### 2.2 Kada koristiti koji tip

```
INT        → Za sve ID-jeve glavnih entiteta
SMALLINT   → Za lookup tabele (< 32K vrednosti)
NVARCHAR   → Za sav tekst (Unicode podrška)
BIT        → Za da/ne vrednosti
DECIMAL    → Za vrednosti sa decimalama (težine, stope)
```

## 3. Relacioni Obrasci

### 3.1 Jedan-prema-Više (1:N)

```sql
-- Parent tabela
CREATE TABLE QuestionnaireTypes (
    QuestionnaireTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ...
);

-- Child tabela sa FK
CREATE TABLE Questionnaires (
    QuestionnaireID INT IDENTITY(1,1) PRIMARY KEY,
    QuestionnaireTypeID INT NOT NULL,  -- FK
    CONSTRAINT FK_Questionnaires_QuestionnaireTypes 
        FOREIGN KEY (QuestionnaireTypeID) 
        REFERENCES QuestionnaireTypes(QuestionnaireTypeID)
);
```

### 3.2 Self-Reference

```sql
-- Pitanje može imati parent pitanje
CREATE TABLE Questions (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    ParentQuestionID INT NULL,  -- Self-FK, nullable
    CONSTRAINT FK_Questions_ParentQuestion 
        FOREIGN KEY (ParentQuestionID) 
        REFERENCES Questions(QuestionID)
);
```

### 3.3 Many-to-Many (preko join tabele)

```sql
-- Join tabela za conditional branching
CREATE TABLE PredefinedAnswerSubQuestions (
    PredefinedAnswerSubQuestionID INT PRIMARY KEY,
    PredefinedAnswerID INT NOT NULL,  -- FK
    SubQuestionID INT NOT NULL,       -- FK
    -- Constrainti...
);
```

## 4. Proširenje Modela

### 4.1 Kada dodati novu kolonu

1. ✅ Kolona je potrebna za novu funkcionalnost
2. ✅ Ne može se postići kroz postojeće kolone
3. ✅ Tip je konzistentan sa postojećim konvencijama
4. ✅ Nullable ako nije obavezna za stare podatke
5. ✅ Default vrednost ako je primenljivo

### 4.2 Kada dodati novu tabelu

1. ✅ Entitet je dovoljno različit da zahteva zasebnu tabelu
2. ✅ Postoji jasna relacija sa postojećim tabelama
3. ✅ Naming prati konvenciju grupe (`Questionnaire*`, `Question*`)
4. ✅ FK i constrainti su definisani

### 4.3 Minimalne promene

> [!IMPORTANT]
> Uvek teži **minimalnom proširenju** modela. Prvo proveri da li postojeće tabele mogu da podrže zahtev.

Prioritet:
1. Koristi postojeće kolone/tabele
2. Dodaj lookup vrednosti u postojeće tabele
3. Dodaj kolonu u postojeću tabelu
4. Kreiraj novu tabelu (poslednja opcija)

## 5. Verzioniranje

Sve promene modela moraju biti verzionisane:

```sql
-- WIWA_DB_MODEL_CHANGE_<DATUM>.sql
-- Verzija: 1.x
-- Autor: [Agent]
-- Opis: [Šta i zašto]
-- Zavisnosti: [Koje tabele su uključene]

-- DDL promene ovde...
```

---

*Verzija: 1.0 | Datum: 2026-01-22*
