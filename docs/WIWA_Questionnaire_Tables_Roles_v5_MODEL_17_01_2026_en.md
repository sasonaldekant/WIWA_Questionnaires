# WIWA – Table roles documentation (Questionnaire module) — v5

> Date: 2026‑01‑17  
> Database version: **WIWA_DB_NEW_MODEL_17_01_2026.sql** / **WIWA_DB_NEW_DATA_17_01_2026.sql**

This document explains the **role of each table** in the questionnaire module.  
Tables are grouped by layer to make it clear which part of the process they belong to: *template* (definition), *assignment* (eligibility), *runtime* (instance), *answers*, *references/matrices* and *scoring*.

---

## 1) Template / configuration (defining the questionnaire)

### `QuestionnaireTypes`
Defines a questionnaire type (e.g. *Buildings*, *Activities*, *Location*).  
Columns: `QuestionnaireTypeID` (PK), `Name`, `Code`, `QuestionnaireCategoryID`.  
Relations: 1 → N to `Questionnaires`, 1 → N to `QuestionnaireTypeRules`.

### `Questionnaires` (question mapping)
A join table that binds a questionnaire type to its set of questions.  
Columns: `QuestionnaireID`, `QuestionnaireTypeID`, `QuestionID`.  
Relations: N → 1 to `QuestionnaireTypes`, N → 1 to `Questions`.  
Allows the same question to appear in multiple questionnaires.

### `Questions`
The master catalogue of questions.  
Columns: `QuestionID`, `QuestionText`, `QuestionLabel`, `QuestionOrder`, `QuestionFormatID`, `SpecificQuestionTypeID`, `ParentQuestionID`, `ReadOnly`.  
Relations: 1 → N to `PredefinedAnswers`, self‑link via `ParentQuestionID`, N → 1 to `QuestionFormats`, N → 1 to `SpecificQuestionTypes`.  
Display behaviour is derived from unconditional nesting (`ParentQuestionID`), conditional branching (`PredefinedAnswerSubQuestions`) and question markers (`SpecificQuestionTypeID`, `ReadOnly`).

### `QuestionFormats`
A lookup of UI formats (`radio`, `select`, `checkbox`, `input`, `textarea`, `hidden`).  
Columns: `QuestionFormatID`, `Name`.  
Relations: 1 → N to `Questions`.

### `SpecificQuestionTypes`
Special question types: `AlwaysVisible`, `ConditionallyVisible`, `Computed`, `Hidden`.  
Columns: `SpecificQuestionTypeID`, `Name`.  
Relations: 1 → N to `Questions`.

### `PredefinedAnswers`
Catalogue of selectable answers.  
Columns: `PredefinedAnswerID`, `QuestionID`, `Answer`, `PreSelected`, `StatisticalWeight`, `Code`.  
Relations: N → 1 to `Questions`, 1 → N to `PredefinedAnswerSubQuestions`, 1 → N to `QuestionnaireAnswers`.  
`Code` contains the key from a reference table or matrix.  
Answer ordering is typically controlled through data (e.g., `PredefinedAnswerID`) or a defined ordering strategy in the export generator.

### `PredefinedAnswerSubQuestions`
Answer branching: each row links an answer to a question that becomes visible when that answer is selected.  
Columns: `PredefinedAnswerSubQuestionID`, `PredefinedAnswerID`, `SubQuestionID`.  
Each row represents one conditional edge: *answer → sub‑question*.

### `QuestionnaireTypeReferenceTables`
Specifies which reference tables (lookups/matrices) each questionnaire type uses.  
Columns: `QuestionnaireTypeReferenceTableID`, `QuestionnaireTypeID`, `TableName`.  
A **unique** constraint on (`QuestionnaireTypeID`, `TableName`) is recommended so the same reference table can be defined for multiple questionnaire types.

### `QuestionReferenceColumns`
Maps each question to the column name in the reference table.  
Columns: `QuestionReferenceColumnID`, `QuestionID`, `QuestionnaireTypeReferenceTableID`, `ReferenceColumnName`.  
Together with `QuestionnaireTypeReferenceTables`, this provides a generic mapping layer that the UI/engine can use for lookups and computed logic.

---

## 2) Assignment / eligibility (who fills which questionnaire)

### `QuestionnaireIdentificatorsTypes`
Types of identifiers that can have a questionnaire (e.g. object, person).  
Columns: `QuestionnaireIdentificatorsTypeID`, `Name`, `Code`, `Deleted`.  
Relations: 1 → N to `QuestionnaireByQuestionnaireIdentificatorsTypes`.

### `QuestionnaireByQuestionnaireIdentificatorsTypes`
Assignment rules: which combination of identificator and questionnaire type is valid.  
Columns: `QuestionnaireByQuestionnaireIdentificatorsTypeID`, `QuestionnaireIdentificatorsTypeID`, `QuestionnaireTypeID`, `Condition` (optional).  
Relations: N → 1 to `QuestionnaireIdentificatorsTypes`, N → 1 to `QuestionnaireTypes`.

