/*
    Script: 27_Fix_Duplicates_And_Formulas.sql
    Description: Merges duplicate questions (Visina, Tezina) and updates string formulas.
    Strategy: Keep IDs 104 (Visina) and 105 (Tezina). Map 10 -> 104, 11 -> 105.
*/

SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Defining Mappings
    -- 10 (Visina) -> 104
    -- 11 (Tezina) -> 105

    PRINT 'Starting Merge...';

    -- 2. Update Questionnaires (Linkage)
    -- If the target link already exists, just delete the source link to avoid dupe.
    -- Otherwise, update the source link to target.
    
    -- Handle Visina (10 -> 104)
    IF EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionID = 10)
    BEGIN
        IF EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionID = 104)
        BEGIN
             -- Target already has a link (or multiple). Logic implies we just remove the old link from 10?
             -- Identify if we are losing any type association.
             -- If 10 is linked to Type A, and 104 is NOT, we must move 10's link to 104.
             -- If both are linked to Type A, delete 10's link.
             
             -- Update where target doesn't exist
             UPDATE Source
             SET QuestionID = 104
             FROM Questionnaires Source
             WHERE Source.QuestionID = 10
             AND NOT EXISTS (SELECT 1 FROM Questionnaires Target WHERE Target.QuestionID = 104 AND Target.QuestionnaireTypeID = Source.QuestionnaireTypeID);

             -- Delete remaining (duplicates)
             DELETE FROM Questionnaires WHERE QuestionID = 10;
        END
        ELSE
        BEGIN
            -- Target has no links, safe to update all
            UPDATE Questionnaires SET QuestionID = 104 WHERE QuestionID = 10;
        END
    END

    -- Handle Tezina (11 -> 105)
    IF EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionID = 11)
    BEGIN
        IF EXISTS (SELECT 1 FROM Questionnaires WHERE QuestionID = 105)
        BEGIN
             UPDATE Source
             SET QuestionID = 105
             FROM Questionnaires Source
             WHERE Source.QuestionID = 11
             AND NOT EXISTS (SELECT 1 FROM Questionnaires Target WHERE Target.QuestionID = 105 AND Target.QuestionnaireTypeID = Source.QuestionnaireTypeID);

             DELETE FROM Questionnaires WHERE QuestionID = 11;
        END
        ELSE
        BEGIN
            UPDATE Questionnaires SET QuestionID = 105 WHERE QuestionID = 11;
        END
    END
    
    PRINT 'Questionnaires Updated.';

    -- 3. Update Formulas (QuestionComputedConfigs)
    -- Replace {10} with {104}
    UPDATE QuestionComputedConfigs
    SET FormulaExpression = REPLACE(FormulaExpression, '{10}', '{104}')
    WHERE FormulaExpression LIKE '%{10}%';

    -- Replace {11} with {105}
    UPDATE QuestionComputedConfigs
    SET FormulaExpression = REPLACE(FormulaExpression, '{11}', '{105}')
    WHERE FormulaExpression LIKE '%{11}%';

    PRINT 'Formulas Updated.';

    -- 4. Update Other References (Parent/Child, PredefinedAnswers)
    -- Just in case they are used as parents
    UPDATE Questions SET ParentQuestionID = 104 WHERE ParentQuestionID = 10;
    UPDATE Questions SET ParentQuestionID = 105 WHERE ParentQuestionID = 11;

    -- SubQuestions (PredefinedAnswerSubQuestions)
    UPDATE PredefinedAnswerSubQuestions SET SubQuestionID = 104 WHERE SubQuestionID = 10;
    UPDATE PredefinedAnswerSubQuestions SET SubQuestionID = 105 WHERE SubQuestionID = 11;

    -- 5. Delete Old Questions
    DELETE FROM Questions WHERE QuestionID IN (10, 11);

    PRINT 'Old Questions (10, 11) Deleted.';
    
    COMMIT TRANSACTION;
    PRINT 'Success.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;
