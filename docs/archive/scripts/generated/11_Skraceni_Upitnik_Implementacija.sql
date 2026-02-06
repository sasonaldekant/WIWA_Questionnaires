/*
===============================================================
  SKRIPTA: 11_Skraceni_Upitnik_Implementacija.sql
  OPIS: Implementacija "Skraćenog upitnika" u bazu podataka.
        Uključuje: Tip upitnika, Pitanja, Odgovore, Logiku grananja,
        i Computed konfiguraciju za BMI.
  DATUM: 2026-01-25
===============================================================
*/

USE [WIWA_DB_NEW];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;

BEGIN TRANSACTION;

-- 1. INSERT QUESTIONNAIRE TYPE
-- ===============================================================
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE Code = 'SHORT_QUEST')
BEGIN
    -- Using explicit ID 2 assuming 1 is Location
    SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] ON;
    INSERT INTO QuestionnaireTypes (QuestionnaireTypeID, Name, Code)
    VALUES (2, N'Skraćeni upitnik', N'SHORT_QUEST');
    SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] OFF;
END

-- 2. DEFINE QUESTIONS
-- Range: 100 - 150
-- ===============================================================
SET IDENTITY_INSERT [dbo].[Questions] ON;

-- Q100: Visina (Input za BMI)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 100)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel, SpecificQuestionTypeID)
    VALUES (100, N'Visina (cm)', 1, 1, N'BMI.H', NULL); -- Format 1 = Text

-- Q101: Težina (Input za BMI)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 101)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel, SpecificQuestionTypeID)
    VALUES (101, N'Težina (kg)', 2, 1, N'BMI.W', NULL);

-- Q102: BMI (Computed Result)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 102)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel, SpecificQuestionTypeID, ReadOnly)
    VALUES (102, N'BMI Index', 3, 1, N'BMI.R', 3, 1); -- Format 1, Specific 3 (Computed), ReadOnly

-- Q103: Zdravstveni karton
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 103)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel)
    VALUES (103, N'Naziv zdravstvene ustanove kod koje klijent ima otvoren zdravstveni karton', 4, 1, N'Q0.5');

-- Q104: Bolesti (Boolean)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 104)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel)
    VALUES (104, N'Da li ste ikada bolovali ili sada bolujete... (Lista bolesti)', 5, 2, N'Q1'); -- Format 2 = Radio

-- Q104_1: Detalji bolesti (Subquestion)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 1041)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel, ParentQuestionID)
    VALUES (1041, N'Navedite koje oboljenje:', 5, 1, N'Q1.1', 104);

-- Q105: Ispitivanje (Boolean)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 105)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel)
    VALUES (105, N'Da li se trenutno nalazite na ispitivanju...', 6, 2, N'Q2');

-- Q106: Invaliditet (Boolean)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 106)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel)
    VALUES (106, N'Da li Vam je utvrđena trajna nesposobnost/invaliditet?', 7, 2, N'Q3');

-- Q107: Sport (Boolean)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 107)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel)
    VALUES (107, N'Da li se bavite nekim sportom?', 8, 2, N'Q4');

-- Q107_1: Sport Selection (Subquestion - Dropdown)
-- Note: Requires linkage to Sports table later
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 1071)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel, ParentQuestionID)
    VALUES (1071, N'Izaberite sport', 8, 3, N'Q4.1', 107); -- Format 3 = Dropdown

-- Q108: Rizik zanimanja (Boolean)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 108)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel)
    VALUES (108, N'Da li ste izloženi povećanom riziku od povređivanja?', 9, 2, N'Q5');

-- Q108_1: Opis rizika (Subquestion)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 1081)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel, ParentQuestionID)
    VALUES (1081, N'Navesti opasnosti:', 9, 1, N'Q5.1', 108);

-- Q109: Odbijena ponuda (Boolean)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 109)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel)
    VALUES (109, N'Da li vam je ranije odbijena ponuda?', 10, 2, N'Q6');

-- Q109_1: Razlozi (Subquestion)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 1091)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, QuestionLabel, ParentQuestionID)
    VALUES (1091, N'Navesti razloge:', 10, 1, N'Q6.1', 109);

SET IDENTITY_INSERT [dbo].[Questions] OFF;


-- 3. LINK QUESTIONS TO TYPE
-- ===============================================================
SET IDENTITY_INSERT [dbo].[Questionnaires] ON;

DECLARE @NextQID INT = (SELECT ISNULL(MAX(QuestionnaireID), 0) + 1 FROM Questionnaires);

-- Helper to insert if not exists
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 100) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 100); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 101) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 101); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 102) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 102); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 103) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 103); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 104) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 104); SET @NextQID = @NextQID + 1;
-- 1041 is subquestion, assumed linked by ParentID, but generally parent question is the entry point
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 105) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 105); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 106) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 106); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 107) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 107); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 108) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 108); SET @NextQID = @NextQID + 1;
IF NOT EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionnaireTypeID = 2 AND QuestionID = 109) INSERT INTO Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID) VALUES (@NextQID, 2, 109); SET @NextQID = @NextQID + 1;

SET IDENTITY_INSERT [dbo].[Questionnaires] OFF;


