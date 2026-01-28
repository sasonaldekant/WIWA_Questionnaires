/* 
    25_Final_Clean_Setup.sql
    Generated to reset IDs and fix encodings.
*/
USE WIWA_DB_NEW;
GO

EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";
DELETE FROM QuestionComputedConfigs;
DELETE FROM PredefinedAnswerSubQuestions;
DELETE FROM PredefinedAnswers;
DELETE FROM Questionnaires;
DELETE FROM Questions;
DELETE FROM QuestionnaireTypes;

DBCC CHECKIDENT ('QuestionComputedConfigs', RESEED, 0);
DBCC CHECKIDENT ('PredefinedAnswers', RESEED, 0);
DBCC CHECKIDENT ('Questions', RESEED, 0);
DBCC CHECKIDENT ('QuestionnaireTypes', RESEED, 0);

SET IDENTITY_INSERT QuestionnaireTypes ON;
INSERT INTO QuestionnaireTypes (QuestionnaireTypeID, Name, Code) VALUES 
(1, N'Upitnik lokacije', 'LOC_QUEST'),
(2, N'Skraćeni upitnik', 'SHORT_QUEST'), 
(3, N'Veliki upitnik', 'GREAT_QUEST');
SET IDENTITY_INSERT QuestionnaireTypes OFF;

