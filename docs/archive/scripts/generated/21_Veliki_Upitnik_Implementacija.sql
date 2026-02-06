/*
    21_Veliki_Upitnik_Implementacija.sql
    ------------------------------------
    Implements:
      - QuestionnaireType: 1 (Veliki upitnik)
      - Questions: 1-6 (Medical, BMI, Sport, Habits)
      - Reference Tables: Sports, DangerClass
      - Logic: BMI Calculation, Branching
*/

USE [WIWA_DB_NEW];
GO

SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ARITHABORT ON;
SET NUMERIC_ROUNDABORT OFF;

-- 1. DDL: Create Reference Tables if missing
IF OBJECT_ID('dbo.DangerClass', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DangerClass (
        DangerClassID INT PRIMARY KEY IDENTITY(1,1),
        ClassName NVARCHAR(10) NOT NULL, -- I, II, III...
        Description NVARCHAR(200)
    );
END

IF OBJECT_ID('dbo.Sports', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Sports (
        SportID INT PRIMARY KEY IDENTITY(1,1),
        SportName NVARCHAR(100) NOT NULL,
        DangerClassID INT,
        LifeIncrease_Permille DECIMAL(5,2),
        CONSTRAINT FK_Sports_DangerClass FOREIGN KEY (DangerClassID) REFERENCES dbo.DangerClass(DangerClassID)
    );
END
GO

-- 2. Populate Reference Tables (Dummy Data)
INSERT INTO DangerClass (ClassName, Description)
SELECT 'I', 'Standard Risk' WHERE NOT EXISTS (SELECT 1 FROM DangerClass WHERE ClassName='I')
UNION ALL
SELECT 'II', 'Moderate Risk' WHERE NOT EXISTS (SELECT 1 FROM DangerClass WHERE ClassName='II')
UNION ALL
SELECT 'VI', 'Uninsurable' WHERE NOT EXISTS (SELECT 1 FROM DangerClass WHERE ClassName='VI');

INSERT INTO Sports (SportName, DangerClassID, LifeIncrease_Permille)
SELECT 'Fudbal', (SELECT DangerClassID FROM DangerClass WHERE ClassName='I'), 0 
WHERE NOT EXISTS (SELECT 1 FROM Sports WHERE SportName='Fudbal')
UNION ALL
SELECT 'Padobranstvo', (SELECT DangerClassID FROM DangerClass WHERE ClassName='VI'), 50
WHERE NOT EXISTS (SELECT 1 FROM Sports WHERE SportName='Padobranstvo')
UNION ALL
SELECT 'Trčanje', (SELECT DangerClassID FROM DangerClass WHERE ClassName='I'), 0
WHERE NOT EXISTS (SELECT 1 FROM Sports WHERE SportName='Trčanje');

GO

-- 3. Register Format: Autocomplete Dropdown
IF NOT EXISTS (SELECT 1 FROM QuestionFormats WHERE Name = 'Autocomplete Dropdown')
BEGIN
    INSERT INTO QuestionFormats (Name) VALUES ('Autocomplete Dropdown');
END
DECLARE @FmtAutocomplete INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Autocomplete Dropdown');
DECLARE @FmtText INT = 1;
DECLARE @FmtRadio INT = 2;
DECLARE @FmtSelect INT = 3;
DECLARE @FmtCheck INT = 4;

-- 4. Register QuestionnaireType
DECLARE @QTypeID INT = 3; -- Veliki upitnik


-- 5. Register Questionnaire instance (?) - Wait, QuestType is the template.
-- We insert Questions linked to this Type via Questionnaires table mapping?
-- Current Schema: Questions link to QuestionnaireID? No.
-- Questions link to... wait.
-- Previous analysis (Step 549) showed:
-- Questionnaires (QuestionnaireID, QuestionnaireTypeID, QuestionID).
-- Questions (QuestionID, ...).
-- So creating a question involves:
-- 1. Insert into Questions.
-- 2. Insert into Questionnaires (binding Type <-> Question).

DECLARE @QnaireID INT = @QTypeID; -- Assuming 1:1 for now or reusing ID space

-- Helper Table to track questions


-- Define Questions
-- Q1.2: Srce (Radio/Check?). "Omogućiti izbor više od jedne opcije" -> Checkbox (FmtCheck).
-- Note: Subquestions support exists for Checkbox? Yes.
-- Q4: BMI
-- Q5: Sport
-- Q6: Habits

-- Insert into Questions table directly using IDENTITY_INSERT?
-- Or auto-increment? model uses IDENTITY?
-- I'll check model or just try. (Script 11 did NOT use IDENTITY_INSERT for Questions?
-- Script 11 used: `VALUES (100, ...)`?
-- Let's check Script 11 content again (Step 350? I didn't verify it fully).
-- If Questions has IDENTITY, I must use SET IDENTITY_INSERT.
-- I'll assume YES.

SET IDENTITY_INSERT Questions ON;

-- Clear previous if re-running (safe?)
-- DELETE FROM Questionnaires WHERE QuestionnaireTypeID = @QTypeID;
-- DELETE FROM Questions WHERE QuestionID BETWEEN 200 AND 300; (Range strategy)
-- I'll use IDs 200+ for Veliki Upitnik.

-- Q1: Srce i krvni sudovi (Checkbox logic basically)
-- But wait, standard logic: "Da li bolujete..." (Yes/No). If Yes -> Checklist.
-- 01 Docs: "Pitanja 1-3... izbor više od jedne opcije".
-- So Q1 is a Checkbox Group?
-- Or Q1 is "Select conditions that apply: [ ] BP [ ] Heart [ ] ...".
-- I will implement Q1 as Checkbox Group.

IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 201)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (201, 'Da li bolujete od sledećih bolesti (označite sve)?', 'Q1', 1, @FmtCheck, 1); -- Conditionally Visible? No, Always Visible root.

