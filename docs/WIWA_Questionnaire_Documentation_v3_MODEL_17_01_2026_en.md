# WIWA – Questionnaire documentation (v3) – Model 17‑01‑2026

> Date: 2026‑01‑17  
> Database model version: **WIWA_DB_NEW_MODEL_17_01_2026.sql** / **WIWA_DB_NEW_DATA_17_01_2026.sql**

This document describes the **data model and operating rules** of the questionnaire module in the WIWA project.  
The focus is on how to generate a JSON document from the database that a generic UI renderer can interpret (without hardcoded special cases), and on how questions, answers, unconditional nesting and conditional branching are represented.

---

## 1) Introduction and scope

The questionnaire module allows product managers to configure flexible forms that collect information from users.  
To render a form correctly and to apply the proper back‑end logic (for example calculating insurance premiums), it is essential to understand **which tables define the questionnaire**, **how answers trigger sub‑questions**, and **how lookups into reference tables and matrices are performed**.  
This document brings together the following topics:

- an explanation of the role of key tables in the **template**, **assignment** and **runtime** layers
- rendering rules and guidelines for turning relational data into a JSON document
- instructions for generating the JSON output for the UI

Everything described here reflects the state of the database on **17 January 2026**.  Any removed columns or legacy behaviour has been intentionally excluded to avoid confusion.

---

## 2) Template / configuration (defining the questionnaire)

### 2.1 `QuestionnaireTypes`
Defines a questionnaire type (e.g. *Buildings*, *Activities*, *Location*).  Typical columns:

- `QuestionnaireTypeID` (PK)
- `Name`
- `Code`
- `QuestionnaireCategoryID` (links to a product category)

Relationships:
- **1 → N** to `Questionnaires` (defines which questions belong to the type)
- **1 → N** to `QuestionnaireTypeRules` (rules for scoring and premium calculation)

### 2.2 `Questionnaires` (alias *QuestionnaireQuestions*)
Maps questionnaire types to their questions.  This join table allows the same question to appear in multiple questionnaires.  Typical columns:

- `QuestionnaireID` (PK)
- `QuestionnaireTypeID` (FK → `QuestionnaireTypes`)
- `QuestionID` (FK → `Questions`)

Use this table to change the question set of a questionnaire without modifying the master `Questions` table.

### 2.3 `Questions`
A catalogue of all questions.  Each record holds the text, label, order and relationships that drive UI behaviour.  Key columns (reflecting the 2026 model):

- `QuestionID` (PK)
- `QuestionText` – the full text shown to the user
- `QuestionLabel` – a short label (used in headers or summaries)
- `QuestionOrder` – order within the questionnaire (integer)
- `QuestionFormatID` (FK → `QuestionFormats`)
- `SpecificQuestionTypeID` (FK → `SpecificQuestionTypes`)
- `ParentQuestionID` (nullable FK → `Questions`) – used for Always‑Visible child questions
- `ReadOnly` (bit) – mark a question as computed (answer selected by the engine)

How a question is displayed is derived from:
- unconditional nesting (`ParentQuestionID`),
- conditional branching via `PredefinedAnswerSubQuestions`,
- and question markers (`SpecificQuestionTypeID` and `ReadOnly`).

Relationships:
- **1 → N** to `PredefinedAnswers` (possible answers)
- **self‑reference** via `ParentQuestionID` for Always‑Visible children
- **N → 1** to `QuestionFormats` and `SpecificQuestionTypes`

### 2.4 `QuestionFormats`
A small lookup of UI control types.  Columns:

- `QuestionFormatID` (PK)
- `Name` – values such as `radio`, `select`, `checkbox`, `input`, `textarea`, `hidden`

Each question references a format to tell the front‑end which control to render.

### 2.5 `SpecificQuestionTypes`
Defines special behaviour for questions.  Four values are currently supported:

| ID | Name              | Meaning |
|----|-------------------|---------|
| 1  | AlwaysVisible     | Always show; do not depend on answers |
| 2  | ConditionallyVisible | Shown only if triggered by an answer |
| 3  | Computed          | Engine selects the answer (read‑only) |
| 4  | Hidden            | Question does not appear in the UI |

