/*
===============================================================
  FAZA 7: Upitnik za Funkcionera (FUNCTIONARY_QUEST)
  Opis: Unos pitanja za AML/PEP identifikaciju
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

SET IDENTITY_INSERT Questions ON;

DECLARE @FuncQuestID INT = (SELECT QuestionnaireTypeID FROM QuestionnaireTypes WHERE Code = 'FUNCTIONARY_QUEST');

-- Formats & Types
DECLARE @Fmt_String INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'String');
DECLARE @Fmt_Boolean INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean');
DECLARE @Fmt_MultipleChoice INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Multiple Choice');

DECLARE @Type_AlwaysVisible INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible');
DECLARE @Type_Conditionally INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible');

-- ============================================
-- 1. PEP Pitanja
-- ============================================

-- Pitanje 400: PEP Main
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 400)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (400, N'Da li ste politički eksponirana osoba ili član porodice politički eksponirane osobe?', 1,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'1');
END

-- Pitanje 400a: Detalji (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 404)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (404, N'Navedite detalje o funkciji', 1,
        @Fmt_String, @Type_Conditionally, 400, 0, N'1.1');
END

-- Pitanje 401: Intl Org
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 401)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (401, N'Da li obavljate ili ste obavljali istaknutu javnu funkciju u međunarodnoj organizaciji?', 2,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'2');
END

-- Pitanje 401a: Detalji (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 405)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (405, N'Navedite detalje o funkciji', 1,
        @Fmt_String, @Type_Conditionally, 401, 0, N'2.1');
END

-- Pitanje 402: Public Org
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 402)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (402, N'Da li obavljate ili ste obavljali funkciju u državnim organima?', 3,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'3');
END

-- Pitanje 402a: Detalji (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 406)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (406, N'Navedite detalje o funkciji', 1,
        @Fmt_String, @Type_Conditionally, 402, 0, N'3.1');
END

-- ============================================
-- 2. Izvori Sredstava
-- ============================================

-- Pitanje 407: Izvori
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 407)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (407, N'Koje su glavni izvori Vaših prihoda/sredstava?', 5,
        @Fmt_MultipleChoice, @Type_AlwaysVisible, 0, N'5');
END

-- Pitanje 407a: Drugi izvori (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 408)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (408, N'Navedite druge izvore', 1,
        @Fmt_String, @Type_Conditionally, 407, 0, N'5.1');
END

SET IDENTITY_INSERT Questions OFF;

-- Povezivanje
DELETE FROM QuestionQuestionnaireTypes 
WHERE QuestionnaireTypeID = @FuncQuestID AND QuestionID BETWEEN 400 AND 499;

INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID)
SELECT QuestionID, @FuncQuestID
FROM Questions
WHERE QuestionID BETWEEN 400 AND 499;

-- Validacija
SELECT q.QuestionID, q.QuestionText, q.ParentQuestionID
FROM Questions q
JOIN QuestionQuestionnaireTypes qqt ON q.QuestionID = qqt.QuestionID
WHERE qqt.QuestionnaireTypeID = @FuncQuestID;

COMMIT;