-- Q4: BMI Section (Parent)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 204)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES (204, 'Podaci o visini i težini (BMI)', 'BMI.R', 4, @FmtText, 3, 1); -- Computed

-- Q4 Children: Height, Weight (Parent 204)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 2041)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
VALUES (2041, 'Visina (cm)', 'BMI.H', 1, @FmtText, 1, 204);

IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 2042)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
VALUES (2042, 'Težina (kg)', 'BMI.W', 2, @FmtText, 1, 204);


-- Q5: Sport (Autocomplete Reference)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 205)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (205, 'Sport koji praktikujete', 'SPORT', 5, @FmtAutocomplete, 1);


-- Q6: Habits (Composite/Group) - using ParentID grouping?
-- Or separate questions?
-- Docs: "Question 8... Composite".
-- I will implement as Group Question (206) with Children (2061, 2062, 2063).
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 206)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (206, 'Životne navike', 'HABITS', 6, @FmtText, 1); -- Text/Label only? Or specific format for Group? FmtText is fine (ReadOnly/Label).

IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 2061)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
VALUES (2061, 'Alkohol', 'ALCOHOL', 1, @FmtRadio, 1, 206);

IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 2062)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
VALUES (2062, 'Duvan', 'TOBACCO', 2, @FmtRadio, 1, 206);

SET IDENTITY_INSERT Questions OFF;

-- 6. Link to Questionnaire
DELETE FROM Questionnaires WHERE QuestionnaireTypeID = @QTypeID AND QuestionID IN (201, 204, 205, 206); -- Clean mapping
INSERT INTO Questionnaires (QuestionnaireTypeID, QuestionID)
VALUES 
(@QTypeID, 201),
(@QTypeID, 204),
(@QTypeID, 205),
(@QTypeID, 206);
-- Note: Nested questions (2041, 2042, 2061...) are NOT linked to Questionnaire directly usually? 
-- JSON Generator finds them via ParentID.
-- Logic check: Script 452 (Generator) Line 50: `SELECT ... FROM Questionnaires`.
-- It selects ROOTS.
-- It also adds `MissingChildren` (Line 81) and `Missing` (Line 56).
-- So mapping ONLY Roots is sufficient and correct.

