# strict_hierarchy_plan.md

## Objective
Implement "Veliki Upitnik" exactly matching the hierarchy and numbering from `veliki_upitnik_clean_utf8.txt`.

## Hierarchy Definitions

### Level 1: Q1 (Root)
*   **ID**: 1000
*   **Text**: "Da li ste bolovali ili trenutno bolujete od:"
*   **Label**: "1"
*   **Format**: Checkbox Group (SpecificType: AlwaysVisible)

### Level 2: Answers to Q1 & Their Sub-Questions
Each Answer in Q1 corresponds to a `.x` number (1.1, 1.2, 1.3...).
Checking an answer triggers a Sub-Question.

*   **1.1 Maligni tumori** (Answer)
    *   Triggers **Q_1_1** (ID 1100, Label "1.1") -> "Detalji (Maligni tumori)" (Text Input)
*   **1.2 Bolesti srca** (Answer)
    *   Triggers **Q_1_2** (ID 1200, Label "1.2") -> "Koje bolesti srca i krvnih sudova?" (Checkbox Group)

### Level 3: Answers to Q_1_2 & Their Sub-Questions
Each Answer in Q_1_2 corresponds to a `.x.y` number (1.2.1, 1.2.2...).

*   **1.2.1 Povišen pritisak** (Answer)
    *   Triggers **Q_1_2_1** (ID 1210, Label "1.2.1") -> "Detalji (Pritisak)" (Text Input)
*   **1.2.2 Aritmija** (Answer)
    *   Triggers **Q_1_2_2** (ID 1220, Label "1.2.2") -> "Detalji (Aritmija)" (Text Input)
*   ... (and so on for 1.2.3 to 1.2.10)

### Level 2 Cont'd (Other Q1 Branches)
*   **1.3 Metabolizam** (Answer) -> Triggers **Q_1_3** (ID 1300, Label "1.3") -> Checkbox Group
    *   **1.3.1 Dijabetes** -> Triggers **Q_1_3_1** (Text)
    *   ...
*   **1.4 Disajni** (Answer) -> Triggers **Q_1_4** (ID 1400, Label "1.4") -> Checkbox Group
    *   **1.4.1 Bronhitis** -> Triggers **Q_1_4_1** (Text)
    *   ...
*   **1.5 Uro-genitalni** (Answer) -> Triggers **Q_1_5** (ID 1500, Label "1.5") -> Checkbox Group
*   **... up to 1.12**

### Other Root Questions (2 - 9)
Currently Q2-Q9 are handled, will double check their internal numbering (e.g., 9.1).

## Technical Details
*   **IDs**:
    *   Q1: 1000
    *   Q1.x Branches: 1100, 1200, 1300...
    *   Q1.x.y Details: 1210, 1220...
    *   Answers: 10000+ to avoid collision.
*   **Format**: Strict usage of `PredefinedAnswerSubQuestions`.
*   **Cleanup**: Aggressive deletion of `ID > 200` to be safe.

## Action
Create `24_Implement_Veliki_Strict.sql` implementing this structure.
