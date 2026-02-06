# Questionnaire Database Inventory

This document provides a comprehensive list of database tables related to the Questionnaire module, categorized by their usage in the solution. It includes technical details such as Entity names in C# and Primary Keys.

## Currently Used Tables
These tables are essential for the questionnaire solution, acting as core data structures, reference points, or configuration logic for computed questions.

### Core Questionnaire Tables
| Table Name | Primary Key | Entity Name (C#) | Description |
| :--- | :--- | :--- | :--- |
| `Questionnaires` | `QuestionnaireID` | `QuestionnaireEntity` | Main table for questionnaire definitions. |
| `QuestionnaireTypes` | `QuestionnaireTypeID` | `QuestionnaireType` | Types of questionnaires (e.g., Location, Large). |
| `Questions` | `QuestionID` | `Question` | Stores individual questions. |
| `SpecificQuestionTypes` | `SpecificQuestionTypeID` | `SpecificQuestionType` | Specific types for questions. |
| `QuestionFormats` | `QuestionFormatID` | `QuestionFormat` | Format definitions for questions. |
| `PredefinedAnswers` | `PredefinedAnswerID` | `PredefinedAnswer` | Standard answers for questions. |
| `PredefinedAnswerSubQuestions` | `PredefinedAnswerSubQuestionID` | `PredefinedAnswerSubQuestion` | Logic for sub-questions triggered by answers. |
| `QuestionComputedConfigs` | `QuestionComputedConfigID` | `QuestionComputedConfig` | Configuration for computed questions. |
| `QuestionnaireIdentificators` | `QuestionnaireIdentificatorID` | `QuestionnaireIdentificator` | Identifiers for questionnaires. |
| `QuestionnaireByQuestionnaireIdentificators` | `QuestionnaireByQuestionnaireIdentificatorID` | `QuestionnaireByQuestionnaireIdentificator` | Mapping between questionnaires and identifiers. |
| `QuestionnaireAnswers` | `QuestionnaireAnswerID` | `QuestionnaireAnswer` | Stores user answers. |
| `QuestionnaireIdentificatorTypes` | `QuestionnaireIdentificatorTypeID` | `QuestionnaireIdentificatorType` | Types of identifiers. |
| `QuestionnaireTypeRules` | `QuestionnaireTypeRuleID` | *Database Only* | Validation and display rules for questionnaire types. |

### Computed Logic, Indicators & Ranks
Tables used for calculation logic, scoring, and ranking within questionnaires.

| Table Name | Primary Key | Description |
| :--- | :--- | :--- |
| `ComputeMethods` | `ComputeMethodID` | Methods used for computing question values. |
| `Indicators` | `IndicatorID` | Indicators used in scoring or logic. |
| `Ranks` | `RankID` | Ranking definitions. |
| `RiskLevels` | `RiskLevelID` | Risk levels associated with ranks or indicators. |

### Reference & Mapping Tables
Tables used to reference external data or map questionnaires to other entities.

| Table Name | Primary Key | Description |
| :--- | :--- | :--- |
| `QuestionReferenceColumns` | `QuestionReferenceColumnID` | Maps questions to specific database columns for reporting/logic. |
| `QuestionnaireTypeReferenceTables` | `QuestionnaireTypeReferenceTableID` | Maps questionnaire types to reference tables. |
| `ProductQuestionaryTypes` | `ProductQuestionaryTypeID` | Maps questionnaires to products. |

> [!NOTE]
> Primary Keys were verified directly from the database schema `INFORMATION_SCHEMA.KEY_COLUMN_USAGE`.
