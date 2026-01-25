-- SQL query to retrieve all questions, sub-questions, and children for 'Veliki upitnik' (QuestionnaireTypeID = 3)
-- Includes formats, specific types, and predefined answers.

WITH QuestionnaireStructure AS (
    -- 1. Main questions explicitly listed in the questionnaire
    SELECT 
        q.QuestionID,
        q.QuestionText,
        q.QuestionLabel,
        q.QuestionOrder,
        q.QuestionFormatID,
        q.SpecificQuestionTypeID,
        q.ParentQuestionID,
        q.ReadOnly,
        CAST('Main' AS VARCHAR(20)) as RelationshipType,
        CAST(NULL AS INT) as TriggerAnswerID
    FROM Questions q
    JOIN Questionnaires qj ON q.QuestionID = qj.QuestionID
    WHERE qj.QuestionnaireTypeID = 3

    UNION ALL

    -- 2. Sub-questions (Conditional Branching via PredefinedAnswerSubQuestions)
    SELECT 
        sq.QuestionID,
        sq.QuestionText,
        sq.QuestionLabel,
        sq.QuestionOrder,
        sq.QuestionFormatID,
        sq.SpecificQuestionTypeID,
        sq.ParentQuestionID,
        sq.ReadOnly,
        CAST('Conditional' AS VARCHAR(20)) as RelationshipType,
        pasq.PredefinedAnswerID as TriggerAnswerID
    FROM Questions sq
    JOIN PredefinedAnswerSubQuestions pasq ON sq.QuestionID = pasq.SubQuestionID
    JOIN PredefinedAnswers pa ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID
    JOIN QuestionnaireStructure qs ON pa.QuestionID = qs.QuestionID

    UNION ALL

    -- 3. Child questions (Direct Nesting via ParentQuestionID)
    SELECT 
        cq.QuestionID,
        cq.QuestionText,
        cq.QuestionLabel,
        cq.QuestionOrder,
        cq.QuestionFormatID,
        cq.SpecificQuestionTypeID,
        cq.ParentQuestionID,
        cq.ReadOnly,
        CAST('Child' AS VARCHAR(20)) as RelationshipType,
        CAST(NULL AS INT) as TriggerAnswerID
    FROM Questions cq
    JOIN QuestionnaireStructure qs ON cq.ParentQuestionID = qs.QuestionID
    WHERE cq.ParentQuestionID IS NOT NULL
)
SELECT DISTINCT
    qs.QuestionID,
    qs.QuestionLabel,
    qs.QuestionText,
    qs.QuestionOrder,
    qf.Name AS Format,
    sqt.Name AS SpecificType,
    qs.RelationshipType,
    qs.ParentQuestionID,
    qs.TriggerAnswerID,
    pa.PredefinedAnswerID,
    pa.Answer AS PredefinedAnswer,
    pa.Code AS AnswerCode,
    qs.ReadOnly
FROM QuestionnaireStructure qs
LEFT JOIN QuestionFormats qf ON qs.QuestionFormatID = qf.QuestionFormatID
LEFT JOIN SpecificQuestionTypes sqt ON qs.SpecificQuestionTypeID = sqt.SpecificQuestionTypeID
LEFT JOIN PredefinedAnswers pa ON qs.QuestionID = pa.QuestionID
ORDER BY qs.QuestionOrder, qs.QuestionID, pa.PredefinedAnswerID;
