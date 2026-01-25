USE [WIWA_DB_NEW];
GO

SET NOCOUNT ON;

PRINT '--------------------------------------------------';
PRINT 'VERIFICATION: Skraceni upitnik (SHORT_QUEST)';
PRINT '--------------------------------------------------';

-- Check Type
DECLARE @TypeID INT;
SELECT @TypeID = QuestionnaireTypeID FROM QuestionnaireTypes WHERE Code = 'SHORT_QUEST';

IF @TypeID IS NOT NULL
    PRINT 'PASS: QuestionnaireType found. ID: ' + CAST(@TypeID AS VARCHAR);
ELSE
    PRINT 'FAIL: QuestionnaireType NOT found.';

-- Check Questions
PRINT 'Checking Linked Questions:';
SELECT 
    q.QuestionID, 
    LEFT(q.QuestionText, 50) AS Text, 
    q.QuestionFormatID,
    q.SpecificQuestionTypeID
FROM Questions q
JOIN Questionnaires qn ON q.QuestionID = qn.QuestionID
WHERE qn.QuestionnaireTypeID = @TypeID
ORDER BY q.QuestionOrder;

-- Check Branching
PRINT 'Checking Branching (SubQuestions):';
SELECT 
    pasq.PredefinedAnswerSubQuestionID,
    pa.Answer AS ParentAnswer,
    q_sub.QuestionText AS SubQuestion
FROM PredefinedAnswerSubQuestions pasq
JOIN PredefinedAnswers pa ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID
JOIN Questions q_sub ON pasq.SubQuestionID = q_sub.QuestionID
WHERE pa.QuestionID IN (SELECT QuestionID FROM Questionnaires WHERE QuestionnaireTypeID = @TypeID);

-- Check Computed Config
PRINT 'Checking Computed Config (BMI):';
SELECT 
    qcc.QuestionComputedConfigID,
    cm.Code AS Method,
    qcc.MatrixObjectName
FROM QuestionComputedConfigs qcc
JOIN ComputeMethods cm ON qcc.ComputeMethodID = cm.ComputeMethodID
WHERE qcc.QuestionID = 102; 
-- Assuming 102 is BMI question
