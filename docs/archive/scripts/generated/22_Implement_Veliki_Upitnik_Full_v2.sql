/*
    22_Implement_Veliki_Upitnik_Full_v2.sql
    ---------------------------------------
    Puna implementacija Velikog upitnika (Type 3) prema dogovoru:
    1. Redosled (QuestionOrder) se striktno poštuje.
    2. Medicinska pitanja (Q1) su u Checkbox grupi.
    3. BMI (Q204) je roditelj, a Visina i Težina su deca (AlwaysVisible).
    4. Navike (Alcohol, Tobacco, Drugs) su deca roditelja "Životne navike".
    5. ID opseg: 200+ (za razvoj).
*/

USE [WIWA_DB_NEW];
GO

SET NOCOUNT ON;

-- 1. Čišćenje prethodnih testnih podataka za Type 3 da bismo imali čisto stanje
DELETE FROM Questionnaires WHERE QuestionnaireTypeID = 3;
DELETE FROM PredefinedAnswerSubQuestions WHERE SubQuestionID BETWEEN 200 AND 299 OR PredefinedAnswerID IN (SELECT PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID BETWEEN 200 AND 299);
DELETE FROM PredefinedAnswers WHERE QuestionID BETWEEN 200 AND 299;
DELETE FROM QuestionComputedConfigs WHERE QuestionID BETWEEN 200 AND 299;
DELETE FROM Questions WHERE QuestionID BETWEEN 200 AND 299;
DELETE FROM Questions WHERE QuestionID BETWEEN 2000 AND 2100; -- Neki subquestions su možda u drugom opsegu
GO

-- 2. Formati i Tipovi (konstante)
DECLARE @FmtText INT = 1;
DECLARE @FmtRadio INT = 2;
DECLARE @FmtSelect INT = 3;
DECLARE @FmtCheck INT = 4;
DECLARE @FmtAutocomplete INT = 5;

DECLARE @TypeAlways INT = 1;
DECLARE @TypeCond INT = 2;
DECLARE @TypeComp INT = 3;

-- 3. Unos Pitanja (IDENTITY_INSERT ON)
SET IDENTITY_INSERT Questions ON;

-- Q1: Medicinska pitanja (Root)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (201, N'Da li bolujete od sledećih bolesti (označite sve)?', 'Q1', 1, @FmtCheck, @TypeAlways);

-- Q1 Sub Questions (Conditional - No ParentID)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES 
(211, N'Detalji o povišenom krvnom pritisku (terapija, vrednosti):', 'BP_DET', 1, @FmtText, @TypeCond),
(212, N'Detalji o bolesti srca (dijagnoza, lečenje):', 'HEART_DET', 2, @FmtText, @TypeCond),
(213, N'Detalji o dijabetesu (tip, terapija):', 'DIAB_DET', 3, @FmtText, @TypeCond);

-- Q4: BMI Blok (Parent/Root)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES (204, N'BMI Index (sračunata vrednost)', 'BMI.R', 4, @FmtText, @TypeComp, 1);

-- Q4 Children: Visina i Težina (AlwaysVisible, Parent = 204)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
VALUES 
(241, N'Unesite vašu visinu (cm)', 'BMI.H', 1, @FmtText, @TypeAlways, 204),
(242, N'Unesite vašu težinu (kg)', 'BMI.W', 2, @FmtText, @TypeAlways, 204);

-- Q5: Sport (Root)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (205, N'Sport koji praktikujete', 'SPORT', 5, @FmtAutocomplete, @TypeAlways);

-- Q6: Životne navike (Parent/Root)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (206, N'Životne navike (alkohol, duvan, opijati)', 'HABITS', 6, @FmtText, @TypeAlways);

-- Q6 Children (AlwaysVisible, Parent = 206)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
VALUES 
(261, N'Dnevna konzumacija alkohola', 'ALCOHOL', 1, @FmtRadio, @TypeAlways, 206),
(262, N'Konzumacija duvana (cigarete dnevno)', 'TOBACCO', 2, @FmtRadio, @TypeAlways, 206),
(263, N'Da li konzumirate droge ili narkotike?', 'DRUGS', 3, @FmtRadio, @TypeAlways, 206);

