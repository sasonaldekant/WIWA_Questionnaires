/*
===============================================================
  FAZA 8: Obrazac za Procenu Rizika (RISK_ASSESSMENT)
  Opis: Unos pitanja za AML Scoring
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

SET IDENTITY_INSERT Questions ON;

DECLARE @RiskQuestID INT = (SELECT QuestionnaireTypeID FROM QuestionnaireTypes WHERE Code = 'RISK_ASSESSMENT');

-- Formats
DECLARE @Fmt_Dropdown INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Dropdown');
DECLARE @Fmt_Computed INT = (SELECT QuestionFormatID FROM QuestionFormats WHERE Name = 'Computed');

DECLARE @Type_AlwaysVisible INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'AlwaysVisible');
DECLARE @Type_Computed INT = (SELECT SpecificQuestionTypeID FROM SpecificQuestionTypes WHERE Name = 'Computed');

-- ============================================
-- 1. Pitanja za bodovanje (500+)
-- ============================================

-- Pitanje 500: Geografski rizik
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 500)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (500, N'Zemlja državljanstva', 1,
        @Fmt_Dropdown, @Type_AlwaysVisible, 0, N'1');
END

-- Pitanje 501: Tip klijenta
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 501)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (501, N'Tip klijenta', 2,
        @Fmt_Dropdown, @Type_AlwaysVisible, 0, N'2');
END

-- Pitanje 502: Proizvod
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 502)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (502, N'Tip proizvoda/usluge', 3,
        @Fmt_Dropdown, @Type_AlwaysVisible, 0, N'3');
END

-- Pitanje 503: Način isplate
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 503)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (503, N'Način isplate premije', 4,
        @Fmt_Dropdown, @Type_AlwaysVisible, 0, N'4');
END

-- Pitanje 504: Distribucioni kanal
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 504)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (504, N'Kanal distribucije', 5,
        @Fmt_Dropdown, @Type_AlwaysVisible, 0, N'5');
END

-- Pitanje 510: Ukupno Bodova (Computed)
IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = 510)
BEGIN
    INSERT INTO Questions
    (QuestionID, QuestionText, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly, QuestionLabel)
    VALUES
    (510, N'Ukupan AML Skor', 10,
        @Fmt_Computed, @Type_Computed, 1, N'TOTAL');
END

SET IDENTITY_INSERT Questions OFF;

-- ============================================
-- 2. Predefined Answers za bodovanje
-- ============================================
SET IDENTITY_INSERT PredefinedAnswers ON;

-- Odgovori za 500 (Zemlja)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 5000)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, StatisticalWeight)
    VALUES (5000, 500, N'Srbija', N'RS', 0); -- Nizak

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 5001)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, StatisticalWeight)
    VALUES (5001, 500, N'Zemlje EU', N'EU', 2); -- Srednji/Nizak (primer)

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 5002)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, StatisticalWeight)
    VALUES (5002, 500, N'Visokorizične zemlje', N'HIGH_RISK', 10); -- Visok

-- Odgovori za 501 (Tip klijenta)
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 5010)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, StatisticalWeight)
    VALUES (5010, 501, N'Fizičko lice', N'INDIVIDUAL', 0);

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 5011)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code, StatisticalWeight)
    VALUES (5011, 501, N'Pravno lice - kompleksna struktura', N'LEGAL_COMPLEX', 5);

SET IDENTITY_INSERT PredefinedAnswers OFF;

-- Povezivanje
DELETE FROM QuestionQuestionnaireTypes 
WHERE QuestionnaireTypeID = @RiskQuestID AND QuestionID BETWEEN 500 AND 599;

INSERT INTO QuestionQuestionnaireTypes (QuestionID, QuestionnaireTypeID)
SELECT QuestionID, @RiskQuestID
FROM Questions
WHERE QuestionID BETWEEN 500 AND 599;

COMMIT;
