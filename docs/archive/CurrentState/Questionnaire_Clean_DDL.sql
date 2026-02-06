USE [master];
GO
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'WIWA_Questionnaires_DB')
BEGIN
    CREATE DATABASE [WIWA_Questionnaires_DB]
END
GO
USE [WIWA_Questionnaires_DB];
GO
CREATE TABLE [dbo].[Questionnaires] (
        [QuestionnaireID] int NOT NULL IDENTITY(1,1),
    [QuestionnaireTypeID] smallint NOT NULL,
    [QuestionID] int NOT NULL,
    CONSTRAINT [PK_Questionaries_QuestionaryID] PRIMARY KEY CLUSTERED ([QuestionnaireID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionnaireTypes] (
        [QuestionnaireTypeID] smallint NOT NULL IDENTITY(1,1),
    [Name] nvarchar(100) NOT NULL,
    [Code] nvarchar(20) NOT NULL,
    [QuestionnaireCategoryID] smallint NULL,
    CONSTRAINT [PK_QuestionaryTypes_QuestionaryTypeID] PRIMARY KEY CLUSTERED ([QuestionnaireTypeID] ASC)
);
GO
CREATE TABLE [dbo].[Questions] (
        [QuestionID] int NOT NULL IDENTITY(1,1),
    [QuestionText] nvarchar(2000) NOT NULL,
    [QuestionOrder] int NULL,
    [QuestionFormatID] smallint NULL,
    [SpecificQuestionTypeID] int NULL,
    [QuestionLabel] nvarchar(10) NULL,
    [ParentQuestionID] int NULL,
    [ReadOnly] bit NULL,
    [IsRequired] bit NOT NULL DEFAULT ((0)),
    [ValidationPattern] nvarchar(255) NULL,
    CONSTRAINT [PK_Questions_QuestionID] PRIMARY KEY CLUSTERED ([QuestionID] ASC)
);
GO
CREATE TABLE [dbo].[SpecificQuestionTypes] (
        [SpecificQuestionTypeID] int NOT NULL IDENTITY(1,1),
    [Name] nvarchar(250) NULL,
    CONSTRAINT [PK_SpecificQuestionTypes] PRIMARY KEY CLUSTERED ([SpecificQuestionTypeID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionFormats] (
        [QuestionFormatID] smallint NOT NULL IDENTITY(1,1),
    [Name] nvarchar(200) NOT NULL,
    [Code] nvarchar(50) NOT NULL,
    [Description] nvarchar(500) NULL,
    CONSTRAINT [PK_QuestionFormat_QuestionFormatID] PRIMARY KEY CLUSTERED ([QuestionFormatID] ASC)
);
GO
CREATE TABLE [dbo].[PredefinedAnswers] (
        [PredefinedAnswerID] int NOT NULL IDENTITY(1,1),
    [QuestionID] int NOT NULL,
    [PreSelected] bit NOT NULL DEFAULT ((0)),
    [Answer] nvarchar(2000) NOT NULL,
    [StatisticalWeight] decimal(18, 2) NULL,
    [Code] nvarchar(50) NULL,
    [DisplayOrder] int NOT NULL DEFAULT ((0)),
    CONSTRAINT [PK_PredefinedAnswers_PredefinedAnswerID] PRIMARY KEY CLUSTERED ([PredefinedAnswerID] ASC)
);
GO
CREATE TABLE [dbo].[PredefinedAnswerSubQuestions] (
        [PredefinedAnswerSubQuestionID] int NOT NULL IDENTITY(1,1),
    [PredefinedAnswerID] int NOT NULL,
    [SubQuestionID] int NOT NULL,
    CONSTRAINT [PK_PredefinedAnswerSubQuestions_PredefinedAnswerSubQuestionID] PRIMARY KEY CLUSTERED ([PredefinedAnswerSubQuestionID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionComputedConfigs] (
        [QuestionComputedConfigID] int NOT NULL IDENTITY(1,1),
    [QuestionID] int NOT NULL,
    [ComputeMethodID] smallint NOT NULL,
    [MatrixObjectName] nvarchar(128) NOT NULL,
    [RuleName] nvarchar(200) NULL,
    [RuleDescription] nvarchar(1000) NULL,
    [OutputMode] tinyint NOT NULL,
    [OutputTarget] nvarchar(256) NULL,
    [MatrixOutputColumnName] nvarchar(128) NOT NULL,
    [Priority] smallint NOT NULL DEFAULT ((100)),
    [IsActive] bit NOT NULL DEFAULT ((1)),
    [FormulaExpression] nvarchar(MAX) NULL,
    CONSTRAINT [PK_QuestionComputedConfigs] PRIMARY KEY CLUSTERED ([QuestionComputedConfigID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionnaireIdentificators] (
        [QuestionnaireIdentificatorID] bigint NOT NULL IDENTITY(1,1),
    [QuestionnaireIdentificatorTypeID] int NOT NULL,
    [Identificator] nvarchar(20) NOT NULL,
    [UserID] int NOT NULL,
    [PoliticalPerson] bit NOT NULL,
    CONSTRAINT [PK_QuestionnarieIdentificator] PRIMARY KEY CLUSTERED ([QuestionnaireIdentificatorID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators] (
        [QuestionnaireByQuestionnaireIdentificatorID] int NOT NULL IDENTITY(1,1),
    [QuestionnaireIdentificatorID] bigint NOT NULL,
    [QuestionnaireTypeID] smallint NOT NULL,
    [StartDateTime] datetime NOT NULL,
    [FinishDateTime] datetime NULL,
    [Locked] bit NULL,
    [LastChange] datetime NULL,
    CONSTRAINT [PK_QuestionnaireByQuestionnaireIdentificator] PRIMARY KEY CLUSTERED ([QuestionnaireByQuestionnaireIdentificatorID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionnaireAnswers] (
        [QuestionnaireAnswerID] int NOT NULL IDENTITY(1,1),
    [QuestionID] int NOT NULL,
    [Answer] nvarchar(2000) NULL,
    [AnswerPoints] int NULL,
    [QuestionnaireByQuestionnaireIdentificatorID] int NOT NULL,
    [PredefinedAnswerID] int NULL,
    CONSTRAINT [PK_MoneyLaundryQuestionaryAnswers_MoneyLaundryQuestionaryAnswerID] PRIMARY KEY CLUSTERED ([QuestionnaireAnswerID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionnaireIdentificatorTypes] (
        [QuestionnaireIdentificatorTypeID] int NOT NULL IDENTITY(1,1),
    [Name] nvarchar(50) NULL,
    CONSTRAINT [PK_QuestionnarieIdentificatorType] PRIMARY KEY CLUSTERED ([QuestionnaireIdentificatorTypeID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionnaireTypeRules] (
        [QuestionnaireTypeRuleID] int NOT NULL IDENTITY(1,1),
    [QuestionnaireTypeID] smallint NULL,
    [TotalStatisticalWeightFrom] int NULL,
    [TotalStatisticalWeightTo] int NULL,
    [FinalRate] int NULL,
    [ContractIssuingBlocker] bit NULL,
    [Suitable] bit NULL,
    [TariffID] int NULL,
    CONSTRAINT [PK_QuestionaryTypeRules] PRIMARY KEY CLUSTERED ([QuestionnaireTypeRuleID] ASC)
);
GO
CREATE TABLE [dbo].[ComputeMethods] (
        [ComputeMethodID] smallint NOT NULL IDENTITY(1,1),
    [Code] nvarchar(50) NOT NULL,
    [Name] nvarchar(200) NOT NULL,
    [Description] nvarchar(500) NULL,
    [IsActive] bit NOT NULL DEFAULT ((1)),
    CONSTRAINT [PK_ComputeMethods] PRIMARY KEY CLUSTERED ([ComputeMethodID] ASC)
);
GO
CREATE TABLE [dbo].[Indicators] (
        [IndicatorID] int NOT NULL IDENTITY(1,1),
    [QuestionnaireIdentificatorID] bigint NOT NULL,
    [RankID] int NULL,
    [RiskLevelID] int NULL,
    [TransferDate] datetime NULL,
    CONSTRAINT [PK_MoneyLaundryIndicators_MoneyLaundryIndicatorID] PRIMARY KEY CLUSTERED ([IndicatorID] ASC)
);
GO
CREATE TABLE [dbo].[Ranks] (
        [RankID] int NOT NULL IDENTITY(1,1),
    [Rank] nvarchar(10) NOT NULL,
    [Description] nvarchar(200) NULL,
    [StateID] smallint NOT NULL,
    CONSTRAINT [PK_MoneyLaundryRanks_RankID] PRIMARY KEY CLUSTERED ([RankID] ASC)
);
GO
CREATE TABLE [dbo].[RiskLevels] (
        [RiskLevelID] int NOT NULL IDENTITY(1,1),
    [RiskLevel] nvarchar(10) NOT NULL,
    [Description] nvarchar(200) NULL,
    [StateID] smallint NOT NULL,
    CONSTRAINT [PK_MoneyLaundryRiskLevels_RiskLevelID] PRIMARY KEY CLUSTERED ([RiskLevelID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionReferenceColumns] (
        [QuestionReferenceColumnID] int NOT NULL IDENTITY(1,1),
    [QuestionID] int NOT NULL,
    [QuestionnaireTypeReferenceTableID] int NOT NULL,
    [ReferenceColumnName] nvarchar(200) NULL,
    CONSTRAINT [PK__Question__0DC06F8C6DA96EE1] PRIMARY KEY CLUSTERED ([QuestionReferenceColumnID] ASC)
);
GO
CREATE TABLE [dbo].[QuestionnaireTypeReferenceTables] (
        [QuestionnaireTypeReferenceTableID] int NOT NULL IDENTITY(1,1),
    [QuestionnaireTypeID] smallint NOT NULL,
    [TableName] nvarchar(200) NOT NULL,
    CONSTRAINT [PK__Referenc__65F2CF4FBA970EA5] PRIMARY KEY CLUSTERED ([QuestionnaireTypeReferenceTableID] ASC)
);
GO
CREATE TABLE [dbo].[ProductQuestionaryTypes] (
        [ProductQuestionaryTypeID] int NOT NULL IDENTITY(1,1),
    [ProductID] smallint NOT NULL,
    [QuestionaryTypeID] smallint NOT NULL,
    CONSTRAINT [PK_ProductQuestionaryTypes_ProductQuestionaryTypeID] PRIMARY KEY CLUSTERED ([ProductQuestionaryTypeID] ASC)
);
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] WITH CHECK ADD CONSTRAINT [FK_QuestionnarieAnswers_PredefinedAnswers] FOREIGN KEY([PredefinedAnswerID]) REFERENCES [dbo].[PredefinedAnswers] ([PredefinedAnswerID]);
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] CHECK CONSTRAINT [FK_QuestionnarieAnswers_PredefinedAnswers];
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions] WITH CHECK ADD CONSTRAINT [FK_PredefinedAnswerSubQuestions_PredefinedAnswers_PredefinedAnswerID] FOREIGN KEY([PredefinedAnswerID]) REFERENCES [dbo].[PredefinedAnswers] ([PredefinedAnswerID]);
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions] CHECK CONSTRAINT [FK_PredefinedAnswerSubQuestions_PredefinedAnswers_PredefinedAnswerID];
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] WITH CHECK ADD CONSTRAINT [FK_QuestionnaireAnswers_QuestionnaireByQuestionnaireIdentificator] FOREIGN KEY([QuestionnaireByQuestionnaireIdentificatorID]) REFERENCES [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID]);
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] CHECK CONSTRAINT [FK_QuestionnaireAnswers_QuestionnaireByQuestionnaireIdentificator];
GO
ALTER TABLE [dbo].[Questions] WITH CHECK ADD CONSTRAINT [FK_Questions_QuestionFormat] FOREIGN KEY([QuestionFormatID]) REFERENCES [dbo].[QuestionFormats] ([QuestionFormatID]);
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK_Questions_QuestionFormat];
GO
ALTER TABLE [dbo].[QuestionReferenceColumns] WITH CHECK ADD CONSTRAINT [FK_QuestionReferenceColumns_QuestionnaireTypeReferenceTables] FOREIGN KEY([QuestionnaireTypeReferenceTableID]) REFERENCES [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID]);
GO
ALTER TABLE [dbo].[QuestionReferenceColumns] CHECK CONSTRAINT [FK_QuestionReferenceColumns_QuestionnaireTypeReferenceTables];
GO
ALTER TABLE [dbo].[Indicators] WITH CHECK ADD CONSTRAINT [FK_Indicators_QuestionnarieIdentificator] FOREIGN KEY([QuestionnaireIdentificatorID]) REFERENCES [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID]);
GO
ALTER TABLE [dbo].[Indicators] CHECK CONSTRAINT [FK_Indicators_QuestionnarieIdentificator];
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators] WITH CHECK ADD CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieIdentificator] FOREIGN KEY([QuestionnaireIdentificatorID]) REFERENCES [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID]);
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators] CHECK CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieIdentificator];
GO
ALTER TABLE [dbo].[QuestionnaireIdentificators] WITH CHECK ADD CONSTRAINT [FK_QuestionnarieIdentificator_QuestionnarieIdentificatorType] FOREIGN KEY([QuestionnaireIdentificatorTypeID]) REFERENCES [dbo].[QuestionnaireIdentificatorTypes] ([QuestionnaireIdentificatorTypeID]);
GO
ALTER TABLE [dbo].[QuestionnaireIdentificators] CHECK CONSTRAINT [FK_QuestionnarieIdentificator_QuestionnarieIdentificatorType];
GO
ALTER TABLE [dbo].[QuestionnaireTypeRules] WITH CHECK ADD CONSTRAINT [FK_QuestionnarieTypeRules_QuestionnarieTypes_QuestionnarieTypeID] FOREIGN KEY([QuestionnaireTypeID]) REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID]);
GO
ALTER TABLE [dbo].[QuestionnaireTypeRules] CHECK CONSTRAINT [FK_QuestionnarieTypeRules_QuestionnarieTypes_QuestionnarieTypeID];
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators] WITH CHECK ADD CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieTypes] FOREIGN KEY([QuestionnaireTypeID]) REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID]);
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators] CHECK CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieTypes];
GO
ALTER TABLE [dbo].[QuestionnaireTypeReferenceTables] WITH CHECK ADD CONSTRAINT [FK_QuestionnaireTypeReferenceTables_QuestionnaireTypes] FOREIGN KEY([QuestionnaireTypeID]) REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID]);
GO
ALTER TABLE [dbo].[QuestionnaireTypeReferenceTables] CHECK CONSTRAINT [FK_QuestionnaireTypeReferenceTables_QuestionnaireTypes];
GO
ALTER TABLE [dbo].[Questionnaires] WITH CHECK ADD CONSTRAINT [FK_Questionnaries_QuestionnarieTypes_QuestionnarieTypeID] FOREIGN KEY([QuestionnaireTypeID]) REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID]);
GO
ALTER TABLE [dbo].[Questionnaires] CHECK CONSTRAINT [FK_Questionnaries_QuestionnarieTypes_QuestionnarieTypeID];
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes] WITH CHECK ADD CONSTRAINT [FK_ProductQuestionaryTypes_QuestionnaireTypes] FOREIGN KEY([QuestionaryTypeID]) REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID]);
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes] CHECK CONSTRAINT [FK_ProductQuestionaryTypes_QuestionnaireTypes];
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] WITH CHECK ADD CONSTRAINT [FK_QuestionnarieAnswers_Questions] FOREIGN KEY([QuestionID]) REFERENCES [dbo].[Questions] ([QuestionID]);
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] CHECK CONSTRAINT [FK_QuestionnarieAnswers_Questions];
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] WITH CHECK ADD CONSTRAINT [FK_QCC_Questions] FOREIGN KEY([QuestionID]) REFERENCES [dbo].[Questions] ([QuestionID]);
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] CHECK CONSTRAINT [FK_QCC_Questions];
GO
ALTER TABLE [dbo].[PredefinedAnswers] WITH CHECK ADD CONSTRAINT [FK_PredefinedAnswers_Questions] FOREIGN KEY([QuestionID]) REFERENCES [dbo].[Questions] ([QuestionID]);
GO
ALTER TABLE [dbo].[PredefinedAnswers] CHECK CONSTRAINT [FK_PredefinedAnswers_Questions];
GO
ALTER TABLE [dbo].[Questionnaires] WITH CHECK ADD CONSTRAINT [FK_Questionnarie_Questions_QuestionID] FOREIGN KEY([QuestionID]) REFERENCES [dbo].[Questions] ([QuestionID]);
GO
ALTER TABLE [dbo].[Questionnaires] CHECK CONSTRAINT [FK_Questionnarie_Questions_QuestionID];
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions] WITH CHECK ADD CONSTRAINT [FK_PredefinedAnswerSubQuestions_Questions] FOREIGN KEY([SubQuestionID]) REFERENCES [dbo].[Questions] ([QuestionID]);
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions] CHECK CONSTRAINT [FK_PredefinedAnswerSubQuestions_Questions];
GO
ALTER TABLE [dbo].[Indicators] WITH CHECK ADD CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRanks_RankID] FOREIGN KEY([RankID]) REFERENCES [dbo].[Ranks] ([RankID]);
GO
ALTER TABLE [dbo].[Indicators] CHECK CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRanks_RankID];
GO
ALTER TABLE [dbo].[Indicators] WITH CHECK ADD CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRiskLevels_RiskLevelID] FOREIGN KEY([RiskLevelID]) REFERENCES [dbo].[RiskLevels] ([RiskLevelID]);
GO
ALTER TABLE [dbo].[Indicators] CHECK CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRiskLevels_RiskLevelID];
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] WITH CHECK ADD CONSTRAINT [FK_QCC_ComputeMethods] FOREIGN KEY([ComputeMethodID]) REFERENCES [dbo].[ComputeMethods] ([ComputeMethodID]);
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] CHECK CONSTRAINT [FK_QCC_ComputeMethods];
GO
ALTER TABLE [dbo].[Questions] WITH CHECK ADD CONSTRAINT [FK_Questions_SpecificQuestionTypes] FOREIGN KEY([SpecificQuestionTypeID]) REFERENCES [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID]);
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK_Questions_SpecificQuestionTypes];
GO
