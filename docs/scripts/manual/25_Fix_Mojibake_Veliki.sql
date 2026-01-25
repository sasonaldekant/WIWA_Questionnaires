
/*
    25_Fix_Mojibake_Veliki.sql
    --------------------------
    Fixes double-encoded UTF-8 strings in Questions and PredefinedAnswers.
    
    Mappings (UTF-8 bytes -> CP1252 chars):
    č (C4 8D) -> Ä + CHAR(141)
    ć (C4 87) -> Ä + ‡ (135)
    š (C5 A1) -> Å + ¡ (161)
    ž (C5 BE) -> Å + ¾ (190)
    đ (C4 91) -> Ä + ‘ (145)
    
    Č (C4 8C) -> Ä + CHAR(140)
    Ć (C4 86) -> Ä + † (134)
    Š (C5 A0) -> Å + CHAR(160) Note: NBSP
    Ž (C5 BD) -> Å + ½ (189)
    Đ (C4 90) -> Ä + CHAR(144)
*/

USE [WIWA_DB_NEW];
GO
SET NOCOUNT ON;

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. FIX Questions (Text)
    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(141), N'č')
    WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(141) + N'%';

    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(135), N'ć')
    WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(135) + N'%';

    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(197) + NCHAR(161), N'š')
    WHERE QuestionText LIKE N'%' + NCHAR(197) + NCHAR(161) + N'%';
    
    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(197) + NCHAR(190), N'ž')
    WHERE QuestionText LIKE N'%' + NCHAR(197) + NCHAR(190) + N'%';
    
    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(145), N'đ')
    WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(145) + N'%';

    -- Uppercase QuestionText
    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(140), N'Č')
    WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(140) + N'%';
    
    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(134), N'Ć')
    WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(134) + N'%';
    
    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(197) + NCHAR(160), N'Š')
    WHERE QuestionText LIKE N'%' + NCHAR(197) + NCHAR(160) + N'%';
            
    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(197) + NCHAR(189), N'Ž')
    WHERE QuestionText LIKE N'%' + NCHAR(197) + NCHAR(189) + N'%';

    UPDATE Questions
    SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(144), N'Đ')
    WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(144) + N'%';

    -- 2. FIX PredefinedAnswers (Answer)
    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(141), N'č')
    WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(141) + N'%';

    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(135), N'ć')
    WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(135) + N'%';

    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(197) + NCHAR(161), N'š')
    WHERE Answer LIKE N'%' + NCHAR(197) + NCHAR(161) + N'%';
    
    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(197) + NCHAR(190), N'ž')
    WHERE Answer LIKE N'%' + NCHAR(197) + NCHAR(190) + N'%';
    
    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(145), N'đ')
    WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(145) + N'%';

    -- Uppercase Answers
    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(140), N'Č')
    WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(140) + N'%';
    
    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(134), N'Ć')
    WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(134) + N'%';
    
    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(197) + NCHAR(160), N'Š')
    WHERE Answer LIKE N'%' + NCHAR(197) + NCHAR(160) + N'%';
    
    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(197) + NCHAR(189), N'Ž')
    WHERE Answer LIKE N'%' + NCHAR(197) + NCHAR(189) + N'%';

    UPDATE PredefinedAnswers
    SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(144), N'Đ')
    WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(144) + N'%';

    COMMIT TRANSACTION;
    PRINT 'Character encoding fixed successfully.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH
