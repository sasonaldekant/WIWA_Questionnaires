---
description: Podešavanje computed pitanja sa matrix lookup-om
---

# Podešavanje Computed Pitanja

## Scenario

Computed pitanje automatski dobija odgovor na osnovu vrednosti iz drugih pitanja kroz lookup u matrici.

**Primer**: Kategorija objekta se računa iz materijala zidova, krova, konstrukcije.

## Koraci

### 1. Definiši strukturu

```
Parent Question (Computed, ReadOnly)
├── Child 1: Spoljašnji zidovi (input)
├── Child 2: Konstrukcija (input)
├── Child 3: Krovna konstrukcija (input)
└── Child 4: Pokrivač krova (input)

Matrix: BuildingCategoryMatrix
    [Zidovi] + [Konstrukcija] + [Krov] + [Pokrivač] → [Kategorija]
```

### 2. Kreiraj parent pitanje (computed)

```sql
INSERT INTO Questions (
    QuestionText,
    QuestionLabel,
    QuestionOrder,
    QuestionFormatID,      -- 1=RadioButton
    SpecificQuestionTypeID, -- 3=Computed
    ParentQuestionID,
    ReadOnly               -- 1 (true)
)
VALUES (
    N'Kategorija objekta',
    N'Kategorija',
    1,
    1,
    3,   -- Computed
    NULL,
    1    -- ReadOnly
);

DECLARE @ComputedQuestionID INT = SCOPE_IDENTITY();
```

### 3. Kreiraj child pitanja (inputs)

```sql
-- Child 1: Spoljašnji zidovi
INSERT INTO Questions (
    QuestionText, QuestionLabel, QuestionOrder,
    QuestionFormatID, SpecificQuestionTypeID,
    ParentQuestionID,  -- LINKUJ NA PARENT!
    ReadOnly
)
VALUES (
    N'Materijal spoljašnjih zidova?',
    N'Zidovi',
    1,
    1,   -- Radio
    1,   -- AlwaysVisible
    @ComputedQuestionID,  -- Parent link!
    0
);
DECLARE @Child1_ID INT = SCOPE_IDENTITY();

-- Ponovi za ostale child-ove...
```

### 4. Kreiraj odgovore za computed pitanje

```sql
-- Ovo su mogući rezultati kalkulacije
INSERT INTO PredefinedAnswers (QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES 
    (@ComputedQuestionID, N'Masivna', N'1', 0, 1.0),
    (@ComputedQuestionID, N'Mešovita', N'2', 0, 2.0),
    (@ComputedQuestionID, N'Laka', N'3', 0, 3.0);
```

### 5. Kreiraj odgovore za child pitanja sa Code-ovima

```sql
-- Odgovori za Child 1 (Spoljašnji zidovi)
-- Code mora odgovarati vrednosti u matrici!
INSERT INTO PredefinedAnswers (QuestionID, Answer, Code, PreSelected, StatisticalWeight)
VALUES 
    (@Child1_ID, N'Beton', N'1', 0, 0),
    (@Child1_ID, N'Opeka', N'2', 0, 0),
    (@Child1_ID, N'Drvo', N'3', 0, 0);
```

### 6. Definiši reference mapping

```sql
-- Registruj matricu za questionnaire type
INSERT INTO QuestionnaireTypeReferenceTables (
    QuestionnaireTypeID, 
    TableName
)
VALUES (@QuestionnaireTypeID, N'BuildingCategoryMatrix');

DECLARE @RefTableID INT = SCOPE_IDENTITY();

-- Mapiraj child pitanja na kolone matrice
INSERT INTO QuestionReferenceColumns (
    QuestionID,
    QuestionnaireTypeReferenceTableID,
    ReferenceColumnName
)
VALUES 
    (@Child1_ID, @RefTableID, N'ExternalWallMaterialID'),
    (@Child2_ID, @RefTableID, N'ConstructionMaterialID'),
    (@Child3_ID, @RefTableID, N'RoofStructureMaterialID'),
    (@Child4_ID, @RefTableID, N'RoofCoveringMaterialID');
```

### 7. Proveri/kreiraj matricu

```sql
-- BuildingCategoryMatrix mora imati strukturu:
-- | ExternalWallMaterialID | ConstructionMaterialID | ... | ConstructionTypeID |

-- Primer unosa:
INSERT INTO BuildingCategoryMatrix (
    ExternalWallMaterialID,
    ConstructionMaterialID,
    RoofStructureMaterialID,
    RoofCoveringMaterialID,
    ConstructionTypeID  -- Rezultat!
)
VALUES 
    (1, 1, 1, 1, 1),  -- Sve masivno → Kategorija 1
    (1, 1, 1, 2, 2),  -- Mix → Kategorija 2
    (3, 3, 3, 3, 3);  -- Sve lako → Kategorija 3
```

### 8. Definiši rule u JSON-u

```json
{
  "rules": [
    {
      "kind": "buildingCategory",
      "questionId": [ComputedQuestionID],
      "inputQuestionIds": [Child1_ID, Child2_ID, Child3_ID, Child4_ID],
      "matrixName": "BuildingCategoryMatrix",
      "inputColumns": [
        "ExternalWallMaterialID",
        "ConstructionMaterialID",
        "RoofStructureMaterialID",
        "RoofCoveringMaterialID"
      ],
      "resultColumn": "ConstructionTypeID"
    }
  ]
}
```

### 9. Verifikacija

```sql
-- Proveri parent-child vezu
SELECT 
    p.QuestionID AS ParentID,
    p.QuestionText AS Parent,
    c.QuestionID AS ChildID,
    c.QuestionText AS Child
FROM Questions p
JOIN Questions c ON c.ParentQuestionID = p.QuestionID
WHERE p.QuestionID = @ComputedQuestionID;

-- Proveri reference mapping
SELECT 
    q.QuestionText,
    qrc.ReferenceColumnName,
    qtrt.TableName
FROM QuestionReferenceColumns qrc
JOIN Questions q ON q.QuestionID = qrc.QuestionID
JOIN QuestionnaireTypeReferenceTables qtrt 
    ON qtrt.QuestionnaireTypeReferenceTableID = qrc.QuestionnaireTypeReferenceTableID
WHERE q.ParentQuestionID = @ComputedQuestionID;
```

## Testovi

```javascript
// Test: Computed question ima Children
assert(computedQuestion.Children.length === 4);

// Test: Computed question je ReadOnly
assert(computedQuestion.ReadOnly === true);

// Test: Children imaju ParentQuestionID
computedQuestion.Children.forEach(child => {
  assert(child.ParentQuestionID === computedQuestion.QuestionID);
});

// Test: Rule evaluation
// Kad izaberem sve "1" kodove, rezultat treba da bude "1"
```