SET IDENTITY_INSERT Questions OFF;
GO

-- 4. Unos Predefinisanih Odgovora
SET IDENTITY_INSERT PredefinedAnswers ON;

-- Odgovori za Q1 (Checkbox)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected)
VALUES 
(2011, 201, N'Povišen krvni pritisak', 'BP_HIGH', 0),
(2012, 201, N'Bolesti srca i krvnih sudova', 'HEART', 0),
(2013, 201, N'Šećerna bolest (Dijabetes)', 'DIABETES', 0),
(2014, 201, N'Ništa od navedenog', 'NONE', 0);

-- Odgovori za Alkohol (Q261)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected)
VALUES 
(2611, 261, N'Ne konzumiram', 'LEVEL_0', 0),
(2612, 261, N'Umereno (do 2 pića dnevno)', 'LEVEL_1', 0),
(2613, 261, N'Povećano (više od 2 pića)', 'LEVEL_2', 0);

-- Odgovori za Duvan (Q262)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected)
VALUES 
(2621, 262, N'Nepušač', 'SMOKE_0', 0),
(2622, 262, N'Do 20 cigareta', 'SMOKE_1', 0),
(2623, 262, N'Preko 20 cigareta', 'SMOKE_2', 0);

-- Odgovori za Drogu (Q263)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected)
VALUES 
(2631, 263, N'Ne', 'NO', 0),
(2632, 263, N'Da', 'YES', 0);

SET IDENTITY_INSERT PredefinedAnswers OFF;
GO

-- 5. Povezivanje Podpitanja (Conditional Branching)
-- Svaki odgovor u Checkbox-u otvara svoje pitanje
DECLARE @NextSubID INT = ISNULL((SELECT MAX(PredefinedAnswerSubQuestionID) FROM PredefinedAnswerSubQuestions), 0) + 1;

INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID)
VALUES 
(@NextSubID, 2011, 211),
(@NextSubID + 1, 2012, 212),
(@NextSubID + 2, 2013, 213);
GO

-- 6. Povezivanje na Upitnik (Questionnaires)
-- Povezujemo samo ROOT pitanja. Children i Subquestions generator nalazi sam.
INSERT INTO Questionnaires (QuestionnaireTypeID, QuestionID)
VALUES 
(3, 201),
(3, 204),
(3, 205),
(3, 206);
GO

-- 7. Computed Logic za BMI
INSERT INTO QuestionComputedConfigs (QuestionID, ComputeMethodID, RuleName, MatrixObjectName, OutputMode, MatrixOutputColumnName, Priority, IsActive)
VALUES (204, 2, 'BMI Calculation', '', 1, '', 1, 1); -- 2 je ID za BMI_CALC
GO

-- 8. Reference Mapping za Sport
DECLARE @RefTableID INT;
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 3 AND TableName = 'Sports')
BEGIN
    INSERT INTO QuestionnaireTypeReferenceTables (QuestionnaireTypeID, TableName) VALUES (3, 'Sports');
END
SELECT @RefTableID = QuestionnaireTypeReferenceTableID FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 3 AND TableName = 'Sports';

INSERT INTO QuestionReferenceColumns (QuestionReferenceColumnID, QuestionID, QuestionnaireTypeReferenceTableID, ReferenceColumnName)
SELECT ISNULL((SELECT MAX(QuestionReferenceColumnID) FROM QuestionReferenceColumns), 0) + 1, 205, @RefTableID, 'SportName'
WHERE NOT EXISTS (SELECT 1 FROM QuestionReferenceColumns WHERE QuestionID = 205);
GO

-- Provera
SELECT q.QuestionID, q.QuestionLabel, q.QuestionText, q.QuestionOrder, qf.Name as Format, sqt.Name as SpecificType, q.ParentQuestionID
FROM Questions q
LEFT JOIN QuestionFormats qf ON q.QuestionFormatID = qf.QuestionFormatID
LEFT JOIN SpecificQuestionTypes sqt ON q.SpecificQuestionTypeID = sqt.SpecificQuestionTypeID
WHERE q.QuestionID BETWEEN 200 AND 299
ORDER BY q.QuestionOrder, q.QuestionID;
