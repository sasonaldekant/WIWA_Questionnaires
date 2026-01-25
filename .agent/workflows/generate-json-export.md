---
description: Generisanje JSON eksporta upitnika
---

# Generisanje JSON Eksporta

## Preduslovi

- [ ] Upitnik je popunjen u bazi (Questions, Answers, Branching)
- [ ] Mappings su definisani
- [ ] QuestionnaireTypeID je poznat

## Koraci

### 1. Postavi QuestionnaireTypeID

```sql
DECLARE @QuestionnaireTypeID SMALLINT = [TVOJ_ID];
```

// turbo
### 2. Proveri uključena pitanja

```sql
SELECT q.QuestionID, q.QuestionText, q.QuestionOrder
FROM Questionnaires qn
JOIN Questions q ON q.QuestionID = qn.QuestionID
WHERE qn.QuestionnaireTypeID = @QuestionnaireTypeID
ORDER BY q.QuestionOrder;
```

// turbo
### 3. Proveri root pitanja

```sql
SELECT q.QuestionID, q.QuestionText
FROM Questions q
JOIN Questionnaires qn ON qn.QuestionID = q.QuestionID
WHERE qn.QuestionnaireTypeID = @QuestionnaireTypeID
  AND q.ParentQuestionID IS NULL
  AND q.QuestionID NOT IN (
      SELECT SubQuestionID FROM PredefinedAnswerSubQuestions
  );
```

### 4. Pokreni JSON generator

Otvori i izvrši: `docs/JSON_File_Generator_v8_MODEL_18_01_2026.sql`

```sql
-- Postavi ID na vrhu fajla
DECLARE @QuestionnaireTypeID SMALLINT = [TVOJ_ID];
-- Zatim izvrši ostatak skripte
```

### 5. Sačuvaj output

Output će biti jedan JSON dokument. Sačuvaj ga kao:
`[TypeCode]_questionnaire_[DATUM].json`

// turbo
### 6. Validiraj JSON

```javascript
// Proveri osnovnu strukturu
const json = JSON.parse(output);
console.assert(json.meta !== undefined);
console.assert(json.questionnaire !== undefined);
console.assert(json.questions !== undefined);
console.assert(json.questions.length > 0);
```

### 7. Testiraj u rendereru

1. Otvori `docs/WIWA_Questionnaire_Renderer.html`
2. Klikni "File input" i izaberi JSON
3. Proveri:
   - [ ] Sva pitanja se prikazuju
   - [ ] Branching radi
   - [ ] Computed vrednosti se računaju

## Troubleshooting

### Problem: Pitanje nedostaje u JSON-u

```sql
-- Proveri da li je u Questionnaires mappingu
SELECT * FROM Questionnaires 
WHERE QuestionnaireTypeID = @ID AND QuestionID = @MissingID;
```

### Problem: Branching ne radi

```sql
-- Proveri PredefinedAnswerSubQuestions
SELECT * FROM PredefinedAnswerSubQuestions pasq
JOIN PredefinedAnswers pa ON pa.PredefinedAnswerID = pasq.PredefinedAnswerID
WHERE pa.QuestionID = @ParentQuestionID;
```

### Problem: Computed ne radi

```sql
-- Proveri reference mappings
SELECT * FROM QuestionReferenceColumns
WHERE QuestionID = @ComputedQuestionID;
```
