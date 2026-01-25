
/*
    debug_hierarchy_full.sql
    ------------------------
    Lists ALL relationships in the system:
    1. Branching (Answer -> SubQuestion)
    2. Grouping (Parent -> Child)
*/
USE [WIWA_DB_NEW];
GO
SET NOCOUNT ON;

PRINT '=== BRANCHING HIERARCHY (PredefinedAnswerSubQuestions) ===';
SELECT 
    P.QuestionID AS [ParentID],
    P.QuestionLabel AS [ParentLbl],
    LEFT(P.QuestionText, 20) AS [ParentTxt],
    PA.Answer AS [TriggerAnswer],
    C.QuestionID AS [ChildID],
    C.QuestionLabel AS [ChildLbl],
    LEFT(C.QuestionText, 20) AS [ChildTxt]
FROM PredefinedAnswerSubQuestions PASQ
JOIN PredefinedAnswers PA ON PASQ.PredefinedAnswerID = PA.PredefinedAnswerID
JOIN Questions P ON PA.QuestionID = P.QuestionID
JOIN Questions C ON PASQ.SubQuestionID = C.QuestionID
ORDER BY P.QuestionOrder, P.QuestionID, PA.PredefinedAnswerID;

PRINT '';
PRINT '=== GROUPING HIERARCHY (ParentQuestionID) ===';
SELECT 
    P.QuestionID AS [ParentID],
    P.QuestionLabel AS [ParentLbl],
    LEFT(P.QuestionText, 20) AS [ParentTxt],
    C.QuestionID AS [ChildID],
    C.QuestionLabel AS [ChildLbl],
    LEFT(C.QuestionText, 20) AS [ChildTxt]
FROM Questions C
JOIN Questions P ON C.ParentQuestionID = P.QuestionID
ORDER BY P.QuestionOrder, P.QuestionID, C.QuestionOrder;
