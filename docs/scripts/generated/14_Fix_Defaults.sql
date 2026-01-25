USE [WIWA_DB_NEW];
GO

-- Fix: Ensure no answer is pre-selected by default.
-- Update PreSelected = 0 for all answers belonging to questions of Type 2 (Skraćeni upitnik).

UPDATE pa
SET pa.PreSelected = 0
FROM PredefinedAnswers pa
JOIN Questions q ON pa.QuestionID = q.QuestionID
-- Link via Questionnaires table (Mapping)
JOIN Questionnaires qn ON qn.QuestionID = q.QuestionID
WHERE qn.QuestionnaireTypeID = 2; -- Skraćeni upitnik

-- Or safer: join Questions directly if QuestionnaireID allows
-- My Questions (100-110) are linked to QuestionnaireID=2?
-- Script 11 insert: INSERT INTO Questionnaires (..., QuestionnaireTypeID=2).
-- Then INSERT INTO Questions (..., QuestionnaireID=@QnaireID).
-- So yes.

GO
