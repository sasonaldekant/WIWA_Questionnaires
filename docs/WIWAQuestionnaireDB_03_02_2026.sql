USE [WIWA_Questionnaires_DB]
GO
/****** Object:  Table [dbo].[BuildingCategoryMatrix]    Script Date: 03-Feb-26 14:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BuildingCategoryMatrix](
	[BuildingCategoryMatrixID] [int] IDENTITY(1,1) NOT NULL,
	[ExternalWallMaterialID] [int] NULL,
	[ConstructionMaterialID] [int] NULL,
	[RoofCoveringMaterialID] [int] NULL,
	[ConstructionTypeID] [int] NULL,
 CONSTRAINT [PK_BuildingCategoryMatrix] PRIMARY KEY CLUSTERED 
(
	[BuildingCategoryMatrixID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComputeMethods]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputeMethods](
	[ComputeMethodID] [smallint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ComputeMethods] PRIMARY KEY CLUSTERED 
(
	[ComputeMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Indicators]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Indicators](
	[IndicatorID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireIdentificatorID] [bigint] NOT NULL,
	[RankID] [int] NULL,
	[RiskLevelID] [int] NULL,
	[TransferDate] [datetime] NULL,
 CONSTRAINT [PK_MoneyLaundryIndicators_MoneyLaundryIndicatorID] PRIMARY KEY CLUSTERED 
(
	[IndicatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PredefinedAnswers]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PredefinedAnswers](
	[PredefinedAnswerID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[PreSelected] [bit] NOT NULL,
	[Answer] [nvarchar](2000) NOT NULL,
	[StatisticalWeight] [decimal](18, 2) NULL,
	[Code] [nvarchar](50) NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_PredefinedAnswers_PredefinedAnswerID] PRIMARY KEY CLUSTERED 
(
	[PredefinedAnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PredefinedAnswerSubQuestions]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PredefinedAnswerSubQuestions](
	[PredefinedAnswerSubQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[PredefinedAnswerID] [int] NOT NULL,
	[SubQuestionID] [int] NOT NULL,
 CONSTRAINT [PK_PredefinedAnswerSubQuestions_PredefinedAnswerSubQuestionID] PRIMARY KEY CLUSTERED 
(
	[PredefinedAnswerSubQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductQuestionaryTypes]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductQuestionaryTypes](
	[ProductQuestionaryTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [smallint] NOT NULL,
	[QuestionaryTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK_ProductQuestionaryTypes_ProductQuestionaryTypeID] PRIMARY KEY CLUSTERED 
(
	[ProductQuestionaryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionComputedConfigs]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionComputedConfigs](
	[QuestionComputedConfigID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[ComputeMethodID] [smallint] NOT NULL,
	[MatrixObjectName] [nvarchar](128) NOT NULL,
	[RuleName] [nvarchar](200) NULL,
	[RuleDescription] [nvarchar](1000) NULL,
	[OutputMode] [tinyint] NOT NULL,
	[OutputTarget] [nvarchar](256) NULL,
	[MatrixOutputColumnName] [nvarchar](128) NOT NULL,
	[Priority] [smallint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FormulaExpression] [nvarchar](max) NULL,
 CONSTRAINT [PK_QuestionComputedConfigs] PRIMARY KEY CLUSTERED 
(
	[QuestionComputedConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionFormats]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionFormats](
	[QuestionFormatID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_QuestionFormat_QuestionFormatID] PRIMARY KEY CLUSTERED 
(
	[QuestionFormatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireAnswers]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireAnswers](
	[QuestionnaireAnswerID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[Answer] [nvarchar](2000) NULL,
	[AnswerPoints] [int] NULL,
	[QuestionnaireByQuestionnaireIdentificatorID] [int] NOT NULL,
	[PredefinedAnswerID] [int] NULL,
 CONSTRAINT [PK_MoneyLaundryQuestionaryAnswers_MoneyLaundryQuestionaryAnswerID] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireAnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireByQuestionnaireIdentificators]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators](
	[QuestionnaireByQuestionnaireIdentificatorID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireIdentificatorID] [bigint] NOT NULL,
	[QuestionnaireTypeID] [smallint] NOT NULL,
	[StartDateTime] [datetime] NOT NULL,
	[FinishDateTime] [datetime] NULL,
	[Locked] [bit] NULL,
	[LastChange] [datetime] NULL,
 CONSTRAINT [PK_QuestionnaireByQuestionnaireIdentificator] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireByQuestionnaireIdentificatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireIdentificators]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireIdentificators](
	[QuestionnaireIdentificatorID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionnaireIdentificatorTypeID] [int] NOT NULL,
	[Identificator] [nvarchar](20) NOT NULL,
	[UserID] [int] NOT NULL,
	[PoliticalPerson] [bit] NOT NULL,
 CONSTRAINT [PK_QuestionnarieIdentificator] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireIdentificatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireIdentificatorTypes]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireIdentificatorTypes](
	[QuestionnaireIdentificatorTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_QuestionnarieIdentificatorType] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireIdentificatorTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questionnaires]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questionnaires](
	[QuestionnaireID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireTypeID] [smallint] NOT NULL,
	[QuestionID] [int] NOT NULL,
 CONSTRAINT [PK_Questionaries_QuestionaryID] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireTypeReferenceTables]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireTypeReferenceTables](
	[QuestionnaireTypeReferenceTableID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireTypeID] [smallint] NOT NULL,
	[TableName] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK__Referenc__65F2CF4FBA970EA5] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireTypeReferenceTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireTypeRules]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireTypeRules](
	[QuestionnaireTypeRuleID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireTypeID] [smallint] NULL,
	[TotalStatisticalWeightFrom] [int] NULL,
	[TotalStatisticalWeightTo] [int] NULL,
	[FinalRate] [int] NULL,
	[ContractIssuingBlocker] [bit] NULL,
	[Suitable] [bit] NULL,
	[TariffID] [int] NULL,
 CONSTRAINT [PK_QuestionaryTypeRules] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireTypeRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireTypes]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireTypes](
	[QuestionnaireTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](20) NOT NULL,
	[QuestionnaireCategoryID] [smallint] NULL,
 CONSTRAINT [PK_QuestionaryTypes_QuestionaryTypeID] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionReferenceColumns]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionReferenceColumns](
	[QuestionReferenceColumnID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[QuestionnaireTypeReferenceTableID] [int] NOT NULL,
	[ReferenceColumnName] [nvarchar](200) NULL,
 CONSTRAINT [PK__Question__0DC06F8C6DA96EE1] PRIMARY KEY CLUSTERED 
(
	[QuestionReferenceColumnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionText] [nvarchar](2000) NOT NULL,
	[QuestionOrder] [int] NULL,
	[QuestionFormatID] [smallint] NULL,
	[SpecificQuestionTypeID] [int] NULL,
	[QuestionLabel] [nvarchar](10) NULL,
	[ParentQuestionID] [int] NULL,
	[ReadOnly] [bit] NULL,
	[IsRequired] [bit] NOT NULL,
	[ValidationPattern] [nvarchar](255) NULL,
 CONSTRAINT [PK_Questions_QuestionID] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ranks]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranks](
	[RankID] [int] IDENTITY(1,1) NOT NULL,
	[Rank] [nvarchar](10) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[StateID] [smallint] NOT NULL,
 CONSTRAINT [PK_MoneyLaundryRanks_RankID] PRIMARY KEY CLUSTERED 
(
	[RankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RiskLevels]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RiskLevels](
	[RiskLevelID] [int] IDENTITY(1,1) NOT NULL,
	[RiskLevel] [nvarchar](10) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[StateID] [smallint] NOT NULL,
 CONSTRAINT [PK_MoneyLaundryRiskLevels_RiskLevelID] PRIMARY KEY CLUSTERED 
(
	[RiskLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpecificQuestionTypes]    Script Date: 03-Feb-26 14:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpecificQuestionTypes](
	[SpecificQuestionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
 CONSTRAINT [PK_SpecificQuestionTypes] PRIMARY KEY CLUSTERED 
(
	[SpecificQuestionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BuildingCategoryMatrix] ON 
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (1, 2, 2, 1, 6)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (2, 1, 2, 2, 7)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (3, 2, 3, 2, 7)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (4, 3, 1, 1, 7)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (5, 3, 2, 1, 7)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (6, 3, 3, 2, 7)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (7, 1, 1, 1, 8)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (8, 1, 2, 1, 8)
GO
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (9, 2, 1, 1, 8)
GO
SET IDENTITY_INSERT [dbo].[BuildingCategoryMatrix] OFF
GO
SET IDENTITY_INSERT [dbo].[ComputeMethods] ON 
GO
INSERT [dbo].[ComputeMethods] ([ComputeMethodID], [Code], [Name], [Description], [IsActive]) VALUES (1, N'MATRIX', N'Matrix Lookup', NULL, 1)
GO
INSERT [dbo].[ComputeMethods] ([ComputeMethodID], [Code], [Name], [Description], [IsActive]) VALUES (2, N'FORMULA', N'Formula', NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ComputeMethods] OFF
GO
SET IDENTITY_INSERT [dbo].[PredefinedAnswers] ON 
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (1, 1, 0, N'Da', NULL, N'DA', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (2, 1, 0, N'Ne', NULL, N'NE', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (3, 2, 0, N'Da', NULL, N'DA', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (4, 2, 0, N'Ne', NULL, N'NE', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (5, 3, 0, N'Da', NULL, N'DA', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (6, 3, 0, N'Ne', NULL, N'NE', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (7, 4, 0, N'Kamen / opeka / cigla / beton', NULL, N'1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (8, 4, 0, N'Metalni sendvič paneli', NULL, N'2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (9, 4, 0, N'Drvo i drugi gorivi i slabi materijali', NULL, N'3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (10, 5, 0, N'Beton / crep / salonit / eternit / lim', NULL, N'1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (11, 5, 0, N'Drvo / trska / slama / plastika', NULL, N'2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (12, 6, 0, N'Armirano-betonske konstrukcije', NULL, N'1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (13, 6, 0, N'Čelična konstrukcija', NULL, N'2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (14, 6, 0, N'Drvena konstrukcija', NULL, N'3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (15, 7, 0, N'Prizemne i jednospratne zgrade', NULL, N'4', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (16, 7, 0, N'Zgrade sa dva i više sprata', NULL, N'5', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (17, 8, 0, N'A - do 15 min (do 15 km)', NULL, N'1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (18, 8, 0, N'B - 15 do 30 min (15-30 km)', NULL, N'2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (19, 8, 0, N'C - preko 30 min (preko 30 km)', NULL, N'3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (20, 9, 0, N'Masivna', NULL, N'8', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (21, 9, 0, N'Mešovita', NULL, N'6', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (22, 9, 0, N'Laka', NULL, N'7', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (23, 24, 0, N'Malignih tumora, premaligne promene ili benignih tumora bilo koje lokalizacije', NULL, N'1.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (24, 24, 0, N'Bolesti srca i krvnih sudova (što podrazumeva i : povišen krvni pritisak, aritmija, tahikardija, urođene ili stečene srčane mane i slabosti, infarkt srca, angina pektoris, aneurizma arterija, ateroskleroza, proširene vene ili tromboza vena):', NULL, N'1.2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (25, 24, 0, N'Bolesti metabolizma i endokrinološke bolesti (što podrazumeva i: šećerna bolest - dijabetes, poremećaj metabolizma mokraćne kiseline - giht, bolesti štitaste i nadbubrežne žlezde, bolesti hipofize)', NULL, N'1.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (26, 24, 0, N'1.4 Bolesti disajnog sistema', NULL, N'1.4', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (27, 24, 0, N'1.5 Bolesti uro-genitalnog sistema', NULL, N'1.5', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (28, 24, 0, N'1.6 Bolesti krvi/imunog sistema', NULL, N'1.6', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (29, 24, 0, N'1.7 Bolesti digestivnog sistema', NULL, N'1.7', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (30, 24, 0, N'1.8 Bolesti lokomotornog', NULL, N'1.8', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (31, 24, 0, N'1.9 Nervne i psihičke', NULL, N'1.9', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (32, 24, 0, N'1.10 Čula vida i sluha', NULL, N'1.10', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (33, 24, 0, N'1.11 Kožne bolesti', NULL, N'1.11', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (34, 24, 0, N'1.12 Tegobe od ranije', NULL, N'1.12', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (35, 26, 0, N'Povišen pritisak', NULL, N'1.2.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (36, 26, 0, N'Aritmija', NULL, N'1.2.2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (37, 26, 0, N'Tahikardija', NULL, N'1.2.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (38, 30, 0, N'Dijabetes', NULL, N'1.3.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (39, 30, 0, N'1.3.3 Štitna žlezda', NULL, N'1.3.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (40, 42, 0, N'Da', NULL, N'YES', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (41, 42, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (42, 44, 0, N'Da', NULL, N'YES', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (43, 44, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (44, 46, 0, N'Da', NULL, N'YES', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (45, 46, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (46, 48, 0, N'Organizovano', NULL, N'ORG', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (47, 48, 0, N'Rekreativno', NULL, N'REK', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (48, 48, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (49, 52, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (50, 52, 0, N'Umereno', NULL, N'MOD', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (51, 52, 0, N'Prekomerno', NULL, N'EXC', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (52, 53, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (53, 53, 0, N'Da', NULL, N'YES', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (54, 55, 0, N'Da', NULL, N'YES', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (55, 55, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (56, 60, 0, N'Da', NULL, N'YES', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (57, 60, 0, N'Ne', NULL, N'NO', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (58, 54, 0, N'Ne', NULL, N'NO', 2)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (59, 54, 0, N'Da', NULL, N'YES', 1)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (60, 12, 0, N'Da', NULL, N'YES', 1)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (61, 12, 0, N'Ne', NULL, N'NO', 2)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (62, 13, 0, N'Da', NULL, N'YES', 1)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (63, 13, 0, N'Ne', NULL, N'NO', 2)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (64, 14, 0, N'Da', NULL, N'YES', 1)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (65, 14, 0, N'Ne', NULL, N'NO', 2)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (68, 16, 0, N'Da', NULL, N'YES', 1)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (69, 16, 0, N'Ne', NULL, N'NO', 2)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (70, 17, 0, N'Da', NULL, N'YES', 1)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (71, 17, 0, N'Ne', NULL, N'NO', 2)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (72, 33, 0, N'1.4.1 Bronhitis', NULL, N'1.4.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (73, 33, 0, N'1.4.2 HOBP', NULL, N'1.4.2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (74, 33, 0, N'1.4.3 Astma', NULL, N'1.4.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (75, 33, 0, N'1.4.4 Emfizem', NULL, N'1.4.4', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (76, 33, 0, N'1.4.5 Embolija', NULL, N'1.4.5', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (77, 33, 0, N'1.4.6 Tuberkuloza', NULL, N'1.4.6', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (78, 34, 0, N'1.5.1 Bubrezi', NULL, N'1.5.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (79, 34, 0, N'1.5.2 Mokraćni kanali', NULL, N'1.5.2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (80, 34, 0, N'1.5.3 Prostata', NULL, N'1.5.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (81, 34, 0, N'1.5.4 Testisi', NULL, N'1.5.4', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (82, 34, 0, N'1.5.5 Materica', NULL, N'1.5.5', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (83, 34, 0, N'1.5.6 Jajnici', NULL, N'1.5.6', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (84, 34, 0, N'1.5.7 Dojka', NULL, N'1.5.7', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (85, 35, 0, N'1.6.1 Leukemija', NULL, N'1.6.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (86, 35, 0, N'1.6.2 Limfomi', NULL, N'1.6.2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (87, 35, 0, N'1.6.3 HIV/SIDA', NULL, N'1.6.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (88, 35, 0, N'1.6.4 Lupus', NULL, N'1.6.4', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (89, 35, 0, N'1.6.5 Vezivno tkivo', NULL, N'1.6.5', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (90, 36, 0, N'1.7Čir', NULL, N'1.7.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (91, 36, 0, N'1.7.2 Kron', NULL, N'1.7.2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (92, 36, 0, N'1.7.3 Kolitis', NULL, N'1.7.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (93, 36, 0, N'1.7.4 Hepatitis', NULL, N'1.7.4', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (94, 36, 0, N'1.7.5 Ciroza', NULL, N'1.7.5', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (95, 36, 0, N'1.7.6 Å½uÄ', NULL, N'1.7.6', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (96, 36, 0, N'1.7.7 Pankreas', NULL, N'1.7.7', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (97, 38, 0, N'1.9.1 Pareze', NULL, N'1.9.1', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (98, 38, 0, N'1.9.2 Epilepsija', NULL, N'1.9.2', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (99, 38, 0, N'Šlog', NULL, N'1.9.3', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (100, 38, 0, N'MS', NULL, N'1.9.4', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (101, 38, 0, N'Distrofije', NULL, N'1.9.5', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (102, 38, 0, N'1.9.6 Parkinson', NULL, N'1.9.6', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (103, 38, 0, N'1.9.7 Alchajmer', NULL, N'1.9.7', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (104, 38, 0, N'1.9.8 Psihoze', NULL, N'1.9.8', 0)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (109, 15, 0, N'Organizovano', NULL, NULL, 1)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (110, 15, 0, N'Rekreativno', NULL, NULL, 2)
GO
INSERT [dbo].[PredefinedAnswers] ([PredefinedAnswerID], [QuestionID], [PreSelected], [Answer], [StatisticalWeight], [Code], [DisplayOrder]) VALUES (111, 15, 0, N'Ne', NULL, NULL, 3)
GO
SET IDENTITY_INSERT [dbo].[PredefinedAnswers] OFF
GO
SET IDENTITY_INSERT [dbo].[PredefinedAnswerSubQuestions] ON 
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (1, 1, 2)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (2, 4, 3)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (3, 20, 7)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (4, 23, 25)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (5, 24, 26)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (6, 35, 27)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (7, 36, 28)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (8, 37, 29)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (9, 25, 30)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (10, 38, 31)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (11, 39, 32)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (12, 26, 33)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (13, 27, 34)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (14, 28, 35)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (15, 29, 36)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (16, 30, 37)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (17, 31, 38)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (18, 32, 39)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (19, 33, 40)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (20, 34, 41)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (21, 40, 43)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (22, 42, 45)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (23, 44, 47)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (24, 46, 49)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (25, 47, 50)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (27, 54, 56)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (28, 56, 61)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (29, 50, 62)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (30, 51, 62)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (31, 50, 63)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (32, 51, 63)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (33, 59, 64)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (34, 59, 65)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (35, 60, 66)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (36, 62, 67)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (37, 68, 68)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (38, 70, 69)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (39, 72, 70)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (40, 73, 71)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (41, 74, 72)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (42, 75, 73)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (43, 76, 74)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (44, 77, 75)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (45, 78, 76)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (46, 79, 77)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (47, 85, 78)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (48, 90, 79)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (49, 91, 80)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (50, 92, 81)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (51, 93, 82)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (52, 94, 83)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (53, 95, 84)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (54, 96, 85)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (55, 97, 86)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (56, 98, 87)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (57, 99, 88)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (58, 100, 89)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (59, 101, 90)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (60, 102, 91)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (61, 103, 92)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (62, 104, 93)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (67, 109, 49)
GO
INSERT [dbo].[PredefinedAnswerSubQuestions] ([PredefinedAnswerSubQuestionID], [PredefinedAnswerID], [SubQuestionID]) VALUES (68, 110, 50)
GO
SET IDENTITY_INSERT [dbo].[PredefinedAnswerSubQuestions] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] ON 
GO
INSERT [dbo].[QuestionComputedConfigs] ([QuestionComputedConfigID], [QuestionID], [ComputeMethodID], [MatrixObjectName], [RuleName], [RuleDescription], [OutputMode], [OutputTarget], [MatrixOutputColumnName], [Priority], [IsActive], [FormulaExpression]) VALUES (1, 10, 2, N'BMI_Formula', N'BMI Formula (Short)', NULL, 1, NULL, N'Value', 1, 1, N'{105} / Math.pow({104}/100, 2)')
GO
INSERT [dbo].[QuestionComputedConfigs] ([QuestionComputedConfigID], [QuestionID], [ComputeMethodID], [MatrixObjectName], [RuleName], [RuleDescription], [OutputMode], [OutputTarget], [MatrixOutputColumnName], [Priority], [IsActive], [FormulaExpression]) VALUES (2, 57, 2, N'BMI_Formula', N'BMI Formula (Great)', NULL, 1, NULL, N'Value', 1, 1, N'{59} / Math.pow({58}/100, 2)')
GO
INSERT [dbo].[QuestionComputedConfigs] ([QuestionComputedConfigID], [QuestionID], [ComputeMethodID], [MatrixObjectName], [RuleName], [RuleDescription], [OutputMode], [OutputTarget], [MatrixOutputColumnName], [Priority], [IsActive], [FormulaExpression]) VALUES (3, 9, 1, N'BuildingCategoryMatrix', N'Building Category Rule', NULL, 2, NULL, N'ConstructionTypeID', 1, 1, NULL)
GO
SET IDENTITY_INSERT [dbo].[QuestionComputedConfigs] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionFormats] ON 
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (1, N'Text input', N'input', NULL)
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (2, N'Radio Button', N'radio', NULL)
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (3, N'Drop-down List', N'select', NULL)
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (4, N'Check Box', N'checkbox', NULL)
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (5, N'Autocomplete', N'autocomplete', NULL)
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (6, N'Textarea', N'textarea', NULL)
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (7, N'Date', N'date', NULL)
GO
INSERT [dbo].[QuestionFormats] ([QuestionFormatID], [Name], [Code], [Description]) VALUES (8, N'Section Label', N'label', NULL)
GO
SET IDENTITY_INSERT [dbo].[QuestionFormats] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireAnswers] ON 
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (1, 1, NULL, NULL, 1, 1)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (2, 2, NULL, NULL, 1, 4)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (3, 3, NULL, NULL, 1, 5)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (4, 4, NULL, NULL, 1, 7)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (5, 5, NULL, NULL, 1, 10)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (6, 6, NULL, NULL, 1, 12)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (7, 7, NULL, NULL, 1, 15)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (8, 8, NULL, NULL, 1, 17)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (9, 9, NULL, NULL, 1, 20)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (10, 24, NULL, NULL, 2, 23)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (11, 25, N'x', NULL, 2, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (12, 42, NULL, NULL, 2, 41)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (13, 44, NULL, NULL, 2, 43)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (14, 46, NULL, NULL, 2, 45)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (15, 48, NULL, NULL, 2, 48)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (16, 52, NULL, NULL, 2, 49)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (17, 53, NULL, NULL, 2, 52)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (18, 54, NULL, NULL, 2, 58)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (19, 55, NULL, NULL, 2, 55)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (20, 57, N'29.32', NULL, 2, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (21, 58, N'180', NULL, 2, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (22, 59, N'95', NULL, 2, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (23, 60, NULL, NULL, 2, 56)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (24, 61, N'sss', NULL, 2, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (25, 24, NULL, NULL, 3, 23)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (26, 24, NULL, NULL, 3, 31)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (27, 25, N'dfdg', NULL, 3, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (28, 38, NULL, NULL, 3, 97)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (29, 42, NULL, NULL, 3, 41)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (30, 44, NULL, NULL, 3, 43)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (31, 46, NULL, NULL, 3, 45)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (32, 48, NULL, NULL, 3, 48)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (33, 52, NULL, NULL, 3, 49)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (34, 53, NULL, NULL, 3, 53)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (35, 54, NULL, NULL, 3, 58)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (36, 55, NULL, NULL, 3, 55)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (37, 57, N'24.38', NULL, 3, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (38, 58, N'180', NULL, 3, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (39, 59, N'79', NULL, 3, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (40, 60, NULL, NULL, 3, 56)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (41, 61, N'dhdahs', NULL, 3, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (42, 86, N'dxx', NULL, 3, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (43, 24, NULL, NULL, 4, 31)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (44, 42, NULL, NULL, 4, 41)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (45, 44, NULL, NULL, 4, 43)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (46, 46, NULL, NULL, 4, 45)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (47, 48, NULL, NULL, 4, 48)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (48, 52, NULL, NULL, 4, 49)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (49, 53, NULL, NULL, 4, 52)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (50, 54, NULL, NULL, 4, 58)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (51, 55, NULL, NULL, 4, 55)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (52, 57, N'2.47', NULL, 4, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (53, 58, N'180', NULL, 4, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (54, 59, N'80', NULL, 4, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (55, 60, NULL, NULL, 4, 57)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (56, 1, NULL, NULL, 5, 1)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (57, 2, NULL, NULL, 5, 4)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (58, 3, NULL, NULL, 5, 6)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (59, 4, NULL, NULL, 5, 7)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (60, 5, NULL, NULL, 5, 10)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (61, 6, NULL, NULL, 5, 12)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (62, 7, NULL, NULL, 5, 15)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (63, 8, NULL, NULL, 5, 18)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (64, 9, NULL, NULL, 5, 20)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (65, 11, N'1523', NULL, 6, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (66, 12, NULL, NULL, 6, 61)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (67, 13, NULL, NULL, 6, 63)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (68, 14, NULL, NULL, 6, 65)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (70, 16, NULL, NULL, 6, 69)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (71, 17, NULL, NULL, 6, 71)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (72, 57, N'23.15', NULL, 6, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (73, 58, N'180', NULL, 6, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (74, 59, N'75', NULL, 6, NULL)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (75, 1, NULL, NULL, 7, 1)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (76, 2, NULL, NULL, 7, 4)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (77, 3, NULL, NULL, 7, 5)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (78, 4, NULL, NULL, 7, 7)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (79, 5, NULL, NULL, 7, 10)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (80, 6, NULL, NULL, 7, 12)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (81, 7, NULL, NULL, 7, 15)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (82, 8, NULL, NULL, 7, 18)
GO
INSERT [dbo].[QuestionnaireAnswers] ([QuestionnaireAnswerID], [QuestionID], [Answer], [AnswerPoints], [QuestionnaireByQuestionnaireIdentificatorID], [PredefinedAnswerID]) VALUES (83, 9, NULL, NULL, 7, 20)
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireAnswers] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ON 
GO
INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID], [QuestionnaireIdentificatorID], [QuestionnaireTypeID], [StartDateTime], [FinishDateTime], [Locked], [LastChange]) VALUES (1, 3, 1, CAST(N'2026-01-29T14:53:39.707' AS DateTime), CAST(N'2026-01-29T14:53:39.707' AS DateTime), 1, CAST(N'2026-01-29T14:53:39.707' AS DateTime))
GO
INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID], [QuestionnaireIdentificatorID], [QuestionnaireTypeID], [StartDateTime], [FinishDateTime], [Locked], [LastChange]) VALUES (2, 4, 3, CAST(N'2026-01-29T17:28:14.927' AS DateTime), CAST(N'2026-01-29T17:28:14.927' AS DateTime), 1, CAST(N'2026-01-29T17:28:14.927' AS DateTime))
GO
INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID], [QuestionnaireIdentificatorID], [QuestionnaireTypeID], [StartDateTime], [FinishDateTime], [Locked], [LastChange]) VALUES (3, 5, 3, CAST(N'2026-01-29T20:02:13.143' AS DateTime), CAST(N'2026-01-29T20:02:13.147' AS DateTime), 1, CAST(N'2026-01-29T20:02:13.147' AS DateTime))
GO
INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID], [QuestionnaireIdentificatorID], [QuestionnaireTypeID], [StartDateTime], [FinishDateTime], [Locked], [LastChange]) VALUES (4, 6, 3, CAST(N'2026-01-29T20:19:45.370' AS DateTime), CAST(N'2026-01-29T20:19:45.370' AS DateTime), 1, CAST(N'2026-01-29T20:19:45.370' AS DateTime))
GO
INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID], [QuestionnaireIdentificatorID], [QuestionnaireTypeID], [StartDateTime], [FinishDateTime], [Locked], [LastChange]) VALUES (5, 7, 1, CAST(N'2026-01-29T20:25:53.823' AS DateTime), CAST(N'2026-01-29T20:25:53.823' AS DateTime), 1, CAST(N'2026-01-29T20:25:53.823' AS DateTime))
GO
INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID], [QuestionnaireIdentificatorID], [QuestionnaireTypeID], [StartDateTime], [FinishDateTime], [Locked], [LastChange]) VALUES (6, 8, 2, CAST(N'2026-01-29T20:31:40.313' AS DateTime), CAST(N'2026-01-29T20:31:40.313' AS DateTime), 1, CAST(N'2026-01-29T22:36:09.417' AS DateTime))
GO
INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID], [QuestionnaireIdentificatorID], [QuestionnaireTypeID], [StartDateTime], [FinishDateTime], [Locked], [LastChange]) VALUES (7, 9, 1, CAST(N'2026-01-30T05:24:45.067' AS DateTime), CAST(N'2026-01-30T05:24:45.067' AS DateTime), 1, CAST(N'2026-01-30T05:24:45.067' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireByQuestionnaireIdentificators] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireIdentificators] ON 
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (1, 1, N'TEST-PS-125', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (2, 1, N'PRES-2026', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (3, 1, N'00111', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (4, 1, N'PRESENTATION-FINAL', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (5, 1, N'123', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (6, 1, N'TEST_LOC_FINAL', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (7, 1, N'0111', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (8, 1, N'1', 1, 0)
GO
INSERT [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID], [QuestionnaireIdentificatorTypeID], [Identificator], [UserID], [PoliticalPerson]) VALUES (9, 1, N'001', 1, 0)
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireIdentificators] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireIdentificatorTypes] ON 
GO
INSERT [dbo].[QuestionnaireIdentificatorTypes] ([QuestionnaireIdentificatorTypeID], [Name]) VALUES (1, N'LocationID')
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireIdentificatorTypes] OFF
GO
SET IDENTITY_INSERT [dbo].[Questionnaires] ON 
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (1, 2, 57)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (2, 2, 11)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (3, 2, 12)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (4, 2, 13)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (5, 2, 14)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (6, 2, 15)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (7, 2, 16)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (8, 2, 17)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (9, 3, 24)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (10, 3, 42)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (11, 3, 44)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (12, 3, 46)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (13, 3, 48)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (14, 3, 51)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (15, 3, 55)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (16, 3, 57)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (17, 3, 60)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (18, 1, 1)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (19, 1, 2)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (20, 1, 3)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (21, 1, 9)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (22, 1, 4)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (23, 1, 5)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (24, 1, 6)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (25, 1, 7)
GO
INSERT [dbo].[Questionnaires] ([QuestionnaireID], [QuestionnaireTypeID], [QuestionID]) VALUES (26, 1, 8)
GO
SET IDENTITY_INSERT [dbo].[Questionnaires] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireTypeReferenceTables] ON 
GO
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (1, 1, N'BuildingCategoryMatrix')
GO
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (2, 1, N'ConstructionMaterials')
GO
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (3, 1, N'ConstructionTypes')
GO
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (4, 1, N'ExternalWallMaterials')
GO
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (5, 1, N'ProtectionClasses')
GO
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (6, 1, N'RoofCoveringMaterials')
GO
INSERT [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID], [QuestionnaireTypeID], [TableName]) VALUES (7, 3, N'Sports')
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireTypeReferenceTables] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] ON 
GO
INSERT [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID], [Name], [Code], [QuestionnaireCategoryID]) VALUES (1, N'Upitnik lokacije - podaci za PremiumRateMatrix', N'LOC_QUEST', 1)
GO
INSERT [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID], [Name], [Code], [QuestionnaireCategoryID]) VALUES (2, N'Skraćeni upitnik', N'SHORT_QUEST', NULL)
GO
INSERT [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID], [Name], [Code], [QuestionnaireCategoryID]) VALUES (3, N'Veliki upitnik', N'GREAT_QUEST', NULL)
GO
SET IDENTITY_INSERT [dbo].[QuestionnaireTypes] OFF
GO
SET IDENTITY_INSERT [dbo].[QuestionReferenceColumns] ON 
GO
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (1, 6100, 7, N'SportName')
GO
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (2, 6200, 7, N'SportName')
GO
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (3, 4, 4, N'ExternalWallMaterialID')
GO
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (4, 5, 6, N'RoofCoveringMaterialID')
GO
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (5, 6, 2, N'ConstructionMaterialID')
GO
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (6, 8, 5, N'ProtectionClassID')
GO
INSERT [dbo].[QuestionReferenceColumns] ([QuestionReferenceColumnID], [QuestionID], [QuestionnaireTypeReferenceTableID], [ReferenceColumnName]) VALUES (7, 9, 3, N'ConstructionTypeID')
GO
SET IDENTITY_INSERT [dbo].[QuestionReferenceColumns] OFF
GO
SET IDENTITY_INSERT [dbo].[Questions] ON 
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (1, N'Da li se na lokaciji skladište zalihe robe', 1, 2, 1, N'1', NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (2, N'Da li se skladište zapaljive materije (boje i lakovi, ulja, alkoholi, razređivači, nafta i goriva, pirotehnika, zemni gas, industrijski plin, materije podložne samozapaljenju i sl.)', 2, 2, 2, N'1.1', NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (3, N'Da li se skladište voće, povrće, gvože, kamena roba, cementni proizvodi, šljunak i sl.', 3, 2, 2, N'1.1.1', NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (4, N'Građevinska kategorija - Spoljašnji zidovi', 5, 2, 1, N'2.1', 9, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (5, N'Građevinska kategorija - Krovni pokrivač', 6, 2, 1, N'2.2', 9, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (6, N'Građevinska kategorija - Konstrukcija objekta', 7, 2, 1, N'2.3', 9, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (7, N'Izaberite spratnost objekta', 8, 2, 2, N'2.4', NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (8, N'Klasa zaštitnih mera - udaljenost vatrogasne jedinice', 9, 2, 1, N'3', NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (9, N'Građevinska kategorija', 4, 2, 3, N'2', NULL, 1, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (10, N'BMI Index', 120, 1, 3, NULL, NULL, 1, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (11, N'Navedite naziv zdravstvene ustanove kod koje imate otvoren zdravstveni karton i od kada:', 130, 1, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (12, N'Da li ste ikada bolovali ili sada bolujete te da li vam je postavljena sumnja i da li ste ispitivani za postojanje sledećih bolesti:
malignih tumora, premalignih promena, polipa bilo koje lokalizacije, visokog krvnog pritiska, urođenih ili stečenih srčanih mana i slabosti, poremećaja srčanog ritma, kardiomiopatije, infarkta srca, angine pektoris, aneurizme arterija,  ugrađeni stentovi, operacije na srcu i mozgu, proširenih vena i tromboze, leukemija, limfoma, HIV, SIDA, sistemskog lupusa, sistemskih bolesti vezivnog tkiva, gihta, poremećaja zgrušavanja krvi, hronične bolesti pluća,  plućne embolije, Kronove bolesti, ulceroznog kolitisa, bolesti štitaste, nadbubrežne žlezde i hipofize, bolesti bubrega i bešike, bolesti materice, bolesti jajnika, bolesti dojke, bilo kog oblika: hepatitisa, ciroze jetre, bolesti žuči i žučnih puteva, bolesti pankreasa, epilepsije, moždanog udara, psihoze, pareze, paralize, bolesti motornog neurona, demijelinizirajućih bolesti, naslednih ili stečenih mišićnih distrofija, dijabetesa    ', 140, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (13, N'Da li se trenutno nalazite na ispitivanju ili praćenju nekog zdravstvenog stanja ili čekate rezultate dijagnostičkih procedura?', 150, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (14, N'Da li Vam je utvrđena trajna nesposobnost za rad, nesposobnost za samostalan život ili odredjeni stepen invaliditeta?', 160, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (15, N'Da li se bavite nekim sportom organizovano ili rekreativno', 170, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (16, N'Da li ste na poslu ili u slobodno vreme izloženi povećanom riziku od povređivanja? (zračenje, rad sa eksplozivom,materijama štetnim po zdravlje, rad na visini ili pod vodom)', 180, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (17, N'Da li vam je, do sada, neki drugi osiguravač, odbio ponudu o životnom osiguranju ili je prihvatio pod posebnim uslovima?         ', 190, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (18, N'Ukoliko je označen pozitivan odgovor – napisati koje oboljenje i priložiti kompletnu medicinsku dokumentaciju:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (19, N'Ukoliko je označen pozitivan odgovor – priložiti kompletnu medicinsku dokumentaciju :', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (20, N'Navesti koji sport ', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (21, N'Navesti koji sport ', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (22, N'Ukoliko je odgovor pozitivan navesti opasnosti:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (23, N'Ukoliko je odgovor pozitivan navesti razloge zbog kojih je ponuda odbijena ili prihvaćena pod posebnim uslovima:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (24, N'Da li ste bolovali ili trenutno bolujete od:', 10, 4, 1, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (25, N'Detalji (Maligni tumori):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (26, N'Bolesti srca i krvnih sudova (označite):', 1, 4, 2, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (27, N'Detalji (Povišen pritisak):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (28, N'Detalji (Aritmija):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (29, N'Detalji (Tahikardija):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (30, N'Bolesti metabolizma (označite):', 1, 4, 2, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (31, N'Detalji (Dijabetes):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (32, N'Detalji (Štitna žlezda):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (33, N'Bolesti disajnog sistema (označite):', 1, 4, 2, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (34, N'Bolesti uro-genitalnog sistema (označite):', 1, 4, 2, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (35, N'Bolesti krvi/imunog sistema (označite):', 1, 4, 2, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (36, N'Bolesti digestivnog sistema (označite):', 1, 4, 2, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (37, N'Detalji (Lokomotorni sistem):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (38, N'Bolesti nervnog sistema (označite):', 1, 4, 2, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (39, N'Detalji (Vid/Sluh):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (40, N'Detalji (Kožne promene):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (41, N'Detalji (Povrede/Tegobe):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (42, N'Da li bolujete od bolesti koja nije navedena?', 20, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (43, N'Navedite detalje bolesti:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (44, N'Da li se trenutno nalazite na ispitivanju?', 30, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (45, N'Pojasnite ispitivanja:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (46, N'Da li ste izloženi povećanom riziku?', 40, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (47, N'Pojasnite rizik:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (48, N'Da li se bavite sportom?', 50, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (49, N'Organizovano (Sport):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (50, N'Rekreativno (Sport):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (51, N'Navike (konzumacija):', 60, 8, 1, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (52, N'Alkohol', 1, 2, 1, NULL, 97, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (53, N'Droga/Narkotici', 2, 2, 1, NULL, 97, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (54, N'Cigarete/Duvan', 3, 2, 1, NULL, 97, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (55, N'Uzimate li redovno lekove?', 70, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (56, N'Koji lekovi i količina:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (57, N'BMI Index', 80, 1, 3, NULL, NULL, 1, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (58, N'Visina (cm)', 1, 1, 1, NULL, 57, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (59, N'Težina (kg)', 2, 1, 1, NULL, 57, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (60, N'Hronološki karton?', 90, 2, 1, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (61, N'Naziv ustanove i datum diplome:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (62, N'Vrsta pića:', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (63, N'Dnevna količina:', 2, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (64, N'Dnevna kolićina (kom):', 1, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (65, N'Koliko dugo konzumirate (god):', 2, 1, 2, NULL, NULL, 0, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (66, N'Navesti koje oboljenje', 1, 1, NULL, N'Detalji', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (67, N'Detalji ispitivanja', 1, 1, NULL, N'Detalji', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (68, N'Navesti opasnosti', 1, 1, NULL, N'Opis', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (69, N'Navesti razloge', 1, 1, NULL, N'Razlozi', NULL, NULL, 1, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (70, N'Detalji (Bronhitis):', 1, 1, 2, N'1.4.1', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (71, N'Detalji (HOBP):', 2, 1, 2, N'1.4.2', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (72, N'Detalji (Astma):', 3, 1, 2, N'1.4.3', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (73, N'Detalji (Emfizem):', 4, 1, 2, N'1.4.4', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (74, N'Detalji (Embolija):', 5, 1, 2, N'1.4.5', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (75, N'Detalji (Tuberkuloza):', 6, 1, 2, N'1.4.6', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (76, N'Detalji (Bubrezi):', 1, 1, 2, N'1.5.1', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (77, N'Detalji (MokraÄ‡ni kanali):', 2, 1, 2, N'1.5.2', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (78, N'Detalji (Leukemija):', 1, 1, 2, N'1.6.1', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (79, N'Detalji (ÄŒir):', 1, 1, 2, N'1.7.1', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (80, N'Detalji (Kron):', 2, 1, 2, N'1.7.2', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (81, N'Detalji (Kolitis):', 3, 1, 2, N'1.7.3', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (82, N'Detalji (Hepatitis):', 4, 1, 2, N'1.7.4', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (83, N'Detalji (Ciroza):', 5, 1, 2, N'1.7.5', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (84, N'Detalji (Å½uÄ):', 6, 1, 2, N'1.7.6', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (85, N'Detalji (Pankreas):', 7, 1, 2, N'1.7.7', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (86, N'Detalji (Pareze):', 1, 1, 2, N'1.9.1', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (87, N'Detalji (Epilepsija):', 2, 1, 2, N'1.9.2', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (88, N'Detalji (Å log):', 3, 1, 2, N'1.9.3', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (89, N'Detalji (MS):', 4, 1, 2, N'1.9.4', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (90, N'Detalji (Distrofije):', 5, 1, 2, N'1.9.5', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (91, N'Detalji (Parkinson):', 6, 1, 2, N'1.9.6', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (92, N'Detalji (Alchajmer):', 7, 1, 2, N'1.9.7', NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Questions] ([QuestionID], [QuestionText], [QuestionOrder], [QuestionFormatID], [SpecificQuestionTypeID], [QuestionLabel], [ParentQuestionID], [ReadOnly], [IsRequired], [ValidationPattern]) VALUES (93, N'Detalji (Psihoze/Depresija):', 8, 1, 2, N'1.9.8', NULL, NULL, 0, NULL)
GO
SET IDENTITY_INSERT [dbo].[Questions] OFF
GO
SET IDENTITY_INSERT [dbo].[SpecificQuestionTypes] ON 
GO
INSERT [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID], [Name]) VALUES (1, N'AlwaysVisible')
GO
INSERT [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID], [Name]) VALUES (2, N'ConditionallyVisible')
GO
INSERT [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID], [Name]) VALUES (3, N'Computed')
GO
INSERT [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID], [Name]) VALUES (4, N'Hidden')
GO
SET IDENTITY_INSERT [dbo].[SpecificQuestionTypes] OFF
GO
ALTER TABLE [dbo].[ComputeMethods] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PredefinedAnswers] ADD  DEFAULT ((0)) FOR [PreSelected]
GO
ALTER TABLE [dbo].[PredefinedAnswers] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] ADD  DEFAULT ((100)) FOR [Priority]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Questions] ADD  DEFAULT ((0)) FOR [IsRequired]
GO
ALTER TABLE [dbo].[Indicators]  WITH CHECK ADD  CONSTRAINT [FK_Indicators_QuestionnarieIdentificator] FOREIGN KEY([QuestionnaireIdentificatorID])
REFERENCES [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID])
GO
ALTER TABLE [dbo].[Indicators] CHECK CONSTRAINT [FK_Indicators_QuestionnarieIdentificator]
GO
ALTER TABLE [dbo].[Indicators]  WITH CHECK ADD  CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRanks_RankID] FOREIGN KEY([RankID])
REFERENCES [dbo].[Ranks] ([RankID])
GO
ALTER TABLE [dbo].[Indicators] CHECK CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRanks_RankID]
GO
ALTER TABLE [dbo].[Indicators]  WITH CHECK ADD  CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRiskLevels_RiskLevelID] FOREIGN KEY([RiskLevelID])
REFERENCES [dbo].[RiskLevels] ([RiskLevelID])
GO
ALTER TABLE [dbo].[Indicators] CHECK CONSTRAINT [FK_MoneyLaundryIndicators_MoneyLaundryRiskLevels_RiskLevelID]
GO
ALTER TABLE [dbo].[PredefinedAnswers]  WITH CHECK ADD  CONSTRAINT [FK_PredefinedAnswers_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[PredefinedAnswers] CHECK CONSTRAINT [FK_PredefinedAnswers_Questions]
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions]  WITH CHECK ADD  CONSTRAINT [FK_PredefinedAnswerSubQuestions_PredefinedAnswers_PredefinedAnswerID] FOREIGN KEY([PredefinedAnswerID])
REFERENCES [dbo].[PredefinedAnswers] ([PredefinedAnswerID])
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions] CHECK CONSTRAINT [FK_PredefinedAnswerSubQuestions_PredefinedAnswers_PredefinedAnswerID]
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions]  WITH CHECK ADD  CONSTRAINT [FK_PredefinedAnswerSubQuestions_Questions] FOREIGN KEY([SubQuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[PredefinedAnswerSubQuestions] CHECK CONSTRAINT [FK_PredefinedAnswerSubQuestions_Questions]
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProductQuestionaryTypes_QuestionnaireTypes] FOREIGN KEY([QuestionaryTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes] CHECK CONSTRAINT [FK_ProductQuestionaryTypes_QuestionnaireTypes]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs]  WITH CHECK ADD  CONSTRAINT [FK_QCC_ComputeMethods] FOREIGN KEY([ComputeMethodID])
REFERENCES [dbo].[ComputeMethods] ([ComputeMethodID])
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] CHECK CONSTRAINT [FK_QCC_ComputeMethods]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs]  WITH CHECK ADD  CONSTRAINT [FK_QCC_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] CHECK CONSTRAINT [FK_QCC_Questions]
GO
ALTER TABLE [dbo].[QuestionnaireAnswers]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireAnswers_QuestionnaireByQuestionnaireIdentificator] FOREIGN KEY([QuestionnaireByQuestionnaireIdentificatorID])
REFERENCES [dbo].[QuestionnaireByQuestionnaireIdentificators] ([QuestionnaireByQuestionnaireIdentificatorID])
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] CHECK CONSTRAINT [FK_QuestionnaireAnswers_QuestionnaireByQuestionnaireIdentificator]
GO
ALTER TABLE [dbo].[QuestionnaireAnswers]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnarieAnswers_PredefinedAnswers] FOREIGN KEY([PredefinedAnswerID])
REFERENCES [dbo].[PredefinedAnswers] ([PredefinedAnswerID])
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] CHECK CONSTRAINT [FK_QuestionnarieAnswers_PredefinedAnswers]
GO
ALTER TABLE [dbo].[QuestionnaireAnswers]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnarieAnswers_Questions] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[QuestionnaireAnswers] CHECK CONSTRAINT [FK_QuestionnarieAnswers_Questions]
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieIdentificator] FOREIGN KEY([QuestionnaireIdentificatorID])
REFERENCES [dbo].[QuestionnaireIdentificators] ([QuestionnaireIdentificatorID])
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators] CHECK CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieIdentificator]
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieTypes] FOREIGN KEY([QuestionnaireTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificators] CHECK CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificator_QuestionnarieTypes]
GO
ALTER TABLE [dbo].[QuestionnaireIdentificators]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnarieIdentificator_QuestionnarieIdentificatorType] FOREIGN KEY([QuestionnaireIdentificatorTypeID])
REFERENCES [dbo].[QuestionnaireIdentificatorTypes] ([QuestionnaireIdentificatorTypeID])
GO
ALTER TABLE [dbo].[QuestionnaireIdentificators] CHECK CONSTRAINT [FK_QuestionnarieIdentificator_QuestionnarieIdentificatorType]
GO
ALTER TABLE [dbo].[Questionnaires]  WITH CHECK ADD  CONSTRAINT [FK_Questionnarie_Questions_QuestionID] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Questions] ([QuestionID])
GO
ALTER TABLE [dbo].[Questionnaires] CHECK CONSTRAINT [FK_Questionnarie_Questions_QuestionID]
GO
ALTER TABLE [dbo].[Questionnaires]  WITH CHECK ADD  CONSTRAINT [FK_Questionnaries_QuestionnarieTypes_QuestionnarieTypeID] FOREIGN KEY([QuestionnaireTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[Questionnaires] CHECK CONSTRAINT [FK_Questionnaries_QuestionnarieTypes_QuestionnarieTypeID]
GO
ALTER TABLE [dbo].[QuestionnaireTypeReferenceTables]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireTypeReferenceTables_QuestionnaireTypes] FOREIGN KEY([QuestionnaireTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[QuestionnaireTypeReferenceTables] CHECK CONSTRAINT [FK_QuestionnaireTypeReferenceTables_QuestionnaireTypes]
GO
ALTER TABLE [dbo].[QuestionnaireTypeRules]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnarieTypeRules_QuestionnarieTypes_QuestionnarieTypeID] FOREIGN KEY([QuestionnaireTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[QuestionnaireTypeRules] CHECK CONSTRAINT [FK_QuestionnarieTypeRules_QuestionnarieTypes_QuestionnarieTypeID]
GO
ALTER TABLE [dbo].[QuestionReferenceColumns]  WITH CHECK ADD  CONSTRAINT [FK_QuestionReferenceColumns_QuestionnaireTypeReferenceTables] FOREIGN KEY([QuestionnaireTypeReferenceTableID])
REFERENCES [dbo].[QuestionnaireTypeReferenceTables] ([QuestionnaireTypeReferenceTableID])
GO
ALTER TABLE [dbo].[QuestionReferenceColumns] CHECK CONSTRAINT [FK_QuestionReferenceColumns_QuestionnaireTypeReferenceTables]
GO
ALTER TABLE [dbo].[Questions]  WITH CHECK ADD  CONSTRAINT [FK_Questions_QuestionFormat] FOREIGN KEY([QuestionFormatID])
REFERENCES [dbo].[QuestionFormats] ([QuestionFormatID])
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK_Questions_QuestionFormat]
GO
ALTER TABLE [dbo].[Questions]  WITH CHECK ADD  CONSTRAINT [FK_Questions_SpecificQuestionTypes] FOREIGN KEY([SpecificQuestionTypeID])
REFERENCES [dbo].[SpecificQuestionTypes] ([SpecificQuestionTypeID])
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK_Questions_SpecificQuestionTypes]
GO
