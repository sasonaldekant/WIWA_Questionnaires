/*
===============================================================
  FAZA 4: PredefinedAnswers - Veliki Upitnik
  Opis: Unos predefinisanih odgovora (Da/Ne, Dropdown liste)
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

SET IDENTITY_INSERT PredefinedAnswers ON;

-- ============================================
-- Odgovori za Pitanje 110: Bolesti srca - Boolean
-- ============================================
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1100)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1100, 110, N'Da', N'YES', 0, NULL);
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1101)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1101, 110, N'Ne', N'NO', 1, NULL); -- Default NO
END

-- ============================================
-- Odgovori za Pitanje 160: Alkohol - Dropdown
-- ============================================
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1600)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1600, 160, N'do 1 lit. piva ILI do 0.5 lit. vina ILI do 0.1 lit. žestokog', N'ALCOHOL_LEVEL_0', 1, 0);
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1601)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1601, 160, N'do 1.5 lit. piva ILI do 0.75 lit. vina ILI do 0.15 lit. žestokog', N'ALCOHOL_LEVEL_1', 0, 5); -- +5 godina
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1602)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1602, 160, N'do 2 lit. piva ILI do 1 lit. vina ILI do 0.2 lit. žestokog', N'ALCOHOL_LEVEL_2', 0, 10); -- +10 godina
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1603)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1603, 160, N'preko 2 lit. piva ILI preko 1 lit. vina ILI preko 0.2 lit. žestokog', N'ALCOHOL_LEVEL_3_REJECT', 0, NULL); -- Odbijanje
END

-- ============================================
-- Odgovori za Pitanje 161: Duvan - Dropdown
-- ============================================
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1610)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1610, 161, N'manje od 20 cigareta ILI manje od 20 gr. duvana', N'TOBACCO_LEVEL_0', 1, 0);
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1611)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1611, 161, N'do 30 cigareta ILI do 30 gr. duvana', N'TOBACCO_LEVEL_1', 0, 5);
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1612)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1612, 161, N'do 40 cigareta ILI do 40 gr. duvana', N'TOBACCO_LEVEL_2', 0, 10);
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1613)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1613, 161, N'preko 40 cigareta ILI preko 40 gr. duvana', N'TOBACCO_LEVEL_3_REJECT', 0, NULL);
END

-- ============================================
-- Odgovori za Pitanje 162: Droge - Boolean
-- ============================================
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1620)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1620, 162, N'Da', N'DRUGS_YES_REJECT', 0, NULL); -- Odbijanje
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswers WHERE PredefinedAnswerID = 1621)
BEGIN
    INSERT INTO PredefinedAnswers
    (PredefinedAnswerID, QuestionID, Answer, Code, PreSelected, StatisticalWeight)
    VALUES
    (1621, 162, N'Ne', N'DRUGS_NO', 1, NULL);
END

SET IDENTITY_INSERT PredefinedAnswers OFF;

-- Validacija
SELECT pa.PredefinedAnswerID, q.QuestionText, pa.Answer, pa.Code, pa.StatisticalWeight
FROM PredefinedAnswers pa
JOIN Questions q ON pa.QuestionID = q.QuestionID
WHERE q.QuestionID >= 110;

COMMIT;
