# Flow Builder - Visual Guide

## 🎨 **Color Coding System**

### Root Question - 🔵 Blue
- No incoming connections
- This is the starting question of the questionnaire
- Border: `#1890ff`
- Header: Blue background

### Parent-Child Question - 🟣 Purple  
- Connected from another Question (Q→Q)
- Indicates direct parent-child relationship
- Sets `ParentQuestionID` in database
- Border: `#722ed1`
- Header: Purple background

### Subquestion - 🟠 Orange
- Connected from an Answer (A→Q)
- Indicates conditional branching based on answer
- Creates entry in `PredefinedAnswerSubQuestions` table
- Border: `#fa8c16`
- Header: Orange background

---

## 📋 **Usage Examples**

### Example 1: Simple Linear Flow
```
[Q1: Main Question] 🔵 Blue
    ↓
[A1: Yes] 🟢 Green
[A2: No] 🟢 Green
```

### Example 2: Parent-Child Hierarchy
```
[Q1: Main Question] 🔵 Blue (root)
    ↓ (Q→Q)
[Q2: Sub-detail] 🟣 Purple (parent-child)
    ↓ (Q→Q)
[Q3: Further detail] 🟣 Purple (parent-child)
```
**Database**: Q2.ParentQuestionID = Q1.QuestionID, Q3.ParentQuestionID = Q2.QuestionID

### Example 3: Conditional Branching
```
[Q1: Do you smoke?] 🔵 Blue
    ↓
[A1: Yes] 🟢 Green
    ↓ (A→Q)
[Q2: How many cigarettes?] 🟠 Orange (subquestion)

[A2: No] 🟢 Green
    (no connection - end of branch)
```
**Database**: Entry in `PredefinedAnswerSubQuestions` where PredefinedAnswerID = A1, SubQuestionID = Q2

### Example 4: Mixed Hierarchy
```
[Q1: Main Category] 🔵 Blue (root)
    ↓ (Q→Q)
[Q2: Sub-category] 🟣 Purple (parent-child)
    ↓
[A1: Option A] 🟢 Green
    ↓ (A→Q)
[Q3: Details for A] 🟠 Orange (subquestion)

[A2: Option B] 🟢 Green
    ↓ (A→Q)
[Q4: Details for B] 🟠 Orange (subquestion)
```

---

## 🔧 **Testing Checklist**

### Visual Verification
- [ ] Root question appears BLUE
- [ ] Q→Q connected question appears PURPLE
- [ ] A→Q connected question appears ORANGE
- [ ] Handles match node border color
- [ ] Node header matches node border color

### Functional Verification  
- [ ] Drag Question from palette → Blue node appears
- [ ] Drag Answer from palette → Green node appears
- [ ] Connect Q→Q → Target turns PURPLE
- [ ] Connect Q→A → Answer stays GREEN
- [ ] Connect A→Q → Target turns ORANGE
- [ ] Double-click opens modal with 3 tabs
- [ ] Save Flow → Pre-submit modal appears
- [ ] After save → Database populated correctly

---

## 🗄️ **Database Mapping**

### Blue (Root)
```sql
SELECT * FROM Questions WHERE ParentQuestionID IS NULL;
```

### Purple (Parent-Child)
```sql
SELECT Q1.QuestionText AS Parent, Q2.QuestionText AS Child
FROM Questions Q1
INNER JOIN Questions Q2 ON Q2.ParentQuestionID = Q1.QuestionID;
```

### Orange (Subquestion)
```sql
SELECT A.Answer, Q.QuestionText AS Subquestion
FROM PredefinedAnswers A
INNER JOIN PredefinedAnswerSubQuestions PAS ON PAS.PredefinedAnswerID = A.PredefinedAnswerID
INNER JOIN Questions Q ON Q.QuestionID = PAS.SubQuestionID;
```

---

## 🎯 **Quick Reference**

| Connection | Source | Target | Color | DB Table |
|------------|--------|--------|-------|----------|
| Root | - | Question | 🔵 Blue | Questions (ParentQuestionID = NULL) |
| Parent-Child | Question | Question | 🟣 Purple | Questions (ParentQuestionID set) |
| Answer | Question | Answer | 🟢 Green | PredefinedAnswers |
| Subquestion | Answer | Question | 🟠 Orange | PredefinedAnswerSubQuestions |

---

## 📸 **Expected Screenshots**

When testing in browser at `http://localhost:5173/flow-builder`, you should see:

1. **Initial State**:
   - Left sidebar with "Question" and "Predefined Answer" palette items
   - Empty canvas on the right
   - Instructions showing color legend

2. **After Dragging Question**:
   - Blue node on canvas
   - Label "New Question"
   - Text "Double-click to edit"

3. **After Double-Click**:
   - Modal with 3 tabs: Basic Info, Advanced, Computed Config
   - Form fields populated with node data

4. **After Connecting Q→Q**:
   - First question stays BLUE
   - Second question turns PURPLE
   - Edge connecting them

5. **After Connecting A→Q**:
   - Answer stays GREEN
   - Target question turns ORANGE
   - Edge shows branching logic

---

✅ **Everything is now implemented and ready for testing!**
