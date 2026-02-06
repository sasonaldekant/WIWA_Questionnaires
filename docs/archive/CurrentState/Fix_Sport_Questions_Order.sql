USE [WIWA_Questionnaires_DB]
GO

SET NOCOUNT ON;
BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Revert Short Questionnaire (Type 2) to use QuestionID 15 (Original Order 170)
    UPDATE [dbo].[Questionnaires] 
    SET QuestionID = 15 
    WHERE QuestionnaireTypeID = 2 AND QuestionID = 48;

    IF @@ROWCOUNT > 0 PRINT 'Restored QuestionID 15 for Type 2.';

    -- 2. Delete USER DATA (QuestionnaireAnswers) keying off Q15 to resolve FK Constraint
    DELETE FROM [dbo].[QuestionnaireAnswers] WHERE QuestionID = 15;
    PRINT 'Deleted User Answers for Q15.';

    -- 3. Clean up existing structure for Q15
    DELETE pasq 
    FROM [dbo].[PredefinedAnswerSubQuestions] pasq
    JOIN [dbo].[PredefinedAnswers] pa ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID
    WHERE pa.QuestionID = 15;

    DELETE FROM [dbo].[PredefinedAnswers] 
    WHERE QuestionID = 15;

    PRINT 'Cleaned up Q15 definitions.';

    -- 4. Insert standardized answers and links
    DECLARE @AnsID INT;

    -- A) Organizovano -> SubQuestion 49
    INSERT INTO [dbo].[PredefinedAnswers] (QuestionID, Answer, DisplayOrder) VALUES (15, 'Organizovano', 1);
    SET @AnsID = SCOPE_IDENTITY();
    INSERT INTO [dbo].[PredefinedAnswerSubQuestions] (PredefinedAnswerID, SubQuestionID) VALUES (@AnsID, 49);

    -- B) Rekreativno -> SubQuestion 50
    INSERT INTO [dbo].[PredefinedAnswers] (QuestionID, Answer, DisplayOrder) VALUES (15, 'Rekreativno', 2);
    SET @AnsID = SCOPE_IDENTITY();
    INSERT INTO [dbo].[PredefinedAnswerSubQuestions] (PredefinedAnswerID, SubQuestionID) VALUES (@AnsID, 50);

    -- C) Ne
    INSERT INTO [dbo].[PredefinedAnswers] (QuestionID, Answer, DisplayOrder) VALUES (15, 'Ne', 3);

    COMMIT TRANSACTION;
    PRINT 'Success: Rebuilt Q15 with logic from Q48.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH
GO
