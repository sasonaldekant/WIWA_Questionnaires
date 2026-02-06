# Flow Builder - Complete Implementation Guide

## Overview
Visual flowchart editor for creating questionnaires by dragging nodes and connecting them.

---

## Phase B: Complete Form Modal (CURRENT FOCUS)

### Form Fields Mapping to DB

#### Question Node Fields (from `Questions` table):
| Field | DB Column | Type | Required | Notes |
|-------|-----------|------|----------|-------|
| Question Text | `QuestionText` | TextArea | Yes | Main question content |
| Question Label | `QuestionLabel` | Input | No | Short identifier (e.g., "1.1") |
| Question Order | `QuestionOrder` | Number | No | Display order |
| Question Format | `QuestionFormatID` | Select | No | Radio, Checkbox, Text, etc. |
| Parent Question | `ParentQuestionID` | Auto | No | **Auto-detected from edges** |
| Specific Question Type | `SpecificQuestionTypeID` | Select | No | Dropdown from DB |
| Read Only | `ReadOnly` | Checkbox | No | User cannot edit |
| Is Required | `IsRequired` | Checkbox | No | Validation flag |
| Validation Pattern | `ValidationPattern` | Input | No | Regex pattern |

#### Computed Configuration (conditional - only for parent questions):
| Field | DB Table | Column | Notes |
|-------|----------|--------|-------|
| Is Computed | - | Checkbox | Shows/hides computed section |
| Compute Method | `QuestionComputedConfig` | `ComputeMethodID` | Matrix, Formula, etc. |
| Rule Name | `QuestionComputedConfig` | `RuleName` | User-friendly name |
| Rule Description | `QuestionComputedConfig` | `RuleDescription` | Optional description |
| Matrix Object Name | `QuestionComputedConfig` | `MatrixObjectName` | For matrix lookups |
| Output Mode | `QuestionComputedConfig` | `OutputMode` | 0=Value, 1=AnswerID |
| Output Target | `QuestionComputedConfig` | `OutputTarget` | Target column |
| Matrix Output Column | `QuestionComputedConfig` | `MatrixOutputColumnName` | Result column |
| Formula Expression | `QuestionComputedConfig` | `FormulaExpression` | For calculated fields |
| Priority | `QuestionComputedConfig` | `Priority` | Execution order |
| Is Active | `QuestionComputedConfig` | `IsActive` | Enable/disable |

#### Reference Table/Column (optional):
| Field | DB Table | Column | Validation |
|-------|----------|--------|------------|
| Reference Table | `QuestionReferenceColumn` | via `QuestionnaireTypeReferenceTable.TableName` | Optional |
| Reference Column | `QuestionReferenceColumn` | `ReferenceColumnName` | **Required if Table is set** |

### Visual Node Behavior

#### Color System (3 colors):
- **🔵 Blue (Root)**: Question with no incoming edge from another question or answer
- **🟣 Purple (Parent-Child)**: Question connected from another Question (Q→Q) - has `ParentQuestionID` in DB
- **🟠 Orange (Subquestion)**: Question connected from an Answer (A→Q) - via `PredefinedAnswerSubQuestions` table

#### Implementation:
```javascript
if (!parentEdge) → Blue (root)
if (parentEdge.source is Question) → Purple (parent-child)
if (parentEdge.source is Answer) → Orange (subquestion)
```

#### Badges on Node:
- `*` - Required (isRequired = true)
- `C` - Computed (has QuestionComputedConfig)
- `[Type]` - Specific Question Type code

---

## Phase C: Backend API Endpoints

### Required Controllers:

#### 1. QuestionnaireTypesController
```csharp
GET    /api/QuestionnaireTypes          // List all
POST   /api/QuestionnaireTypes          // Create new
GET    /api/QuestionnaireTypes/{id}      // Get by ID
PUT    /api/QuestionnaireTypes/{id}      // Update
DELETE /api/QuestionnaireTypes/{id}      // Delete
```

#### 2. QuestionnaireIdentificatorTypesController
```csharp
GET    /api/QuestionnaireIdentificatorTypes
POST   /api/QuestionnaireIdentificatorTypes
```

#### 3. SpecificQuestionTypesController
```csharp
GET    /api/SpecificQuestionTypes        // For dropdown
```

#### 4. QuestionFormatsController
```csharp
GET    /api/QuestionFormats              // For dropdown
```

