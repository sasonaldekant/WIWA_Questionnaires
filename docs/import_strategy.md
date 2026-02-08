# Questionnaire Import Strategy: Excel/CSV Standardization

## 1. Goal
Design a standard data structure to facilitate the import of large questionnaires into the WIWA system from Excel or CSV files. The focus is on capturing the Question text, Answer options, and Hierarchy (Parent-Child and Branching logic).

## 2. Current Domain Model Analysis
The backend uses a relational model:
- **Question**: Main entity (Text, Label, Type, Order).
- **PredefinedAnswer**: Options for a question (Text, Code, Order).
- **Hierarchy Type A (Direct)**: `Question.ParentQuestionID` (Used for Grouping/Sections).
- **Hierarchy Type B (Branching)**: `PredefinedAnswerSubQuestion` (Question X is shown *only* if Answer Y is selected).

## 3. Proposed Standard Format (Flat Excel/CSV)

A single "Flat" sheet is the most user-friendly approach for non-technical users. We handle the relational complexity via naming conventions.

### Columns Structure

| Column Name | Required | Description | Example |
| :--- | :--- | :--- | :--- |
| **Label** | **Yes** | Unique identifier for the question in the file. Used for referencing parents. | `Q1`, `Q1.1`, `Personal_Info` |
| **Text** | **Yes** | The actual question text displayed to the user. | `What is your name?` |
| **Type** | **Yes** | The UI control type. Valid values: `Text`, `TextArea`, `Date`, `Number`, `Radio`, `Checkbox`, `Select`, `SectionLabel`. | `Radio` |
| **Options** | No | For `Radio`, `Checkbox`, `Select`. List of answers separated by a delimiter (`;`). Codes can be specified with `:`. | `Yes:1;No:0` or `Red;Blue;Green` |
| **ParentLabel** | No | The `Label` of the parent question. If empty, it's a root question. | `Q1` |
| **TriggerAnswer**| No | If this question is shown *conditionally*, specify the **exact text or code** of the answer from the Parent that triggers this. | `Yes` (If Parent Q1 is "Yes", show this) |
| **Required** | No | `True` or `False`. Default is `False`. | `True` |
| **Order** | No | Integer for sorting. If empty, file order is used. | `10` |
| **Validation** | No | Regex pattern for text inputs. | `^\d{13}$` |

### Logic & Rules

1.  **Branching vs. Grouping**:
    - If `ParentLabel` is set AND `TriggerAnswer` is **EMPTY**: The question is a direct child of the parent (Group/Section behavior).
    - If `ParentLabel` is set AND `TriggerAnswer` is **SET**: The question is a child of the specific *answer* (Branching behavior).

2.  **Options Parsing**:
    - Simple: `Option A;Option B` -> Creates answers "Option A" and "Option B".
    - With Codes: `Option A:cod1;Option B:cod2` -> Creates answers with explicit DB codes.

3.  **Validation**:
    - `Label` must be unique within the file.
    - `ParentLabel` must exist in the file (or be a known existing question ID, if we support appending).
    - `TriggerAnswer` must match one of the options defined in the Parent's `Options` column.

## 4. Alternative: Relational Format (Multiple Sheets)

For very complex questionnaires, a multi-sheet Excel file might be cleaner to avoid massive "Options" columns.

**Sheet 1: Questions**
Columns: `Label`, `Text`, `Type`, `Required`, `Order`, `Validation`

**Sheet 2: Answers**
Columns: `QuestionLabel`, `OptionText`, `OptionCode`, `Order`

**Sheet 3: Logic**
Columns: `ChildLabel`, `ParentLabel`, `TriggerAnswerCode`

*Pros*: Cleaner data.
*Cons*: Harder for humans to visualize the flow while editing.

## 5. Recommendation

We recommend the **Flat Excel/CSV Format** for the MVP. It allows users to visualize the questionnaire flow linearly.

### Example Data

| Label | Text | Type | Options | ParentLabel | TriggerAnswer |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Q1** | Do you have a car? | Radio | Yes;No | | |
| **Q1_Brand** | What brand? | Select | BMW;Audi;Mercedes | Q1 | Yes |
| **Q1_Model** | What model? | Text | | Q1_Brand | BMW |
| **Q2** | Your Age | Number | | | |

## 6. Implementation Plan (Future)

1.  **Backend Service**: Create `ImportService` in `Wiwa.Questionnaire.API`.
2.  **Parser**: Implement `CsvHelper` or `ExcelDataReader` logic to map rows to DTOs.
3.  **Validator**:
    - validate generic tree structure (no loops).
    - validate missing parents.
    - validate orphaned triggers.
4.  **Mapper**: Convert valid DTO tree into `Question`, `PredefinedAnswer`, `PredefinedAnswerSubQuestion` entities.
5.  **Transaction**: Save entire questionnaire in one transaction.