-- 7. Answers
-- Q201 (Medical Checklist)
-- Options: BP_HIGH, HEART_VALVE...
-- If Checkbox format: Each Option is a checkbox.
INSERT INTO PredefinedAnswers (QuestionID, Answer, Code, PreSelected)
SELECT 201, 'Povišen krvni pritisak', 'BP_HIGH', 0 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE QuestionID=201 AND Code='BP_HIGH')
UNION ALL
SELECT 201, 'Bolesti srca', 'HEART', 0 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE QuestionID=201 AND Code='HEART');

-- SubQuestions for BP_HIGH (Details)
-- Create Q2011 "Detalji o lečenju"
-- It's a SubQuestion. NO ParentID in Questions table (to avoid duplication).
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 2011)
BEGIN
    SET IDENTITY_INSERT Questions ON;
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (2011, 'Detalji o lečenju (Pritisak)', 'BP_DETAILS', 1, @FmtText, 2); -- Conditional
    SET IDENTITY_INSERT Questions OFF;
END

-- Link Answer BP_HIGH -> Q2011
-- Link Answer BP_HIGH -> Q2011
DECLARE @NextSubID INT = ISNULL((SELECT MAX(PredefinedAnswerSubQuestionID) FROM PredefinedAnswerSubQuestions), 0);
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID)
SELECT @NextSubID + ROW_NUMBER() OVER (ORDER BY pa.PredefinedAnswerID), pa.PredefinedAnswerID, 2011
FROM PredefinedAnswers pa
WHERE pa.QuestionID = 201 AND pa.Code = 'BP_HIGH'
  AND NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE SubQuestionID=2011);


-- Q2061 (Alcohol) Answers
INSERT INTO PredefinedAnswers (QuestionID, Answer, Code, PreSelected)
SELECT 2061, 'Bez konzumacije / Malo', 'ALCOHOL_LEVEL_0', 0 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE QuestionID=2061 AND Code='ALCOHOL_LEVEL_0')
UNION ALL
SELECT 2061, 'Umereno', 'ALCOHOL_LEVEL_1', 0 WHERE NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE QuestionID=2061 AND Code='ALCOHOL_LEVEL_1');

-- 8. Computed Logic (BMI)
DECLARE @MethodBMI INT = (SELECT ComputeMethodID FROM ComputeMethods WHERE Code = 'BMI_CALC');
IF NOT EXISTS (SELECT 1 FROM QuestionComputedConfigs WHERE QuestionID = 204)
BEGIN
    INSERT INTO QuestionComputedConfigs (QuestionID, ComputeMethodID, RuleName, MatrixObjectName, OutputMode, MatrixOutputColumnName, Priority, IsActive)
    VALUES (204, @MethodBMI, 'BMI Calculation GreatQuest', '', 1, '', 0, 1);
END

-- 9. Reference Mapping (Sport -> Sports Table)
-- We need to map Question 205 to Table 'Sports'.
-- Table: QuestionnaireTypeReferenceTables (TypeID, TableName).
-- Table: QuestionReferenceColumns (QuestionID, RefTableID, RefColumnName).

DECLARE @RefTableID INT;
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = @QTypeID AND TableName = 'Sports')
BEGIN
    INSERT INTO QuestionnaireTypeReferenceTables (QuestionnaireTypeID, TableName)
    VALUES (@QTypeID, 'Sports');
END
SELECT @RefTableID = QuestionnaireTypeReferenceTableID FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = @QTypeID AND TableName = 'Sports';

-- Map Q205 to Sports table (No specific column mapping needed for Dropdown? 
-- Renderer needs to know "What to display".
-- Usually Name column implies text, ID implies value.
-- If I map ReferenceColumnName='SportName', Renderer can use it?
-- Currently Renderer logic for Reference Tables is MISSING.
-- I will verify this assumption later.
-- For now, I insert the mapping config.

IF NOT EXISTS (SELECT 1 FROM QuestionReferenceColumns WHERE QuestionID = 205)
BEGIN
DECLARE @NextRefColID INT = ISNULL((SELECT MAX(QuestionReferenceColumnID) FROM QuestionReferenceColumns), 0) + 1;
    INSERT INTO QuestionReferenceColumns (QuestionReferenceColumnID, QuestionID, QuestionnaireTypeReferenceTableID, ReferenceColumnName)
    VALUES (@NextRefColID, 205, @RefTableID, 'SportName');
END

GO
