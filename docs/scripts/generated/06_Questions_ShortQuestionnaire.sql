/*
===============================================================
  FAZA 6: Skraćeni Upitnik (SHORT_QUEST)
  Opis: Unos pitanja za skraćeni upitnik i reuse BMI pitanja
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

SET IDENTITY_INSERT Questions ON;

DECLARE @ShortQuestID INT = (SELECT QuestionnaireTypeID FROM QuestionnaireTypes WHERE Code = 'SHORT_QUEST');

-- Formats & Types
DECLARE @Fmt_String INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'String');
DECLARE @Fmt_Boolean INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Boolean');
DECLARE @Fmt_Autocomplete INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Autocomplete');

DECLARE @Type_AlwaysVisible INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible');
DECLARE @Type_Conditionally INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'ConditionallyVisible');

-- ============================================
-- 1. Reuse BMI Pitanja (100, 101, 102)
-- ============================================
-- Povezujemo postojeća BMI pitanja i sa Skraćenim upitnikom

IF NOT EXISTS (SELECT 1 FROM QuestionQuestionnaireTypes WHERE QuestionID = 100 AND QuestionnaireTypeID = @ShortQuestID)
BEGIN
    INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID) VALUES (100, @ShortQuestID);
END

IF NOT EXISTS (SELECT 1 FROM QuestionQuestionnaireTypes WHERE QuestionID = 101 AND QuestionnaireTypeID = @ShortQuestID)
BEGIN
    INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID) VALUES (101, @ShortQuestID);
END

IF NOT EXISTS (SELECT 1 FROM QuestionQuestionnaireTypes WHERE QuestionID = 102 AND QuestionnaireTypeID = @ShortQuestID)
BEGIN
    INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID) VALUES (102, @ShortQuestID);
END

-- ============================================
-- 2. Specifična pitanja za Skraćeni upitnik (200+)
-- ============================================

-- Pitanje 200: Agregovana medicinska pitanja
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 200)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (200, N'Da li ste ikada bolovali ili sada bolujete te da li vam je postavljena sumnja i da li ste ispitivani za postojanje sledećih bolesti: malignih tumora, visokog pritiska, srčanih mana, dijabetesa...?', 1,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'1');
END

-- Pitanje 201: Detalji (Sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 201)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (201, N'Navedite koje oboljenje', 1,
        @Fmt_String, @Type_Conditionally, 200, 0, N'1.1');
END

-- Pitanje 210: Ispitivanje/Praćenje
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 210)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (210, N'Da li se trenutno nalazite na ispitivanju ili praćenju nekog zdravstvenog stanja?', 2,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'2');
END

-- Pitanje 220: Invaliditet
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 220)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (220, N'Da li Vam je utvrđena trajna nesposobnost za rad ili invaliditet?', 3,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'3');
END

-- Pitanje 230: Sport (Slično kao 150 ali boolean + sub)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 230)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (230, N'Da li se bavite nekim sportom?', 4,
        @Fmt_Boolean, @Type_AlwaysVisible, 0, N'4');
END

-- Pitanje 231: Sport Details (Sub - Autocomplete)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 231)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID, ReadOnly, QuestionLabel)
    VALUES
    (231, N'Koji sport?', 1,
        @Fmt_Autocomplete, @Type_Conditionally, 230, 0, N'4.1');
END

SET IDENTITY_INSERT Questions OFF;

-- Povezivanje novih pitanja sa QuestionnaireType
DELETE FROM QuestionQuestionnaireTypes 
WHERE QuestionnaireTypeID = @ShortQuestID AND QuestionID BETWEEN 200 AND 299;

INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID)
SELECT QuestionID, @ShortQuestID
FROM Questions
WHERE QuestionID BETWEEN 200 AND 299;

-- Validacija
SELECT q.QuestionID, q.QuestionText, qt.Name 
FROM Questions q
JOIN QuestionQuestionnaireTypes qqt ON q.QuestionID = qqt.QuestionID
JOIN QuestionnaireTypes qt ON qqt.QuestionnaireTypeID = qt.QuestionnaireTypeID
WHERE qt.Code = 'SHORT_QUEST';

COMMIT;