#### 5. FlowController
```csharp
POST   /api/Flow/Save                    // Save entire flow to DB
GET    /api/Flow/Load/{questionnaireTypeId}  // Load existing questionnaire as flow
```

---

## Phase D: Save Flow Logic

### Pre-Submit Modal Fields:
- **Questionnaire Type**: Dropdown (existing) or Input (new)
- **Questionnaire Identification Type**: Dropdown (existing) or Input (new)
- **Created Date**: Auto-populated (DateTime.Now)

### Flow → DB Conversion Algorithm:

```
1. Validate Flow:
   - At least 1 question node
   - All required fields filled
   - Reference: If Table set, Column must be set

2. Create/Select QuestionnaireType:
   - If new → INSERT into QuestionnaireTypes
   - If existing → Get QuestionnaireTypeID

3. Create/Select QuestionnaireIdentificatorType:
   - If new → INSERT into QuestionnaireIdentificatorTypes
   - If existing → Get QuestionnaireIdentificatorTypeID

4. Insert Questions:
   FOR EACH question node:
     a. INSERT into Questions (return QuestionID)
     b. Detect ParentQuestionID:
        - Find incoming edge from another Question node
        - If exists → set ParentQuestionID
        - Color logic: If ParentQuestionID != null → isChild = true (yellow)
     
     c. IF has child questions (outgoing edges to other Questions):
        - User should have set "Is Computed" = true
        - INSERT into QuestionComputedConfig
     
     d. IF ReferenceTable is set:
        - INSERT into QuestionnaireTypeReferenceTable (if not exists)
        - INSERT into QuestionReferenceColumn

5. Insert Predefined Answers:
   FOR EACH answer node:
     a. Find parent Question (incoming edge from Question)
     b. INSERT into PredefinedAnswers (linked to QuestionID)

6. Insert Answer → SubQuestion Branching:
   FOR EACH edge FROM Answer TO Question:
     a. INSERT into PredefinedAnswerSubQuestions
        - PredefinedAnswerID (source)
        - SubQuestionID (target)

7. Create Questionnaire Entry:
   INSERT into Questionnaires:
     - QuestionnaireTypeID (from step 2)
     - QuestionID (root question - first question in flow)

8. Return Success + QuestionnaireID
```

---

## UI/UX Flow

### Step 1: User Opens Flow Builder
- Blank canvas
- Palette on left with 2 items:
  - 🔵 Question
  - 🟢 Predefined Answer

### Step 2: Drag & Drop
- User drags "Question" → canvas
- Node appears blue, labeled "New Question"

### Step 3: Double-Click to Edit
- Modal opens with tabs:
  - **Basic Info**: QuestionText, Label, Order, Format, Required, ReadOnly, Validation
  - **Advanced**: SpecificQuestionType, ReferenceTable/Column
  - **Computed** (only if has child questions): All computed fields

### Step 4: Connect Nodes
- Question → Answer: Creates predefined answer for that question
- Answer → Question: Creates branching (PredefinedAnswerSubQuestions)
- Question → Question: Creates parent-child (ParentQuestionID)
  - Child question turns **yellow**

### Step 5: Save Flow
- Click "Save Flow" button
- Pre-submit modal appears:
  - QuestionnaireType (dropdown or new)
  - QuestionnaireIdentificationType (dropdown or new)
- Click "Submit" → Flow → DB conversion runs

---

## Implementation Checklist

### Backend
- [ ] QuestionnaireTypesController
- [ ] QuestionnaireIdentificatorTypesController
- [ ] SpecificQuestionTypesController
- [ ] QuestionFormatsController
- [ ] FlowController with Save/Load

### Frontend
- [ ] Update QuestionNode (blue/yellow logic)
- [ ] Expand modal form with all fields
- [ ] Add Computed section (conditional)
- [ ] Add Reference Table section (with validation)
- [ ] Pre-submit modal for QuestionnaireType
- [ ] Save button → backend integration
- [ ] Edge detection logic (parent-child, branching)

### Testing
- [ ] Create simple flow (1 Question, 2 Answers)
- [ ] Create branching flow (Answer → SubQuestion)
- [ ] Create parent-child flow (Question → Question)
- [ ] Test computed configuration
- [ ] Test reference tables
- [ ] Verify DB tables populated correctly

---

## Next Steps
Starting with **Backend API endpoints** to support the flow builder.
