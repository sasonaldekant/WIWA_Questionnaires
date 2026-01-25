USE [WIWA_DB_NEW];
GO

-- Fix parenting for BMI inputs
-- Q100 (Visina) and Q101 (Težina) should be children of Q102 (BMI Result)
-- This allows the generic Computed Logic to identify inputs.

UPDATE Questions
SET ParentQuestionID = 102
WHERE QuestionID IN (100, 101);

UPDATE Questions
SET QuestionOrder = 1
WHERE QuestionID = 100;

UPDATE Questions
SET QuestionOrder = 2
WHERE QuestionID = 101;

GO
