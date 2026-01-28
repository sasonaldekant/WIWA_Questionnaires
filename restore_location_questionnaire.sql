USE [WIWA_DB_NEW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cleanup Section
PRINT 'Cleaning up...'
DELETE FROM QuestionComputedConfigs WHERE QuestionID BETWEEN 1 AND 9
DELETE FROM QuestionReferenceColumns WHERE QuestionID BETWEEN 1 AND 9
-- Delete links from PredefinedAnswerSubQuestions where the SubQuestion is 1-9 or the Answer belongs to 1-9
DELETE FROM PredefinedAnswerSubQuestions WHERE SubQuestionID BETWEEN 1 AND 9
DELETE FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerID IN (SELECT PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID BETWEEN 1 AND 9)

DELETE FROM PredefinedAnswers WHERE QuestionID BETWEEN 1 AND 9
DELETE FROM Questionnaires WHERE QuestionID BETWEEN 1 AND 9
DELETE FROM Questions WHERE QuestionID BETWEEN 1 AND 9

-- Cleanup Types
IF EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE QuestionnaireTypeID = 1)
BEGIN
    DELETE FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 1
    DELETE FROM QuestionnaireTypes WHERE QuestionnaireTypeID = 1
END

PRINT 'Inserting data...'

-- SpecificQuestionTypes
IF NOT EXISTS (SELECT 1 FROM SpecificQuestionTypes WHERE SpecificQuestionTypeID = 3)
BEGIN
    SET IDENTITY_INSERT [dbo].[SpecificQuestionTypes] ON 
    INSERT [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID], [Name]) VALUES (3, N'Computed')
    SET IDENTITY_INSERT [dbo].[SpecificQuestionTypes] OFF
END

