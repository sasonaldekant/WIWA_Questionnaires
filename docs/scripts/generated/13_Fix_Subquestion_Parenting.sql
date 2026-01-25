USE [WIWA_DB_NEW];
GO

-- Fix: Conditional Subquestions should NOT have ParentQuestionID set.
-- If they have ParentID, the JSON Generator includes them in 'Children' (Always Visible) AND 'SubQuestions' (Conditional).
-- We want them ONLY in 'SubQuestions'.

UPDATE Questions
SET ParentQuestionID = NULL
WHERE QuestionID IN (
    SELECT DISTINCT SubQuestionID 
    FROM PredefinedAnswerSubQuestions
);

-- Note: Q100 and Q101 (BMI Inputs) are NOT in PredefinedAnswerSubQuestions, so they keep ParentID=102.
-- This is correct (they are Always Visible children of the BMI Section).

GO
