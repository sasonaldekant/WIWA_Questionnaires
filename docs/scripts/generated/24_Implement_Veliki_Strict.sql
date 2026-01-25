/*
    24_Implement_Veliki_Strict.sql
    -----------------------------------
    Strict hierarchical implementation of "Veliki Upitnik" based on veliki_upitnik_clean_utf8.txt.
    IDs re-indexed to avoid collisions.
    Q1: 1000 (Subquestions 1100 - 2200)
    Q2: 3000
    Q3: 4000
    Q4: 5000
    Q5: 6000
    Q6: 7000
    Q7: 8000
    Q8: 9000
    Q9: 10000
*/
USE [WIWA_DB_NEW];
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET NUMERIC_ROUNDABORT OFF;
SET CONCAT_NULL_YIELDS_NULL ON;
GO

-- 1. Reset podataka
DELETE FROM Questionnaires WHERE QuestionnaireTypeID = 3;

-- Agresivno brisanje (Sve preko 200)
DELETE FROM QuestionComputedConfigs WHERE QuestionID >= 200;
DELETE FROM QuestionReferenceColumns WHERE QuestionID >= 200;
DELETE FROM PredefinedAnswerSubQuestions WHERE SubQuestionID >= 200;
DELETE FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerID IN (SELECT PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID >= 200);
DELETE FROM PredefinedAnswers WHERE QuestionID >= 200;
DELETE FROM Questions WHERE ParentQuestionID >= 200;
DELETE FROM Questions WHERE QuestionID >= 200;
GO

-- 2. Formati i Tipovi
DECLARE @FmtText INT = 1;
DECLARE @FmtRadio INT = 2;
DECLARE @FmtSelect INT = 3;
DECLARE @FmtCheck INT = 4;
DECLARE @FmtAutocomplete INT = 5;

DECLARE @TypeAlways INT = 1;
DECLARE @TypeCond INT = 2;
DECLARE @TypeComp INT = 3;

SET IDENTITY_INSERT Questions ON;