-- Questions (Preserve Explicit IDs 1-9)
SET IDENTITY_INSERT [dbo].[Questions] ON 
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (1, N'Da li se na lokaciji skladište zalihe robe', 1, 2, NULL, N'1', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (2, N'Da li se skladište zapaljive materije (boje i lakovi, ulja, alkoholi, razređivači, nafta i goriva, pirotehnika, zemni gas, industrijski plin, materije podložne samozapaljenju i sl.)', 2, 2, NULL, N'1.1', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (3, N'Da li se skladište voće, povrće, gvožđe, kamena roba, cementni proizvodi, šljunak i sl.', 3, 2, NULL, N'1.1.1', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (4, N'Građevinska kategorija - Spoljašnji zidovi', 5, 2, 1, N'2.1', 9, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (5, N'Građevinska kategorija - Krovni pokrivač', 6, 2, 1, N'2.2', 9, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (6, N'Građevinska kategorija - Konstrukcija objekta', 7, 2, 1, N'2.3', 9, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (7, N'Izaberite spratnost objekta', 8, 2, 2, N'2.4', NULL, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (8, N'Klasa zaštitnih mera - udaljenost vatrogasne jedinice', 9, 2, NULL, N'3', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (9, N'Građevinska kategorija', 4, 2, 3, N'2', NULL, 1)
SET IDENTITY_INSERT [dbo].[Questions] OFF

-- PredefinedAnswers (Use Auto IDs to avoid conflict)
-- Removed SET IDENTITY_INSERT ON
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (1, 0, N'Da', NULL, NULL)
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (1, 0, N'Ne', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (2, 0, N'Da', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (2, 0, N'Ne', NULL, NULL)
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (3, 0, N'Da', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (3, 0, N'Ne', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (4, 0, N'Kamen / opeka / cigla / beton', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (4, 0, N'Metalni sendvič paneli', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (4, 0, N'Drvo i drugi gorivi i slabi materijali', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (5, 0, N'Beton / crep / salonit / eternit / lim', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (5, 0, N'Drvo / trska / slama / plastika', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (6, 0, N'Armirano-betonske konstrukcije', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (6, 0, N'Čelična konstrukcija', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (6, 0, N'Drvena konstrukcija', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (7, 0, N'Prizemne i jednospratne zgrade', NULL, N'4')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (7, 0, N'Zgrade sa dva i više sprata', NULL, N'5')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (8, 0, N'A - do 15 min (do 15 km)', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (8, 0, N'B - 15 do 30 min (15-30 km)', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (8, 0, N'C - preko 30 min (preko 30 km)', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (9, 0, N'Masivna', NULL, N'8')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (9, 0, N'Polumasivna', NULL, N'6')
INSERT [dbo].[PredefinedAnswers] ([QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (9, 0, N'Laka', NULL, N'7')

-- QuestionnaireTypes (Explicit ID 1)
SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] ON 
INSERT [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID], [Name], [Code], [QuestionnaireCategoryID]) VALUES (1, N'Upitnik lokacije - podaci za PremiumRateMatrix', N'LOC_QUEST', 1)
SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] OFF

-- PredefinedAnswerSubQuestions (Dynamic Linking)
-- Link 1: Answer 'Da' (Q1) -> SubQuestion 2
DECLARE @Ans1 INT = (SELECT TOP 1 PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID = 1 AND Answer = 'Da')
-- Link 2: Answer 'Ne' (Q2) -> SubQuestion 3
DECLARE @Ans4 INT = (SELECT TOP 1 PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID = 2 AND Answer = 'Ne')
-- Link 3: Answer 'Masivna' (Q9) -> SubQuestion 7 (Note: Dump used ID 25 for Masivna)
DECLARE @Ans25 INT = (SELECT TOP 1 PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID = 9 AND Answer = 'Masivna')

INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (100, @Ans1, 2)
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (101, @Ans4, 3)
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (102, @Ans25, 7)

-- QuestionnaireTypeReferenceTables (Explicit IDs)
SET IDENTITY_INSERT [dbo].[QuestionnaireTypeReferenceTables] ON 
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (1, 1, N'ConstructionMaterials')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (2, 1, N'ConstructionTypes')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (3, 1, N'ExternalWallMaterials')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (4, 1, N'HazardClasses')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (9, 1, N'MethodsOfContracting')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (5, 1, N'ProtectionClasses')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (6, 1, N'RoofCoveringMaterials')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (7, 1, N'StorageAreas')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (8, 1, N'TariffGroups')
SET IDENTITY_INSERT [dbo].[QuestionnaireTypeReferenceTables] OFF

-- QuestionReferenceColumns (No Identity)
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (1, 4, 3, N'ExternalWallMaterialID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (2, 5, 6, N'RoofCoveringMaterialID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (3, 6, 1, N'ConstructionMaterialID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (4, 7, 2, N'ConstructionTypeID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (5, 8, 5, N'ProtectionClassID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (6, 9, 2, N'ConstructionTypeID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (7, 1, 8, N'TariffGroupID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (8, 2, 4, N'HazardClassID')

-- Questionnaires (Explicit IDs)
SET IDENTITY_INSERT [dbo].[Questionnaires] ON 
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (1, 1, 1)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (2, 1, 2)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (3, 1, 3)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (4, 1, 4)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (5, 1, 5)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (6, 1, 6)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (7, 1, 7)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (8, 1, 8)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (9, 1, 9)
SET IDENTITY_INSERT [dbo].[Questionnaires] OFF

-- ComputeMethods
IF NOT EXISTS (SELECT 1 FROM ComputeMethods WHERE ComputeMethodID = 1)
BEGIN
    SET IDENTITY_INSERT [dbo].[ComputeMethods] ON 
    INSERT [dbo].[ComputeMethods] ([ComputeMethodID], [Code], [Name], [Description], [IsActive]) VALUES (1, N'MATRIX', N'Matrix lookup (table/view)', N'Generic matrix lookup. Inputs are derived from ParentQuestionID children + QuestionReferenceColumns.ReferenceColumnName; output is MatrixOutputColumnName.', 1)
    SET IDENTITY_INSERT [dbo].[ComputeMethods] OFF
END

-- QuestionComputedConfigs
SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] ON 
INSERT [dbo].[QuestionComputedConfigs] ([QuestionComputedConfigID], [QuestionID], [ComputeMethodID], [MatrixObjectName], [RuleName], [RuleDescription], [OutputMode], [OutputTarget], [MatrixOutputColumnName], [Priority], [IsActive]) VALUES (1, 9, 1, N'BuildingCategoryMatrix', N'Building category (computed)', N'Compute BuildingCategory / ConstructionType based on child questions (ParentQuestionID) and their reference columns; select PredefinedAnswer by Code.', 1, NULL, N'ConstructionTypeID', 100, 1)
SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] OFF

PRINT 'Restoration complete.'
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cleanup Section: Delete existing data for Location Questionnaire (IDs 1-9)
-- Order: Configs -> RefCols -> SubAnswers -> Answers -> Questionnaires -> Questions -> TypeRefTables -> Types

PRINT 'Cleaning up existing Location Questionnaire data...'

DELETE FROM QuestionComputedConfigs WHERE QuestionID BETWEEN 1 AND 9
DELETE FROM QuestionReferenceColumns WHERE QuestionID BETWEEN 1 AND 9
-- Delete links from PredefinedAnswerSubQuestions where the SubQuestion is 1-9 or the Answer belongs to 1-9
DELETE FROM PredefinedAnswerSubQuestions WHERE SubQuestionID BETWEEN 1 AND 9
DELETE FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerID IN (SELECT PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID BETWEEN 1 AND 9)

DELETE FROM PredefinedAnswers WHERE QuestionID BETWEEN 1 AND 9
DELETE FROM Questionnaires WHERE QuestionID BETWEEN 1 AND 9
DELETE FROM Questions WHERE QuestionID BETWEEN 1 AND 9

-- Cleanup Types if they are specific to this questionnaire (ID 1)
-- Check if any other questionnaire uses Type 1 (unlikely based on name)
IF EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE QuestionnaireTypeID = 1)
BEGIN
    DELETE FROM QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = 1
    DELETE FROM QuestionnaireTypes WHERE QuestionnaireTypeID = 1
END

PRINT 'Cleanup complete. Inserting data...'

-- Insert Section: Restore from dump

-- SpecificQuestionTypes (Computed - ID 3)
IF NOT EXISTS (SELECT 1 FROM SpecificQuestionTypes WHERE SpecificQuestionTypeID = 3)
BEGIN
    SET IDENTITY_INSERT [dbo].[SpecificQuestionTypes] ON 
    INSERT [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID], [Name]) VALUES (3, N'Computed')
    SET IDENTITY_INSERT [dbo].[SpecificQuestionTypes] OFF
END

-- Questions
SET IDENTITY_INSERT [dbo].[Questions] ON 
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (1, N'Da li se na lokaciji skladište zalihe robe', 1, 2, NULL, N'1', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (2, N'Da li se skladište zapaljive materije (boje i lakovi, ulja, alkoholi, razređivači, nafta i goriva, pirotehnika, zemni gas, industrijski plin, materije podložne samozapaljenju i sl.)', 2, 2, NULL, N'1.1', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (3, N'Da li se skladište voće, povrće, gvožđe, kamena roba, cementni proizvodi, šljunak i sl.', 3, 2, NULL, N'1.1.1', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (4, N'Građevinska kategorija - Spoljašnji zidovi', 5, 2, 1, N'2.1', 9, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (5, N'Građevinska kategorija - Krovni pokrivač', 6, 2, 1, N'2.2', 9, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (6, N'Građevinska kategorija - Konstrukcija objekta', 7, 2, 1, N'2.3', 9, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (7, N'Izaberite spratnost objekta', 8, 2, 2, N'2.4', NULL, 0)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (8, N'Klasa zaštitnih mera - udaljenost vatrogasne jedinice', 9, 2, NULL, N'3', NULL, NULL)
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly]) VALUES (9, N'Građevinska kategorija', 4, 2, 3, N'2', NULL, 1)
SET IDENTITY_INSERT [dbo].[Questions] OFF

-- PredefinedAnswers
SET IDENTITY_INSERT [dbo].[PredefinedAnswers] ON 
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (1, 1, 0, N'Da', NULL, NULL)
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (2, 1, 0, N'Ne', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (3, 2, 0, N'Da', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (4, 2, 0, N'Ne', NULL, NULL)
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (5, 3, 0, N'Da', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (6, 3, 0, N'Ne', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (7, 4, 0, N'Kamen / opeka / cigla / beton', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (8, 4, 0, N'Metalni sendvič paneli', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (9, 4, 0, N'Drvo i drugi gorivi i slabi materijali', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (10, 5, 0, N'Beton / crep / salonit / eternit / lim', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (11, 5, 0, N'Drvo / trska / slama / plastika', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (12, 6, 0, N'Armirano-betonske konstrukcije', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (13, 6, 0, N'Čelična konstrukcija', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (14, 6, 0, N'Drvena konstrukcija', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (15, 7, 0, N'Prizemne i jednospratne zgrade', NULL, N'4')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (16, 7, 0, N'Zgrade sa dva i više sprata', NULL, N'5')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (17, 8, 0, N'A - do 15 min (do 15 km)', NULL, N'1')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (18, 8, 0, N'B - 15 do 30 min (15-30 km)', NULL, N'2')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (19, 8, 0, N'C - preko 30 min (preko 30 km)', NULL, N'3')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (25, 9, 0, N'Masivna', NULL, N'8')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (26, 9, 0, N'Polumasivna', NULL, N'6')
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code]) VALUES (27, 9, 0, N'Laka', NULL, N'7')
SET IDENTITY_INSERT [dbo].[PredefinedAnswers] OFF

-- QuestionnaireTypes
SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] ON 
INSERT [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID], [Name], [Code], [QuestionnaireCategoryID]) VALUES (1, N'Upitnik lokacije - podaci za PremiumRateMatrix', N'LOC_QUEST', 1)
SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] OFF

-- PredefinedAnswerSubQuestions API seems not to be Identity in previous tasks, but I'll check.
-- Previous task showed it IS NOT IDENTITY. So INSERT with explicit ID specified in dump is fine, but I must provide the column.
-- The dump uses: INSERT ... ([PredefinedAnswerSubQuestionID] ... VALUES (1...
-- Wait, if IS_IDENTITY is 0, I can directly insert.
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (100, 1, 2)
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (101, 4, 3)
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (102, 25, 7)

-- QuestionnaireTypeReferenceTables
SET IDENTITY_INSERT [dbo].[QuestionnaireTypeReferenceTables] ON 
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (1, 1, N'ConstructionMaterials')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (2, 1, N'ConstructionTypes')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (3, 1, N'ExternalWallMaterials')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (4, 1, N'HazardClasses')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (9, 1, N'MethodsOfContracting')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (5, 1, N'ProtectionClasses')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (6, 1, N'RoofCoveringMaterials')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (7, 1, N'StorageAreas')
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (8, 1, N'TariffGroups')
SET IDENTITY_INSERT [dbo].[QuestionnaireTypeReferenceTables] OFF

-- QuestionReferenceColumns
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (1, 4, 3, N'ExternalWallMaterialID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (2, 5, 6, N'RoofCoveringMaterialID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (3, 6, 1, N'ConstructionMaterialID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (4, 7, 2, N'ConstructionTypeID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (5, 8, 5, N'ProtectionClassID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (6, 9, 2, N'ConstructionTypeID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (7, 1, 8, N'TariffGroupID')
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (8, 2, 4, N'HazardClassID')

-- Questionnaires
SET IDENTITY_INSERT [dbo].[Questionnaires] ON 
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (1, 1, 1)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (2, 1, 2)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (3, 1, 3)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (4, 1, 4)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (5, 1, 5)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (6, 1, 6)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (7, 1, 7)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (8, 1, 8)
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (9, 1, 9)
SET IDENTITY_INSERT [dbo].[Questionnaires] OFF

-- ComputeMethods (ID 1 Matrix)
IF NOT EXISTS (SELECT 1 FROM ComputeMethods WHERE ComputeMethodID = 1)
BEGIN
    SET IDENTITY_INSERT [dbo].[ComputeMethods] ON 
    INSERT [dbo].[ComputeMethods] ([ComputeMethodID], [Code], [Name], [Description], [IsActive]) VALUES (1, N'MATRIX', N'Matrix lookup (table/view)', N'Generic matrix lookup. Inputs are derived from ParentQuestionID children + QuestionReferenceColumns.ReferenceColumnName; output is MatrixOutputColumnName.', 1)
    SET IDENTITY_INSERT [dbo].[ComputeMethods] OFF
END

-- QuestionComputedConfigs
SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] ON 
INSERT [dbo].[QuestionComputedConfigs] ([QuestionComputedConfigID], [QuestionID], [ComputeMethodID], [MatrixObjectName], [RuleName], [RuleDescription], [OutputMode], [OutputTarget], [MatrixOutputColumnName], [Priority], [IsActive]) VALUES (1, 9, 1, N'BuildingCategoryMatrix', N'Building category (computed)', N'Compute BuildingCategory / ConstructionType based on child questions (ParentQuestionID) and their reference columns; select PredefinedAnswer by Code.', 1, NULL, N'ConstructionTypeID', 100, 1)
SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] OFF

PRINT 'Location Questionnaire restoration complete.'
