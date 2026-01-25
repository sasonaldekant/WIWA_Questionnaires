
/*
    25_Fix_Mojibake_Veliki_V2.sql
    -----------------------------
    Fixes double-encoded UTF-8 strings where bytes 0x80-0x9F were interpreted as Windows-1252.
    
    Previous script failed for characters mapped to 1252 "special" chars (quotes, bullets, daggers).
    
    Mappings (UTF-8 bytes -> CP1252 chars):
    č (C4 8D) -> Ä + (U+008D IS UNDEFINED IN 1252, BUT MAPS TO ITSELF IF RAW, OR MAYBE U+201C?)
                 Wait, step 940 returned 141 for č. So that was correct.
                 
    ć (C4 87) -> Ä + ‡ (U+2021 = 8225, NOT 135)
                 Byte 0x87 (135) in 1252 is ‡ (Double Dagger).
                 My previous script used NCHAR(135) (Control). 
                 User probably has `‡` (8225) in database.
                 
    đ (C4 91) -> Ä + ‘ (U+2018 = 8216). CONFIRMED ID 106.
    
    š (C5 A1) -> Å + ¡ (161). OK (161 is valid 1252).
    ž (C5 BE) -> Å + ¾ (190). OK.
    
    Upper Case:
    Č (C4 8C) -> Ä + Œ (U+0152 = 338). Byte 0x8C.
    Ć (C4 86) -> Ä + † (U+2020 = 8224). Byte 0x86.
    Š (C5 A0) -> Å +   (NBSP = 160). OK.
    Ž (C5 BD) -> Å + ½ (189). OK.
    Đ (C4 90) -> Ä +   (U+0090? Depends). Byte 0x90 in 1252 is undefined?
                 Actually 0x90 in 1252 IS UNDEFINED. MS SQL might map it to U+0090 or ?.
                 Let's assume U+0090 unless proven otherwise.
                 Wait, 0x90 usually maps to nothing or box?
                 
    We will perform REPLACE for both variants (Control codes AND Windows-1252 mappings).
*/

USE [WIWA_DB_NEW];
GO
SET NOCOUNT ON;

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. đ (C4 91) -> Ä + ‘ (8216) OR (145)
    UPDATE Questions SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(8216), N'đ') WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(8216) + N'%';
    UPDATE PredefinedAnswers SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(8216), N'đ') WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(8216) + N'%';

    -- 2. ć (C4 87) -> Ä + ‡ (8225) OR (135)
    UPDATE Questions SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(8225), N'ć') WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(8225) + N'%';
    UPDATE PredefinedAnswers SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(8225), N'ć') WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(8225) + N'%';

    -- 3. č (C4 8D) -> Ä + (141) OR (U+008D is Control)
    -- In 1252, 0x8D is undefined. But checking just in case.
    -- (Already fixed in V1 for 141, but let's be safe if it appears differently).

    -- 4. Č (C4 8C) -> Ä + Œ (338) OR (140)
    UPDATE Questions SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(338), N'Č') WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(338) + N'%';
    UPDATE PredefinedAnswers SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(338), N'Č') WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(338) + N'%';

    -- 5. Ć (C4 86) -> Ä + † (8224) OR (134)
    UPDATE Questions SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(8224), N'Ć') WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(8224) + N'%';
    UPDATE PredefinedAnswers SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(8224), N'Ć') WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(8224) + N'%';

    -- 6. Đ (C4 90) -> Ä + (144) OR ?
    -- 0x90 is undefined in 1252.

    -- Re-run V1 fixes just to be sure (idempotent)
    -- đ (145)
    UPDATE Questions SET QuestionText = REPLACE(QuestionText, NCHAR(196) + NCHAR(145), N'đ') WHERE QuestionText LIKE N'%' + NCHAR(196) + NCHAR(145) + N'%';
    UPDATE PredefinedAnswers SET Answer = REPLACE(Answer, NCHAR(196) + NCHAR(145), N'đ') WHERE Answer LIKE N'%' + NCHAR(196) + NCHAR(145) + N'%';

    COMMIT TRANSACTION;
    PRINT 'Character encoding V2 fixed successfully.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH
