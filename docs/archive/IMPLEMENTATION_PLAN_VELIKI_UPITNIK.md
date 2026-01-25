# Implementation Plan: Full "Veliki Upitnik" (Great Questionnaire)

This document outlines the proposed strategy for the complete data entry of the "Veliki Upitnik" into the database (`WIWA_DB_NEW`), ensuring the Generic HTML Renderer can display it fully without code changes.

## 1. Goal
Populate all questions, answers, branching logic, and computed fields exactly as defined in the source documentation (`01_VELIKI_UPITNIK.md` and `veliki_upitnik_tabela.xlsx`).

---

## 2. Technical Implementation Strategy

### ID Range Strategy
*   **Questions**: `200 - 299` (Reserved for Great Questionnaire).
*   **Predefined Answers**: `2000 - 2999`.
*   **Sub-Question Links**: Auto-incrementing from max existing.

### Key Data Structures (Ref: Lessons Learned)
1.  **Root Questions**: Linked to `QuestionnaireTypes` (TypeID = 3) via the `Questionnaires` table.
2.  **Conditional Branching (Sub-Questions)**: Defined **ONLY** in `PredefinedAnswerSubQuestions`. 
    *   🛑 **Rule**: These will have `ParentQuestionID = NULL` in the `Questions` table to avoid duplication in the renderer.
3.  **Always Visible Children (Direct Nesting)**: Defined using `ParentQuestionID`. Used for components like BMI inputs (Height, Weight).

---

## 3. Question blocks & Mapping

### Block 1: Medical Questions (Q1 - Q3)
*   **Structure**: 
    *   Q1 (Root): "Do you suffer from..." (Format: `Checkbox Group`).
    *   Answers: BP, Heart, Diabetes, etc.
    *   **Branching**: Each "Yes" answer triggers a specific `SubQuestion` for details (Format: `Textarea`).
*   **Implementation**: 
    *   `SpecificQuestionTypeID = 1` for Root.
    *   `SpecificQuestionTypeID = 2` (Conditional) for detail questions.

### Block 2: BMI Calculation (Q4)
*   **Root**: Question 204 (Label: `BMI.R`).
    *   `Format`: `Text input`.
    *   `SpecificType`: `3` (Computed).
    *   `ReadOnly`: `1`.
*   **Children**: 2041 (`BMI.H`) and 2042 (`BMI.W`).
    *   `ParentQuestionID`: `204`.
    *   `SpecificType`: `1` (AlwaysVisible).
*   **Logic**: Map to `BMI_CALC` method in `QuestionComputedConfigs`.

### Block 3: Sports (Q5)
*   **Root**: Question 205 (Label: `SPORT`).
*   **Format**: `Autocomplete Dropdown`.
*   **Reference**: Linked to `Sports` lookup table via `QuestionReferenceColumns`.

### Block 4: Life Habits (Q6)
*   **Root**: Question 206 (Group Header "Life Habits").
*   **Children** (Always Visible): 
    *   Q6a: Alcohol (Radio).
    *   Q6b: Tobacco (Radio).
    *   Q6c: Drugs (Boolean).
*   **Logic**: Q6c (Drugs) will have a marker for the UW module to trigger "Reject" if "Yes".

---

## 4. Execution Workflow

1.  **DML Script (`22_Implement_Veliki_Upitnik_Full.sql`)**:
    *   `SET IDENTITY_INSERT` for fixed ID ranges.
    *   Atomic inserts of Questions and Answers.
    *   Verification queries to ensure no "double parenting".
2.  **JSON Regeneration**:
    *   Execute `generate_json_veliki.sql` to produce the updated `veliki_upitnik.json`.
3.  **Verification**:
    *   Load `WIWA_Questionnaire_Renderer.html` and verify all sections (Medical, BMI, Habits) appear and branch correctly.

---

## 5. Review Points for USER
*   **IDs**: Is the `200+` range acceptable for this questionnaire?
*   **Multiple Selects**: Should Q1 be a single Checklist or several separate Yes/No questions? (I recommend a Checklist group based on spec).
*   **Grouping**: Is the `ParentID` grouping for Habits preferred over having them as top-level questions?
