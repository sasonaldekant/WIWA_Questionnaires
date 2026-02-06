
/*
    debug_full_recordset_veliki.sql
    -------------------------------
    Exports the complete dataset for "Veliki Upitnik" (Type 3) with all GUI-relevant fields.
    
    Columns:
    - ID, Label, Text
    - Format, SpecificType
    - Hierarchy Info:
        - ParentID (Direct Parent)
        - TriggerAnswerID (If SubQuestion)
        - TriggerQuestionID (Parent of the trigger answer)
    - Metadata: Order, ReadOnly
*/
USE [WIWA_DB_NEW];
GO
SET NOCOUNT ON;

-- 1. Get all questions for Type 3 (Recursive)
--    We need to track *how* we got to each question (Direct or via Answer)
--    Note: CTE is just for filtering, the main SELECT will join back to get details.

;WITH QTree AS (
    -- ROOTS (Linked directly to QuestionnaireType)
    SELECT 
        Q.QuestionID,
        Q.QuestionLabel,
        CAST('ROOT' AS VARCHAR(20)) AS RelationshipType,
        NULL AS ParentID,
        NULL AS TriggerAnswerID,
        NULL AS TriggerQuestionID,
        Q.QuestionOrder
    FROM Questions Q
    JOIN Questionnaires QN ON Q.QuestionID = QN.QuestionID
    WHERE QN.QuestionnaireTypeID = 3

    UNION ALL

    -- DIRECT CHILDREN (ParentQuestionID)
    SELECT 
        Child.QuestionID,
        Child.QuestionLabel,
        CAST('DIRECT_CHILD' AS VARCHAR(20)),
        Parent.QuestionID,
        NULL,
        NULL,
        Child.QuestionOrder
    FROM Questions Child
    JOIN QTree Parent ON Child.ParentQuestionID = Parent.QuestionID

    UNION ALL

    -- SUB-QUESTIONS (via PredefinedAnswers)
    SELECT 
        SubQ.QuestionID,
        SubQ.QuestionLabel,
        CAST('SUB_QUESTION' AS VARCHAR(20)),
        NULL, -- ParentQuestionID IS Usually NULL for sub-questions in this model, but conceptually Parent is the TriggerQuestion
        PA.PredefinedAnswerID,
        PA.QuestionID AS TriggerQuestionID,
        SubQ.QuestionOrder
    FROM Questions SubQ
    JOIN PredefinedAnswerSubQuestions PASQ ON PASQ.SubQuestionID = SubQ.QuestionID
    JOIN PredefinedAnswers PA ON PASQ.PredefinedAnswerID = PA.PredefinedAnswerID
    JOIN QTree GrandParent ON PA.QuestionID = GrandParent.QuestionID
)
SELECT 
    Qt.QuestionID,
    Qt.QuestionLabel,
    LEFT(Q.QuestionText, 50) AS QuestionText,
    Q.QuestionFormatID AS [FmtID],
    QF.Name AS [FormatName],
    Q.SpecificQuestionTypeID AS [TypeID],
    SQT.Name AS [TypeName],
    Qt.RelationshipType,
    Qt.ParentID AS [DirectParentID],
    Qt.TriggerQuestionID AS [BranchParentID],
    Qt.TriggerAnswerID,
    LEFT(PA.Answer, 30) AS [TriggerAnswerText],
    Qt.QuestionOrder
FROM QTree Qt
JOIN Questions Q ON Qt.QuestionID = Q.QuestionID
LEFT JOIN QuestionFormats QF ON Q.QuestionFormatID = QF.QuestionFormatID
LEFT JOIN SpecificQuestionTypes SQT ON Q.SpecificQuestionTypeID = SQT.SpecificQuestionTypeID
LEFT JOIN PredefinedAnswers PA ON Qt.TriggerAnswerID = PA.PredefinedAnswerID
ORDER BY Qt.QuestionID;
