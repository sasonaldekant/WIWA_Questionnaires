DECLARE @TypeId INT = 5;

-- 1. Count Questions via Tree
;WITH Tree AS (
    SELECT QuestionID FROM Questionnaires WHERE QuestionnaireTypeID = @TypeId
    UNION ALL
    SELECT Q.QuestionID FROM Tree T JOIN Questions Q ON Q.ParentQuestionID = T.QuestionID
    UNION ALL
    SELECT PASQ.SubQuestionID FROM Tree T JOIN PredefinedAnswers PA ON T.QuestionID = PA.QuestionID JOIN PredefinedAnswerSubQuestions PASQ ON PA.PredefinedAnswerID = PASQ.PredefinedAnswerID
)
SELECT 'Questions in Tree' as Label, COUNT(*) as Count, (SELECT COUNT(*) FROM FlowLayouts WHERE QuestionnaireTypeID = @TypeId AND ElementType = 'Question') as LayoutCount FROM Tree;

-- 2. Check Roots
SELECT 'Root Questions' as Label, COUNT(*) as Count FROM Questionnaires WHERE QuestionnaireTypeID = @TypeId;

-- 3. Check FlowLayouts detail (sample)
SELECT TOP 5 ElementType, ElementID, PositionX, PositionY 
FROM FlowLayouts 
WHERE QuestionnaireTypeID = @TypeId;
