# WIWA Questionnaire – Documentation index

This `README_EN.md` is the entry point for working with the WIWA *Questionnaire* module.

## 1) Main files

| File | Role |
|---|---|
| `WIWA_DB_NEW_MODEL_17_01_2026.sql` | Database model (DDL): CREATE TABLE, keys, FKs, types |
| `WIWA_DB_NEW_DATA_17_01_2026.sql` | Data snapshot: lookups, questions/answers, matrices |
| `WIWA_Questionnaire_GUI_JSON.schema.v2_MODEL_15_01_2026.json` | JSON schema/contract for the export consumed by the UI renderer |
| `WIWA_Questionnaire_Documentation_v3_MODEL_17_01_2026_sr.md` | Full documentation (SR): model + rendering rules + JSON export |
| `WIWA_Questionnaire_Documentation_v3_MODEL_17_01_2026_en.md` | Full documentation (EN): model + rendering rules + JSON export |
| `WIWA_Questionnaire_Tables_Roles_v5_MODEL_17_01_2026_sr.md` | Table roles (SR) by layers |
| `WIWA_Questionnaire_Tables_Roles_v5_MODEL_17_01_2026_en.md` | Table roles (EN) by layers |
| `WIWA_Questionnaire_Audit_v3_MODEL_17_01_2026.md` | Audit: change history and content moves between documents |
| `README.md` | Serbian version of this README |

## 2) Sources of truth (priority)

When files disagree, use this priority:
1) `WIWA_DB_NEW_MODEL_17_01_2026.sql`
2) `WIWA_DB_NEW_DATA_17_01_2026.sql`
3) `WIWA_Questionnaire_GUI_JSON.schema.v2_MODEL_15_01_2026.json`
4) `WIWA_Questionnaire_Documentation_v3_MODEL_17_01_2026_*.md`

## 3) Terminology (critical for UI and JSON generator)

- **Child (AlwaysVisible) question**: unconditional nesting via `Questions.ParentQuestionID`.
- **Sub-question (conditional)**: a question that becomes visible *only* when a specific answer is selected; defined by `PredefinedAnswerSubQuestions`.
- **Root question**: a question shown at the top level of the form. A root question:
  - **is not a sub-question** (it does not appear as `PredefinedAnswerSubQuestions.SubQuestionID`), and
  - **is not a child** (it has no parent; `ParentQuestionID IS NULL`).

> `ParentQuestionID IS NULL` alone is **not sufficient** to classify a question as root (a sub-question may also have `ParentQuestionID IS NULL`).

## 4) Minimal checklist for JSON export

1) Select questions for the `QuestionnaireType` (template mapping).
2) Compute `rootQuestionIds` using the rules above.
3) Export `Questions` + `PredefinedAnswers`.
4) Nest conditional branches via `PredefinedAnswerSubQuestions` (`Answer.SubQuestions`).
5) Nest unconditional children via `ParentQuestionID`.
6) (Optional, recommended) include `referenceMappings`, `referenceTables`, `matrices`, `rules` for generic computed/matrix logic.
