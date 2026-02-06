
/*
    debug_hierarchy_full_filtered.sql
    ---------------------------------
    Lists relationships strictly for "Veliki Upitnik" (QuestionnaireTypeID = 3).
    Uses recursive CTE to identify all questions belonging to this specific questionnaire tree.
*/
USE [WIWA_DB_NEW];
GO
SET NOCOUNT ON;

-- 1. Identify all QuestionIDs in the Tree for Type 3
;WITH QTree AS (
    -- Roots
    SELECT 
        Q.QuestionID, 
        Q.QuestionLabel
    FROM Questions Q
    JOIN Questionnaires QN ON Q.QuestionID = QN.QuestionID
    WHERE QN.QuestionnaireTypeID = 3

    UNION ALL

    -- Children (Direct Parent)
    SELECT 
        Child.QuestionID, 
        Child.QuestionLabel
    FROM Questions Child
    JOIN QTree Parent ON Child.ParentQuestionID = Parent.QuestionID

    UNION ALL

    -- Children (Branching via Answers)
    SELECT 
        SubQ.QuestionID, 
        SubQ.QuestionLabel
    FROM Questions SubQ
    JOIN PredefinedAnswerSubQuestions PASQ ON PASQ.SubQuestionID = SubQ.QuestionID
    JOIN PredefinedAnswers PA ON PASQ.PredefinedAnswerID = PA.PredefinedAnswerID
    JOIN QTree Parent ON PA.QuestionID = Parent.QuestionID
)
SELECT DISTINCT QuestionID INTO #Type3Questions FROM QTree;

PRINT '=== (Type 3 Only) BRANCHING HIERARCHY ===';
SELECT 
    P.QuestionID AS [ParentID],
    P.QuestionLabel AS [ParentLbl],
    LEFT(P.QuestionText, 25) AS [ParentTxt],
    LEFT(PA.Answer, 25) AS [TriggerAnswer],
    C.QuestionID AS [ChildID],
    C.QuestionLabel AS [ChildLbl],
    LEFT(C.QuestionText, 25) AS [ChildTxt]
FROM PredefinedAnswerSubQuestions PASQ
JOIN PredefinedAnswers PA ON PASQ.PredefinedAnswerID = PA.PredefinedAnswerID
JOIN Questions P ON PA.QuestionID = P.QuestionID
JOIN Questions C ON PASQ.SubQuestionID = C.QuestionID
WHERE P.QuestionID IN (SELECT QuestionID FROM #Type3Questions)
ORDER BY P.QuestionOrder, P.QuestionID, PA.PredefinedAnswerID;

PRINT '';
PRINT '=== (Type 3 Only) DIRECT CHILDREN (Grouped) ===';
SELECT 
    P.QuestionID AS [ParentID],
    P.QuestionLabel AS [ParentLbl],
    LEFT(P.QuestionText, 25) AS [ParentTxt],
    C.QuestionID AS [ChildID],
    C.QuestionLabel AS [ChildLbl],
    LEFT(C.QuestionText, 25) AS [ChildTxt]
FROM Questions C
JOIN Questions P ON C.ParentQuestionID = P.QuestionID
WHERE P.QuestionID IN (SELECT QuestionID FROM #Type3Questions)
ORDER BY P.QuestionOrder, P.QuestionID, C.QuestionOrder;

DROP TABLE #Type3Questions;