---

## 3) Runtime / instance (actual completion)

### `QuestionnaireIdentificators`
A concrete subject (object or person) undergoing a questionnaire.  
Columns: `QuestionnaireIdentificatorID`, `QuestionnaireIdentificatorsTypeID`, `Identificator`, `UserID`, `PoliticalPerson`.  
Relations: N → 1 to `QuestionnaireIdentificatorsTypes`, 1 → N to `QuestionnaireByQuestionnaireIdentificators`, 1 → N to `Indicators`.

### `QuestionnaireByQuestionnaireIdentificators`
An instance of a questionnaire being filled out.  
Columns: `QuestionnaireByQuestionnaireIdentificatorID`, `QuestionnaireIdentificatorID`, `QuestionnaireTypeID`, `StartDateTime`, `FinishDateTime`, `Locked`, `LastChange`.  
Relations: N → 1 to `QuestionnaireIdentificators`, N → 1 to `QuestionnaireTypes`, 1 → N to `QuestionnaireAnswers`.

### `QuestionnaireAnswers`
User answers for a given instance.  
Columns: `QuestionnaireAnswerID`, `QuestionID`, `QuestionnaireByQuestionnaireIdentificatorID`, `Answer` (free‑text), `PredefinedAnswerID`, `AnswerPoints`.  
Relations: N → 1 to `QuestionnaireByQuestionnaireIdentificators`, N → 1 to `Questions`, optionally N → 1 to `PredefinedAnswers`.

---

## 4) Reference / lookups and matrices

The questionnaire uses various lookups (materials, hazard classes…) and matrices (n‑dimensional tables) to compute categories and premium rates.  
`QuestionnaireTypeReferenceTables` indicates which lookups a questionnaire uses, while `QuestionReferenceColumns` specifies the column that `PredefinedAnswers.Code` should match.

Lookup examples: `ConstructionMaterials`, `ExternalWallMaterials`, `RoofCoveringMaterials`, `HazardClasses`, `ProtectionClasses`, `StorageAreas`, `MethodsOfContracting`.  
Matrix examples: `BuildingCategoryMatrix`, `PremiumRateMatrix`.

Lookup algorithm:
1. For each input question, find the column in `QuestionReferenceColumns` (e.g. `ExternalWallMaterialID`).  
2. Cast the selected answer’s `Code` to the type of that column and filter rows in the lookup/matrix.  
3. For matrices, combine multiple parameters until a matching row is found.  
4. Use the result (e.g. a category ID or premium rate) to set a computed answer or calculate a premium.

---

## 5) Scoring / indicators

### `QuestionnaireTypeRules`
Rules at the questionnaire type level: thresholds for statistical weight, final rank, blocking flags, tariff links.  
Relations: N → 1 to `QuestionnaireTypes`.

### `Indicators`
Stores risk assessment results for an identificator.  
Columns: `IndicatorID`, `QuestionnaireIdentificatorID`, `RankID`, `RiskLevelID`, `TransferDate`.  
Relations: N → 1 to `QuestionnaireIdentificators`, N → 1 to `Ranks`.

### `Ranks`
Lookup of ranks or classes (A/B/C or 1/2/3).  
Columns: `RankID`, `Rank`, `Description`, `StateID`.  
Relations: 1 → N to `Indicators`.

---

## 6) Brief “mental model”

- **Template**: `QuestionnaireTypes` + `Questionnaires` + `Questions`/`PredefinedAnswers`/`PredefinedAnswerSubQuestions` define what the questionnaire contains and how it branches.  
- **Assignment**: `QuestionnaireIdentificatorsTypes` + `QuestionnaireByQuestionnaireIdentificatorsTypes` define when and to whom a questionnaire applies.  
- **Runtime**: `QuestionnaireIdentificators` + `QuestionnaireByQuestionnaireIdentificators` + `QuestionnaireAnswers` store the specific completion.  
- **Reference**: `QuestionnaireTypeReferenceTables` + `QuestionReferenceColumns` connect questions to lookups and matrices.  
- **Scoring**: `QuestionnaireTypeRules` + `Indicators` + `Ranks` compute and store outcomes.

---

## 7) Suggested aliases (optional)

For improved readability in application code, you may alias some tables (without changing their actual database names):

- `Questionnaires` → `QuestionnaireQuestions` (clearer that it holds questions per type)
- `QuestionnaireByQuestionnaireIdentificators` → `QuestionnaireInstances`
- `QuestionnaireByQuestionnaireIdentificatorsTypes` → `QuestionnaireTypeEligibility`

---

This document serves as a reference for all tables involved in questionnaire definition, assignment, runtime filling and scoring.