SET IDENTITY_INSERT Questions ON;
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (1, N'Da li se na lokaciji skladi�te zalihe robe', 10, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (2, N'Da li se skladi�te zapaljive materije (boje i lakovi, ulja, alkoholi, razredivaci, nafta i goriva, pirotehnika, zemni gas, industrijski plin, materije podlo�ne samozapaljenju i sl.)', 20, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (3, N'Da li se skladi�te voce, povrce, gvo�de, kamena roba, cementni proizvodi, �ljunak i sl.', 30, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (4, N'Gradevinska kategorija - Spolja�nji zidovi', 40, 9, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (5, N'Gradevinska kategorija - Krovni pokrivac', 50, 9, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (6, N'Gradevinska kategorija - Konstrukcija objekta', 60, 9, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (7, N'Izaberite spratnost objekta', 70, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (8, N'Klasa za�titnih mera - udaljenost vatrogasne jedinice', 80, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (9, N'Gradevinska kategorija', 90, NULL, 0, 1, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (10, N'Visina (cm)', 100, 12, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (11, N'Te�ina (kg)', 110, 12, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (12, N'BMI Index', 120, NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (13, N'Naziv zdravstvene ustanove kod koje klijent ima otvoren zdravstveni karton', 130, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (14, N'Da li ste ikada bolovali ili sada bolujete... (Lista bolesti)', 140, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (15, N'Da li se trenutno nalazite na ispitivanju...', 150, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (16, N'Da li Vam je utvrdena trajna nesposobnost/invaliditet?', 160, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (17, N'Da li se bavite nekim sportom?', 170, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (18, N'Da li ste izlo�eni povecanom riziku od povredivanja?', 180, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (19, N'Da li vam je ranije odbijena ponuda?', 190, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (20, N'Da li ste bolovali ili trenutno bolujete od:', 200, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (21, N'Koje oboljenje:', 210, 14, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (22, N'Detalji (Lista bolesti):', 220, 15, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (23, N'Detalji (Invaliditet):', 230, 16, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (24, N'Detalji (Sport):', 240, 17, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (25, N'Detalji (Rizik povređivanja):', 250, 18, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (26, N'Detalji (Odbijena ponuda):', 260, 19, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (27, N'Detalji (Maligni tumori):', 270, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (28, N'Koje bolesti srca i krvnih sudova (oznacite):', 280, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (29, N'Detalji (Povi�en pritisak):', 290, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (30, N'Detalji (Aritmija):', 300, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (31, N'Detalji (Tahikardija):', 310, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (32, N'Detalji (Mane/Slabosti):', 320, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (33, N'Detalji (Infarkt):', 330, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (34, N'Detalji (Angina):', 340, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (35, N'Detalji (Aneurizma):', 350, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (36, N'Detalji (Ateroskleroza):', 360, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (37, N'Detalji (Vene):', 370, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (38, N'Detalji (Tromboza):', 380, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (39, N'Koje bolesti metabolizma (oznacite):', 390, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (40, N'Detalji (Dijabetes):', 400, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (41, N'Detalji (Giht):', 410, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (42, N'Detalji (�titna �lezda):', 420, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (43, N'Detalji (Nadbubre�na):', 430, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (44, N'Detalji (Hipofiza):', 440, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (45, N'Koje bolesti disajnog sistema (oznacite):', 450, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (46, N'Detalji (Bronhitis):', 460, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (47, N'Detalji (HOBP):', 470, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (48, N'Detalji (Astma):', 480, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (49, N'Detalji (Emfizem):', 490, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (50, N'Detalji (Embolija):', 500, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (51, N'Detalji (Tuberkuloza):', 510, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (52, N'Koje bolesti uro-genitalnog sistema (oznacite):', 520, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (53, N'Detalji (Bubrezi):', 530, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (54, N'Detalji (Mokracni kanali):', 540, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (55, N'Detalji (Prostata):', 550, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (56, N'Detalji (Testisi):', 560, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (57, N'Detalji (Materica):', 570, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (58, N'Detalji (Jajnici):', 580, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (59, N'Detalji (Dojka):', 590, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (60, N'Koje bolesti krvi/imunog sistema (oznacite):', 600, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (61, N'Detalji (Leukemija):', 610, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (62, N'Detalji (Limfomi):', 620, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (63, N'Detalji (HIV/SIDA):', 630, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (64, N'Detalji (Lupus):', 640, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (65, N'Detalji (Vezivno tkivo):', 650, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (66, N'Koje bolesti digestivnog sistema (oznacite):', 660, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (67, N'Detalji (Cir):', 670, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (68, N'Detalji (Kron):', 680, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (69, N'Detalji (Kolitis):', 690, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (70, N'Detalji (Hepatitis):', 700, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (71, N'Detalji (Ciroza):', 710, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (72, N'Detalji (�uc):', 720, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (73, N'Detalji (Pankreas):', 730, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (74, N'Detalji (Lokomotorni):', 740, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (75, N'Koje bolesti nervnog sistema (oznacite):', 750, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (76, N'Detalji (Pareze):', 760, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (77, N'Detalji (Epilepsija):', 770, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (78, N'Detalji (�log):', 780, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (79, N'Detalji (MS):', 790, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (80, N'Detalji (Distrofije):', 800, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (81, N'Detalji (Parkinson):', 810, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (82, N'Detalji (Alchajmer):', 820, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (83, N'Detalji (Psihoze/Depresija):', 830, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (84, N'Detalji (Vid/Sluh):', 840, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (85, N'Visina dioptrije:', 850, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (86, N'Detalji (Ko�ne promene):', 860, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (87, N'Detalji (Povrede/Tegobe):', 870, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (88, N'Da li bolujete od bolesti koja nije navedena ili imate telesni nedostatak?', 880, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (89, N'Navedite koja je bolest:', 890, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (90, N'Da li se trenutno nalazite na ispitivanju ili cekate rezultate?', 900, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (91, N'Navedite detalje:', 910, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (92, N'Da li ste izlo�eni povecanom riziku od povredivanja?', 920, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (93, N'Navesti opasnost:', 930, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (94, N'Da li se bavite sportom?', 940, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (95, N'Organizovano:', 950, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (96, N'Rekreativno:', 960, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (97, N'Da li redovno konzumirate:', 970, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (98, N'Alkohol', 980, 97, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (99, N'Drogu/Narkotike', 990, 97, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (100, N'Cigarete/Duvan', 1000, 97, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (101, N'Uzimate li redovno lekove?', 1010, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (102, N'Navedite koji lekovi i kolicinu:', 1020, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (103, N'BMI Index', 1030, NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (104, N'Visina (cm)', 1040, 103, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (105, N'Te�ina (kg)', 1050, 103, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (106, N'Da li imate otvoren zdravstveni karton?', 1060, NULL, 1, 0, NULL, NULL, NULL);
INSERT INTO Questions (QuestionID, QuestionText, QuestionOrder, ParentQuestionID, IsRequired, ReadOnly, ValidationPattern, QuestionFormatID, SpecificQuestionTypeID) VALUES (107, N'Naziv ustanove i od kada:', 1070, NULL, 1, 0, NULL, NULL, NULL);
SET IDENTITY_INSERT Questions OFF;

INSERT INTO Questionnaires (QuestionnaireTypeID, QuestionID) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(3, 20),
(3, 21),
(3, 22),
(3, 23),
(3, 24),
(3, 25),
(3, 26),
(3, 27),
(3, 28),
(3, 29),
(3, 30),
(3, 31),
(3, 32),
(3, 33),
(3, 34),
(3, 35),
(3, 36),
(3, 37),
(3, 38),
(3, 39),
(3, 40),
(3, 41),
(3, 42),
(3, 43),
(3, 44),
(3, 45),
(3, 46),
(3, 47),
(3, 48),
(3, 49),
(3, 50),
(3, 51),
(3, 52),
(3, 53),
(3, 54),
(3, 55),
(3, 56),
(3, 57),
(3, 58),
(3, 59),
(3, 60),
(3, 61),
(3, 62),
(3, 63),
(3, 64),
(3, 65),
(3, 66),
(3, 67),
(3, 68),
(3, 69),
(3, 70),
(3, 71),
(3, 72),
(3, 73),
(3, 74),
(3, 75),
(3, 76),
(3, 77),
(3, 78),
(3, 79),
(3, 80),
(3, 81),
(3, 82),
(3, 83),
(3, 84),
(3, 85),
(3, 86),
(3, 87),
(3, 88),
(3, 89),
(3, 90),
(3, 91),
(3, 92),
(3, 93),
(3, 94),
(3, 95),
(3, 96),
(3, 97),
(3, 98),
(3, 99),
(3, 100),
(3, 101),
(3, 102),
(3, 103),
(3, 104),
(3, 105),
(3, 106),
(3, 107);

SET IDENTITY_INSERT PredefinedAnswers ON;
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (1, 1, N'Da', NULL);
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (2, 1, N'Ne', N'2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (3, 2, N'Da', N'3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (4, 2, N'Ne', NULL);
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (5, 3, N'Da', N'1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (6, 3, N'Ne', N'2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (7, 4, N'Kamen / opeka / cigla / beton', N'1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (8, 4, N'Metalni sendvic paneli', N'2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (9, 4, N'Drvo i drugi gorivi i slabi materijali', N'3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (10, 5, N'Beton / crep / salonit / eternit / lim', N'1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (11, 5, N'Drvo / trska / slama / plastika', N'2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (12, 6, N'Armirano-betonske konstrukcije', N'1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (13, 6, N'Celicna konstrukcija', N'2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (14, 6, N'Drvena konstrukcija', N'3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (15, 7, N'Prizemne i jednospratne zgrade', N'4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (16, 7, N'Zgrade sa dva i vi�e sprata', N'5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (17, 8, N'A - do 15 min (do 15 km)', N'1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (18, 8, N'B - 15 do 30 min (15-30 km)', N'2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (19, 8, N'C - preko 30 min (preko 30 km)', N'3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (20, 9, N'Masivna', N'8');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (21, 9, N'Polumasivna', N'6');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (22, 9, N'Laka', N'7');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (23, 14, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (24, 14, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (25, 15, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (26, 15, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (27, 16, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (28, 16, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (29, 17, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (30, 17, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (31, 18, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (32, 18, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (33, 19, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (34, 19, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (35, 20, N'1.1 Maligni tumori', N'1.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (36, 20, N'1.2 Bolesti srca', N'1.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (37, 20, N'1.3 Bolesti metabolizma', N'1.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (38, 20, N'1.4 Bolesti disajnog sistema', N'1.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (39, 20, N'1.5 Bolesti uro-genitalnog sistema', N'1.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (40, 20, N'1.6 Bolesti krvi/imunog sistema', N'1.6');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (41, 20, N'1.7 Bolesti digestivnog sistema', N'1.7');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (42, 20, N'1.8 Bolesti lokomotornog sistema', N'1.8');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (43, 20, N'1.9 Nervne i psihicke bolesti', N'1.9');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (44, 20, N'1.10 Bolesti cula vida i sluha', N'1.10');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (45, 20, N'1.11 Ko�ne bolesti', N'1.11');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (46, 20, N'1.12 Tegobe od ranije', N'1.12');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (47, 28, N'1.2.1 Povi�en pritisak', N'1.2.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (48, 28, N'1.2.2 Aritmija', N'1.2.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (49, 28, N'1.2.3 Tahikardija', N'1.2.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (50, 28, N'1.2.4 Mane/Slabosti', N'1.2.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (51, 28, N'1.2.5 Infarkt', N'1.2.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (52, 28, N'1.2.6 Angina pectoris', N'1.2.6');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (53, 28, N'1.2.7 Aneurizma', N'1.2.7');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (54, 28, N'1.2.8 Ateroskleroza', N'1.2.8');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (55, 28, N'1.2.9 Vene', N'1.2.9');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (56, 28, N'1.2.10 Tromboza', N'1.2.10');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (57, 39, N'1.3.1 Dijabetes', N'1.3.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (58, 39, N'1.3.2 Giht', N'1.3.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (59, 39, N'1.3.3 �titna �lezda', N'1.3.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (60, 39, N'1.3.4 Nadbubre�na', N'1.3.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (61, 39, N'1.3.5 Hipofiza', N'1.3.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (62, 45, N'1.4.1 Bronhitis', N'1.4.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (63, 45, N'1.4.2 HOBP', N'1.4.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (64, 45, N'1.4.3 Astma', N'1.4.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (65, 45, N'1.4.4 Emfizem', N'1.4.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (66, 45, N'1.4.5 Embolija', N'1.4.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (67, 45, N'1.4.6 Tuberkuloza', N'1.4.6');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (68, 52, N'1.5.1 Bubrezi', N'1.5.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (69, 52, N'1.5.2 Mokracni kanali', N'1.5.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (70, 52, N'1.5.3 Prostata', N'1.5.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (71, 52, N'1.5.4 Testisi', N'1.5.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (72, 52, N'1.5.5 Materica', N'1.5.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (73, 52, N'1.5.6 Jajnici', N'1.5.6');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (74, 52, N'1.5.7 Dojka', N'1.5.7');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (75, 60, N'1.6.1 Leukemija', N'1.6.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (76, 60, N'1.6.2 Limfomi', N'1.6.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (77, 60, N'1.6.3 HIV/SIDA', N'1.6.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (78, 60, N'1.6.4 Lupus', N'1.6.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (79, 60, N'1.6.5 Vezivno tkivo', N'1.6.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (80, 66, N'1.7.1 Cir', N'1.7.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (81, 66, N'1.7.2 Kron', N'1.7.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (82, 66, N'1.7.3 Kolitis', N'1.7.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (83, 66, N'1.7.4 Hepatitis', N'1.7.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (84, 66, N'1.7.5 Ciroza', N'1.7.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (85, 66, N'1.7.6 �uc', N'1.7.6');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (86, 66, N'1.7.7 Pankreas', N'1.7.7');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (87, 75, N'1.9.1 Pareze', N'1.9.1');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (88, 75, N'1.9.2 Epilepsija', N'1.9.2');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (89, 75, N'1.9.3 �log', N'1.9.3');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (90, 75, N'1.9.4 MS', N'1.9.4');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (91, 75, N'1.9.5 Distrofije', N'1.9.5');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (92, 75, N'1.9.6 Parkinson', N'1.9.6');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (93, 75, N'1.9.7 Alchajmer', N'1.9.7');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (94, 75, N'1.9.8 Psihoze', N'1.9.8');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (95, 88, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (96, 88, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (97, 90, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (98, 90, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (99, 92, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (100, 92, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (101, 94, N'Organizovano', N'ORG');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (102, 94, N'Rekreativno', N'REK');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (103, 94, N'Ne bavim se', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (104, 98, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (105, 98, N'Umereno', N'MOD');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (106, 98, N'Prekomerno', N'EXC');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (107, 99, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (108, 99, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (109, 100, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (110, 100, N'Do 20', N'LOW');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (111, 100, N'Preko 20', N'HIGH');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (112, 101, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (113, 101, N'Ne', N'NO');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (114, 106, N'Da', N'YES');
INSERT INTO PredefinedAnswers (PredefinedAnswerID, QuestionID, Answer, Code) VALUES (115, 106, N'Ne', N'NO');
SET IDENTITY_INSERT PredefinedAnswers OFF;

SET IDENTITY_INSERT QuestionComputedConfigs ON;
INSERT INTO QuestionComputedConfigs (QuestionComputedConfigID, QuestionID, RuleName, FormulaExpression, ComputeMethodID, MatrixObjectName, MatrixOutputColumnName, Priority, IsActive, OutputMode, OutputTarget) VALUES (1, 9, N'Building category (computed)', NULL, 1, 'BuildingCategoryMatrix', 'ConstructionType', 100, 1, 1, 'Value');
INSERT INTO QuestionComputedConfigs (QuestionComputedConfigID, QuestionID, RuleName, FormulaExpression, ComputeMethodID, MatrixObjectName, MatrixOutputColumnName, Priority, IsActive, OutputMode, OutputTarget) VALUES (2, 103, N'BMI Calculation', N'{105} / Math.pow({104}/100, 2)', 2, 'BMI_Formula', 'Value', 1, 1, 1, 'Value');
INSERT INTO QuestionComputedConfigs (QuestionComputedConfigID, QuestionID, RuleName, FormulaExpression, ComputeMethodID, MatrixObjectName, MatrixOutputColumnName, Priority, IsActive, OutputMode, OutputTarget) VALUES (3, 12, N'BMI Calculation', N'{11} / Math.pow({10}/100, 2)', 2, 'BMI_Formula', 'Value', 1, 1, 1, 'Value');
SET IDENTITY_INSERT QuestionComputedConfigs OFF;

EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all";