Each question has a `SpecificQuestionTypeID`.  Computed questions will also have `ReadOnly=1` so the UI disables the control.

### 2.6 `PredefinedAnswers`
A catalogue of selectable answers for each question.  Columns:

- `PredefinedAnswerID` (PK)
- `QuestionID` (FK → `Questions`)
- `Answer` – text shown in the UI
- `PreSelected` (bit) – whether it is selected by default
- `StatisticalWeight` (decimal) – used for scoring
- `Code` (nvarchar) – a string token used as the reference key for lookups into reference tables or matrices

`Code` is treated as a string token in exports; the UI/engine may cast it to the target type required by the referenced column.

### 2.7 `PredefinedAnswerSubQuestions`
Defines conditional branching: selecting a particular answer reveals additional questions.  Columns:

- `PredefinedAnswerSubQuestionID` (PK)
- `PredefinedAnswerID` (FK → `PredefinedAnswers`)
- `SubQuestionID` (FK → `Questions`)

Each row represents one conditional edge: *answer → sub‑question*.

### 2.8 `QuestionnaireTypeReferenceTables`
Associates each questionnaire type with the reference tables that its questions use.  Typical columns:

- `QuestionnaireTypeReferenceTableID` (PK)
- `QuestionnaireTypeID` (FK → `QuestionnaireTypes`)
- `TableName` – name of the domain table or matrix (e.g. `ConstructionMaterials`)

There is a **unique constraint on `(QuestionnaireTypeID, TableName)`**, allowing the same reference table to be used in multiple questionnaires.

### 2.9 `QuestionReferenceColumns`
For each question (within a questionnaire type) specifies the column from the reference table that will be matched against the answer’s `Code`.  Columns:

- `QuestionReferenceColumnID` (PK)
- `QuestionID` (FK → `Questions`)
- `QuestionnaireTypeReferenceTableID` (FK → `QuestionnaireTypeReferenceTables`)
- `ReferenceColumnName` – column name (e.g. `ExternalWallMaterialID`)

These tables replace the older `QuestionReferenceTables` and `QuestionnaireReferenceTables` and provide a clear mapping from questions to reference columns.

---

## 3) Assignment / rules layer (which questionnaire applies when)

### 3.1 `QuestionnaireIdentificatorsTypes`
A list of identifying types (e.g. *Building*, *Person*, *Vehicle*) that can trigger questionnaires.  Columns: `QuestionnaireIdentificatorsTypeID`, `Name`, `Code`, `Deleted`.  
Links: **1 → N** to `QuestionnaireByQuestionnaireIdentificatorsTypes`.

### 3.2 `QuestionnaireByQuestionnaireIdentificatorsTypes`
Defines the **assignment rules**: which questionnaire type applies to which identificator type.  Additional columns can hold conditions (e.g. whether the subject is politically exposed).  
Links: **N → 1** to `QuestionnaireIdentificatorsTypes`, **N → 1** to `QuestionnaireTypes`.

---

## 4) Runtime / instance layer (filling out questionnaires)

### 4.1 `QuestionnaireIdentificators`
Represents a concrete subject (object or person) that undergoes a questionnaire.  Columns: `QuestionnaireIdentificatorID`, `QuestionnaireIdentificatorsTypeID`, `Identificator` (external ID), `UserID`, `PoliticalPerson`.  
Links: **N → 1** to `QuestionnaireIdentificatorsTypes`, **1 → N** to `QuestionnaireByQuestionnaireIdentificators`, **1 → N** to `Indicators`.

### 4.2 `QuestionnaireByQuestionnaireIdentificators`
An instance of a questionnaire run for a given identificator and questionnaire type.  Columns: `QuestionnaireByQuestionnaireIdentificatorID`, `QuestionnaireIdentificatorID`, `QuestionnaireTypeID`, `StartDateTime`, `FinishDateTime`, `Locked`, `LastChange`.  
Links: **N → 1** to `QuestionnaireIdentificators`, **N → 1** to `QuestionnaireTypes`, **1 → N** to `QuestionnaireAnswers`.