----------------------------------------------------------------------------------
-- Q1: Maligni, Srce, Metabolizam... (Root Checkbox Group)
-- ID: 1000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (1000, N'Da li ste bolovali ili trenutno bolujete od:', 'Q1', 10, @FmtCheck, @TypeAlways);

    -- Q1.1 Maligni Tumori -> Detalji 
    -- ID: 1100
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1100, N'Detalji (Maligni tumori):', '1.1', 1, @FmtText, @TypeCond);

    -- Q1.2 Bolesti Srca -> Checkbox List 1.2.1 - 1.2.10
    -- ID: 1200
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1200, N'Koje bolesti srca i krvnih sudova (označite):', '1.2', 2, @FmtCheck, @TypeCond);
    
        -- Sub-Questions for Q1.2 (Details for each heart disease)
        -- IDs: 1210, 1220, ...
        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES
        (1210, N'Detalji (Povišen pritisak):', '1.2.1', 1, @FmtText, @TypeCond),
        (1220, N'Detalji (Aritmija):', '1.2.2', 2, @FmtText, @TypeCond),
        (1230, N'Detalji (Tahikardija):', '1.2.3', 3, @FmtText, @TypeCond),
        (1240, N'Detalji (Mane/Slabosti):', '1.2.4', 4, @FmtText, @TypeCond),
        (1250, N'Detalji (Infarkt):', '1.2.5', 5, @FmtText, @TypeCond),
        (1260, N'Detalji (Angina):', '1.2.6', 6, @FmtText, @TypeCond),
        (1270, N'Detalji (Aneurizma):', '1.2.7', 7, @FmtText, @TypeCond),
        (1280, N'Detalji (Ateroskleroza):', '1.2.8', 8, @FmtText, @TypeCond),
        (1290, N'Detalji (Vene):', '1.2.9', 9, @FmtText, @TypeCond),
        (1291, N'Detalji (Tromboza):', '1.2.10', 10, @FmtText, @TypeCond);

    -- Q1.3 Metabolizam -> Checkbox List
    -- ID: 1300
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1300, N'Koje bolesti metabolizma (označite):', '1.3', 3, @FmtCheck, @TypeCond);

        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES
        (1310, N'Detalji (Dijabetes):', '1.3.1', 1, @FmtText, @TypeCond),
        (1320, N'Detalji (Giht):', '1.3.2', 2, @FmtText, @TypeCond),
        (1330, N'Detalji (Štitna žlezda):', '1.3.3', 3, @FmtText, @TypeCond),
        (1340, N'Detalji (Nadbubrežna):', '1.3.4', 4, @FmtText, @TypeCond),
        (1350, N'Detalji (Hipofiza):', '1.3.5', 5, @FmtText, @TypeCond);

    -- Q1.4 Disajni -> Checkbox List
    -- ID: 1400
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1400, N'Koje bolesti disajnog sistema (označite):', '1.4', 4, @FmtCheck, @TypeCond);

        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES
        (1410, N'Detalji (Bronhitis):', '1.4.1', 1, @FmtText, @TypeCond),
        (1420, N'Detalji (HOBP):', '1.4.2', 2, @FmtText, @TypeCond),
        (1430, N'Detalji (Astma):', '1.4.3', 3, @FmtText, @TypeCond),
        (1440, N'Detalji (Emfizem):', '1.4.4', 4, @FmtText, @TypeCond),
        (1450, N'Detalji (Embolija):', '1.4.5', 5, @FmtText, @TypeCond),
        (1460, N'Detalji (Tuberkuloza):', '1.4.6', 6, @FmtText, @TypeCond);

    -- Q1.5 Uro-genitalni -> Checkbox List
    -- ID: 1500
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1500, N'Koje bolesti uro-genitalnog sistema (označite):', '1.5', 5, @FmtCheck, @TypeCond);

        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES
        (1510, N'Detalji (Bubrezi):', '1.5.1', 1, @FmtText, @TypeCond),
        (1520, N'Detalji (Mokraćni kanali):', '1.5.2', 2, @FmtText, @TypeCond),
        (1530, N'Detalji (Prostata):', '1.5.3', 3, @FmtText, @TypeCond),
        (1540, N'Detalji (Testisi):', '1.5.4', 4, @FmtText, @TypeCond),
        (1550, N'Detalji (Materica):', '1.5.5', 5, @FmtText, @TypeCond),
        (1560, N'Detalji (Jajnici):', '1.5.6', 6, @FmtText, @TypeCond),
        (1570, N'Detalji (Dojka):', '1.5.7', 7, @FmtText, @TypeCond);

    -- Q1.6 Krv/Imuni -> Checkbox List
    -- ID: 1600
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1600, N'Koje bolesti krvi/imunog sistema (označite):', '1.6', 6, @FmtCheck, @TypeCond);

        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES
        (1610, N'Detalji (Leukemija):', '1.6.1', 1, @FmtText, @TypeCond),
        (1620, N'Detalji (Limfomi):', '1.6.2', 2, @FmtText, @TypeCond),
        (1630, N'Detalji (HIV/SIDA):', '1.6.3', 3, @FmtText, @TypeCond),
        (1640, N'Detalji (Lupus):', '1.6.4', 4, @FmtText, @TypeCond),
        (1650, N'Detalji (Vezivno tkivo):', '1.6.5', 5, @FmtText, @TypeCond);

    -- Q1.7 Digestivni -> Checkbox List
    -- ID: 1700
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1700, N'Koje bolesti digestivnog sistema (označite):', '1.7', 7, @FmtCheck, @TypeCond);
    
        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES
        (1710, N'Detalji (Čir):', '1.7.1', 1, @FmtText, @TypeCond),
        (1720, N'Detalji (Kron):', '1.7.2', 2, @FmtText, @TypeCond),
        (1730, N'Detalji (Kolitis):', '1.7.3', 3, @FmtText, @TypeCond),
        (1740, N'Detalji (Hepatitis):', '1.7.4', 4, @FmtText, @TypeCond),
        (1750, N'Detalji (Ciroza):', '1.7.5', 5, @FmtText, @TypeCond),
        (1760, N'Detalji (Žuč):', '1.7.6', 6, @FmtText, @TypeCond),
        (1770, N'Detalji (Pankreas):', '1.7.7', 7, @FmtText, @TypeCond);

    -- Q1.8 Lokomotorni -> Detalji Only
    -- ID: 1800
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1800, N'Detalji (Lokomotorni):', '1.8', 8, @FmtText, @TypeCond);

    -- Q1.9 Nervni -> Checkbox List
    -- ID: 1900
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (1900, N'Koje bolesti nervnog sistema (označite):', '1.9', 9, @FmtCheck, @TypeCond);

        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES
        (1910, N'Detalji (Pareze):', '1.9.1', 1, @FmtText, @TypeCond),
        (1920, N'Detalji (Epilepsija):', '1.9.2', 2, @FmtText, @TypeCond),
        (1930, N'Detalji (Šlog):', '1.9.3', 3, @FmtText, @TypeCond),
        (1940, N'Detalji (MS):', '1.9.4', 4, @FmtText, @TypeCond),
        (1950, N'Detalji (Distrofije):', '1.9.5', 5, @FmtText, @TypeCond),
        (1960, N'Detalji (Parkinson):', '1.9.6', 6, @FmtText, @TypeCond),
        (1970, N'Detalji (Alchajmer):', '1.9.7', 7, @FmtText, @TypeCond),
        (1980, N'Detalji (Psihoze/Depresija):', '1.9.8', 8, @FmtText, @TypeCond);

    -- Q1.10 Vid/Sluh -> Detalji (+ Dioptrija sub)
    -- ID: 2000 => Q2 is now 3000, so 2000 is safe
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (2000, N'Detalji (Vid/Sluh):', '1.10', 10, @FmtText, @TypeCond);
        
        INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
        VALUES (2010, N'Visina dioptrije:', '1.10.1', 2, @FmtText, @TypeCond);

    -- Q1.11 Kožne -> Detalji
    -- ID: 2100
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (2100, N'Detalji (Kožne promene):', '1.11', 11, @FmtText, @TypeCond);

    -- Q1.12 Tegobe -> Detalji
    -- ID: 2200
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (2200, N'Detalji (Povrede/Tegobe):', '1.12', 12, @FmtText, @TypeCond);

