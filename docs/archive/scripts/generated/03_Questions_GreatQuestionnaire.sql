/*
===============================================================
  FAZA 3: Pitanja - Veliki Upitnik (GREAT_QUEST)
  Opis: Unos pitanja za veliki upitnik i povezivanje sa tipom
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

SET IDENTITY_INSERT Questions ON;

DECLARE @GreatQuestID INT = (SELECT QuestionnaireTypeID FROM QuestionnaireTypes WHERE Code = 'GREAT_QUEST');

-- Formats
DECLARE @Fmt_Integer INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Integer');
DECLARE @Fmt_Computed INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Computed'); -- ili BMI_Computed ako smo dodali
DECLARE @Fmt_Boolean INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean');
DECLARE @Fmt_MultipleChoice INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Multiple Choice');
DECLARE @Fmt_Autocomplete INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Autocomplete');
DECLARE @Fmt_Dropdown INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Dropdown');

-- Specific Types
DECLARE @Type_AlwaysVisible INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible');
DECLARE @Type_Conditionally INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible');
DECLARE @Type_Computed INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'Computed');

-- ============================================
-- Pitanje 0: BMI Kalkulacija (Visina i Težina)
-- ============================================

-- Pitanje 100: Visina
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 100)
BEGIN
    INSERT INTO Questions 
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (100, N'Unesite vašu visinu (cm)', 0, 
        @Fmt_Integer, @Type_Computed, 0, N'BMI_H');
END

-- Pitanje 101: Težina
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 101)
BEGIN
    INSERT INTO Questions 
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (101, N'Unesite vašu težinu (kg)', 0,
        @Fmt_Integer, @Type_Computed, 0, N'BMI_W');
END

-- Pitanje 102: BMI Index (Rezultat)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 102)
BEGIN
    INSERT INTO Questions 
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (102, N'BMI Index', 0,
        @Fmt_Computed, @Type_Computed, 1, N'BMI_RES');
END

-- ============================================
-- Pitanje 1: Bolesti srca i krvnih sudova
-- ============================================

-- Pitanje 110: Glavno pitanje
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 110)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (110, N'Da li ste ikada bolovali ili sada bolujete od bolesti srca i krvnih sudova?', 1,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'1');
END

-- Pitanje 111: Povišen pritisak (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 111)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (111, N'Povišen krvni pritisak', 1,
        @Fmt_MultipleChoice, @Type_Conditionally, 110, 0, N'1.1');
END

-- Pitanje 112: Bolesti srčanih zalistaka (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 112)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (112, N'Bolesti srčanih zalistaka', 2,
        @Fmt_MultipleChoice, @Type_Conditionally, 110, 0, N'1.2');
END

-- Pitanje 113: Koronarna bolest (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 113)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (113, N'Koronarna bolest', 3,
        @Fmt_MultipleChoice, @Type_Conditionally, 110, 0, N'1.3');
END

-- ============================================
-- Pitanje 5: Sport
-- ============================================
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 150)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (150, N'Sport koji praktikujete', 5,
        @Fmt_Autocomplete, @Type_AlwaysVisible, 0, N'5');
END

-- ============================================
-- Pitanje 6: Alkohol, Duvan, Droga
-- ============================================
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 160)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (160, N'Dnevna količina alkohola', 6,
        @Fmt_Dropdown, @Type_AlwaysVisible, 0, N'6a');
END

IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 161)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (161, N'Broj cigareta/gr. duvana dnevno', 6,
        @Fmt_Dropdown, @Type_AlwaysVisible, 0, N'6b');
END

IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 162)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (162, N'Da li konzumirate drogu/narkotike?', 6,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'6c');
END

SET IDENTITY_INSERT Questions OFF;

-- ============================================
-- Povezivanje sa QuestionnaireTypes
-- ============================================
-- Resetuj postojeće veze ako postoje za ova pitanja da izbegnemo duplikate
DELETE FROM QuestionQuestionnaireTypes 
WHERE QuestionnaireTypeID = @GreatQuestID AND QuestionID BETWEEN 100 AND 199;

INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID)
SELECT QuestionID, @GreatQuestID
FROM Questions
WHERE QuestionID BETWEEN 100 AND 199;

-- Validacija
SELECT q.QuestionID, q.QuestionText, qt.Name as Questionnaire 
FROM Questions q
JOIN QuestionQuestionnaireTypes qqt ON q.QuestionID = qqt.QuestionID
JOIN QuestionnaireTypes qt ON qqt.QuestionnaireTypeID = qt.QuestionnaireTypeID
WHERE qt.Code = 'GREAT_QUEST';

COMMIT;
