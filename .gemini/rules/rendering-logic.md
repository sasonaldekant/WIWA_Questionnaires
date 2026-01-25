---
description: Pravila za renderovanje upitnika - root detection, branching, computed
priority: high
applies_to: [ba_agent, dba_agent, fs_agent]
version: 1.0
---

# Rendering Logic - Pravila Prikazivanja

## 1. Hijerarhija Pitanja

```
QuestionnaireType
└── Root Questions (top-level)
    ├── Answers
    │   └── SubQuestions (conditional)
    └── Children (AlwaysVisible)
        └── [rekurzivno]
```

## 2. Detekcija Root Pitanja

> [!CAUTION]
> `ParentQuestionID IS NULL` **SAMO** nije dovoljno za root!

### 2.1 Definicija Root Pitanja

**Root pitanje** mora zadovoljiti OBA uslova:
1. ✅ **NIJE sub-question** - ne pojavljuje se kao `PredefinedAnswerSubQuestions.SubQuestionID`
2. ✅ **NIJE child** - nema parent (`ParentQuestionID IS NULL`)

### 2.2 SQL za detekciju

```sql
SELECT q.QuestionID
FROM Questions q
JOIN Questionnaires qn ON qn.QuestionID = q.QuestionID
WHERE qn.QuestionnaireTypeID = @QuestionnaireTypeID
  AND q.ParentQuestionID IS NULL
  AND q.QuestionID NOT IN (
      SELECT SubQuestionID 
      FROM PredefinedAnswerSubQuestions
  )
ORDER BY q.QuestionOrder;
```

## 3. Tipovi Pitanja

### 3.1 SpecificQuestionTypes

| ID | Name | Ponašanje UI |
|----|------|--------------|
| 1 | **AlwaysVisible** | Uvek prikazano, ne zavisi od odgovora roditelja |
| 2 | **ConditionallyVisible** | Prikazano samo kada je triggered odgovorom |
| 3 | **Computed** | Engine automatski bira odgovor (read-only) |
| 4 | **Hidden** | Ne prikazuje se u UI (interno) |

### 3.2 QuestionFormats → UI Controls

| QuestionFormat | UiControl | HTML Element |
|----------------|-----------|--------------|
| RadioButton | `radio` | `<input type="radio">` |
| Select | `select` | `<select>` |
| Checkbox | `checkbox` | `<input type="checkbox">` |
| Input | `input` | `<input type="text">` |
| Textarea | `textarea` | `<textarea>` |
| Hidden | `hidden` | `<input type="hidden">` |

## 4. Conditional Branching (Sub-Questions)

### 4.1 Mehanizam

```
Answer X selektovan
    ↓
PredefinedAnswerSubQuestions.PredefinedAnswerID = X
    ↓
SubQuestionID postaje vidljiv
```

### 4.2 Pravila

1. Sub-questions su definisane **isključivo** kroz `PredefinedAnswerSubQuestions`
2. Kada korisnik promeni odgovor:
   - Prethodna grana se **briše**
   - Svi captured inputi iz te grane se **resetuju**
3. Sub-question može imati svoje sub-questions (višestruko grananje)

### 4.3 JSON reprezentacija

```json
{
  "Answers": [
    {
      "PredefinedAnswerID": 101,
      "Answer": "Da",
      "SubQuestions": [
        {
          "QuestionID": 51,
          "QuestionText": "Koliko puta?",
          ...
        }
      ]
    }
  ]
}
```

## 5. AlwaysVisible Children

### 5.1 Mehanizam

```
Question Q
    ↓
Child.ParentQuestionID = Q.QuestionID
    ↓
Child se UVEK prikazuje ispod Q
```

### 5.2 Pravila

1. Children su definisane kroz `Questions.ParentQuestionID`
2. **UVEK se prikazuju** ispod parent pitanja
3. Ne zavise od selektovanog odgovora
4. Nesting može biti rekurzivan

### 5.3 JSON reprezentacija

```json
{
  "QuestionID": 10,
  "QuestionText": "Materijali objekta",
  "Children": [
    {
      "QuestionID": 11,
      "QuestionText": "Spoljašnji zidovi",
      ...
    },
    {
      "QuestionID": 12,
      "QuestionText": "Krovna konstrukcija",
      ...
    }
  ]
}
```

## 6. Computed Questions

### 6.1 Identifikacija

- `SpecificQuestionTypeID = 3` (Computed)
- `ReadOnly = 1`

### 6.2 Proces izračunavanja

```
1. Prikupi Code vrednosti od input pitanja
2. Izvrši lookup u matrici (npr. BuildingCategoryMatrix)
3. Pronađi matching red
4. Uzmi rezultat (npr. ConstructionTypeID)
5. Mapiraj rezultat na PredefinedAnswer
6. Auto-selektuj taj odgovor
7. Renderuj kao read-only
```

### 6.3 JSON rules sekcija

```json
{
  "rules": [
    {
      "kind": "buildingCategory",
      "questionId": 10,
      "inputQuestionIds": [11, 12, 13, 14],
      "matrixName": "BuildingCategoryMatrix",
      "inputColumns": ["ExternalWallMaterialID", "ConstructionMaterialID", ...],
      "resultColumn": "ConstructionTypeID"
    }
  ]
}
```

## 7. Order i Sortiranje

### 7.1 Redosled pitanja

- Primarno: `QuestionOrder` (ASC)
- Sekundarno: `QuestionID` (ASC) - za stabilnost

### 7.2 Redosled odgovora

- Primarno: `PredefinedAnswerID` (ASC)
- Alternatina: može se dodati kolona `AnswerOrder` ako je potrebno

## 8. State Management

### 8.1 Struktura stanja

```javascript
STATE = {
  [QuestionID]: {
    kind: 'radio' | 'checkbox' | 'select' | 'input' | 'computed',
    answerId: PredefinedAnswerID,
    code: Code,
    text: Answer,
    value: string  // za input/textarea
  }
}
```

### 8.2 Computed vrednosti (odvojeno)

```javascript
COMPUTED = {
  [QuestionID]: {
    code: string,
    answerId: number,
    byRule: string
  }
}
```

---

*Verzija: 1.0 | Datum: 2026-01-22*
