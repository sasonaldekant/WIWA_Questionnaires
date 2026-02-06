---
description: Master workflow covering the entire life cycle of the Admin Panel development (Analysis -> Design -> Implementation -> Verification)
---

# Admin Panel Lifecycle Master

## 1. Analysis Phase (Business Analyst)
// turbo
Trigger the **Business Analyst** skill to review the current request.
- **Input**: User's natural language request + `docs/Admin_Panel_Proposal.md`.
- **Action**: Check if requirements are clear. If not, ask questions. If clear, update `docs/Functional_Specification.md`.
- **Output**: Updated Specs or Questions.

## 2. Design Phase (Database Architect)
// turbo
Trigger the **Database Architect** skill.
- **Input**: The updated `Functional_Specification.md`.
- **Action**:
    - Check if schema changes are needed.
    - If yes, write `.sql` scripts in a new migration file.
    - Verify no cycles in hierarchy.
- **Output**: Validated SQL scripts (or confirmation that none are needed).

## 3. Implementation Phase (FullStack Developer)
// turbo
Trigger the **FullStack Developer** skill.
- **Input**: Functional Specs + SQL Scripts.
- **Action**:
    - Scaffold Backend APIs (Controllers, DTOs).
    - Implement Frontend Components (React Flow, Forms).
    - Connect FE to BE.
- **Output**: Working code.

## 4. Verification Phase (QA Engineer)
// turbo
Trigger the **QA Engineer** skill.
- **Input**: The implemented feature name.
- **Action**:
    - Run the application.
    - Perform a "happy path" test.
    - Create `walkthrough.md` with results.
- **Output**: Verification Report.
