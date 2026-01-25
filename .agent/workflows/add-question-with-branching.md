---
description: Dodavanje pitanja sa conditional branching logikom
---

# Dodavanje Pitanja sa Grananjem

## Scenario

Dodajemo pitanje koje, u zavisnosti od odgovora, otvara različite grane dodatnih pitanja.

## Koraci

### 1. Definiši strukturu

```
Glavno pitanje (P1)
├── Odgovor A → otvara P2
├── Odgovor B → otvara P3, P4
└── Odgovor C → bez dodatnih pitanja
```

### 2. Kreiraj glavno pitanje

```sql
-- Proveri postojeće ID-jeve
SELECT MAX(QuestionID) FROM Questions;

-- Insert glavno pitanje
INSERT INTO Questions (
    QuestionText, 
    QuestionLabel, 
    QuestionOrder, 
    QuestionFormatID,      -- 1=RadioButton
    SpecificQuestionTypeID, -- 1=AlwaysVisible
    ParentQuestionID,      -- NULL za root
    ReadOnly               -- 0
)
VALUES (
    N'Glavno pitanje tekst?',
    N'Glavno',
    10,  -- Order
    1,   -- RadioButton
    1,   -- AlwaysVisible
    NULL,
    0
);

DECLARE @MainQuestionID INT = SCOPE_IDENTITY();
```

### 3. Kreiraj odgovore za glavno pitanje

```sql
-- Odgovor A
INSERT INTO PredefinedAnswers (QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES (@MainQuestionID, N'Odgovor A', N'A', 0, 1.0);
DECLARE @AnswerA_ID INT = SCOPE_IDENTITY();

-- Odgovor B
INSERT INTO PredefinedAnswers (QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES (@MainQuestionID, N'Odgovor B', N'B', 0, 2.0);
DECLARE @AnswerB_ID INT = SCOPE_IDENTITY();

-- Odgovor C
INSERT INTO PredefinedAnswers (QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES (@MainQuestionID, N'Odgovor C', N'C', 0, 0.5);
```

### 4. Kreiraj sub-pitanja

```sql
-- P2 (otvara se za Odgovor A)
INSERT INTO Questions (
    QuestionText, QuestionLabel, QuestionOrder, 
    QuestionFormatID, SpecificQuestionTypeID, 
    ParentQuestionID, ReadOnly
)
VALUES (
    N'Pitanje za odgovor A?',
    N'P2',
    1,
    1,   -- RadioButton
    2,   -- ConditionallyVisible
    NULL,
    0
);
DECLARE @P2_ID INT = SCOPE_IDENTITY();

-- P3 (otvara se za Odgovor B)
INSERT INTO Questions (...)
VALUES (...);
DECLARE @P3_ID INT = SCOPE_IDENTITY();

-- P4 (otvara se za Odgovor B)
INSERT INTO Questions (...)
VALUES (...);
DECLARE @P4_ID INT = SCOPE_IDENTITY();
```

### 5. Definiši grananje

```sql
-- Proveri postojeće ID-jeve
SELECT MAX(PredefinedAnswerSubQuestionID) FROM PredefinedAnswerSubQuestions;

-- Odgovor A → P2
INSERT INTO PredefinedAnswerSubQuestions (
    PredefinedAnswerSubQuestionID, 
    PredefinedAnswerID, 
    SubQuestionID
)
VALUES (
    [NEXT_ID],
    @AnswerA_ID, 
    @P2_ID
);

-- Odgovor B → P3
INSERT INTO PredefinedAnswerSubQuestions (...)
VALUES ([NEXT_ID+1], @AnswerB_ID, @P3_ID);

-- Odgovor B → P4
INSERT INTO PredefinedAnswerSubQuestions (...)
VALUES ([NEXT_ID+2], @AnswerB_ID, @P4_ID);
```

### 6. Dodaj u questionnaire mapping

```sql
INSERT INTO Questionnaires (QuestionnaireTypeID, QuestionID)
SELECT @QuestionnaireTypeID, QuestionID
FROM (VALUES 
    (@MainQuestionID),
    (@P2_ID),
    (@P3_ID),
    (@P4_ID)
) AS t(QuestionID);
```

### 7. Verifikacija

```sql
-- Proveri strukturu
SELECT 
    pa.PredefinedAnswerID,
    pa.Answer,
    pasq.SubQuestionID,
    q.QuestionText AS SubQuestionText
FROM PredefinedAnswers pa
LEFT JOIN PredefinedAnswerSubQuestions pasq 
    ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID
LEFT JOIN Questions q 
    ON q.QuestionID = pasq.SubQuestionID
WHERE pa.QuestionID = @MainQuestionID;
```

## Testovi

```javascript
// Test: Main question ima 3 odgovora
assert(mainQuestion.Answers.length === 3);

// Test: Odgovor A ima SubQuestions
const answerA = mainQuestion.Answers.find(a => a.Code === 'A');
assert(answerA.SubQuestions.length === 1);

// Test: Odgovor B ima 2 SubQuestions
const answerB = mainQuestion.Answers.find(a => a.Code === 'B');
assert(answerB.SubQuestions.length === 2);

// Test: Odgovor C nema SubQuestions
const answerC = mainQuestion.Answers.find(a => a.Code === 'C');
assert(answerC.SubQuestions.length === 0);
```