----------------------------------------------------------------------------------
-- Q2: Ostale bolesti
-- ID: 3000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (3000, N'Da li bolujete od bolesti koja nije navedena ili imate telesni nedostatak?', 'Q2', 20, @FmtRadio, @TypeAlways);
    
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (3100, N'Navedite koja je bolest:', '2.1', 1, @FmtText, @TypeCond);

----------------------------------------------------------------------------------
-- Q3: Ispitivanje
-- ID: 4000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (4000, N'Da li se trenutno nalazite na ispitivanju ili čekate rezultate?', 'Q3', 30, @FmtRadio, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (4100, N'Navedite detalje:', '3.1', 1, @FmtText, @TypeCond);

----------------------------------------------------------------------------------
-- Q4: Rizik
-- ID: 5000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (5000, N'Da li ste izloženi povećanom riziku od povređivanja?', 'Q4', 40, @FmtRadio, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (5100, N'Navesti opasnost:', '4.1', 1, @FmtText, @TypeCond);

----------------------------------------------------------------------------------
-- Q5: Sport
-- ID: 6000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (6000, N'Da li se bavite sportom?', 'Q5', 50, @FmtRadio, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES 
    (6100, N'Organizovano:', '5.1', 1, @FmtAutocomplete, @TypeCond),
    (6200, N'Rekreativno:', '5.2', 2, @FmtAutocomplete, @TypeCond);

----------------------------------------------------------------------------------
-- Q6: Konzumacija (Group)
-- ID: 7000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (7000, N'Da li redovno konzumirate:', 'Q6', 60, @FmtText, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
    VALUES 
    (7100, N'Alkohol', '6.1', 1, @FmtRadio, @TypeAlways, 7000),
    (7200, N'Drogu/Narkotike', '6.2', 2, @FmtRadio, @TypeAlways, 7000),
    (7300, N'Cigarete/Duvan', '6.3', 3, @FmtRadio, @TypeAlways, 7000);

----------------------------------------------------------------------------------
-- Q7: Lekovi
-- ID: 8000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (8000, N'Uzimate li redovno lekove?', 'Q7', 70, @FmtRadio, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (8100, N'Navedite koji lekovi i količinu:', '7.1', 1, @FmtText, @TypeCond);

----------------------------------------------------------------------------------
-- Q8: BMI
-- ID: 9000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES (9000, N'BMI Index', 'Q8', 80, @FmtText, @TypeComp, 1);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
    VALUES 
    (9100, N'Visina (cm)', 'Q8.1', 1, @FmtText, @TypeAlways, 9000),
    (9200, N'Težina (kg)', 'Q8.2', 2, @FmtText, @TypeAlways, 9000);

----------------------------------------------------------------------------------
-- Q9: Karton
-- ID: 10000
----------------------------------------------------------------------------------
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (10000, N'Da li imate otvoren zdravstveni karton?', 'Q9', 90, @FmtRadio, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (10100, N'Naziv ustanove i od kada:', '9.1', 1, @FmtText, @TypeCond);

SET IDENTITY_INSERT Questions OFF;
GO

----------------------------------------------------------------------------------
-- PREDIFINISANI ODGOVORI
----------------------------------------------------------------------------------
SET IDENTITY_INSERT PredefinedAnswers ON;

-- Odgovori za Q1 (1000)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(10101, 1000, N'1.1 Maligni tumori', '1.1'),
(10102, 1000, N'1.2 Bolesti srca', '1.2'),
(10103, 1000, N'1.3 Bolesti metabolizma', '1.3'),
(10104, 1000, N'1.4 Bolesti disajnog sistema', '1.4'),
(10105, 1000, N'1.5 Bolesti uro-genitalnog sistema', '1.5'),
(10106, 1000, N'1.6 Bolesti krvi/imunog sistema', '1.6'),
(10107, 1000, N'1.7 Bolesti digestivnog sistema', '1.7'),
(10108, 1000, N'1.8 Bolesti lokomotornog sistema', '1.8'),
(10109, 1000, N'1.9 Nervne i psihičke bolesti', '1.9'),
(10110, 1000, N'1.10 Bolesti čula vida i sluha', '1.10'),
(10111, 1000, N'1.11 Kožne bolesti', '1.11'),
(10112, 1000, N'1.12 Tegobe od ranije', '1.12');

    -- Odgovori za Q1.2 (1200)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (10201, 1200, N'1.2.1 Povišen pritisak', '1.2.1'),
    (10202, 1200, N'1.2.2 Aritmija', '1.2.2'),
    (10203, 1200, N'1.2.3 Tahikardija', '1.2.3'),
    (10204, 1200, N'1.2.4 Mane/Slabosti', '1.2.4'),
    (10205, 1200, N'1.2.5 Infarkt', '1.2.5'),
    (10206, 1200, N'1.2.6 Angina pectoris', '1.2.6'),
    (10207, 1200, N'1.2.7 Aneurizma', '1.2.7'),
    (10208, 1200, N'1.2.8 Ateroskleroza', '1.2.8'),
    (10209, 1200, N'1.2.9 Vene', '1.2.9'),
    (10210, 1200, N'1.2.10 Tromboza', '1.2.10');

    -- Odgovori za Q1.3 (1300)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (10301, 1300, N'1.3.1 Dijabetes', '1.3.1'),
    (10302, 1300, N'1.3.2 Giht', '1.3.2'),
    (10303, 1300, N'1.3.3 Štitna žlezda', '1.3.3'),
    (10304, 1300, N'1.3.4 Nadbubrežna', '1.3.4'),
    (10305, 1300, N'1.3.5 Hipofiza', '1.3.5');

    -- Odgovori za Q1.4 (1400)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (10401, 1400, N'1.4.1 Bronhitis', '1.4.1'),
    (10402, 1400, N'1.4.2 HOBP', '1.4.2'),
    (10403, 1400, N'1.4.3 Astma', '1.4.3'),
    (10404, 1400, N'1.4.4 Emfizem', '1.4.4'),
    (10405, 1400, N'1.4.5 Embolija', '1.4.5'),
    (10406, 1400, N'1.4.6 Tuberkuloza', '1.4.6');

    -- Odgovori za Q1.5 (1500)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (10501, 1500, N'1.5.1 Bubrezi', '1.5.1'),
    (10502, 1500, N'1.5.2 Mokraćni kanali', '1.5.2'),
    (10503, 1500, N'1.5.3 Prostata', '1.5.3'),
    (10504, 1500, N'1.5.4 Testisi', '1.5.4'),
    (10505, 1500, N'1.5.5 Materica', '1.5.5'),
    (10506, 1500, N'1.5.6 Jajnici', '1.5.6'),
    (10507, 1500, N'1.5.7 Dojka', '1.5.7');

    -- Odgovori za Q1.6 (1600)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (10601, 1600, N'1.6.1 Leukemija', '1.6.1'),
    (10602, 1600, N'1.6.2 Limfomi', '1.6.2'),
    (10603, 1600, N'1.6.3 HIV/SIDA', '1.6.3'),
    (10604, 1600, N'1.6.4 Lupus', '1.6.4'),
    (10605, 1600, N'1.6.5 Vezivno tkivo', '1.6.5');

    -- Odgovori za Q1.7 (1700)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (10701, 1700, N'1.7.1 Čir', '1.7.1'),
    (10702, 1700, N'1.7.2 Kron', '1.7.2'),
    (10703, 1700, N'1.7.3 Kolitis', '1.7.3'),
    (10704, 1700, N'1.7.4 Hepatitis', '1.7.4'),
    (10705, 1700, N'1.7.5 Ciroza', '1.7.5'),
    (10706, 1700, N'1.7.6 Žuč', '1.7.6'),
    (10707, 1700, N'1.7.7 Pankreas', '1.7.7');

    -- Odgovori za Q1.9 (1900)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (10901, 1900, N'1.9.1 Pareze', '1.9.1'),
    (10902, 1900, N'1.9.2 Epilepsija', '1.9.2'),
    (10903, 1900, N'1.9.3 Šlog', '1.9.3'),
    (10904, 1900, N'1.9.4 MS', '1.9.4'),
    (10905, 1900, N'1.9.5 Distrofije', '1.9.5'),
    (10906, 1900, N'1.9.6 Parkinson', '1.9.6'),
    (10907, 1900, N'1.9.7 Alchajmer', '1.9.7'),
    (10908, 1900, N'1.9.8 Psihoze', '1.9.8');

-- Odgovori za ostala pitanja (Da/Ne i slicno)
-- Q2 (3000)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (3001, 3000, N'Da', 'YES'), (3002, 3000, N'Ne', 'NO');
-- Q3 (4000)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (4001, 4000, N'Da', 'YES'), (4002, 4000, N'Ne', 'NO');
-- Q4 (5000)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (5001, 5000, N'Da', 'YES'), (5002, 5000, N'Ne', 'NO');
-- Q5 (6000)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(6001, 6000, N'Organizovano', 'ORG'), (6002, 6000, N'Rekreativno', 'REK'), (6003, 6000, N'Ne bavim se', 'NO');
-- Q6.1, 6.2, 6.3 (7100, 7200, 7300)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(7101, 7100, N'Ne', 'NO'), (7102, 7100, N'Umereno', 'MOD'), (7103, 7100, N'Prekomerno', 'EXC'),
(7201, 7200, N'Ne', 'NO'), (7202, 7200, N'Da', 'YES'),
(7301, 7300, N'Ne', 'NO'), (7302, 7300, N'Do 20', 'LOW'), (7303, 7300, N'Preko 20', 'HIGH');
-- Q7 (8000)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (8001, 8000, N'Da', 'YES'), (8002, 8000, N'Ne', 'NO');
-- Q9 (10000)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (10001, 10000, N'Da', 'YES'), (10002, 10000, N'Ne', 'NO');

SET IDENTITY_INSERT PredefinedAnswers OFF;
GO

----------------------------------------------------------------------------------
-- BRANCHING LOGIC
----------------------------------------------------------------------------------
DECLARE @LinkID INT = ISNULL((SELECT MAX(PredefinedAnswerSubQuestionID) FROM PredefinedAnswerSubQuestions), 0) + 1;

-- Link Q1 Level 2
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES 
(@LinkID, 10101, 1100), -- 1.1 -> Q1.1
(@LinkID+1, 10102, 1200), -- 1.2 -> Q1.2 List
(@LinkID+2, 10103, 1300), -- 1.3 -> Q1.3 List
(@LinkID+3, 10104, 1400), -- 1.4 -> Q1.4 List
(@LinkID+4, 10105, 1500), -- 1.5 -> Q1.5 List
(@LinkID+5, 10106, 1600), -- 1.6 -> Q1.6 List
(@LinkID+6, 10107, 1700), -- 1.7 -> Q1.7 List
(@LinkID+7, 10108, 1800), -- 1.8 -> Q1.8 Detail
(@LinkID+8, 10109, 1900), -- 1.9 -> Q1.9 List
(@LinkID+9, 10110, 2000), -- 1.10 -> Q1.10 Detail (2000)
(@LinkID+10, 10110, 2010), -- 1.10 -> Dioptrija (2010)
(@LinkID+11, 10111, 2100), -- 1.11 -> Q1.11 Detail (2100)
(@LinkID+12, 10112, 2200); -- 1.12 -> Q1.12 Detail (2200)

SET @LinkID = @LinkID + 13;

-- Link Q1 Level 3 (Details for lists)
-- Q1.2 (1200) -> 10201..10210
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 10201, 1210), (@LinkID+1, 10202, 1220), (@LinkID+2, 10203, 1230),
(@LinkID+3, 10204, 1240), (@LinkID+4, 10205, 1250), (@LinkID+5, 10206, 1260),
(@LinkID+6, 10207, 1270), (@LinkID+7, 10208, 1280), (@LinkID+8, 10209, 1290),
(@LinkID+9, 10210, 1291);
SET @LinkID = @LinkID + 10;

-- Q1.3 (1300) -> 10301..10305
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 10301, 1310), (@LinkID+1, 10302, 1320), (@LinkID+2, 10303, 1330),
(@LinkID+3, 10304, 1340), (@LinkID+4, 10305, 1350);
SET @LinkID = @LinkID + 5;

-- Q1.4 (1400) -> 10401..10406
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 10401, 1410), (@LinkID+1, 10402, 1420), (@LinkID+2, 10403, 1430),
(@LinkID+3, 10404, 1440), (@LinkID+4, 10405, 1450), (@LinkID+5, 10406, 1460);
SET @LinkID = @LinkID + 6;

-- Q1.5 (1500) -> 10501..10507
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 10501, 1510), (@LinkID+1, 10502, 1520), (@LinkID+2, 10503, 1530),
(@LinkID+3, 10504, 1540), (@LinkID+4, 10505, 1550), (@LinkID+5, 10506, 1560),
(@LinkID+6, 10507, 1570);
SET @LinkID = @LinkID + 7;

-- Q1.6 (1600) -> 10601..10605
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 10601, 1610), (@LinkID+1, 10602, 1620), (@LinkID+2, 10603, 1630),
(@LinkID+3, 10604, 1640), (@LinkID+4, 10605, 1650);
SET @LinkID = @LinkID + 5;

-- Q1.7 (1700) -> 10701..10707
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 10701, 1710), (@LinkID+1, 10702, 1720), (@LinkID+2, 10703, 1730),
(@LinkID+3, 10704, 1740), (@LinkID+4, 10705, 1750), (@LinkID+5, 10706, 1760),
(@LinkID+6, 10707, 1770);
SET @LinkID = @LinkID + 7;

