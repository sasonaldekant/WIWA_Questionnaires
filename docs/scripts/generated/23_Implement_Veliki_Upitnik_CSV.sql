/*
    23_Implement_Veliki_Upitnik_CSV.sql
    -----------------------------------
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

-- 1. Reset podataka za Type 3
DELETE FROM Questionnaires WHERE QuestionnaireTypeID = 3;

-- Brisanje svih povezanih podataka za opseg 200-400
-- AGRESIVNO BRISANJE SVIH RELACIJA (200 - 30000)
DELETE FROM QuestionComputedConfigs WHERE QuestionID BETWEEN 200 AND 30000;
DELETE FROM QuestionReferenceColumns WHERE QuestionID BETWEEN 200 AND 30000;
DELETE FROM PredefinedAnswerSubQuestions WHERE SubQuestionID BETWEEN 200 AND 30000;
DELETE FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerID IN (SELECT PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID BETWEEN 200 AND 30000);
DELETE FROM PredefinedAnswers WHERE QuestionID BETWEEN 200 AND 30000;
DELETE FROM Questions WHERE ParentQuestionID BETWEEN 200 AND 30000;
DELETE FROM Questions WHERE QuestionID BETWEEN 200 AND 30000;
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
-- SEKCIJA 1: MEDICINSKA PITANJA (Root checked box groups)
----------------------------------------------------------------------------------
-- Q1: Da li ste bolovali... (Glavno pitanje 1. - Maligni)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (201, N'Da li ste bolovali ili trenutno bolujete od:', 'Q1', 1, @FmtCheck, @TypeAlways);

-- 1.1 Maligni tumori (Opcija u checkboxu, otvara ništa jer je samo check, ali spec kaže da traži dokumentaciju. 
-- Dokumentacija se rešava kroz poruke, ne kroz nova pitanja, osim ako treba uneti detalje. 
-- Ovde dodajemo podpitanje "Detalji" za svaki check)

-- Podpitanje za 1.1 (Detalji)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2011, N'Detalji (Maligni tumori):', 'Q1.1_Det', 1, @FmtText, @TypeCond);

-- 1.2 Bolesti srca (Opcija u checkboxu, otvara listu specifičnih bolesti srca)
-- Ovo je kompleksno: 1.2 je opcija u Q1. Ako se čekira, otvara se NOVA checklist-a sa 1.2.1 do 1.2.10
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2012, N'Koje bolesti srca i krvnih sudova (označite):', 'Q1.2_List', 2, @FmtCheck, @TypeCond);

    -- Podpitanja za 1.2.x (Sva su detalji tekstualni)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID) VALUES 
    (20121, N'Detalji (Pritisak):', 'Q1.2.1', 1, @FmtText, @TypeCond),
    (20122, N'Detalji (Aritmija):', 'Q1.2.2', 2, @FmtText, @TypeCond),
    (20123, N'Detalji (Tahikardija):', 'Q1.2.3', 3, @FmtText, @TypeCond),
    (20124, N'Detalji (Mane/Slabosti):', 'Q1.2.4', 4, @FmtText, @TypeCond),
    (20125, N'Detalji (Infarkt):', 'Q1.2.5', 5, @FmtText, @TypeCond),
    (20126, N'Detalji (Angina):', 'Q1.2.6', 6, @FmtText, @TypeCond),
    (20127, N'Detalji (Aneurizma):', 'Q1.2.7', 7, @FmtText, @TypeCond),
    (20128, N'Detalji (Ateroskleroza):', 'Q1.2.8', 8, @FmtText, @TypeCond),
    (20129, N'Detalji (Vene/Tromboza):', 'Q1.2.9', 9, @FmtText, @TypeCond);

-- 1.3 Metabolizam (Opcija u Q1 -> Otvara listu Q1.3_List)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2013, N'Koje bolesti metabolizma (označite):', 'Q1.3_List', 3, @FmtCheck, @TypeCond);
    -- Detalji za 1.3
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (20131, N'Detalji:', 'Q1.3_Det', 1, @FmtText, @TypeCond);

-- 1.4 Disajni (Opcija u Q1 -> Otvara listu Q1.4_List)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2014, N'Koje bolesti disajnog sistema (označite):', 'Q1.4_List', 4, @FmtCheck, @TypeCond);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (20141, N'Detalji:', 'Q1.4_Det', 1, @FmtText, @TypeCond);

-- 1.5 Uro-genitalni (Opcija u Q1 -> Otvara listu Q1.5_List)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2015, N'Koje bolesti uro-genitalnog sistema (označite):', 'Q1.5_List', 5, @FmtCheck, @TypeCond);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (20151, N'Detalji:', 'Q1.5_Det', 1, @FmtText, @TypeCond);

-- 1.6 Krv/Imuni (Opcija u Q1 -> Otvara listu 1.6)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2016, N'Koje bolesti krvi/imunog sistema (označite):', 'Q1.6_List', 6, @FmtCheck, @TypeCond);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (20161, N'Detalji:', 'Q1.6_Det', 1, @FmtText, @TypeCond);

-- 1.7 Digestivni (Opcija u Q1 -> Otvara listu 1.7)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2017, N'Koje bolesti digestivnog sistema (označite):', 'Q1.7_List', 7, @FmtCheck, @TypeCond);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (20171, N'Detalji:', 'Q1.7_Det', 1, @FmtText, @TypeCond);

-- 1.8 Lokomotorni (Opcija u Q1 -> Detalji)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2018, N'Detalji (Lokomotorni):', 'Q1.8_Det', 8, @FmtText, @TypeCond);

-- 1.9 Nervni (Opcija u Q1 -> Lista 1.9)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2019, N'Koje bolesti nervnog sistema (označite):', 'Q1.9_List', 9, @FmtCheck, @TypeCond);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (20191, N'Detalji:', 'Q1.9_Det', 1, @FmtText, @TypeCond);

-- 1.10 Vid/Sluh (Opcija u Q1 -> Detalji)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2020, N'Detalji (Vid/Sluh):', 'Q1.10_Det', 10, @FmtText, @TypeCond);

-- 1.10.1 Dioptrija (Posebno pitanje unutar 1.10 logike? Ne, stavicemo kao kondicional na 1.10)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (20201, N'Visina dioptrije (ako je primenjivo):', 'Q1.10.1', 2, @FmtText, @TypeCond);

-- 1.11 Kožne (Opcija u Q1 -> Detalji)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2021, N'Detalji (Kožne promene):', 'Q1.11_Det', 11, @FmtText, @TypeCond);

-- 1.12 Tegobe od ranije (Opcija u Q1 -> Detalji)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (2022, N'Detalji (Posledice povreda/nesreća):', 'Q1.12_Det', 12, @FmtText, @TypeCond);


----------------------------------------------------------------------------------
-- SEKCIJA 2 - 9: OSTALA PITANJA
----------------------------------------------------------------------------------

-- Q2: Ostale bolesti (Radio Da/Ne -> Detalji)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (202, N'Da li bolujete od bolesti koja nije navedena ili imate telesni nedostatak?', 'Q2', 20, @FmtRadio, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (221, N'Navedite koja je bolest u pitanju:', 'Q2.1', 1, @FmtText, @TypeCond);

-- Q3: Ispitivanje (Radio Da/Ne -> Detalji)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (203, N'Da li se trenutno nalazite na ispitivanju ili čekate rezultate?', 'Q3', 30, @FmtRadio, @TypeAlways);
    -- Nema posebnog detalj pitanja u CSV, samo se traži dokumentacija, ali dodaćemo Text za opis
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (231, N'Navedite detalje ispitivanja:', 'Q3.1', 1, @FmtText, @TypeCond);

-- Q4 (CSV: 4): Rizik na poslu (Radio Da/Ne -> Navesti opasnost)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (204, N'Da li ste izloženi povećanom riziku od povređivanja (zračenje, eksploziv...)?', 'Q4', 40, @FmtRadio, @TypeAlways);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (241, N'Navesti opasnost:', 'Q4.1', 1, @FmtText, @TypeCond);

-- Q5 (CSV: 5): Sport (Autocomplete)
-- Spec pominje "Organizovano" i "Rekreativno" kao stavke.
-- Implementacija: Radio (Org/Rekr/Ne) -> Ako Org/Rekr -> Autocomplete liste.
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (205, N'Da li se bavite sportom?', 'Q5', 50, @FmtRadio, @TypeAlways);

    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES 
    (251, N'Izaberite sport (Organizovano):', 'Q5.1', 1, @FmtAutocomplete, @TypeCond),
    (252, N'Izaberite sport (Rekreativno):', 'Q5.2', 2, @FmtAutocomplete, @TypeCond);

-- Q6 (CSV: 6): Konzumacija (Group)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (206, N'Da li redovno konzumirate:', 'Q6', 60, @FmtText, @TypeAlways); -- Label only

    -- Deca za Q6 (ParentID = 206)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
    VALUES 
    (261, N'Alkohol', 'Q6.1', 1, @FmtRadio, @TypeAlways, 206),
    (262, N'Drogu/Narkotike', 'Q6.2', 2, @FmtRadio, @TypeAlways, 206),
    (263, N'Cigarete/Duvan', 'Q6.3', 3, @FmtRadio, @TypeAlways, 206);

-- Q7 (CSV: 7): Lekovi (Radio Da/Ne -> Tekst)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (207, N'Uzimate li redovno lekove?', 'Q7', 70, @FmtRadio, @TypeAlways);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (271, N'Navedite koji lekovi i količinu:', 'Q7.1', 1, @FmtText, @TypeCond);

-- Q8 (CSV: 8): BMI (Computed) - Kao ranije
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ReadOnly)
VALUES (208, N'BMI Index', 'Q8', 80, @FmtText, @TypeComp, 1);
    
    -- Deca za BMI (Visina, Težina)
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID, ParentQuestionID)
    VALUES 
    (281, N'Visina (cm)', 'Q8.1', 1, @FmtText, @TypeAlways, 208),
    (282, N'Težina (kg)', 'Q8.2', 2, @FmtText, @TypeAlways, 208);

-- Q9 (CSV: 9): Karton (Radio Da/Ne -> Ustanova)
INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
VALUES (209, N'Da li imate otvoren zdravstveni karton?', 'Q9', 90, @FmtRadio, @TypeAlways);
    INSERT INTO Questions (QuestionID, QuestionText, QuestionLabel, QuestionOrder, QuestionFormatID, SpecificQuestionTypeID)
    VALUES (291, N'Naziv ustanove i od kada:', 'Q9.1', 1, @FmtText, @TypeCond);

SET IDENTITY_INSERT Questions OFF;
GO

----------------------------------------------------------------------------------
-- UNOS ODGOVORA (PREDEFINED ANSWERS)
----------------------------------------------------------------------------------
SET IDENTITY_INSERT PredefinedAnswers ON;

-- Odgovori za Q1 (Checkbox opcije)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(20101, 201, N'Maligni tumori...', 'A_1.1'),
(20102, 201, N'Bolesti srca i krvnih sudova', 'A_1.2'),
(20103, 201, N'Bolesti metabolizma (Dijabetes, Štitna...)', 'A_1.3'),
(20104, 201, N'Bolesti disajnog sistema', 'A_1.4'),
(20105, 201, N'Bolesti uro-genitalnog sistema', 'A_1.5'),
(20106, 201, N'Bolesti krvi/imunog sistema', 'A_1.6'),
(20107, 201, N'Bolesti digestivnog sistema', 'A_1.7'),
(20108, 201, N'Bolesti lokomotornog sistema', 'A_1.8'),
(20109, 201, N'Nervne i psihičke bolesti', 'A_1.9'),
(20110, 201, N'Bolesti čula vida i sluha', 'A_1.10'),
(20111, 201, N'Kožne bolesti / alergije', 'A_1.11'),
(20112, 201, N'Tegobe od ranijih povreda', 'A_1.12');

    -- Odgovori za Q1.2 (Srce - Checkbox lista)
    INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
    (20121, 2012, N'Povišen krvni pritisak', 'BP'),
    (20122, 2012, N'Aritmija', 'ARR'),
    (20123, 2012, N'Tahikardija', 'TAH'),
    (20124, 2012, N'Srčane mane/slabosti', 'FAIL'),
    (20125, 2012, N'Infarkt srca', 'INF'),
    (20126, 2012, N'Angina pectoris', 'ANG'),
    (20127, 2012, N'Aneurizma', 'ANE'),
    (20128, 2012, N'Ateroskleroza', 'ATR'),
    (20129, 2012, N'Proširene vene / Tromboza', 'VEIN');

-- Generički Da/Ne odgovori za Q2, Q3, Q4, Q5, Q7, Q9
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(2021, 202, N'Da', 'YES'), (2022, 202, N'Ne', 'NO'),
(2031, 203, N'Da', 'YES'), (2032, 203, N'Ne', 'NO'),
(2041, 204, N'Da', 'YES'), (2042, 204, N'Ne', 'NO'),
(2071, 207, N'Da', 'YES'), (2072, 207, N'Ne', 'NO'),
(2091, 209, N'Da', 'YES'), (2092, 209, N'Ne', 'NO');

-- Odgovori za Sport (Q5)
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(2051, 205, N'Organizovano', 'ORG'),
(2052, 205, N'Rekreativno', 'REK'),
(2053, 205, N'Ne bavim se sportom', 'NO');

-- Odgovori za Navike (Q6)
-- Alkohol
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(2611, 261, N'Ne konzumiram', 'ALC_0'),
(2612, 261, N'Umereno', 'ALC_1'),
(2613, 261, N'Prekomerno', 'ALC_2');
-- Droga
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(2621, 262, N'Ne', 'DRG_0'),
(2622, 262, N'Da', 'DRG_1');
-- Duvan
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES 
(2631, 263, N'Ne', 'TOB_0'),
(2632, 263, N'Do 20', 'TOB_1'),
(2633, 263, N'Preko 20', 'TOB_2');

SET IDENTITY_INSERT PredefinedAnswers OFF;
GO

----------------------------------------------------------------------------------
-- LINKOVANJE (BRANCHING)
----------------------------------------------------------------------------------
-- Funkcija za autoincrement ID-a subquestion veze
DECLARE @NextLinkID INT = ISNULL((SELECT MAX(PredefinedAnswerSubQuestionID) FROM PredefinedAnswerSubQuestions), 0) + 1;

-- 1.1 Maligni -> Detalji
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 20101, 2011); SET @NextLinkID = @NextLinkID + 1;
-- 1.2 Srce -> Lista bolesti srca
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 20102, 2012); SET @NextLinkID = @NextLinkID + 1;

-- 1.2.x Detalji za svaku bolest srca
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 20121, 20121); SET @NextLinkID = @NextLinkID + 1;
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 20122, 20122); SET @NextLinkID = @NextLinkID + 1;
-- ... (nastaviti ako je potrebno za svaku, ovde primer za BP i Arhitmiju)

-- 1.8 Lokomotorni -> Detalji
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 20108, 2018); SET @NextLinkID = @NextLinkID + 1;

-- Q2 Da -> Q2.1
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 2021, 221); SET @NextLinkID = @NextLinkID + 1;
-- Q3 Da -> Q3.1
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 2031, 231); SET @NextLinkID = @NextLinkID + 1;
-- Q4 Da -> Q4.1
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 2041, 241); SET @NextLinkID = @NextLinkID + 1;

-- Q5 Sport -> Grananje
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 2051, 251); SET @NextLinkID = @NextLinkID + 1; -- Org
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 2052, 252); SET @NextLinkID = @NextLinkID + 1; -- Rekr

-- Q7 Da -> Q7.1
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 2071, 271); SET @NextLinkID = @NextLinkID + 1;
-- Q9 Da -> Q9.1
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerSubQuestionID, PredefinedAnswerID, SubQuestionID) VALUES (@NextLinkID, 2091, 291); SET @NextLinkID = @NextLinkID + 1;
GO

----------------------------------------------------------------------------------
-- KONFIGURACIJA
----------------------------------------------------------------------------------

-- 1. Povezivanje na Upitnik
INSERT INTO Questionnaires (QuestionnaireTypeID, QuestionID)
VALUES 
(3, 201), (3, 202), (3, 203), (3, 204), (3, 205), (3, 206), (3, 207), (3, 208), (3, 209);

-- 2. BMI Logika
INSERT INTO QuestionComputedConfigs (QuestionID, ComputeMethodID, RuleName, MatrixObjectName, OutputMode, MatrixOutputColumnName, Priority, IsActive)
VALUES (208, 2, 'BMI Calculation', '', 1, '', 1, 1);

-- 3. Sport Autocomplete Mapping (Za oba pitanja 251 i 252)
DECLARE @RefTableID INT;
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 3 AND TableName = 'Sports') INSERT INTO QuestionnaireTypeReferenceTables VALUES (3, 'Sports');
SELECT @RefTableID = QuestionnaireTypeReferenceTableID FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 3 AND TableName = 'Sports';

INSERT INTO QuestionReferenceColumns (QuestionReferenceColumnID, QuestionID, QuestionnaireTypeReferenceTableID, ReferenceColumnName)
VALUES 
(ISNULL((SELECT MAX(QuestionReferenceColumnID) FROM QuestionReferenceColumns), 0) + 1, 251, @RefTableID, 'SportName'),
(ISNULL((SELECT MAX(QuestionReferenceColumnID) FROM QuestionReferenceColumns), 0) + 2, 252, @RefTableID, 'SportName');
GO
