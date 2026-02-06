# Specifikacija: Correct Questionnaire Type 1 (Upitnik lokacije)

## 1. Data Model Changes

### Questions Table
Refactoring/Inserting questions to match the target hierarchy.

| QuestionID | QuestionText | Label | Format | SpecificType | ReadOnly | ParentQuestionID |
|---|---|---|---|---|---|---|
| 1 | Da li se na lokaciji skladište zalihe robe | 1 | Radio | AlwaysVisible | 0 | NULL |
| 2 | Da li se skladište zapaljive materije... | 1.1 | Radio | ConditionallyVisible | 0 | NULL |
| 3 | Da li se skladište voće, povrće... | 1.1.1 | Radio | ConditionallyVisible | 0 | NULL |
| 9 | Građevinska kategorija | 2 | Radio | Computed | 1 | NULL |
| 4 | Građevinska kategorija - Spoljašnji zidovi | 2.1 | Radio | AlwaysVisible | 0 | 9 |
| 5 | Građevinska kategorija - Krovni pokrivač | 2.2 | Radio | AlwaysVisible | 0 | 9 |
| 6 | Građevinska kategorija - Konstrukcija objekta | 2.3 | Radio | AlwaysVisible | 0 | 9 |
| 7 | Izaberite spratnost objekta | 2.4 | Radio | ConditionallyVisible | 0 | NULL |
| 8 | Klasa zaštitnih mera... | 3 | Radio | AlwaysVisible | 0 | NULL |

### Predefined Answers & Branching
| ParentQ | Answer | Code | Trigger SubQ |
|---|---|---|---|
| 1 | Da | DA | 2 |
| 1 | Ne | NE | - |
| 2 | Da | DA | - |
| 2 | Ne | NE | 3 |
| 3 | Da | DA | - |
| 3 | Ne | NE | - |
| 9 | Masivna | 8 | 7 |
| 9 | Polumasivna | 6 | - |
| 9 | Laka | 7 | - |
| 7 | Prizemne... | 4 | - |
| 7 | Zgrade... | 5 | - |
| 4 | Kamen... | 1 | - |
| 4 | Metalni... | 2 | - |
| 4 | Drvo... | 3 | - |
| 5 | Beton... | 1 | - |
| 5 | Drvo... | 2 | - |
| 6 | Armirano... | 1 | - |
| 6 | Čelična... | 2 | - |
| 6 | Drvena... | 3 | - |
| 8 | A... | 1 | - |
| 8 | B... | 2 | - |
| 8 | C... | 3 | - |

Note: Answer IDs will be set/discovered during insert.

### Reference Mappings
| QuestionID | TableName | ColumnName |
|---|---|---|
| 4 | ExternalWallMaterials | ExternalWallMaterialID |
| 5 | RoofCoveringMaterials | RoofCoveringMaterialID |
| 6 | ConstructionMaterials | ConstructionMaterialID |
| 7 | ConstructionTypes | ConstructionTypeID |
| 8 | ProtectionClasses | ProtectionClassID |
| 9 | ConstructionTypes | ConstructionTypeID |

## 2. Očekivane Vrednosti (Verification Source)
- `temp_generate_json.sql` output should contain matching structure.
- Key check: Q9 has `ParentQuestionID` set for Q4, Q5, Q6.
- Key check: `PredefinedAnswers` for Q1(DA) has `SubQuestions` containing Q2.
