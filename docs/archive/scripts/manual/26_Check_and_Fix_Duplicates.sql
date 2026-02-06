/*
    Script: 26_Check_and_Fix_Duplicates.sql
    Description: Identifies questions with identical text and suggests merging.
*/

-- 1. Identify Duplicates (Detailed)
SELECT QuestionID, QuestionText, QuestionLabel
FROM Questions 
WHERE QuestionText IN (
    SELECT QuestionText 
    FROM Questions 
    GROUP BY QuestionText 
    HAVING COUNT(*) > 1
)
ORDER BY QuestionText, QuestionID;

-- 2. Check Usage
SELECT q.QuestionID, q.QuestionText, qt.Name as QuestionnaireType
FROM Questions q
LEFT JOIN Questionnaires qqt ON q.QuestionID = qqt.QuestionID
LEFT JOIN QuestionnaireTypes qt ON qqt.QuestionnaireTypeID = qt.QuestionnaireTypeID
WHERE q.QuestionID IN (
    SELECT QuestionID
    FROM Questions 
    WHERE QuestionText IN (
        SELECT QuestionText 
        FROM Questions 
        GROUP BY QuestionText 
        HAVING COUNT(*) > 1
    )
)
ORDER BY q.QuestionText, q.QuestionID;

/*
-- 2. (Optional) Manual Fix Strategy
-- Verify which ID you want to keep (e.g., the one appearing first or in ranges 100-199)
-- DECLARE @KeepID INT = 100;
-- DECLARE @RemoveID INT = 999; -- Example

-- UPDATE QuestionQuestionnaireTypes SET QuestionID = @KeepID WHERE QuestionID = @RemoveID;
-- DELETE FROM Questions WHERE QuestionID = @RemoveID;
*/
