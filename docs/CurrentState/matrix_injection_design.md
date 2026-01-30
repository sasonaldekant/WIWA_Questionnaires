# Matrix Data Injection Design

## Problem
The Questionnaire module relies on `BuildingCategoryMatrix` to determine `ConstructionTypeID` based on inputs (Materials). This table exists in the legacy database but is missing from the isolated `WIWA_Questionnaires_DB`, breaking conditional logic.

## Solution
Inject the matrix data via a JSON payload through the API. This allows the Frontend (or an external orchestrator) to provide the necessary reference data without requiring direct database dependencies.

## JSON Structure
We will use a generic structure that can represent any matrix table.

```json
{
  "matrixName": "BuildingCategoryMatrix",
  "definition": {
    "keyColumns": ["ExternalWallMaterialID", "ConstructionMaterialID", "RoofCoveringMaterialID"],
    "valueColumns": ["ConstructionTypeID"]
  },
  "data": [
    {
      "ExternalWallMaterialID": 1,
      "ConstructionMaterialID": 1,
      "RoofCoveringMaterialID": 1,
      "ConstructionTypeID": 100
    },
    {
      "ExternalWallMaterialID": 1,
      "ConstructionMaterialID": 2,
      "RoofCoveringMaterialID": 1,
      "ConstructionTypeID": 101
    }
  ]
}
```

## API Endpoint
**POST** `/api/Matrix/inject`

### Logic
1.  **Receive JSON**: Application receives the full matrix dataset.
2.  **Cache/Store**: Data is stored (In-Memory Cache or Redis) for quick lookup during rule evaluation.
3.  **Evaluate**: When `EvaluateRule` is called for `BuildingCategoryMatrix`, the service looks up the result in this injected dataset instead of querying the database.

## Example Usage (BuildingCategoryMatrix)
Based on legacy schema:
- **Inputs**: `ExternalWallMaterialID`, `ConstructionMaterialID`, `RoofCoveringMaterialID`
- **Output**: `ConstructionTypeID`