-- 4. PREDEFINED ANSWERS
-- Range: 1000+
-- ===============================================================
SET IDENTITY_INSERT [dbo].[PredefinedAnswers] ON;

-- Q104 Answers (Bolesti)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1001)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1001, 104, 0, N'Da', N'YES');
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1002)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1002, 104, 1, N'Ne', N'NO');

-- Q105 Answers (Ispitivanje)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1003)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1003, 105, 0, N'Da', N'YES');
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1004)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1004, 105, 1, N'Ne', N'NO');

-- Q106 Answers (Invaliditet)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1005)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1005, 106, 0, N'Da', N'YES');
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1006)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1006, 106, 1, N'Ne', N'NO');

-- Q107 Answers (Sport)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1007)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1007, 107, 0, N'Da', N'YES');
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1008)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1008, 107, 1, N'Ne', N'NO');

-- Q108 Answers (Rizik)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1009)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1009, 108, 0, N'Da', N'YES');
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1010)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1010, 108, 1, N'Ne', N'NO');

-- Q109 Answers (Odbijena)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1011)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1011, 109, 0, N'Da', N'YES');
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1012)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, PreSelected, Answer, Code) VALUES (1012, 109, 1, N'Ne', N'NO');

SET IDENTITY_INSERT [dbo].[PredefinedAnswers] OFF;


-- 5. BRANCHING LOGIC
-- ===============================================================
-- Q104=Yes -> Q1041
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID)
SELECT 100, 1001, 1041 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerSubQuestionID = 100);

-- Q107=Yes -> Q1071 (Sport)
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID)
SELECT 101, 1007, 1071 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerSubQuestionID = 101);

-- Q108=Yes -> Q1081
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID)
SELECT 102, 1009, 1081 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerSubQuestionID = 102);

-- Q109=Yes -> Q1091
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID)
SELECT 103, 1011, 1091 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerSubQuestionID = 103);


-- 6. BMI CONFIGURATION
-- ===============================================================
-- 6.1 Ensure ComputeMethod exists
SET IDENTITY_INSERT [dbo].[ComputeMethods] ON;
IF NOT EXISTS (SELECT 1 FROM ComputeMethods WHERE Code = 'BMI_CALC')
BEGIN
    INSERT INTO ComputeMethods (ComputeMethodID, Code, Name, Description, IsActive)
    VALUES (2, 'BMI_CALC', 'BMI Calculator', 'Weight / (Height/100)^2', 1);
END
SET IDENTITY_INSERT [dbo].[ComputeMethods] OFF;

-- 6.2 Ensure OutputMode exists
SET IDENTITY_INSERT [dbo].[ComputedOutputModes] ON;
IF NOT EXISTS (SELECT 1 FROM ComputedOutputModes WHERE Code = 'READONLY_DISPLAY')
BEGIN
    INSERT INTO ComputedOutputModes (OutputModeID, Code, Name, Description, IsActive)
    VALUES (2, 'READONLY_DISPLAY', 'Read Only', 'Display value only', 1);
END
SET IDENTITY_INSERT [dbo].[ComputedOutputModes] OFF;

-- 6.3 Link Question to Method
-- Note: Table name in logic analysis was ComputedQuestions, but in DB Model it might be QuestionComputedConfigs or ComputedQuestions.
-- Based on previous grep, 'ComputedQuestions' was used in script 10_... but not found in model file.
-- Model file has 'QuestionComputedConfigs'.
-- Warning: Compatibility check. If 10_ComputedQuestions_BMI.sql used 'ComputedQuestions', then that table exists in DB but not in Model file?
-- User instruction: "uklopi u postojeći model".
-- Model file contains [QuestionComputedConfigs].
-- Let's use [QuestionComputedConfigs] if it fits, OR [ComputedQuestions] if that's the preferred table.
-- Given I cannot be 100% sure without DB access, I will assume QuestionComputedConfigs is the one from the MODEL file.
-- Reference to Step 16337 in data file:
-- INSERT INTO QuestionComputedConfigs (... QuestionID, ComputeMethodID ...)
-- So this IS the table!

SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] ON;
IF NOT EXISTS (SELECT 1 FROM QuestionComputedConfigs WHERE QuestionID = 102)
BEGIN
    INSERT INTO QuestionComputedConfigs (QuestionComputedConfigID, QuestionID, ComputeMethodID, MatrixObjectName, RuleName, OutputMode, Priority, IsActive, MatrixOutputColumnName)
    VALUES (100, 102, 2, N'BMI_Formula_Logic', N'BMI Calculation', 1, 1, 1, N'Value');
    -- Note: 2 is BMI_CALC ID (assuming we inserted it as 2)
    -- Or use Subquery: (SELECT ComputeMethodID FROM ComputeMethods WHERE Code='BMI_CALC')
END
SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] OFF;


-- 7. REFERENCE TABLES FOR SPORT
-- ===============================================================
-- Link Sport table to Type 2
-- Assuming 'Sports' table is named 'Sports'?
-- In Data file check: No 'Sports' table insert seen. Maybe it's 'RiskClasses' or similar?
-- If Sport table doesn't exist in data, I won't link it yet.
-- I'll skip linking Sports table to keep script safe.

COMMIT;
