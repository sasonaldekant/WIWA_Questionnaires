
/*
    debug_flat_audit_veliki.sql
    ---------------------------
    Exports a flat recordset for "Veliki Upitnik" (Type 3) with requested columns.
    Sorted by QuestionID and PredefinedAnswerID to maintain defined order.
*/
USE [WIWA_DB_NEW];
GO
SET NOCOUNT ON;

-- 1. Helper to identify Type 3 universe (Recursive)
WITH Type3Questions AS (
    -- Roots
    SELECT Q.QuestionID
    FROM Questions Q
    JOIN Questionnaires QN ON Q.QuestionID = QN.QuestionID
    WHERE QN.QuestionnaireTypeID = 3

    UNION ALL

    -- Direct Children
    SELECT Child.QuestionID
    FROM Questions Child
    JOIN Type3Questions Parent ON Child.ParentQuestionID = Parent.QuestionID

    UNION ALL

    -- SubQuestions (Branching)
    SELECT SQ.QuestionID
    FROM Questions SQ
    JOIN PredefinedAnswerSubQuestions PASQ ON PASQ.SubQuestionID = SQ.QuestionID
    JOIN PredefinedAnswers PA ON PASQ.PredefinedAnswerID = PA.PredefinedAnswerID
    JOIN Type3Questions P ON PA.QuestionID = P.QuestionID
)
SELECT DISTINCT QuestionID INTO #T3Scope FROM Type3Questions;

-- 2. Main Query
SELECT 
    Q.QuestionID, 
    LEFT(Q.QuestionText, 50) AS QuestionText, 
    Q.QuestionOrder, 
    QF.Name AS QuestionFormatName, 
    SQT.Name AS SpecificQuestionType,
    Q.ParentQuestionID AS ParentQuestion, 
    PA.PredefinedAnswerID, 
    LEFT(PA.Answer, 50) AS Answer, 
    PASQ.PredefinedAnswerSubQuestionID, 
    PASQ.SubQuestionID, 
    LEFT(SubQ.QuestionText, 50) AS SubquestionText
FROM Questions Q
JOIN #T3Scope Scope ON Q.QuestionID = Scope.QuestionID
LEFT JOIN QuestionFormats QF ON Q.QuestionFormatID = QF.QuestionFormatID
LEFT JOIN SpecificQuestionTypes SQT ON Q.SpecificQuestionTypeID = SQT.SpecificQuestionTypeID
LEFT JOIN PredefinedAnswers PA ON Q.QuestionID = PA.QuestionID
LEFT JOIN PredefinedAnswerSubQuestions PASQ ON PA.PredefinedAnswerID = PASQ.PredefinedAnswerID
LEFT JOIN Questions SubQ ON PASQ.SubQuestionID = SubQ.QuestionID
ORDER BY Q.QuestionID, PA.PredefinedAnswerID;

DROP TABLE #T3Scope;
