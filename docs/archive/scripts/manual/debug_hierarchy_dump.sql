
/*
    debug_hierarchy_dump.sql
    ------------------------
    Dumps the full hierarchy of "Veliki Upitnik" (QuestionnaireTypeID = 3).
    Shows: Parent Question -> Answer -> Sub-Question relationship.
*/

USE [WIWA_DB_NEW];
GO
SET NOCOUNT ON;

SELECT 
    ParentQ.QuestionID AS [ParentID],
    ParentQ.QuestionLabel AS [ParentLabel],
    LEFT(ParentQ.QuestionText, 30) AS [ParentText],
    PA.Answer AS [TriggerAnswer],
    SubQ.QuestionID AS [ChildID],
    SubQ.QuestionLabel AS [ChildLabel],
    SubQ.SpecificQuestionTypeID AS [ChildType],
    LEFT(SubQ.QuestionText, 30) AS [ChildText]
FROM Questions ParentQ
-- Join to Answers
LEFT JOIN PredefinedAnswers PA ON ParentQ.QuestionID = PA.QuestionID
-- Join to Link Table
LEFT JOIN PredefinedAnswerSubQuestions PASQ ON PA.PredefinedAnswerID = PASQ.PredefinedAnswerID
-- Join to Child Question
LEFT JOIN Questions SubQ ON PASQ.SubQuestionID = SubQ.QuestionID
WHERE ParentQ.QuestionID IN (SELECT QuestionID FROM Questionnaires WHERE QuestionnaireTypeID = 3)
   OR ParentQ.ParentQuestionID IN (SELECT QuestionID FROM Questionnaires WHERE QuestionnaireTypeID = 3) -- Include children linked via ParentID
ORDER BY ParentQ.QuestionOrder, ParentQ.QuestionID, PA.PredefinedAnswerID;

-- Also check for "Orphaned" questions that are supposed to be children but have no incoming links?
-- Or check root questions list specifically
PRINT '--- ROOT QUESTIONS (In Questionnaires Table) ---';
SELECT Q.QuestionID, Q.QuestionLabel, LEFT(Q.QuestionText, 50) as Text
FROM Questions Q
JOIN Questionnaires QN ON Q.QuestionID = QN.QuestionID
WHERE QN.QuestionnaireTypeID = 3
ORDER BY Q.QuestionOrder;
