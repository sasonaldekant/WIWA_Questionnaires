# Admin Panel - Phase 2 Implementation Plan (Grid & Edit Flow)

**Phase 2 Goal**: Implement a dashboard for managing questionnaires and enable the "Edit" workflow by loading existing structures from the database.

## User Review Required
> [!IMPORTANT]
> **Workflow Update**: 
> 1. **Dashboard**: Main entry point with a Grid of Questionnaires (filtered by Type/Parameters).
> 2. **Edit Mode**: Select a Questionnaire -> Load Diagram -> reuse existing Visual Builder.
> 3. **Create Mode**: Define Type/Identifier -> Redirect to Visual Builder.

## Proposed Changes

### 1. Backend (`FlowController.cs` & Services)
#### [NEW] `GetQuestionnaireTypes`
-   **Purpose**: Populate the Dashboard Grid and Filter dropdowns.

#### [NEW] `GetFlow(int questionnaireTypeId)` (CRITICAL)
-   **Purpose**: "Reverse Engineer" the relational DB data into Nodes and Edges for the Visual Builder.
-   **BFS Traversal Algorithm**:
    1.  **Roots**: Fetch `Questionnaire` entries for `TypeID`. Get Root Questions.
    2.  **Nodes (Questions)**: Map `QuestionText`, `Type`, `ReferenceTable`, `ReferenceColumn`.
    3.  **Nodes (Answers)**: Fetch `PredefinedAnswers` for each Question.
    4.  **Edges**: 
        -   `Question` -> `Answer` (Parent-Child)
        -   `Answer` -> `SubQuestion` (Branching via `PredefinedAnswerSubQuestions`)
    5.  **Return**: `FlowDto` compatible with React Flow.

### 2. Frontend (`wiwa-admin-panel`)
#### [NEW] `DashboardPage.tsx`
-   **Grid**: List available Questionnaire Types.
-   **Filters**: Multi-parameter filter (Name, ID, etc.).
-   **Actions**: "Edit" (opens Builder with loaded data), "Create New".

#### [MODIFY] `FlowBuilderPage.tsx`
-   **Initialization**: Check for `questionnaireTypeId` param.
-   **Load Logic**: If ID exists, call `getFlow` and populate `nodes`/`edges`.
-   **Toolbar**: Add "Select" and "Delete" tools if missing.

## Verification Plan
1.  **Edit Verification (Priority)**:
    -   Open Dashboard.
    -   Select "Veliki Upitnik".
    -   **Expected**: Visual Builder loads with the correct graph structure.
2.  **Create Verification**:
    -   Create new Type.
    -   Save empty/simple flow.
    -   Verify it appears in Dashboard.
