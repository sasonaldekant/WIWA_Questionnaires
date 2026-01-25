---
description: JSON format specifikacija za razmenu podataka
priority: high
applies_to: [ba_agent, dba_agent, fs_agent]
version: 1.0
---

# JSON Contract - Format Specifikacija

## 1. Struktura Dokumenta

```json
{
  "meta": { ... },
  "questionnaire": { ... },
  "dictionaries": { ... },
  "questionnaireTypeRules": [ ... ],
  "rules": [ ... ],
  "referenceMappings": [ ... ],
  "referenceTables": { ... },
  "questions": [ ... ]
}
```

## 2. Meta Sekcija

```json
{
  "meta": {
    "schemaVersion": "v3_MODEL_18_01_2026",
    "dbModel": "WIWA_DB_NEW_MODEL_18_01_2026.sql",
    "generatedAt": "2026-01-22T12:00:00Z",
    "questionnaireTypeId": 1
  }
}
```

| Polje | Tip | Opis |
|-------|-----|------|
| schemaVersion | string | Verzija JSON šeme |
| dbModel | string | Ime SQL model fajla |
| generatedAt | string (ISO 8601) | Timestamp generisanja |
| questionnaireTypeId | number | ID tipa upitnika |

## 3. Questionnaire Sekcija

```json
{
  "questionnaire": {
    "id": 1,
    "typeId": 1,
    "typeName": "Buildings",
    "typeCode": "BLD",
    "questionnaireCategoryId": 1
  }
}
```

## 4. Dictionaries Sekcija

```json
{
  "dictionaries": {
    "questionFormats": [
      {
        "QuestionFormatID": 1,
        "Name": "RadioButton",
        "UiControl": "radio"
      }
    ],
    "specificQuestionTypes": [
      {
        "SpecificQuestionTypeID": 1,
        "Name": "AlwaysVisible"
      }
    ]
  }
}
```

## 5. Questions Array

### 5.1 Root Question

```json
{
  "QuestionID": 1,
  "QuestionLabel": "Lokacija",
  "QuestionText": "Gde se nalazi objekat?",
  "QuestionOrder": 1,
  "QuestionFormatID": 1,
  "QuestionFormatName": "RadioButton",
  "UiControl": "radio",
  "SpecificQuestionTypeID": 1,
  "SpecificQuestionTypeName": "AlwaysVisible",
  "ReadOnly": false,
  "ParentQuestionID": null,
  "Children": [],
  "Answers": []
}
```

### 5.2 Answer Object

```json
{
  "PredefinedAnswerID": 101,
  "Answer": "Beton",
  "Code": "1",
  "PreSelected": false,
  "StatisticalWeight": 1.0,
  "SubQuestions": []
}
```

### 5.3 Nested SubQuestion

```json
{
  "QuestionID": 51,
  "QuestionText": "Dodatno pitanje...",
  "QuestionFormatID": 1,
  "SubQuestionFormat": "RadioButton",
  "SpecificQuestionTypeID": 2,
  "SpecificQuestionTypeName": "ConditionallyVisible",
  "ReadOnly": false,
  "ParentQuestionID": null,
  "Children": [],
  "SubAnswers": []
}
```

> [!NOTE]
> SubQuestions koriste `SubAnswers` umesto `Answers` za jasnu distinkciju.

## 6. Reference Mappings

```json
{
  "referenceMappings": [
    {
      "QuestionID": 11,
      "QuestionnaireTypeReferenceTableID": 1,
      "QuestionnaireTypeID": 1,
      "TableName": "BuildingCategoryMatrix",
      "ReferenceColumnName": "ExternalWallMaterialID"
    }
  ]
}
```

## 7. Reference Tables

```json
{
  "referenceTables": {
    "ConstructionTypes": [
      {
        "ConstructionTypeID": 1,
        "Name": "Massive",
        "Code": "M"
      }
    ],
    "BuildingCategoryMatrix": [
      {
        "ConstructionTypeID": 1,
        "ExternalWallMaterialID": 1,
        "ConstructionMaterialID": 1,
        "RoofCoveringMaterialID": 1,
        "ResultConstructionTypeID": 1
      }
    ]
  }
}
```

## 8. Rules Sekcija

```json
{
  "rules": [
    {
      "kind": "buildingCategory",
      "questionId": 10,
      "inputQuestionIds": [11, 12, 13, 14],
      "matrixName": "BuildingCategoryMatrix",
      "inputColumns": [
        "ExternalWallMaterialID",
        "ConstructionMaterialID",
        "RoofCoveringMaterialID",
        "RoofStructureMaterialID"
      ],
      "resultColumn": "ConstructionTypeID"
    }
  ]
}
```

## 9. QuestionnaireTypeRules

```json
{
  "questionnaireTypeRules": [
    {
      "QuestionnaireTypeRuleID": 1,
      "QuestionnaireTypeID": 1,
      "TotalStatisticalWeightFrom": 0,
      "TotalStatisticalWeightTo": 10,
      "FinalRate": 1.0,
      "ContractIssuingBlocker": false,
      "Suitable": true,
      "TariffID": 1
    }
  ]
}
```

## 10. Tipovi Podataka

| JSON Tip | SQL Tip | Primer |
|----------|---------|--------|
| number | INT, SMALLINT | `"QuestionID": 1` |
| string | NVARCHAR | `"Answer": "Beton"` |
| boolean | BIT | `"ReadOnly": false` |
| null | NULL | `"ParentQuestionID": null` |
| array | N/A | `"Answers": [...]` |
| object | N/A | Nested structures |

## 11. Validacija

Svaki JSON mora proći ove provere:

1. ✅ `meta.schemaVersion` postoji
2. ✅ `questionnaire.typeId` odgovara `meta.questionnaireTypeId`
3. ✅ Svi `QuestionFormatID` postoje u `dictionaries.questionFormats`
4. ✅ Svi `SpecificQuestionTypeID` postoje u `dictionaries.specificQuestionTypes`
5. ✅ `referenceMappings` tabele postoje u `referenceTables`
6. ✅ `rules.matrixName` postoji u `referenceTables`

---

*Verzija: 1.0 | Datum: 2026-01-22*
