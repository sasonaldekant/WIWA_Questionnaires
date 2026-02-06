-- 1. Migrate Questions Coordinates
;WITH QuestionTree AS (
    -- Roots
    SELECT QuestionnaireTypeID, QuestionID
    FROM Questionnaires
    
    UNION ALL
    
    -- Parent -> Child
    SELECT qt.QuestionnaireTypeID, q.QuestionID
    FROM QuestionTree qt
    JOIN Questions q ON q.ParentQuestionID = qt.QuestionID
    
    UNION ALL
    
    -- Answer -> SubQuestion
    SELECT qt.QuestionnaireTypeID, pasq.SubQuestionID
    FROM QuestionTree qt
    JOIN PredefinedAnswers pa ON pa.QuestionID = qt.QuestionID
    JOIN PredefinedAnswerSubQuestions pasq ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID
)
INSERT INTO FlowLayouts (QuestionnaireTypeID, ElementType, ElementID, PositionX, PositionY)
SELECT DISTINCT
    t.QuestionnaireTypeID,
    'Question',
    'q-' + CAST(t.QuestionID AS NVARCHAR(50)),
    qu.PositionX, 
    qu.PositionY
FROM QuestionTree t
JOIN Questions qu ON t.QuestionID = qu.QuestionID
WHERE qu.PositionX IS NOT NULL AND qu.PositionY IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM FlowLayouts fl 
    WHERE fl.QuestionnaireTypeID = t.QuestionnaireTypeID 
    AND fl.ElementType = 'Question' 
    AND fl.ElementID = 'q-' + CAST(t.QuestionID AS NVARCHAR(50))
);

-- 2. Migrate PredefinedAnswers Coordinates
;WITH QuestionTree AS (
    SELECT QuestionnaireTypeID, QuestionID
    FROM Questionnaires
    UNION ALL
    SELECT qt.QuestionnaireTypeID, q.QuestionID
    FROM QuestionTree qt
    JOIN Questions q ON q.ParentQuestionID = qt.QuestionID
    UNION ALL
    SELECT qt.QuestionnaireTypeID, pasq.SubQuestionID
    FROM QuestionTree qt
    JOIN PredefinedAnswers pa ON pa.QuestionID = qt.QuestionID
    JOIN PredefinedAnswerSubQuestions pasq ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID
)
INSERT INTO FlowLayouts (QuestionnaireTypeID, ElementType, ElementID, PositionX, PositionY)
SELECT DISTINCT
    t.QuestionnaireTypeID,
    'Answer',
    'a-' + CAST(pa.PredefinedAnswerID AS NVARCHAR(50)),
    pa.PositionX, 
    pa.PositionY
FROM QuestionTree t
JOIN PredefinedAnswers pa ON t.QuestionID = pa.QuestionID
WHERE pa.PositionX IS NOT NULL AND pa.PositionY IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM FlowLayouts fl 
    WHERE fl.QuestionnaireTypeID = t.QuestionnaireTypeID 
    AND fl.ElementType = 'Answer' 
    AND fl.ElementID = 'a-' + CAST(pa.PredefinedAnswerID AS NVARCHAR(50))
);

-- 3. Drop Columns
ALTER TABLE Questions DROP COLUMN PositionX;
ALTER TABLE Questions DROP COLUMN PositionY;
ALTER TABLE PredefinedAnswers DROP COLUMN PositionX;
ALTER TABLE PredefinedAnswers DROP COLUMN PositionY;