### 4.3 `QuestionnaireAnswers`
Stores the answers provided by the user in an instance.  Columns: `QuestionnaireAnswerID`, `QuestionID`, `QuestionnaireByQuestionnaireIdentificatorID`, `Answer` (free‑text entry), `PredefinedAnswerID` (if a choice was selected), `AnswerPoints` (for scoring).  
Links: **N → 1** to `QuestionnaireByQuestionnaireIdentificators`, **N → 1** to `Questions`, optionally **N → 1** to `PredefinedAnswers`.

---

## 5) Reference tables and matrices (lookup logic)

Domain data resides in a set of lookup tables and matrices.  Each questionnaire type declares which domain tables it uses via `QuestionnaireTypeReferenceTables`, and each question declares which column from the table it binds to via `QuestionReferenceColumns`.  Answers are matched by `Code`.

Common reference tables:
- `ConstructionMaterials`, `ExternalWallMaterials`, `RoofCoveringMaterials` (building materials)
- `ConstructionTypes` (e.g. Massive, Weak, Mixed)
- `HazardClasses`, `ProtectionClasses`, `StorageAreas`, `MethodsOfContracting`

Common matrices:
- `BuildingCategoryMatrix` – calculates a building category from construction parameters
- `PremiumRateMatrix` – determines a premium rate from hazard class, protection class, construction type and other dimensions

**Lookup process:**
1. For each input question, `QuestionReferenceColumns` specifies the column name.  
2. The selected answer’s `Code` (as string) is cast to the column’s data type and used to filter the reference table or matrix.  
3. When using a matrix, multiple input values are combined to find a matching row.  
4. The result (e.g. a `ConstructionTypeID` or a `PremiumRate`) is then used either to automatically select a computed answer or to calculate a premium.

---

## 6) Scoring and indicators

### 6.1 `QuestionnaireTypeRules`
Defines thresholds and conclusions at the questionnaire type level.  Examples include ranges for total statistical weight, final rank, premium adjustments, and flags that block issuance.  
Links: **N → 1** to `QuestionnaireTypes`.

### 6.2 `Indicators`
Stores the results of risk assessment or underwriting for each identificator.  Columns: `IndicatorID`, `QuestionnaireIdentificatorID`, `RankID`, `RiskLevelID`, `TransferDate`.  
Links: **N → 1** to `QuestionnaireIdentificators`, **N → 1** to `Ranks`.

### 6.3 `Ranks`
A lookup of ranks or classes (e.g. A/B/C or 1/2/3).  Columns: `RankID`, `Rank`, `Description`, `StateID`.  
Links: **1 → N** to `Indicators`.

---

## 7) Rendering rules (JSON → UI)

### 7.1 Detecting root questions
To render a questionnaire form, the UI (or export generator) must detect which questions are shown as **roots** (top‑level questions).

Root questions are determined by the following rule:

1) **The question is not a sub‑question** — it does not appear as `PredefinedAnswerSubQuestions.SubQuestionID` (a sub‑question always depends on selecting a specific answer).  
2) **The question is not an unconditional child question** — it has no parent (i.e., `ParentQuestionID IS NULL`).

Key distinction:
- `ParentQuestionID` is used only for **unconditional nesting** (a static list of children that is always shown with the parent).  
- `PredefinedAnswerSubQuestions` defines **conditional branching** (*sub‑questions*) that is shown only when a specific answer is selected.

### 7.2 AlwaysVisible children
If a question `Q` has children where:

* `Child.ParentQuestionID = Q.QuestionID`, and
* `Child.SpecificQuestionType` is **AlwaysVisible**

…those children are always rendered immediately under the parent question, regardless of which answer is selected.  Nesting can be recursive.

### 7.3 Conditional sub‑questions
Conditional branches are defined exclusively through `PredefinedAnswerSubQuestions` and exported into JSON as `Answer.SubQuestions` (or IDs, depending on the contract).
When the user selects an answer, that answer’s `SubQuestions` are displayed under it. Changing the answer must clear the previous branch and its captured inputs.

### 7.4 Computed questions and ReadOnly
Questions marked as **Computed** and/or `ReadOnly = 1` do not display an input control. The UI/engine sets their answer automatically, typically via:

1. Collecting input tokens (`PredefinedAnswers.Code`) from dependent questions (often AlwaysVisible children).  
2. Looking up a row in a matrix (e.g., `BuildingCategoryMatrix`, `PremiumRateMatrix`).  
3. Resolving the resulting value back to a `PredefinedAnswer` using the mapping defined in `QuestionReferenceColumns`.  
4. Marking the answer as selected and rendering it as read‑only.

### 7.5 `Code` as a string token
`PredefinedAnswers.Code` is stored and exported as a string token. When comparing it to reference data, the engine casts it to the target type required by the referenced column (as defined by `QuestionReferenceColumns.ReferenceColumnName`).

---

## 8) Guidelines for generating the JSON document

When exporting a questionnaire to JSON, follow these steps:

1. **Header**: Populate the `questionnaire` object with identifiers (e.g. `typeId`, `typeName`), and optionally a schema version and timestamp.  
2. **Questions array**: Export a flat list of all questions participating in the questionnaire.  For each question include its ID, parent ID, order, labels, format, specific type, read‑only flag, and a list of answer options.  Use a wrapper object `{ "*": { ... } }` if your consumer requires it.  
3. **Answers**: For each question, output an `answers` array with `id`, `text`, `code`, `preSelected` and `statisticalWeight`.  Include `subQuestionIds` as an array of numbers for conditional branching.  
4. **Reference mappings and tables**: Include a `referenceMappings` array that links question IDs to `(tableName, columnName)` using `QuestionReferenceColumns` and `QuestionnaireTypeReferenceTables`.  Include a `referenceTables` section containing the actual records of each lookup table used.  
5. **Matrices**: Export the complete data of any matrices used by the questionnaire (e.g. `BuildingCategoryMatrix`, `PremiumRateMatrix`) under a `matrices` object.  
6. **Rules**: If the questionnaire uses computed questions or scoring rules, include a `rules` section describing the method (e.g. matrix lookup) and the bindings from input questions to matrix columns.

These additional sections (`referenceMappings`, `matrices`, `rules`) are optional but recommended.  They allow a generic front‑end to implement conditional logic and computations without hard‑coded knowledge of the database.

---

## 9) Mental model (high‑level view)

1. **Template**: A questionnaire type is defined by `QuestionnaireTypes`, the mapping of questions in `Questionnaires`, and the master data in `Questions`/`PredefinedAnswers`/`PredefinedAnswerSubQuestions`.  This layer answers **what** the questionnaire is.  
2. **Assignment**: `QuestionnaireIdentificatorsTypes` and `QuestionnaireByQuestionnaireIdentificatorsTypes` determine **for whom** and **under what conditions** a questionnaire applies.  
3. **Runtime**: `QuestionnaireIdentificators`, `QuestionnaireByQuestionnaireIdentificators` and `QuestionnaireAnswers` capture **who filled out what** and **what they answered**.  
4. **Lookups and matrices**: `QuestionnaireTypeReferenceTables` and `QuestionReferenceColumns` connect the questionnaire to domain data and matrices, enabling dynamic behaviour and computations.  
5. **Scoring**: `QuestionnaireTypeRules`, `Indicators` and `Ranks` derive risk assessments and final outcomes.

---

## 10) Naming conventions and recommendations

- Use singular names for tables and include clear prefixes (`Questionnaire`, `Question`) to avoid ambiguity.  
- When mapping a question to a reference table, ensure that `TableName` matches the actual table name in the database and that `ReferenceColumnName` matches a column in that table.  
- Treat `PredefinedAnswers.Code` as a string; convert it to the appropriate numeric type only when performing lookups.  
- For convenience you can alias `Questionnaires` as `QuestionnaireQuestions` in the application code – the database keeps the original name for backward compatibility.  
- Avoid adding business logic into the database; keep rules and computations in configuration where possible.

---

## 11) Conclusion

The updated questionnaire model simplifies the schema by removing redundant columns, introduces explicit mapping tables for reference data, and clarifies the meaning of each field.  By following the guidelines above you can generate a single JSON document that contains all the information required by a generic UI to render, branch and compute without hard‑coding.  
This document serves as the primary reference for the questionnaire module as of **17 January 2026**.