-- Q1.9 (1900) -> 10901..10908
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 10901, 1910), (@LinkID+1, 10902, 1920), (@LinkID+2, 10903, 1930),
(@LinkID+3, 10904, 1940), (@LinkID+4, 10905, 1950), (@LinkID+5, 10906, 1960),
(@LinkID+6, 10907, 1970), (@LinkID+7, 10908, 1980);
SET @LinkID = @LinkID + 8;

-- Other Questions
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES
(@LinkID, 3001, 3100), -- Q2 -> 2.1 (3100)
(@LinkID+1, 4001, 4100), -- Q3 -> 3.1 (4100)
(@LinkID+2, 5001, 5100), -- Q4 -> 4.1 (5100)
(@LinkID+3, 6001, 6100), (@LinkID+4, 6002, 6200), -- Q5 -> 5.1/5.2
(@LinkID+5, 8001, 8100), -- Q7 -> 7.1
(@LinkID+6, 10001, 10100); -- Q9 -> 9.1
GO

----------------------------------------------------------------------------------
-- FINAL SETUP
----------------------------------------------------------------------------------
-- Link to Questionnaire Type 3
INSERT INTO Questionnaires (QuestionnaireTypeID, QuestionID)
VALUES 
(3, 1000), (3, 3000), (3, 4000), (3, 5000), (3, 6000), (3, 7000), (3, 8000), (3, 9000), (3, 10000);

-- BMI Logic
INSERT INTO QuestionComputedConfigs (QuestionID, ComputeMethodID, RuleName, MatrixObjectName, OutputMode, MatrixOutputColumnName, Priority, IsActive)
VALUES (9000, 2, 'BMI Calculation', '', 1, '', 1, 1);

-- Sports Autocomplete
DECLARE @RefTableID INT;
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 3 AND TableName = 'Sports') INSERT INTO QuestionnaireTypeReferenceTables VALUES (3, 'Sports');
SELECT @RefTableID = QuestionnaireTypeReferenceTableID FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 3 AND TableName = 'Sports';

INSERT INTO QuestionReferenceColumns (QuestionReferenceColumnID, QuestionID, QuestionnaireTypeReferenceTableID, ReferenceColumnName)
VALUES 
(ISNULL((SELECT MAX(QuestionReferenceColumnID) FROM QuestionReferenceColumns), 0) + 1, 6100, @RefTableID, 'SportName'),
(ISNULL((SELECT MAX(QuestionReferenceColumnID) FROM QuestionReferenceColumns), 0) + 2, 6200, @RefTableID, 'SportName');
GO
