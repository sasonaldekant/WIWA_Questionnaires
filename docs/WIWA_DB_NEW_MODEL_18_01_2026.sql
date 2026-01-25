USE [WIWA_DB_NEW]
GO
/****** Object:  Table [dbo].[ExternalWallMaterials]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalWallMaterials](
	[ExternalWallMaterialID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ExternalWallMaterials] PRIMARY KEY CLUSTERED 
(
	[ExternalWallMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConstructionMaterials]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConstructionMaterials](
	[ConstructionMaterialID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ConstructionMaterials] PRIMARY KEY CLUSTERED 
(
	[ConstructionMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoofCoveringMaterials]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoofCoveringMaterials](
	[RoofCoveringMaterialID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_RoofCoveringMaterials] PRIMARY KEY CLUSTERED 
(
	[RoofCoveringMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BuildingCategoryMatrix]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BuildingCategoryMatrix](
	[BuildingCategoryMatrixID] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionTypeID] [int] NOT NULL,
	[ExternalWallMaterialID] [int] NOT NULL,
	[ConstructionMaterialID] [int] NOT NULL,
	[RoofCoveringMaterialID] [int] NOT NULL,
 CONSTRAINT [PK_BuildingCategoryMatrix] PRIMARY KEY CLUSTERED 
(
	[BuildingCategoryMatrixID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_BuildingCategoryMatrix_Combination] UNIQUE NONCLUSTERED 
(
	[ConstructionTypeID] ASC,
	[ExternalWallMaterialID] ASC,
	[ConstructionMaterialID] ASC,
	[RoofCoveringMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConstructionTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConstructionTypes](
	[ConstructionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
 CONSTRAINT [PK_ConstructionTypes_ConstructionTypeID] PRIMARY KEY CLUSTERED 
(
	[ConstructionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_BuildingCategoryMatrix]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_BuildingCategoryMatrix]
AS
SELECT bcm.BuildingCategoryMatrixID, bcm.ConstructionMaterialID, cm.Name AS ConstructionMaterial, bcm.ConstructionTypeID, ct.Name AS ConstructionType, bcm.ExternalWallMaterialID, ewm.Name AS ExternalWallMaterial, 
                  bcm.RoofCoveringMaterialID, rcm.Name AS RoofCoveringMaterial
FROM     dbo.BuildingCategoryMatrix AS bcm LEFT OUTER JOIN
                  dbo.ConstructionTypes AS ct ON bcm.ConstructionTypeID = ct.ConstructionTypeID LEFT OUTER JOIN
                  dbo.ExternalWallMaterials AS ewm ON ewm.ExternalWallMaterialID = bcm.ExternalWallMaterialID LEFT OUTER JOIN
                  dbo.ConstructionMaterials AS cm ON cm.ConstructionMaterialID = bcm.ConstructionMaterialID LEFT OUTER JOIN
                  dbo.RoofCoveringMaterials AS rcm ON rcm.RoofCoveringMaterialID = bcm.RoofCoveringMaterialID
GO
/****** Object:  Table [dbo].[PredefinedAnswers]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PredefinedAnswers](
	[PredefinedAnswerID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[PreSelected] [bit] NOT NULL,
	[Answer] [nvarchar](2000) NOT NULL,
	[StatisticalWeight] [int] NULL,
	[Code] [nvarchar](50) NULL,
 CONSTRAINT [PK_PredefinedAnswers_PredefinedAnswerID] PRIMARY KEY CLUSTERED 
(
	[PredefinedAnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PredefinedAnswerSubQuestions]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PredefinedAnswerSubQuestions](
	[PredefinedAnswerSubQuestionID] [int] NOT NULL,
	[PredefinedAnswerID] [int] NOT NULL,
	[SubQuestionID] [int] NOT NULL,
 CONSTRAINT [PK_PredefinedAnswerSubQuestions_PredefinedAnswerSubQuestionID] PRIMARY KEY CLUSTERED 
(
	[PredefinedAnswerSubQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionFormats]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionFormats](
	[QuestionFormatID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_QuestionFormat_QuestionFormatID] PRIMARY KEY CLUSTERED 
(
	[QuestionFormatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    Script Date: 18-Jan-26 13:43:11 ******/
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
 CONSTRAINT [PK_Questions_QuestionID] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_GetQuestionsWithRelations]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_GetQuestionsWithRelations]
AS
SELECT q.QuestionID, q.QuestionText, q.QuestionOrder, q.QuestionFormatID, qf.Name AS QuestionFormat, q.SpecificQuestionTypeID, q.QuestionLabel, q.ParentQuestionID, q.ReadOnly, pa.PredefinedAnswerID, pa.Answer, pa.Code, 
                  pasq.SubQuestionID AS PredefinedAnswerSubQuestion, pasqq.QuestionText AS PredefinedAnswerSubText
FROM     dbo.Questions AS q LEFT OUTER JOIN
                  dbo.QuestionFormats AS qf ON q.QuestionFormatID = qf.QuestionFormatID LEFT OUTER JOIN
                  dbo.QuestionReferenceTables AS qrt ON qrt.QuestionID = q.QuestionID LEFT OUTER JOIN
                  dbo.PredefinedAnswers AS pa ON pa.QuestionID = q.QuestionID LEFT OUTER JOIN
                  dbo.PredefinedAnswerSubQuestions AS pasq ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID LEFT OUTER JOIN
                  dbo.Questions AS pasqq ON pasqq.QuestionID = pasq.SubQuestionID
GO
/****** Object:  Table [dbo].[ActionPerTariffs]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionPerTariffs](
	[ActionPerTariffID] [int] IDENTITY(1,1) NOT NULL,
	[TariffID] [int] NOT NULL,
	[ActionID] [int] NOT NULL,
 CONSTRAINT [PK_ActionPerTariffs_ActionPerTariffID] PRIMARY KEY CLUSTERED 
(
	[ActionPerTariffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Addresses]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Addresses](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[HouseNumber] [nvarchar](20) NULL,
	[AddressCode] [nvarchar](20) NULL,
	[StreetID] [int] NOT NULL,
	[Note] [nvarchar](2000) NULL,
 CONSTRAINT [PK_Addresses_AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AllowedCorrectionLevels]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllowedCorrectionLevels](
	[AllowedCorrectionLevelID] [int] IDENTITY(1,1) NOT NULL,
	[ActionID] [int] NULL,
	[CorrectionID] [int] NOT NULL,
	[CorrectionLevelID] [int] NOT NULL,
	[TariffID] [int] NULL,
	[OrdinalNumber] [smallint] NULL,
	[IsPrintedOnItem] [bit] NOT NULL,
 CONSTRAINT [PK_AllowedCorrectionLevels_AllowedCorrectionLevelID] PRIMARY KEY CLUSTERED 
(
	[AllowedCorrectionLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BuildingMarks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BuildingMarks](
	[BuildingMarkID] [int] IDENTITY(1,1) NOT NULL,
	[BuildingID] [int] NOT NULL,
	[BuildingMarkTypeID] [int] NOT NULL,
 CONSTRAINT [PK_BuildingMarks_BuildingMarkID] PRIMARY KEY CLUSTERED 
(
	[BuildingMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BuildingMarkTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BuildingMarkTypes](
	[BuildingMarkTypeID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_BuildingMarkTypes_BuildingMarkTypeID] PRIMARY KEY CLUSTERED 
(
	[BuildingMarkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Buildings]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Buildings](
	[BuildingID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [int] NOT NULL,
	[Decription] [nvarchar](4000) NULL,
	[Entrance] [nvarchar](50) NULL,
	[Floor] [nvarchar](50) NULL,
	[Number] [nvarchar](50) NULL,
	[Surface] [decimal](18, 2) NULL,
	[ValueM2] [decimal](18, 2) NULL,
	[NewValuePrice] [bit] NULL,
 CONSTRAINT [PK_Buildings_BuildingID] PRIMARY KEY CLUSTERED 
(
	[BuildingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BusinessEntityNotificationQuestionaryHistories]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusinessEntityNotificationQuestionaryHistories](
	[BusinessEntityNotificationQuestionaryHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[BusinessEntityHistoryID] [bigint] NOT NULL,
	[NotificationReasonID] [int] NOT NULL,
	[NotificationTypeID] [int] NOT NULL,
	[WantsNotification] [bit] NOT NULL,
	[BusinessEntityTelephoneHistoryID] [bigint] NULL,
	[BusinessEntityEmailHistoryID] [bigint] NULL,
 CONSTRAINT [PK_BusinessEntityNotificationQuestionaryHistory_BusinessEntityNotificationQuestionaryHistoryID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityNotificationQuestionaryHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClauseForActions]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClauseForActions](
	[ClauseForActionID] [int] IDENTITY(1,1) NOT NULL,
	[ActionID] [int] NOT NULL,
	[ClauseID] [int] NOT NULL,
 CONSTRAINT [PK_ClauseForActions_ClauseForActionID] PRIMARY KEY CLUSTERED 
(
	[ClauseForActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clauses]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clauses](
	[ClauseID] [int] IDENTITY(1,1) NOT NULL,
	[ClauseTypeID] [smallint] NOT NULL,
	[ProductTypeID] [int] NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[ClauseText] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Clauses_ClauseID] PRIMARY KEY CLUSTERED 
(
	[ClauseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClauseTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClauseTypes](
	[ClauseTypeID] [smallint] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ClauseTypes_ClauseTypeID] PRIMARY KEY CLUSTERED 
(
	[ClauseTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyDistricts]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyDistricts](
	[CompanyDistrictID] [int] IDENTITY(1,1) NOT NULL,
	[DistrictID] [smallint] NOT NULL,
	[CompanyID] [smallint] NOT NULL,
 CONSTRAINT [PK_CompanyDistricts_CompanyDistrictID] PRIMARY KEY CLUSTERED 
(
	[CompanyDistrictID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComputedOutputModes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputedOutputModes](
	[OutputModeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ComputedOutputModes] PRIMARY KEY CLUSTERED 
(
	[OutputModeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ComputedOutputModes_Code] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComputeMethods]    Script Date: 18-Jan-26 13:43:11 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ComputeMethods_Code] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernHierarchies]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernHierarchies](
	[ConcernHierarchyID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernParentID] [int] NOT NULL,
	[ConcernChildID] [int] NOT NULL,
 CONSTRAINT [PK_ConcernHierarchies_ConcernHierarchyID] PRIMARY KEY CLUSTERED 
(
	[ConcernHierarchyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernInsuredPersons]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernInsuredPersons](
	[ConcernInsuredPersonID] [int] IDENTITY(1,1) NOT NULL,
	[InsuredPersonID] [int] NOT NULL,
	[ConcernID] [int] NOT NULL,
 CONSTRAINT [PK_ConcernInsuredPersons_ConcernInsuredPersonID] PRIMARY KEY CLUSTERED 
(
	[ConcernInsuredPersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernMarkGroups]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernMarkGroups](
	[ConcernMarkGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_ConcernMarkGroup] PRIMARY KEY CLUSTERED 
(
	[ConcernMarkGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernMarks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernMarks](
	[ConcernMarkID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernMarkTypeID] [int] NOT NULL,
	[ConcernID] [int] NOT NULL,
	[TariffRiskMarkID] [int] NULL,
 CONSTRAINT [PK_ConcernMarks_ConcernMarkID] PRIMARY KEY CLUSTERED 
(
	[ConcernMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ConcernMarks_ConcernID_ConcernMarkTypeID] UNIQUE NONCLUSTERED 
(
	[ConcernID] ASC,
	[ConcernMarkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernMarkTypeFilters]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernMarkTypeFilters](
	[ConcernMarkTypeFilterID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernMarkTypeID] [int] NOT NULL,
	[ConcernTypeID] [smallint] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
 CONSTRAINT [PK_ConcernMarkTypeFilters_ConcernMarkTypeFilterID] PRIMARY KEY CLUSTERED 
(
	[ConcernMarkTypeFilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernMarkTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernMarkTypes](
	[ConcernMarkTypeID] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[ConcernMarkGroupId] [int] NULL,
 CONSTRAINT [PK_ConcernMarkTypes_ConcernMarkTypeID] PRIMARY KEY CLUSTERED 
(
	[ConcernMarkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernPackages]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernPackages](
	[ConcernPackageID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernID] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[FreeEntryName] [nvarchar](50) NULL,
 CONSTRAINT [PK_ConcernPackages_ConcernPackageID] PRIMARY KEY CLUSTERED 
(
	[ConcernPackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernPersons]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernPersons](
	[ConcernID] [int] NOT NULL,
	[PersonID] [int] NULL,
	[IncreasedAge] [smallint] NULL,
	[DateOfBirth] [date] NULL,
	[Height] [decimal](18, 4) NULL,
	[Weight] [decimal](18, 4) NULL,
	[GenderID] [smallint] NULL,
	[PersonInfo] [nvarchar](200) NULL,
	[BMI] [decimal](18, 4) NULL,
	[ConcernPersonID] [int] IDENTITY(1,1) NOT NULL,
	[CardNumber] [nvarchar](30) NULL,
	[PIN] [nvarchar](8) NULL,
	[IdentificationNumber] [nvarchar](20) NULL,
 CONSTRAINT [PK_ConcernPersons_ConcernPersonID] PRIMARY KEY CLUSTERED 
(
	[ConcernPersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernProperties]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernProperties](
	[ConcernID] [int] NOT NULL,
	[ConcernPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyConcernTypeID] [int] NOT NULL,
	[ConcernBuildingRate] [decimal](18, 4) NULL,
	[DumpingRate] [decimal](18, 4) NULL,
	[Surface] [decimal](18, 2) NULL,
	[ValueM2] [decimal](18, 2) NULL,
	[NewValuePrice] [bit] NULL,
	[Estimate] [bit] NULL,
	[Protection] [bit] NULL,
	[PrivatePossessions] [bit] NULL,
	[BuiltYear] [int] NULL,
	[AdditionalObjectSurface] [decimal](18, 2) NULL,
	[Description] [nvarchar](500) NULL,
	[AdditionalObjectDescription] [nvarchar](500) NULL,
	[PhotoEquipmentDescription] [nvarchar](500) NULL,
	[BicycleDescription] [nvarchar](500) NULL,
	[ContractingTypeID] [int] NULL,
	[ParentConcernPropertyID] [int] NULL,
	[LocationID] [int] NOT NULL,
	[EntryModeId] [int] NULL,
 CONSTRAINT [PK_ConcernProperties] PRIMARY KEY CLUSTERED 
(
	[ConcernPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernPropertyListItems]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernPropertyListItems](
	[ConcernPropertyListItemID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernPropertyListID] [int] NOT NULL,
	[ItemOrdinal] [int] NOT NULL,
	[ItemDescription] [nvarchar](500) NOT NULL,
	[ProductionYear] [int] NULL,
	[SerialNumber] [nvarchar](100) NULL,
	[ItemSumInsured] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_ConcernPropertyListItems] PRIMARY KEY CLUSTERED 
(
	[ConcernPropertyListItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernPropertyLists]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernPropertyLists](
	[ConcernPropertyListID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernPropertyID] [int] NOT NULL,
	[ListNumber] [int] NOT NULL,
	[ItemsCount] [int] NULL,
	[ItemsSum] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ConcernPropertyList] PRIMARY KEY CLUSTERED 
(
	[ConcernPropertyListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ConcernPropertyList_ConcernPropertyId] UNIQUE NONCLUSTERED 
(
	[ConcernPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ConcernPropertyList_ListNumber] UNIQUE NONCLUSTERED 
(
	[ListNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernQuestionaryTypeOptions]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernQuestionaryTypeOptions](
	[ConcernQuestionaryTypeOptionID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernID] [int] NOT NULL,
	[QuestionaryTypeID] [smallint] NOT NULL,
	[IsSelected] [bit] NOT NULL,
 CONSTRAINT [PK_ConcernQuestionaryTypeOptions_ConcernQuestionaryTypeOptionID] PRIMARY KEY CLUSTERED 
(
	[ConcernQuestionaryTypeOptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernRiskCovers]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernRiskCovers](
	[ConcernRiskCoverID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernRiskID] [int] NOT NULL,
	[CoverID] [int] NOT NULL,
	[Rate] [decimal](18, 4) NULL,
	[Limit] [decimal](18, 2) NULL,
	[LimitTypeId] [int] NULL,
 CONSTRAINT [PK_ConcernRiskCovers_ConcernRiskCoverID] PRIMARY KEY CLUSTERED 
(
	[ConcernRiskCoverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernRiskQuestionaries]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernRiskQuestionaries](
	[ConcernRiskQuestionaryID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernRiskID] [int] NOT NULL,
	[Answer] [nvarchar](2000) NULL,
 CONSTRAINT [PK_ConcernRiskQuestionaries_ConcernRiskQuestionaryID] PRIMARY KEY CLUSTERED 
(
	[ConcernRiskQuestionaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernRisks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernRisks](
	[ConcernRiskID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernID] [int] NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[InsuredSum] [decimal](18, 4) NULL,
	[PremiumRate] [decimal](18, 6) NULL,
	[Premium] [decimal](18, 4) NULL,
	[OrdinalNumber] [int] NULL,
	[NetoInstallment] [decimal](18, 4) NULL,
	[UnderwritingSurcharge] [decimal](18, 4) NULL,
	[Tax] [decimal](18, 4) NULL,
	[OriginalConcernRiskID] [int] NOT NULL,
	[InsuredSumRate] [decimal](18, 4) NULL,
	[PremiumYear] [decimal](18, 4) NULL,
	[SumInsuredEndowmentPercent] [decimal](18, 10) NULL,
	[PremiumRateCode] [nvarchar](50) NULL,
	[IsExcluded] [bit] NULL,
	[BaseForExperimentalCalculation] [decimal](18, 4) NULL,
	[MathematicalReserveAmount] [decimal](18, 4) NULL,
	[ContractingTypeID] [int] NULL,
 CONSTRAINT [PK_ConcernRisks_ConcernRiskID] PRIMARY KEY CLUSTERED 
(
	[ConcernRiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Concerns]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Concerns](
	[ConcernID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernTypeID] [smallint] NOT NULL,
	[OrdinalNumber] [int] NOT NULL,
	[InsuredSum] [decimal](18, 4) NULL,
	[DocumentCalculationLayerID] [bigint] NOT NULL,
	[GroupDescription] [nvarchar](2000) NULL,
	[NumberOfConcernsInGroup] [int] NULL,
	[OriginalConcernID] [int] NOT NULL,
	[LevelOfRiskID] [smallint] NULL,
	[CurrencyID] [smallint] NULL,
 CONSTRAINT [PK_Concerns_ConcernID] PRIMARY KEY CLUSTERED 
(
	[ConcernID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConcernTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConcernTypes](
	[ConcernTypeID] [smallint] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](2000) NULL,
 CONSTRAINT [PK_ConcernTypes_ConcernTypeID] PRIMARY KEY CLUSTERED 
(
	[ConcernTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConstructionSubtypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConstructionSubtypes](
	[ConstructionSubtypeID] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionTypeID] [int] NOT NULL,
	[SubConstructionTypeID] [int] NOT NULL,
 CONSTRAINT [PK_ConstructionSubtypes_ConstructionSubtypeID] PRIMARY KEY CLUSTERED 
(
	[ConstructionSubtypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractingTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractingTypes](
	[ContractingTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[DefaultFlag] [bit] NULL,
 CONSTRAINT [PK_ContractingTypes] PRIMARY KEY CLUSTERED 
(
	[ContractingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CorrectionPackageRisks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CorrectionPackageRisks](
	[CorrectionPackageRiskID] [int] IDENTITY(1,1) NOT NULL,
	[CorrectionID] [int] NOT NULL,
	[PackageIDFrom] [int] NULL,
	[PackageIDTo] [int] NULL,
	[RiskIDFrom] [int] NULL,
	[RiskIDTo] [int] NULL,
	[CoverIDFrom] [int] NULL,
	[CoverIDTo] [int] NULL,
 CONSTRAINT [PK_CorrectionPackageRisks_CorrectionPackageRiskID] PRIMARY KEY CLUSTERED 
(
	[CorrectionPackageRiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Covers]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Covers](
	[CoverID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Covers_CoverID] PRIMARY KEY CLUSTERED 
(
	[CoverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currencies]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currencies](
	[CurrencyID] [smallint] NOT NULL,
	[Code] [char](3) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Valid] [bit] NULL,
	[Note] [nvarchar](2000) NULL,
 CONSTRAINT [PK_Currencies_CurrencyID] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Districts]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Districts](
	[DistrictID] [smallint] IDENTITY(1,1) NOT NULL,
	[StateID] [smallint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Code] [nvarchar](50) NULL,
 CONSTRAINT [PK_Districts_DistrictID] PRIMARY KEY CLUSTERED 
(
	[DistrictID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EarthquakeZones]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EarthquakeZones](
	[EarthquakeZoneID] [int] IDENTITY(1,1) NOT NULL,
	[ZoneCode] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[ZoneCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ForPurposes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForPurposes](
	[ForPurposeID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ForPurposes_ForPurposeID] PRIMARY KEY CLUSTERED 
(
	[ForPurposeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GoodsHazardClasses]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GoodsHazardClasses](
	[GoodsHazardClassID] [int] IDENTITY(1,1) NOT NULL,
	[GoodsName] [nvarchar](100) NULL,
	[HazardClassId] [int] NOT NULL,
 CONSTRAINT [PK_GoodsHazardClass] PRIMARY KEY CLUSTERED 
(
	[GoodsHazardClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupsOfContracting]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupsOfContracting](
	[GroupOfContractingID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_GroupOfContracting] PRIMARY KEY CLUSTERED 
(
	[GroupOfContractingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HazardClasses]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HazardClasses](
	[HazardClassID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_HazardClasses] PRIMARY KEY CLUSTERED 
(
	[HazardClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Indicators]    Script Date: 18-Jan-26 13:43:11 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndividualMachineCategories]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndividualMachineCategories](
	[IndividualMachineCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[IndividualMachineTariffGroupID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_IndividualMachineCategories_IndividualMachineCategoryID] PRIMARY KEY CLUSTERED 
(
	[IndividualMachineCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndividualMachineGroups]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndividualMachineGroups](
	[IndividualMachineGroupID] [int] IDENTITY(1,1) NOT NULL,
	[IndividualMachineCategoryID] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_IndividualMachineGroups_IndividualMachineGroupID] PRIMARY KEY CLUSTERED 
(
	[IndividualMachineGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndividualMachineTariffGroups]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndividualMachineTariffGroups](
	[IndividualMachineTariffGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_IndividualMachineTariffGroups_IndividualMachineTariffGroupID] PRIMARY KEY CLUSTERED 
(
	[IndividualMachineTariffGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndividualMachineTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndividualMachineTypes](
	[IndividualMachineTypeID] [int] IDENTITY(1,1) NOT NULL,
	[IndividualMachineGroupID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_IndividualMachineTypes_IndividualMachineTypeID] PRIMARY KEY CLUSTERED 
(
	[IndividualMachineTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndustryCodeCategories]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndustryCodeCategories](
	[IndustryCodeCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[IndustryCodeID] [int] NOT NULL,
	[ForPurposeID] [int] NOT NULL,
	[DangerClass] [nvarchar](200) NULL,
 CONSTRAINT [PK_IndustryCodeCategories_IndustryCodeCategoryID] PRIMARY KEY CLUSTERED 
(
	[IndustryCodeCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndustryCodeLevels]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndustryCodeLevels](
	[IndustryCodeLevelID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_IndustryCodeLevels_IndustryCodeLevelID] PRIMARY KEY CLUSTERED 
(
	[IndustryCodeLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndustryCodes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndustryCodes](
	[IndustryCodeID] [int] IDENTITY(1,1) NOT NULL,
	[IndustryCodeLevelID] [int] NOT NULL,
	[Code] [nvarchar](20) NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[LevelOfRiskID] [smallint] NULL,
 CONSTRAINT [PK_IndustryCodes_IndustryCodeID] PRIMARY KEY CLUSTERED 
(
	[IndustryCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuranceConditions]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuranceConditions](
	[InsuranceConditionID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](10) NULL,
	[Name] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_InsuranceConditions_InsuranceConditionID] PRIMARY KEY CLUSTERED 
(
	[InsuranceConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuredSumPaymentConditions]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuredSumPaymentConditions](
	[InsuredSumPaymentConditionID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_InsuredSumPaymentConditions_InsuredSumPaymentConditionID] PRIMARY KEY CLUSTERED 
(
	[InsuredSumPaymentConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuredSumPaymentTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuredSumPaymentTypes](
	[InsuredSumPaymentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_InsuredSumPaymentTypes_InsuredSumPaymentTypeID] PRIMARY KEY CLUSTERED 
(
	[InsuredSumPaymentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuredSumPerUnitOfPremiums]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuredSumPerUnitOfPremiums](
	[InsuredSumPerUnitOfPremiumID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[PaymentDynamicID] [smallint] NOT NULL,
	[Age] [smallint] NOT NULL,
	[InsuranceDurationInYears] [smallint] NOT NULL,
	[InsuredSum] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_InsuredSumPerUnitOfPremiums_InsuredSumPerUnitOfPremiumID] PRIMARY KEY CLUSTERED 
(
	[InsuredSumPerUnitOfPremiumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LevelOfRisks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LevelOfRisks](
	[LevelOfRiskID] [smallint] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_LevelOfRisks_LevelOfRiskID] PRIMARY KEY CLUSTERED 
(
	[LevelOfRiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LineOfBusinesses]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LineOfBusinesses](
	[LineOfBusinessID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_LineOfBusinesses_LineOfBusinessID] PRIMARY KEY CLUSTERED 
(
	[LineOfBusinessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LineOfBusinessExtensions]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LineOfBusinessExtensions](
	[LineOfBusinessExtensionID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskStateLineOfBusinessID] [int] NOT NULL,
	[Extension] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_LineOfBusinessExtensions_LineOfBusinessExtensionID] PRIMARY KEY CLUSTERED 
(
	[LineOfBusinessExtensionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LineOfBusinessHierarchies]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LineOfBusinessHierarchies](
	[LineOfBusinessHierarchyID] [int] IDENTITY(1,1) NOT NULL,
	[LineOfBusinessID] [smallint] NOT NULL,
	[ChildLineOfBusinessID] [smallint] NOT NULL,
 CONSTRAINT [PK_LineOfBusinessHierarchies_LineOfBusinessHierarchyID] PRIMARY KEY CLUSTERED 
(
	[LineOfBusinessHierarchyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Locations]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locations](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[IndustryCodeCategoryID] [int] NULL,
	[AddressID] [int] NOT NULL,
	[PremiumRateMatrixID] [int] NULL,
 CONSTRAINT [PK_Locations_LocationID] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MerchandiseTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MerchandiseTypes](
	[MerchandiseTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MerchandiseTypes_MerchandiseTypeID] PRIMARY KEY CLUSTERED 
(
	[MerchandiseTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MethodsOfContracting]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MethodsOfContracting](
	[MethodOfContractingID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[GroupOfContractingID] [int] NOT NULL,
 CONSTRAINT [PK_MethodOfContracting] PRIMARY KEY CLUSTERED 
(
	[MethodOfContractingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Municipalities]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Municipalities](
	[MunicipalityID] [smallint] IDENTITY(1,1) NOT NULL,
	[DistrictID] [smallint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Code] [nvarchar](50) NULL,
 CONSTRAINT [PK_Municipalities_MunicipalitieID] PRIMARY KEY CLUSTERED 
(
	[MunicipalityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotSelectedConcernRisks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotSelectedConcernRisks](
	[NotSelectedConcernRiskID] [int] IDENTITY(1,1) NOT NULL,
	[ConcernID] [int] NOT NULL,
	[TariffRiskID] [int] NOT NULL,
 CONSTRAINT [PK_NotSelectedConcernRisks_NotSelectedConcernRiskID] PRIMARY KEY CLUSTERED 
(
	[NotSelectedConcernRiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NumberOfInsurees]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NumberOfInsurees](
	[NumberOfInsureeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_NumberOfInsurees_NumberOfInsureeID] PRIMARY KEY CLUSTERED 
(
	[NumberOfInsureeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Packages]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Packages](
	[PackageID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Indent] [int] NULL,
	[IsOpenPolicy] [bit] NULL,
	[TariffCode] [int] NOT NULL,
 CONSTRAINT [PK_Packages_PackageID] PRIMARY KEY CLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackageTariffRisks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageTariffRisks](
	[PackageTariffRiskID] [int] IDENTITY(1,1) NOT NULL,
	[PackageID] [int] NULL,
	[TariffRiskID] [int] NULL,
	[Premium] [decimal](18, 2) NULL,
	[InsuredSum] [decimal](18, 2) NULL,
	[Franchise] [decimal](18, 2) NULL,
 CONSTRAINT [PK_PackageTariffRisk] PRIMARY KEY CLUSTERED 
(
	[PackageTariffRiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentDynamics]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentDynamics](
	[PaymentDynamicID] [smallint] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[NumberOfInstallmentsPerYear] [int] NULL,
 CONSTRAINT [PK_PaymentDynamics_PaymentDynamicID] PRIMARY KEY CLUSTERED 
(
	[PaymentDynamicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentMethods]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentMethods](
	[PaymentMethodID] [smallint] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](2000) NULL,
 CONSTRAINT [PK_PaymentMethods_PaymentMethodID] PRIMARY KEY CLUSTERED 
(
	[PaymentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Places]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Places](
	[PlaceID] [smallint] IDENTITY(1,1) NOT NULL,
	[StateID] [smallint] NOT NULL,
	[MunicipalityID] [smallint] NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_Places_PlaceID] PRIMARY KEY CLUSTERED 
(
	[PlaceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PremiumInstallmentPerUnitOfInsuredSums]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PremiumInstallmentPerUnitOfInsuredSums](
	[PremiumInstallmentPerUnitOfInsuredSumID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[PaymentDynamicID] [smallint] NOT NULL,
	[Age] [smallint] NOT NULL,
	[InsuranceDurationInYears] [smallint] NOT NULL,
	[PremiumInstallment] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_PremiumInstallmentPerUnitOfInsuredSums_PremiumInstallmentPerUnitOfInsuredSumID] PRIMARY KEY CLUSTERED 
(
	[PremiumInstallmentPerUnitOfInsuredSumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PremiumRateMatrix]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PremiumRateMatrix](
	[PremiumRateMatrixID] [int] IDENTITY(1,1) NOT NULL,
	[TariffPropertyTypeID] [int] NULL,
	[HazardClassID] [int] NULL,
	[ProtectionClassID] [int] NULL,
	[MethodOfContractingID] [int] NULL,
	[StorageAreaID] [int] NULL,
	[ConstructionTypeID] [int] NULL,
	[PremiumRate] [decimal](10, 4) NULL,
 CONSTRAINT [PK_PremiumRateMatrix] PRIMARY KEY CLUSTERED 
(
	[PremiumRateMatrixID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductQuestionaryTypes]    Script Date: 18-Jan-26 13:43:11 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[CompanyID] [smallint] NOT NULL,
	[IsLife] [bit] NOT NULL,
	[ActiveTillOnField] [date] NULL,
	[ActiveTillInHQ] [date] NULL,
 CONSTRAINT [PK_Products_ProductID] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductSettings]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductSettings](
	[ProductSettingID] [int] IDENTITY(1,1) NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[TariffID] [int] NOT NULL,
	[ProductSettingSourceID] [int] NOT NULL,
	[ProductSettingTypeID] [int] NOT NULL,
	[SourceID] [int] NOT NULL,
	[Value] [varchar](255) NULL,
 CONSTRAINT [PK_ProductSettings] PRIMARY KEY CLUSTERED 
(
	[ProductSettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTypeDocumentMarks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTypeDocumentMarks](
	[ProductTypeDocumentMarkID] [int] IDENTITY(1,1) NOT NULL,
	[DocumentMarkID] [int] NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[DateFrom] [date] NOT NULL,
	[DateTo] [date] NULL,
	[OrdinalNumber] [smallint] NULL,
	[NotAffectOnCalculation] [bit] NULL,
	[NotAffectOnTariff] [bit] NULL,
 CONSTRAINT [PK_ProductTypeDocumentMark_ProductTypeDocumentMarkID] PRIMARY KEY CLUSTERED 
(
	[ProductTypeDocumentMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTypes](
	[ProductTypeID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[ProductID] [smallint] NOT NULL,
 CONSTRAINT [PK_ProductTypes_ProductTypeID] PRIMARY KEY CLUSTERED 
(
	[ProductTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTypeTariffs]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTypeTariffs](
	[ProductTypeTariffID] [int] IDENTITY(1,1) NOT NULL,
	[ProductTypeID] [int] NOT NULL,
	[TariffID] [int] NOT NULL,
	[IsPolicy] [bit] NOT NULL,
 CONSTRAINT [PK_ProductTypeTariffs_ProductTypeTariffID] PRIMARY KEY CLUSTERED 
(
	[ProductTypeTariffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ProductTypeTariffs_ProductTypeID_TariffID_IsPolicy] UNIQUE NONCLUSTERED 
(
	[ProductTypeID] ASC,
	[TariffID] ASC,
	[IsPolicy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyBuildings]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyBuildings](
	[PropertyBuildingID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyBuildingTypeID] [int] NOT NULL,
	[BuildingID] [int] NOT NULL,
	[RiskZoneID] [int] NULL,
	[MerchandiseTypeID] [int] NULL,
	[ConcernPropertyID] [int] NOT NULL,
	[ConstructionSubtypeID] [int] NULL,
	[IndustryCodeCategoryId] [int] NULL,
 CONSTRAINT [PK_PropertyBuildings_PropertyBuildingID] PRIMARY KEY CLUSTERED 
(
	[PropertyBuildingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyBuildingTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyBuildingTypes](
	[PropertyBuildingTypeID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PropertyBuildingTypes_PropertyBuildingTypeID] PRIMARY KEY CLUSTERED 
(
	[PropertyBuildingTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyConcernTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyConcernTypes](
	[PropertyConcernTypeID] [int] NOT NULL,
	[PropertyTypeID] [int] NOT NULL,
	[Name] [nvarchar](300) NOT NULL,
	[Description] [nvarchar](2000) NULL,
 CONSTRAINT [PK_PropertyConcernTypes_PropertyConcernTypeID] PRIMARY KEY CLUSTERED 
(
	[PropertyConcernTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyInsuranceGroups]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyInsuranceGroups](
	[PropertyInsuranceGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_PropertyInsuranceLine] PRIMARY KEY CLUSTERED 
(
	[PropertyInsuranceGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyTypes](
	[PropertyTypeID] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](2000) NULL,
 CONSTRAINT [PK_PropertyTypes_PropertyTypeID] PRIMARY KEY CLUSTERED 
(
	[PropertyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProtectionClasses]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProtectionClasses](
	[ProtectionClassID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_ProtectionClasses] PRIMARY KEY CLUSTERED 
(
	[ProtectionClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionComputedConfigs]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionComputedConfigs](
	[QuestionComputedConfigID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[ComputeMethodID] [smallint] NOT NULL,
	[MatrixObjectName] [sysname] NOT NULL,
	[RuleName] [nvarchar](200) NULL,
	[RuleDescription] [nvarchar](1000) NULL,
	[OutputMode] [tinyint] NOT NULL,
	[OutputTarget] [nvarchar](256) NULL,
	[MatrixOutputColumnName] [sysname] NOT NULL,
	[Priority] [smallint] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_QuestionComputedConfigs] PRIMARY KEY CLUSTERED 
(
	[QuestionComputedConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireAnswers]    Script Date: 18-Jan-26 13:43:11 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireByQuestionnaireIdentificators]    Script Date: 18-Jan-26 13:43:11 ******/
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
/****** Object:  Table [dbo].[QuestionnaireByQuestionnaireIdentificatorTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireByQuestionnaireIdentificatorTypes](
	[QuestionnaireByQuestionnaireIdentificatorTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[QuestionnaireIdentificatorTypeID] [int] NULL,
	[QuestionnaireTypeID] [smallint] NULL,
	[PoliticalPerson] [bit] NULL,
 CONSTRAINT [PK_QuestionnaireByQuestionnaireIdentificatorType] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireByQuestionnaireIdentificatorTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireIdentificators]    Script Date: 18-Jan-26 13:43:11 ******/
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
/****** Object:  Table [dbo].[QuestionnaireIdentificatorTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireIdentificatorTypes](
	[QuestionnaireIdentificatorTypeID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_QuestionnarieIdentificatorType] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireIdentificatorTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questionnaires]    Script Date: 18-Jan-26 13:43:11 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireTypeReferenceTables]    Script Date: 18-Jan-26 13:43:11 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_QuestionnaireTypeReferenceTables_QuestionnaireTypeID_TableName] UNIQUE NONCLUSTERED 
(
	[QuestionnaireTypeID] ASC,
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionnaireTypeRules]    Script Date: 18-Jan-26 13:43:11 ******/
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
/****** Object:  Table [dbo].[QuestionnaireTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionnaireTypes](
	[QuestionnaireTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[QuestionnaireCategoryID] [smallint] NULL,
 CONSTRAINT [PK_QuestionaryTypes_QuestionaryTypeID] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionReferenceColumns]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionReferenceColumns](
	[QuestionReferenceColumnID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[QuestionnaireTypeReferenceTableID] [int] NOT NULL,
	[ReferenceColumnName] [nvarchar](200) NULL,
 CONSTRAINT [PK__Question__0DC06F8C6DA96EE1] PRIMARY KEY CLUSTERED 
(
	[QuestionReferenceColumnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ranks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS OFF
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RiskAttributeTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RiskAttributeTypes](
	[RiskAttributeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](2000) NULL,
 CONSTRAINT [PK_RiskAttributeTypes_RiskAttributeTypeID] PRIMARY KEY CLUSTERED 
(
	[RiskAttributeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RiskHierarchies]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RiskHierarchies](
	[RiskHierarchyID] [int] IDENTITY(1,1) NOT NULL,
	[RiskID] [int] NOT NULL,
	[ParentRiskID] [int] NOT NULL,
 CONSTRAINT [PK_RiskHierarchies_RiskHierarchyID] PRIMARY KEY CLUSTERED 
(
	[RiskHierarchyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RiskLevels]    Script Date: 18-Jan-26 13:43:11 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Risks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Risks](
	[RiskID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](2000) NULL,
 CONSTRAINT [PK_Risks_RiskID] PRIMARY KEY CLUSTERED 
(
	[RiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RiskZones]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RiskZones](
	[RiskZoneID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[RiskZoneCode] [nvarchar](50) NOT NULL,
	[Class] [nvarchar](50) NOT NULL,
	[ProductID] [smallint] NOT NULL,
 CONSTRAINT [PK_RiskZones_RiskZoneID] PRIMARY KEY CLUSTERED 
(
	[RiskZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpecificQuestionTypes]    Script Date: 18-Jan-26 13:43:11 ******/
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
/****** Object:  Table [dbo].[States]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[States](
	[StateID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[AlfaCode] [char](2) NOT NULL,
	[NumericCode] [smallint] NOT NULL,
	[OfficialCurrencyID] [smallint] NULL,
	[OldID] [char](10) NULL,
 CONSTRAINT [PK_States_StateID] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StorageAreas]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StorageAreas](
	[StorageAreaID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_StorageAreas] PRIMARY KEY CLUSTERED 
(
	[StorageAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Streets]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Streets](
	[StreetID] [int] IDENTITY(1,1) NOT NULL,
	[PlaceID] [smallint] NOT NULL,
	[Name] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_Streets_StreetID] PRIMARY KEY CLUSTERED 
(
	[StreetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffConditions]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffConditions](
	[TariffConditionID] [int] IDENTITY(1,1) NOT NULL,
	[StandardRisk] [bit] NOT NULL,
	[InsuranceConditionID] [int] NOT NULL,
	[TariffID] [int] NOT NULL,
	[ConditionValue] [decimal](18, 4) NULL,
 CONSTRAINT [PK_TariffConditions_TarrifConditionID] PRIMARY KEY CLUSTERED 
(
	[TariffConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffGroupActivityCodes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffGroupActivityCodes](
	[TariffGroupID] [int] NOT NULL,
	[ActivityCode] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_TGAct] PRIMARY KEY CLUSTERED 
(
	[TariffGroupID] ASC,
	[ActivityCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffGroupHierarchies]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffGroupHierarchies](
	[TariffGroupHierarchyID] [int] IDENTITY(1,1) NOT NULL,
	[TariffGroupID] [int] NOT NULL,
	[SubTariffGroupID] [int] NOT NULL,
 CONSTRAINT [PK_TariffGroupHierarchies_TariffGroupHierarchyID] PRIMARY KEY CLUSTERED 
(
	[TariffGroupHierarchyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffGroups]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffGroups](
	[TariffGroupID] [int] IDENTITY(1,1) NOT NULL,
	[LineOfBusinessID] [smallint] NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](2000) NULL,
	[InsuredSumPaymentTypeID] [int] NULL,
	[NumberOfInsureeID] [int] NULL,
	[InsuredSumPaymentConditionID] [smallint] NULL,
	[BeginingOfInsuredSumPayment] [datetime] NULL,
	[EndOfInsuredSumPayment] [datetime] NULL,
	[PropertyInsuranceGroupID] [int] NULL,
 CONSTRAINT [PK_TariffGroups_TariffGroupID] PRIMARY KEY CLUSTERED 
(
	[TariffGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffHierarchies]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffHierarchies](
	[TariffHierarchyID] [int] IDENTITY(1,1) NOT NULL,
	[TariffID] [int] NOT NULL,
	[ParentTariffID] [int] NOT NULL,
 CONSTRAINT [PK_TariffHierarchies_RiskTariffID] PRIMARY KEY CLUSTERED 
(
	[TariffHierarchyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffOverheads]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffOverheads](
	[TariffOverheadID] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[TariffID] [int] NOT NULL,
	[NetPremiumRate] [decimal](18, 6) NULL,
 CONSTRAINT [PK_TariffOverheads_TariffOverheadID] PRIMARY KEY CLUSTERED 
(
	[TariffOverheadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffPropertyMarkTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffPropertyMarkTypes](
	[TariffPropertyMarkTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TariffID] [int] NOT NULL,
	[PropertyConcernTypeID] [int] NOT NULL,
	[ConcernMarkTypeID] [int] NOT NULL,
	[IsAllowed] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TariffPropertyMarkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_TGPropertyMark] UNIQUE NONCLUSTERED 
(
	[TariffID] ASC,
	[PropertyConcernTypeID] ASC,
	[ConcernMarkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffPropertyTypeKingCodes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffPropertyTypeKingCodes](
	[TariffPropertyTypeKingCodeID] [smallint] IDENTITY(1,1) NOT NULL,
	[TariffRiskTypeID] [int] NULL,
	[TariffPropertyTypeID] [int] NOT NULL,
	[KingCode] [nvarchar](10) NULL,
 CONSTRAINT [PK_TariffPropertyTypesKingCode] PRIMARY KEY CLUSTERED 
(
	[TariffPropertyTypeKingCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffPropertyTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffPropertyTypes](
	[TariffPropertyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TariffID] [int] NOT NULL,
	[PropertyConcernTypeID] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsRequired] [bit] NOT NULL,
	[IsDefault] [bit] NOT NULL,
 CONSTRAINT [PK_TariffGroupPropertyTypes] PRIMARY KEY CLUSTERED 
(
	[TariffPropertyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_TGPT_Group_Property] UNIQUE NONCLUSTERED 
(
	[TariffID] ASC,
	[PropertyConcernTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskApprovalCorrectionSurcharges]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskApprovalCorrectionSurcharges](
	[TariffRiskApprovalCorrectionSurchargeID] [int] NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[Format] [nvarchar](50) NULL,
 CONSTRAINT [PK_TariffRiskApprovalCorrectionSurcharges_TariffRiskApprovalCorrectionSurchargeID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskApprovalCorrectionSurchargeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskApprovalCorrectionTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskApprovalCorrectionTypes](
	[TariffRiskApprovalCorrectionTypeID] [int] NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_TariffRiskApprovalCorrectionTypes_TariffRiskApprovalCorrectionTypeID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskApprovalCorrectionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskBeneficiaryTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskBeneficiaryTypes](
	[TariffRiskBeneficiaryTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[BeneficiaryTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK_TariffRiskBeneficiaryTypes_TariffRiskBeneficiaryTypeID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskBeneficiaryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskCovers]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskCovers](
	[TariffRiskCoverID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NULL,
	[CoverID] [int] NULL,
	[IsMainCover] [bit] NULL,
 CONSTRAINT [PK_TariffRiskCovers] PRIMARY KEY CLUSTERED 
(
	[TariffRiskCoverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskHierarchies]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskHierarchies](
	[TariffRiskHierarchyID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NULL,
	[ParentTariffRiskID] [int] NULL,
 CONSTRAINT [PK_TariffRiskHierarchies_TariffRiskHierarchyID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskHierarchyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskInsuredSumLists]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskInsuredSumLists](
	[TariffRiskInsuredSumListID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[InsuredSum] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_TariffRiskInsuredSumLists_TariffRiskInsuredSumListID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskInsuredSumListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskMarks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskMarks](
	[TariffRiskMarkID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[TariffRiskMarkTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK_TariffRiskMarks_TariffRiskMarkID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskMarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_TariffRiskMarks_TariffRiskID_TariffRiskMarkTypeID] UNIQUE NONCLUSTERED 
(
	[TariffRiskID] ASC,
	[TariffRiskMarkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskMarkTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskMarkTypes](
	[TariffRiskMarkTypeID] [smallint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_TariffRiskMarkTypes_TariffRiskMarkTypeID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskMarkTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskRiskAttributeTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskRiskAttributeTypes](
	[TariffRiskRiskAttributeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TariffRiskID] [int] NOT NULL,
	[RiskAttributeTypeID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ValidFrom] [smalldatetime] NULL,
	[ValidTo] [smalldatetime] NULL,
	[IsVisibleForAgent] [smallint] NULL,
	[CurrencyId] [smallint] NULL,
	[OrderNumber] [smallint] NULL,
 CONSTRAINT [PK_TariffRiskRiskAttributeTypes_TariffRiskRiskAttributeTypeID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskRiskAttributeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRisks]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRisks](
	[TariffRiskID] [int] IDENTITY(1,1) NOT NULL,
	[TariffID] [int] NOT NULL,
	[RiskID] [int] NOT NULL,
	[IsInsuredSumLimitedBySetOfValues] [bit] NULL,
	[MainEventCoeficient] [decimal](18, 4) NULL,
	[OrdinalNumber] [int] NOT NULL,
	[TariffRiskTypeID] [smallint] NOT NULL,
	[MainEventCoeficientGender] [decimal](18, 4) NULL,
	[GenderID] [smallint] NULL,
 CONSTRAINT [PK_TariffRisks_TariffRiskID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TariffRiskTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TariffRiskTypes](
	[TariffRiskTypeID] [smallint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_TariffRiskTypes_TariffRiskTypeID] PRIMARY KEY CLUSTERED 
(
	[TariffRiskTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tariffs]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tariffs](
	[TariffID] [int] IDENTITY(1,1) NOT NULL,
	[TariffGroupID] [int] NOT NULL,
	[VersionNumber] [nvarchar](20) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[Description] [nvarchar](200) NULL,
	[RowStartDate] [date] NULL,
	[RowEndDate] [date] NULL,
	[Code] [nvarchar](20) NULL,
	[ShortName] [nvarchar](50) NOT NULL,
	[FullName] [nvarchar](1000) NOT NULL,
	[RiskSumCalculationTypeID] [int] NULL,
 CONSTRAINT [PK_Tariffs_TariffID] PRIMARY KEY CLUSTERED 
(
	[TariffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VinculationCreditors]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VinculationCreditors](
	[VinculationCreditorID] [int] IDENTITY(1,1) NOT NULL,
	[VinculationID] [int] NOT NULL,
	[BankID] [int] NULL,
	[Rate] [decimal](18, 4) NULL,
	[Ordinal] [int] NOT NULL,
	[VinculationCreditorTypeID] [smallint] NOT NULL,
	[Firstname] [nvarchar](200) NULL,
	[Surname] [nvarchar](200) NULL,
	[LegalName] [nvarchar](1000) NULL,
	[JMBG] [nvarchar](50) NULL,
	[PIB] [nvarchar](50) NULL,
	[MBR] [nvarchar](50) NULL,
	[OIB] [nvarchar](50) NULL,
 CONSTRAINT [PK_VinculationCreditors_VinculationCreditorID] PRIMARY KEY CLUSTERED 
(
	[VinculationCreditorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VinculationCreditorTypes]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VinculationCreditorTypes](
	[VinculationCreditorTypeID] [smallint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_VinculationCreditorTypes_VinculationCreditorTypeID] PRIMARY KEY CLUSTERED 
(
	[VinculationCreditorTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VinculationDetails]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VinculationDetails](
	[VinculationDetailID] [int] IDENTITY(1,1) NOT NULL,
	[VinculationID] [int] NOT NULL,
	[ConcernRiskID] [int] NULL,
	[OrdinalNumber] [int] NOT NULL,
	[VinculatedInsuredSum] [decimal](18, 4) NULL,
	[Description] [nvarchar](4000) NULL,
 CONSTRAINT [PK_VinculationDetails_VinculationDetailID] PRIMARY KEY CLUSTERED 
(
	[VinculationDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VinculationInsuredPersons]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VinculationInsuredPersons](
	[VinculationInsuredPersonID] [int] IDENTITY(1,1) NOT NULL,
	[VinculationID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[RateShare] [decimal](18, 4) NULL,
	[Description] [nvarchar](4000) NULL,
 CONSTRAINT [PK_VinculationInsuredPersons_VinculationInsuredPersonID] PRIMARY KEY CLUSTERED 
(
	[VinculationInsuredPersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vinculations]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vinculations](
	[VinculationID] [int] IDENTITY(1,1) NOT NULL,
	[StatusID] [smallint] NOT NULL,
	[DocumentID] [int] NOT NULL,
	[OrdinalNumber] [int] NOT NULL,
	[InsuredSum] [decimal](18, 4) NULL,
	[IssuingDate] [date] NULL,
	[ConcernDescription] [nvarchar](4000) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Note] [nvarchar](4000) NULL,
	[DevinculationDate] [date] NULL,
	[DevinculationNote] [nvarchar](4000) NULL,
	[ChangeDate] [datetime2](0) NOT NULL,
	[ChangeUserID] [int] NOT NULL,
	[Vinculator] [nvarchar](4000) NULL,
	[LoanNumber] [nvarchar](50) NULL,
	[DocumentCalculationId] [bigint] NULL,
	[OriginalVinculationId] [bigint] NULL,
 CONSTRAINT [PK_Vinculations_VinculationID] PRIMARY KEY CLUSTERED 
(
	[VinculationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VinculationStatuses]    Script Date: 18-Jan-26 13:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VinculationStatuses](
	[VinculationStatusID] [smallint] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_VinculationStatuses_VinculationStatusID] PRIMARY KEY CLUSTERED 
(
	[VinculationStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AllowedCorrectionLevels] ADD  CONSTRAINT [DF_AllowedCorrectionLevels_IsPrintedOnItem]  DEFAULT ((0)) FOR [IsPrintedOnItem]
GO
ALTER TABLE [dbo].[ComputedOutputModes] ADD  CONSTRAINT [DF_ComputedOutputModes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ComputeMethods] ADD  CONSTRAINT [DF_ComputeMethods_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ConcernQuestionaryTypeOptions] ADD  CONSTRAINT [DF__ConcernQu__IsSel__2FC4F8E9]  DEFAULT ((0)) FOR [IsSelected]
GO
ALTER TABLE [dbo].[PredefinedAnswers] ADD  CONSTRAINT [DF__Predefine__PreSe__32A16594]  DEFAULT ((0)) FOR [PreSelected]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] ADD  CONSTRAINT [DF_QCC_Priority]  DEFAULT ((100)) FOR [Priority]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] ADD  CONSTRAINT [DF_QCC_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[TariffPropertyTypes] ADD  CONSTRAINT [DF_TGPT_IsRequired]  DEFAULT ((0)) FOR [IsRequired]
GO
ALTER TABLE [dbo].[TariffPropertyTypes] ADD  CONSTRAINT [DF_TGPT_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo].[ActionPerTariffs]  WITH CHECK ADD  CONSTRAINT [FK_ActionPerTariffs_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[ActionPerTariffs] CHECK CONSTRAINT [FK_ActionPerTariffs_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[Addresses]  WITH CHECK ADD  CONSTRAINT [FK_Addresses_Streets_StreetID] FOREIGN KEY([StreetID])
REFERENCES [dbo].[Streets] ([StreetID])
GO
ALTER TABLE [dbo].[Addresses] CHECK CONSTRAINT [FK_Addresses_Streets_StreetID]
GO
ALTER TABLE [dbo].[AllowedCorrectionLevels]  WITH CHECK ADD  CONSTRAINT [FK_AllowedCorrectionLevels_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[AllowedCorrectionLevels] CHECK CONSTRAINT [FK_AllowedCorrectionLevels_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix]  WITH CHECK ADD  CONSTRAINT [FK_BuildingCategoryMatrix_ConstructionMaterials] FOREIGN KEY([ConstructionMaterialID])
REFERENCES [dbo].[ConstructionMaterials] ([ConstructionMaterialID])
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix] CHECK CONSTRAINT [FK_BuildingCategoryMatrix_ConstructionMaterials]
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix]  WITH CHECK ADD  CONSTRAINT [FK_BuildingCategoryMatrix_ConstructionTypes] FOREIGN KEY([ConstructionTypeID])
REFERENCES [dbo].[ConstructionTypes] ([ConstructionTypeID])
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix] CHECK CONSTRAINT [FK_BuildingCategoryMatrix_ConstructionTypes]
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix]  WITH CHECK ADD  CONSTRAINT [FK_BuildingCategoryMatrix_ExternalWallMaterials] FOREIGN KEY([ExternalWallMaterialID])
REFERENCES [dbo].[ExternalWallMaterials] ([ExternalWallMaterialID])
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix] CHECK CONSTRAINT [FK_BuildingCategoryMatrix_ExternalWallMaterials]
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix]  WITH CHECK ADD  CONSTRAINT [FK_BuildingCategoryMatrix_RoofCoveringMaterials] FOREIGN KEY([RoofCoveringMaterialID])
REFERENCES [dbo].[RoofCoveringMaterials] ([RoofCoveringMaterialID])
GO
ALTER TABLE [dbo].[BuildingCategoryMatrix] CHECK CONSTRAINT [FK_BuildingCategoryMatrix_RoofCoveringMaterials]
GO
ALTER TABLE [dbo].[BuildingMarks]  WITH CHECK ADD  CONSTRAINT [FK_BuildingMarks_BuildingMarkTypes_BuildingMarkTypeID] FOREIGN KEY([BuildingMarkTypeID])
REFERENCES [dbo].[BuildingMarkTypes] ([BuildingMarkTypeID])
GO
ALTER TABLE [dbo].[BuildingMarks] CHECK CONSTRAINT [FK_BuildingMarks_BuildingMarkTypes_BuildingMarkTypeID]
GO
ALTER TABLE [dbo].[BuildingMarks]  WITH CHECK ADD  CONSTRAINT [FK_BuildingMarks_Buildings_BuildingID] FOREIGN KEY([BuildingID])
REFERENCES [dbo].[Buildings] ([BuildingID])
GO
ALTER TABLE [dbo].[BuildingMarks] CHECK CONSTRAINT [FK_BuildingMarks_Buildings_BuildingID]
GO
ALTER TABLE [dbo].[ClauseForActions]  WITH CHECK ADD  CONSTRAINT [FK_ClauseForActions_Clauses] FOREIGN KEY([ClauseID])
REFERENCES [dbo].[Clauses] ([ClauseID])
GO
ALTER TABLE [dbo].[ClauseForActions] CHECK CONSTRAINT [FK_ClauseForActions_Clauses]
GO
ALTER TABLE [dbo].[Clauses]  WITH CHECK ADD  CONSTRAINT [FK_Clauses_ClauseTypes] FOREIGN KEY([ClauseTypeID])
REFERENCES [dbo].[ClauseTypes] ([ClauseTypeID])
GO
ALTER TABLE [dbo].[Clauses] CHECK CONSTRAINT [FK_Clauses_ClauseTypes]
GO
ALTER TABLE [dbo].[CompanyDistricts]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDistricts_Districts_DistrictID] FOREIGN KEY([DistrictID])
REFERENCES [dbo].[Districts] ([DistrictID])
GO
ALTER TABLE [dbo].[CompanyDistricts] CHECK CONSTRAINT [FK_CompanyDistricts_Districts_DistrictID]
GO
ALTER TABLE [dbo].[ConcernHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_ConcernHierarchies_Concerns_ConcernChildID] FOREIGN KEY([ConcernChildID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernHierarchies] CHECK CONSTRAINT [FK_ConcernHierarchies_Concerns_ConcernChildID]
GO
ALTER TABLE [dbo].[ConcernHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_ConcernHierarchies_Concerns_ConcernParentID] FOREIGN KEY([ConcernParentID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernHierarchies] CHECK CONSTRAINT [FK_ConcernHierarchies_Concerns_ConcernParentID]
GO
ALTER TABLE [dbo].[ConcernInsuredPersons]  WITH CHECK ADD  CONSTRAINT [FK_ConcernInsuredPersons_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernInsuredPersons] CHECK CONSTRAINT [FK_ConcernInsuredPersons_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[ConcernMarks]  WITH CHECK ADD  CONSTRAINT [FK_ConcernMarks_ConcernMarkTypes_ConcernMarkTypeID] FOREIGN KEY([ConcernMarkTypeID])
REFERENCES [dbo].[ConcernMarkTypes] ([ConcernMarkTypeID])
GO
ALTER TABLE [dbo].[ConcernMarks] CHECK CONSTRAINT [FK_ConcernMarks_ConcernMarkTypes_ConcernMarkTypeID]
GO
ALTER TABLE [dbo].[ConcernMarks]  WITH CHECK ADD  CONSTRAINT [FK_ConcernMarks_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernMarks] CHECK CONSTRAINT [FK_ConcernMarks_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[ConcernMarkTypeFilters]  WITH CHECK ADD  CONSTRAINT [FK_ConcernMarkTypeFilters_ConcernMarkTypes_ConcernMarkTypeID] FOREIGN KEY([ConcernMarkTypeID])
REFERENCES [dbo].[ConcernMarkTypes] ([ConcernMarkTypeID])
GO
ALTER TABLE [dbo].[ConcernMarkTypeFilters] CHECK CONSTRAINT [FK_ConcernMarkTypeFilters_ConcernMarkTypes_ConcernMarkTypeID]
GO
ALTER TABLE [dbo].[ConcernMarkTypeFilters]  WITH CHECK ADD  CONSTRAINT [FK_ConcernMarkTypeFilters_ConcernTypes_ConcernTypeID] FOREIGN KEY([ConcernTypeID])
REFERENCES [dbo].[ConcernTypes] ([ConcernTypeID])
GO
ALTER TABLE [dbo].[ConcernMarkTypeFilters] CHECK CONSTRAINT [FK_ConcernMarkTypeFilters_ConcernTypes_ConcernTypeID]
GO
ALTER TABLE [dbo].[ConcernMarkTypeFilters]  WITH CHECK ADD  CONSTRAINT [FK_ConcernMarkTypeFilters_ProductTypes_ProductTypeID] FOREIGN KEY([ProductTypeID])
REFERENCES [dbo].[ProductTypes] ([ProductTypeID])
GO
ALTER TABLE [dbo].[ConcernMarkTypeFilters] CHECK CONSTRAINT [FK_ConcernMarkTypeFilters_ProductTypes_ProductTypeID]
GO
ALTER TABLE [dbo].[ConcernMarkTypes]  WITH CHECK ADD  CONSTRAINT [FK_ConcernMarkTypes_ConcernMarkGroup] FOREIGN KEY([ConcernMarkGroupId])
REFERENCES [dbo].[ConcernMarkGroups] ([ConcernMarkGroupID])
GO
ALTER TABLE [dbo].[ConcernMarkTypes] CHECK CONSTRAINT [FK_ConcernMarkTypes_ConcernMarkGroup]
GO
ALTER TABLE [dbo].[ConcernPackages]  WITH CHECK ADD  CONSTRAINT [FK_ConcernPackages_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernPackages] CHECK CONSTRAINT [FK_ConcernPackages_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[ConcernPackages]  WITH CHECK ADD  CONSTRAINT [FK_ConcernPackages_Packages_PackageID] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
GO
ALTER TABLE [dbo].[ConcernPackages] CHECK CONSTRAINT [FK_ConcernPackages_Packages_PackageID]
GO
ALTER TABLE [dbo].[ConcernPersons]  WITH CHECK ADD  CONSTRAINT [FK_ConcernPersons_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernPersons] CHECK CONSTRAINT [FK_ConcernPersons_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[ConcernProperties]  WITH CHECK ADD  CONSTRAINT [FK_ConcernProperties_ConcernPropertyList] FOREIGN KEY([ConcernPropertyID])
REFERENCES [dbo].[ConcernPropertyLists] ([ConcernPropertyID])
GO
ALTER TABLE [dbo].[ConcernProperties] CHECK CONSTRAINT [FK_ConcernProperties_ConcernPropertyList]
GO
ALTER TABLE [dbo].[ConcernProperties]  WITH CHECK ADD  CONSTRAINT [FK_ConcernProperties_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernProperties] CHECK CONSTRAINT [FK_ConcernProperties_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[ConcernProperties]  WITH CHECK ADD  CONSTRAINT [FK_ConcernProperties_ContractingTypes] FOREIGN KEY([ContractingTypeID])
REFERENCES [dbo].[ContractingTypes] ([ContractingTypeID])
GO
ALTER TABLE [dbo].[ConcernProperties] CHECK CONSTRAINT [FK_ConcernProperties_ContractingTypes]
GO
ALTER TABLE [dbo].[ConcernProperties]  WITH CHECK ADD  CONSTRAINT [FK_ConcernProperties_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[ConcernProperties] CHECK CONSTRAINT [FK_ConcernProperties_Locations]
GO
ALTER TABLE [dbo].[ConcernProperties]  WITH CHECK ADD  CONSTRAINT [FK_ConcernProperties_PropertyConcernTypes_PropertyConcernTypeID] FOREIGN KEY([PropertyConcernTypeID])
REFERENCES [dbo].[PropertyConcernTypes] ([PropertyConcernTypeID])
GO
ALTER TABLE [dbo].[ConcernProperties] CHECK CONSTRAINT [FK_ConcernProperties_PropertyConcernTypes_PropertyConcernTypeID]
GO
ALTER TABLE [dbo].[ConcernQuestionaryTypeOptions]  WITH CHECK ADD  CONSTRAINT [FK_ConcernQuestionaryTypeOptions_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernQuestionaryTypeOptions] CHECK CONSTRAINT [FK_ConcernQuestionaryTypeOptions_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[ConcernQuestionaryTypeOptions]  WITH CHECK ADD  CONSTRAINT [FK_ConcernQuestionaryTypeOptions_QuestionnaireTypes] FOREIGN KEY([QuestionaryTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[ConcernQuestionaryTypeOptions] CHECK CONSTRAINT [FK_ConcernQuestionaryTypeOptions_QuestionnaireTypes]
GO
ALTER TABLE [dbo].[ConcernRiskCovers]  WITH CHECK ADD  CONSTRAINT [FK_ConcernRiskCovers_ConcernRisks_ConcernRiskID] FOREIGN KEY([ConcernRiskID])
REFERENCES [dbo].[ConcernRisks] ([ConcernRiskID])
GO
ALTER TABLE [dbo].[ConcernRiskCovers] CHECK CONSTRAINT [FK_ConcernRiskCovers_ConcernRisks_ConcernRiskID]
GO
ALTER TABLE [dbo].[ConcernRiskCovers]  WITH CHECK ADD  CONSTRAINT [FK_ConcernRiskCovers_Covers_CoverID] FOREIGN KEY([CoverID])
REFERENCES [dbo].[Covers] ([CoverID])
GO
ALTER TABLE [dbo].[ConcernRiskCovers] CHECK CONSTRAINT [FK_ConcernRiskCovers_Covers_CoverID]
GO
ALTER TABLE [dbo].[ConcernRiskQuestionaries]  WITH CHECK ADD  CONSTRAINT [FK_ConcernRiskQuestionaries_ConcernRisks_ConcernRiskID] FOREIGN KEY([ConcernRiskID])
REFERENCES [dbo].[ConcernRisks] ([ConcernRiskID])
GO
ALTER TABLE [dbo].[ConcernRiskQuestionaries] CHECK CONSTRAINT [FK_ConcernRiskQuestionaries_ConcernRisks_ConcernRiskID]
GO
ALTER TABLE [dbo].[ConcernRisks]  WITH CHECK ADD  CONSTRAINT [FK_ConcernRisks_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
GO
ALTER TABLE [dbo].[ConcernRisks] CHECK CONSTRAINT [FK_ConcernRisks_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[ConcernRisks]  WITH CHECK ADD  CONSTRAINT [FK_ConcernRisks_ContractingTypes] FOREIGN KEY([ContractingTypeID])
REFERENCES [dbo].[ContractingTypes] ([ContractingTypeID])
GO
ALTER TABLE [dbo].[ConcernRisks] CHECK CONSTRAINT [FK_ConcernRisks_ContractingTypes]
GO
ALTER TABLE [dbo].[ConcernRisks]  WITH CHECK ADD  CONSTRAINT [FK_ConcernRisks_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[ConcernRisks] CHECK CONSTRAINT [FK_ConcernRisks_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[Concerns]  WITH CHECK ADD  CONSTRAINT [FK_Concerns_ConcernTypes_ConcernTypeID] FOREIGN KEY([ConcernTypeID])
REFERENCES [dbo].[ConcernTypes] ([ConcernTypeID])
GO
ALTER TABLE [dbo].[Concerns] CHECK CONSTRAINT [FK_Concerns_ConcernTypes_ConcernTypeID]
GO
ALTER TABLE [dbo].[Concerns]  WITH CHECK ADD  CONSTRAINT [FK_Concerns_LevelOfRisks_LevelOfRiskID] FOREIGN KEY([LevelOfRiskID])
REFERENCES [dbo].[LevelOfRisks] ([LevelOfRiskID])
GO
ALTER TABLE [dbo].[Concerns] CHECK CONSTRAINT [FK_Concerns_LevelOfRisks_LevelOfRiskID]
GO
ALTER TABLE [dbo].[ConstructionSubtypes]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionSubtypes_ConstructionTypes_ConstructionTypeID] FOREIGN KEY([ConstructionTypeID])
REFERENCES [dbo].[ConstructionTypes] ([ConstructionTypeID])
GO
ALTER TABLE [dbo].[ConstructionSubtypes] CHECK CONSTRAINT [FK_ConstructionSubtypes_ConstructionTypes_ConstructionTypeID]
GO
ALTER TABLE [dbo].[CorrectionPackageRisks]  WITH CHECK ADD  CONSTRAINT [FK_CorrectionPackageRisks_Covers_CoverIDFrom] FOREIGN KEY([CoverIDFrom])
REFERENCES [dbo].[Covers] ([CoverID])
GO
ALTER TABLE [dbo].[CorrectionPackageRisks] CHECK CONSTRAINT [FK_CorrectionPackageRisks_Covers_CoverIDFrom]
GO
ALTER TABLE [dbo].[CorrectionPackageRisks]  WITH CHECK ADD  CONSTRAINT [FK_CorrectionPackageRisks_Covers_CoverIDTo] FOREIGN KEY([CoverIDTo])
REFERENCES [dbo].[Covers] ([CoverID])
GO
ALTER TABLE [dbo].[CorrectionPackageRisks] CHECK CONSTRAINT [FK_CorrectionPackageRisks_Covers_CoverIDTo]
GO
ALTER TABLE [dbo].[CorrectionPackageRisks]  WITH CHECK ADD  CONSTRAINT [FK_CorrectionPackageRisks_Packages_PackageIDFrom] FOREIGN KEY([PackageIDFrom])
REFERENCES [dbo].[Packages] ([PackageID])
GO
ALTER TABLE [dbo].[CorrectionPackageRisks] CHECK CONSTRAINT [FK_CorrectionPackageRisks_Packages_PackageIDFrom]
GO
ALTER TABLE [dbo].[CorrectionPackageRisks]  WITH CHECK ADD  CONSTRAINT [FK_CorrectionPackageRisks_Packages_PackageIDTo] FOREIGN KEY([PackageIDTo])
REFERENCES [dbo].[Packages] ([PackageID])
GO
ALTER TABLE [dbo].[CorrectionPackageRisks] CHECK CONSTRAINT [FK_CorrectionPackageRisks_Packages_PackageIDTo]
GO
ALTER TABLE [dbo].[Districts]  WITH CHECK ADD  CONSTRAINT [FK_Districts_States_StateID] FOREIGN KEY([StateID])
REFERENCES [dbo].[States] ([StateID])
GO
ALTER TABLE [dbo].[Districts] CHECK CONSTRAINT [FK_Districts_States_StateID]
GO
ALTER TABLE [dbo].[GoodsHazardClasses]  WITH CHECK ADD  CONSTRAINT [FK_GoodsHazardClasses_HazardClasses] FOREIGN KEY([HazardClassId])
REFERENCES [dbo].[HazardClasses] ([HazardClassID])
GO
ALTER TABLE [dbo].[GoodsHazardClasses] CHECK CONSTRAINT [FK_GoodsHazardClasses_HazardClasses]
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
ALTER TABLE [dbo].[IndividualMachineCategories]  WITH CHECK ADD  CONSTRAINT [FK_IndividualMachineCategories_IndividualMachineTariffGroups_IndividualMachineTariffGroupID] FOREIGN KEY([IndividualMachineTariffGroupID])
REFERENCES [dbo].[IndividualMachineTariffGroups] ([IndividualMachineTariffGroupID])
GO
ALTER TABLE [dbo].[IndividualMachineCategories] CHECK CONSTRAINT [FK_IndividualMachineCategories_IndividualMachineTariffGroups_IndividualMachineTariffGroupID]
GO
ALTER TABLE [dbo].[IndividualMachineGroups]  WITH CHECK ADD  CONSTRAINT [FK_IndividualMachineGroups_IndividualMachineCategories_IndividualMachineCategoryID] FOREIGN KEY([IndividualMachineCategoryID])
REFERENCES [dbo].[IndividualMachineCategories] ([IndividualMachineCategoryID])
GO
ALTER TABLE [dbo].[IndividualMachineGroups] CHECK CONSTRAINT [FK_IndividualMachineGroups_IndividualMachineCategories_IndividualMachineCategoryID]
GO
ALTER TABLE [dbo].[IndividualMachineTypes]  WITH CHECK ADD  CONSTRAINT [FK_IndividualMachineTypes_IndividualMachineGroups_IndividualMachineGroupID] FOREIGN KEY([IndividualMachineGroupID])
REFERENCES [dbo].[IndividualMachineGroups] ([IndividualMachineGroupID])
GO
ALTER TABLE [dbo].[IndividualMachineTypes] CHECK CONSTRAINT [FK_IndividualMachineTypes_IndividualMachineGroups_IndividualMachineGroupID]
GO
ALTER TABLE [dbo].[IndustryCodeCategories]  WITH CHECK ADD  CONSTRAINT [FK_IndustryCodeCategories_ForPurposes_ForPurposeID] FOREIGN KEY([ForPurposeID])
REFERENCES [dbo].[ForPurposes] ([ForPurposeID])
GO
ALTER TABLE [dbo].[IndustryCodeCategories] CHECK CONSTRAINT [FK_IndustryCodeCategories_ForPurposes_ForPurposeID]
GO
ALTER TABLE [dbo].[IndustryCodeCategories]  WITH CHECK ADD  CONSTRAINT [FK_IndustryCodeCategories_IndustryCodes] FOREIGN KEY([IndustryCodeID])
REFERENCES [dbo].[IndustryCodes] ([IndustryCodeID])
GO
ALTER TABLE [dbo].[IndustryCodeCategories] CHECK CONSTRAINT [FK_IndustryCodeCategories_IndustryCodes]
GO
ALTER TABLE [dbo].[IndustryCodes]  WITH CHECK ADD  CONSTRAINT [FK_IndustryCodes_IndustryCodeLevels] FOREIGN KEY([IndustryCodeLevelID])
REFERENCES [dbo].[IndustryCodeLevels] ([IndustryCodeLevelID])
GO
ALTER TABLE [dbo].[IndustryCodes] CHECK CONSTRAINT [FK_IndustryCodes_IndustryCodeLevels]
GO
ALTER TABLE [dbo].[InsuredSumPerUnitOfPremiums]  WITH CHECK ADD  CONSTRAINT [FK_InsuredSumPerUnitOfPremiums_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[InsuredSumPerUnitOfPremiums] CHECK CONSTRAINT [FK_InsuredSumPerUnitOfPremiums_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[LineOfBusinessHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_LineOfBusinessHierarchies_LineOfBusiness_ChildLineOfBusinessID] FOREIGN KEY([ChildLineOfBusinessID])
REFERENCES [dbo].[LineOfBusinesses] ([LineOfBusinessID])
GO
ALTER TABLE [dbo].[LineOfBusinessHierarchies] CHECK CONSTRAINT [FK_LineOfBusinessHierarchies_LineOfBusiness_ChildLineOfBusinessID]
GO
ALTER TABLE [dbo].[LineOfBusinessHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_LineOfBusinessHierarchies_LineOfBusiness_LineOfBusinessID] FOREIGN KEY([LineOfBusinessID])
REFERENCES [dbo].[LineOfBusinesses] ([LineOfBusinessID])
GO
ALTER TABLE [dbo].[LineOfBusinessHierarchies] CHECK CONSTRAINT [FK_LineOfBusinessHierarchies_LineOfBusiness_LineOfBusinessID]
GO
ALTER TABLE [dbo].[Locations]  WITH CHECK ADD  CONSTRAINT [FK_Locations_Addresses_AddressID] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Addresses] ([AddressID])
GO
ALTER TABLE [dbo].[Locations] CHECK CONSTRAINT [FK_Locations_Addresses_AddressID]
GO
ALTER TABLE [dbo].[Locations]  WITH CHECK ADD  CONSTRAINT [FK_Locations_IndustryCodeCategories_IndustryCodeCategoryID] FOREIGN KEY([IndustryCodeCategoryID])
REFERENCES [dbo].[IndustryCodeCategories] ([IndustryCodeCategoryID])
GO
ALTER TABLE [dbo].[Locations] CHECK CONSTRAINT [FK_Locations_IndustryCodeCategories_IndustryCodeCategoryID]
GO
ALTER TABLE [dbo].[Locations]  WITH CHECK ADD  CONSTRAINT [FK_Locations_PremiumRateMatrix] FOREIGN KEY([PremiumRateMatrixID])
REFERENCES [dbo].[PremiumRateMatrix] ([PremiumRateMatrixID])
GO
ALTER TABLE [dbo].[Locations] CHECK CONSTRAINT [FK_Locations_PremiumRateMatrix]
GO
ALTER TABLE [dbo].[MethodsOfContracting]  WITH CHECK ADD  CONSTRAINT [FK_MethodOfContracting_GroupOfContracting] FOREIGN KEY([GroupOfContractingID])
REFERENCES [dbo].[GroupsOfContracting] ([GroupOfContractingID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MethodsOfContracting] CHECK CONSTRAINT [FK_MethodOfContracting_GroupOfContracting]
GO
ALTER TABLE [dbo].[Municipalities]  WITH CHECK ADD  CONSTRAINT [FK_Municipalities_Districts] FOREIGN KEY([DistrictID])
REFERENCES [dbo].[Districts] ([DistrictID])
GO
ALTER TABLE [dbo].[Municipalities] CHECK CONSTRAINT [FK_Municipalities_Districts]
GO
ALTER TABLE [dbo].[NotSelectedConcernRisks]  WITH CHECK ADD  CONSTRAINT [FK_NotSelectedConcernRisks_Concerns_ConcernID] FOREIGN KEY([ConcernID])
REFERENCES [dbo].[Concerns] ([ConcernID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NotSelectedConcernRisks] CHECK CONSTRAINT [FK_NotSelectedConcernRisks_Concerns_ConcernID]
GO
ALTER TABLE [dbo].[NotSelectedConcernRisks]  WITH CHECK ADD  CONSTRAINT [FK_NotSelectedConcernRisks_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NotSelectedConcernRisks] CHECK CONSTRAINT [FK_NotSelectedConcernRisks_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[PackageTariffRisks]  WITH CHECK ADD  CONSTRAINT [FK_PackageTariffRisk_Packages] FOREIGN KEY([PackageID])
REFERENCES [dbo].[Packages] ([PackageID])
GO
ALTER TABLE [dbo].[PackageTariffRisks] CHECK CONSTRAINT [FK_PackageTariffRisk_Packages]
GO
ALTER TABLE [dbo].[PackageTariffRisks]  WITH CHECK ADD  CONSTRAINT [FK_PackageTariffRisk_TariffRisks] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[PackageTariffRisks] CHECK CONSTRAINT [FK_PackageTariffRisk_TariffRisks]
GO
ALTER TABLE [dbo].[Places]  WITH CHECK ADD  CONSTRAINT [FK_Places_Municipalities] FOREIGN KEY([MunicipalityID])
REFERENCES [dbo].[Municipalities] ([MunicipalityID])
GO
ALTER TABLE [dbo].[Places] CHECK CONSTRAINT [FK_Places_Municipalities]
GO
ALTER TABLE [dbo].[Places]  WITH CHECK ADD  CONSTRAINT [FK_Places_States_StateID] FOREIGN KEY([StateID])
REFERENCES [dbo].[States] ([StateID])
GO
ALTER TABLE [dbo].[Places] CHECK CONSTRAINT [FK_Places_States_StateID]
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
ALTER TABLE [dbo].[PremiumInstallmentPerUnitOfInsuredSums]  WITH CHECK ADD  CONSTRAINT [FK_PremiumInstallmentPerUnitOfInsuredSums_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[PremiumInstallmentPerUnitOfInsuredSums] CHECK CONSTRAINT [FK_PremiumInstallmentPerUnitOfInsuredSums_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[PremiumRateMatrix]  WITH CHECK ADD  CONSTRAINT [FK_PremiumRateMatrix_ConstructionTypes] FOREIGN KEY([ConstructionTypeID])
REFERENCES [dbo].[ConstructionTypes] ([ConstructionTypeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PremiumRateMatrix] CHECK CONSTRAINT [FK_PremiumRateMatrix_ConstructionTypes]
GO
ALTER TABLE [dbo].[PremiumRateMatrix]  WITH CHECK ADD  CONSTRAINT [FK_PremiumRateMatrix_HazardClasses] FOREIGN KEY([HazardClassID])
REFERENCES [dbo].[HazardClasses] ([HazardClassID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PremiumRateMatrix] CHECK CONSTRAINT [FK_PremiumRateMatrix_HazardClasses]
GO
ALTER TABLE [dbo].[PremiumRateMatrix]  WITH CHECK ADD  CONSTRAINT [FK_PremiumRateMatrix_MethodOfContracting] FOREIGN KEY([MethodOfContractingID])
REFERENCES [dbo].[MethodsOfContracting] ([MethodOfContractingID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PremiumRateMatrix] CHECK CONSTRAINT [FK_PremiumRateMatrix_MethodOfContracting]
GO
ALTER TABLE [dbo].[PremiumRateMatrix]  WITH CHECK ADD  CONSTRAINT [FK_PremiumRateMatrix_ProtectionClasses] FOREIGN KEY([ProtectionClassID])
REFERENCES [dbo].[ProtectionClasses] ([ProtectionClassID])
GO
ALTER TABLE [dbo].[PremiumRateMatrix] CHECK CONSTRAINT [FK_PremiumRateMatrix_ProtectionClasses]
GO
ALTER TABLE [dbo].[PremiumRateMatrix]  WITH CHECK ADD  CONSTRAINT [FK_PremiumRateMatrix_StorageAreas] FOREIGN KEY([StorageAreaID])
REFERENCES [dbo].[StorageAreas] ([StorageAreaID])
GO
ALTER TABLE [dbo].[PremiumRateMatrix] CHECK CONSTRAINT [FK_PremiumRateMatrix_StorageAreas]
GO
ALTER TABLE [dbo].[PremiumRateMatrix]  WITH CHECK ADD  CONSTRAINT [FK_PremiumRateMatrix_TariffPropertyTypes] FOREIGN KEY([TariffPropertyTypeID])
REFERENCES [dbo].[TariffPropertyTypes] ([TariffPropertyTypeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PremiumRateMatrix] CHECK CONSTRAINT [FK_PremiumRateMatrix_TariffPropertyTypes]
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProductQuestionaryTypes_Products_ProductID] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes] CHECK CONSTRAINT [FK_ProductQuestionaryTypes_Products_ProductID]
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProductQuestionaryTypes_QuestionnaireTypes] FOREIGN KEY([QuestionaryTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[ProductQuestionaryTypes] CHECK CONSTRAINT [FK_ProductQuestionaryTypes_QuestionnaireTypes]
GO
ALTER TABLE [dbo].[ProductSettings]  WITH CHECK ADD  CONSTRAINT [FK_ProductSettings_ProductTypes_ProductTypeID] FOREIGN KEY([ProductTypeID])
REFERENCES [dbo].[ProductTypes] ([ProductTypeID])
GO
ALTER TABLE [dbo].[ProductSettings] CHECK CONSTRAINT [FK_ProductSettings_ProductTypes_ProductTypeID]
GO
ALTER TABLE [dbo].[ProductSettings]  WITH CHECK ADD  CONSTRAINT [FK_ProductSettings_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[ProductSettings] CHECK CONSTRAINT [FK_ProductSettings_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[ProductTypeDocumentMarks]  WITH CHECK ADD  CONSTRAINT [FK_ProductTypeDocumentMark_ProductTypes_ProductTypeID] FOREIGN KEY([ProductTypeID])
REFERENCES [dbo].[ProductTypes] ([ProductTypeID])
GO
ALTER TABLE [dbo].[ProductTypeDocumentMarks] CHECK CONSTRAINT [FK_ProductTypeDocumentMark_ProductTypes_ProductTypeID]
GO
ALTER TABLE [dbo].[ProductTypes]  WITH CHECK ADD  CONSTRAINT [FK_ProductTypes_Products_ProductID] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[ProductTypes] CHECK CONSTRAINT [FK_ProductTypes_Products_ProductID]
GO
ALTER TABLE [dbo].[ProductTypeTariffs]  WITH CHECK ADD  CONSTRAINT [FK_ProductTypeTariffs_ProductTypes_ProductTypeID] FOREIGN KEY([ProductTypeID])
REFERENCES [dbo].[ProductTypes] ([ProductTypeID])
GO
ALTER TABLE [dbo].[ProductTypeTariffs] CHECK CONSTRAINT [FK_ProductTypeTariffs_ProductTypes_ProductTypeID]
GO
ALTER TABLE [dbo].[ProductTypeTariffs]  WITH CHECK ADD  CONSTRAINT [FK_ProductTypeTariffs_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[ProductTypeTariffs] CHECK CONSTRAINT [FK_ProductTypeTariffs_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[PropertyBuildings]  WITH CHECK ADD  CONSTRAINT [FK_PB_ConstructionSubtypes] FOREIGN KEY([ConstructionSubtypeID])
REFERENCES [dbo].[ConstructionSubtypes] ([ConstructionSubtypeID])
GO
ALTER TABLE [dbo].[PropertyBuildings] CHECK CONSTRAINT [FK_PB_ConstructionSubtypes]
GO
ALTER TABLE [dbo].[PropertyBuildings]  WITH CHECK ADD  CONSTRAINT [FK_PropertyBuildings_Buildings_BuildingID] FOREIGN KEY([BuildingID])
REFERENCES [dbo].[Buildings] ([BuildingID])
GO
ALTER TABLE [dbo].[PropertyBuildings] CHECK CONSTRAINT [FK_PropertyBuildings_Buildings_BuildingID]
GO
ALTER TABLE [dbo].[PropertyBuildings]  WITH CHECK ADD  CONSTRAINT [FK_PropertyBuildings_ConcernProperties] FOREIGN KEY([ConcernPropertyID])
REFERENCES [dbo].[ConcernProperties] ([ConcernPropertyID])
GO
ALTER TABLE [dbo].[PropertyBuildings] CHECK CONSTRAINT [FK_PropertyBuildings_ConcernProperties]
GO
ALTER TABLE [dbo].[PropertyBuildings]  WITH CHECK ADD  CONSTRAINT [FK_PropertyBuildings_ConstructionTypes] FOREIGN KEY([ConstructionSubtypeID])
REFERENCES [dbo].[ConstructionTypes] ([ConstructionTypeID])
GO
ALTER TABLE [dbo].[PropertyBuildings] CHECK CONSTRAINT [FK_PropertyBuildings_ConstructionTypes]
GO
ALTER TABLE [dbo].[PropertyBuildings]  WITH CHECK ADD  CONSTRAINT [FK_PropertyBuildings_PropertyBuildingTypes_PropertyBuildingTypeID] FOREIGN KEY([PropertyBuildingTypeID])
REFERENCES [dbo].[PropertyBuildingTypes] ([PropertyBuildingTypeID])
GO
ALTER TABLE [dbo].[PropertyBuildings] CHECK CONSTRAINT [FK_PropertyBuildings_PropertyBuildingTypes_PropertyBuildingTypeID]
GO
ALTER TABLE [dbo].[PropertyBuildings]  WITH CHECK ADD  CONSTRAINT [FK_PropertyBuildings_RiskZones_RiskZoneID] FOREIGN KEY([RiskZoneID])
REFERENCES [dbo].[RiskZones] ([RiskZoneID])
GO
ALTER TABLE [dbo].[PropertyBuildings] CHECK CONSTRAINT [FK_PropertyBuildings_RiskZones_RiskZoneID]
GO
ALTER TABLE [dbo].[PropertyConcernTypes]  WITH CHECK ADD  CONSTRAINT [FK_PropertyConcernTypes_PropertyTypes_PropertyTypeID] FOREIGN KEY([PropertyTypeID])
REFERENCES [dbo].[PropertyTypes] ([PropertyTypeID])
GO
ALTER TABLE [dbo].[PropertyConcernTypes] CHECK CONSTRAINT [FK_PropertyConcernTypes_PropertyTypes_PropertyTypeID]
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
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificatorTypes]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificatorType_QuestionnarieIdentificatorType] FOREIGN KEY([QuestionnaireIdentificatorTypeID])
REFERENCES [dbo].[QuestionnaireIdentificatorTypes] ([QuestionnaireIdentificatorTypeID])
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificatorTypes] CHECK CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificatorType_QuestionnarieIdentificatorType]
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificatorTypes]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificatorType_QuestionnarieTypes] FOREIGN KEY([QuestionnaireTypeID])
REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
GO
ALTER TABLE [dbo].[QuestionnaireByQuestionnaireIdentificatorTypes] CHECK CONSTRAINT [FK_QuestionnaireByQuestionnaireIdentificatorType_QuestionnarieTypes]
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
ALTER TABLE [dbo].[RiskHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_RiskHierarchies_Risks] FOREIGN KEY([RiskID])
REFERENCES [dbo].[Risks] ([RiskID])
GO
ALTER TABLE [dbo].[RiskHierarchies] CHECK CONSTRAINT [FK_RiskHierarchies_Risks]
GO
ALTER TABLE [dbo].[RiskHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_RiskHierarchies_Risks1] FOREIGN KEY([ParentRiskID])
REFERENCES [dbo].[Risks] ([RiskID])
GO
ALTER TABLE [dbo].[RiskHierarchies] CHECK CONSTRAINT [FK_RiskHierarchies_Risks1]
GO
ALTER TABLE [dbo].[RiskZones]  WITH CHECK ADD  CONSTRAINT [FK_RiskZones_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[RiskZones] CHECK CONSTRAINT [FK_RiskZones_Products]
GO
ALTER TABLE [dbo].[Streets]  WITH CHECK ADD  CONSTRAINT [FK_Streets_Places_PlaceID] FOREIGN KEY([PlaceID])
REFERENCES [dbo].[Places] ([PlaceID])
GO
ALTER TABLE [dbo].[Streets] CHECK CONSTRAINT [FK_Streets_Places_PlaceID]
GO
ALTER TABLE [dbo].[TariffConditions]  WITH CHECK ADD  CONSTRAINT [FK_TariffConditions_InsuranceConditions] FOREIGN KEY([InsuranceConditionID])
REFERENCES [dbo].[InsuranceConditions] ([InsuranceConditionID])
GO
ALTER TABLE [dbo].[TariffConditions] CHECK CONSTRAINT [FK_TariffConditions_InsuranceConditions]
GO
ALTER TABLE [dbo].[TariffConditions]  WITH CHECK ADD  CONSTRAINT [FK_TariffConditions_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[TariffConditions] CHECK CONSTRAINT [FK_TariffConditions_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[TariffGroupActivityCodes]  WITH CHECK ADD  CONSTRAINT [FK_TGAct_TG] FOREIGN KEY([TariffGroupID])
REFERENCES [dbo].[TariffGroups] ([TariffGroupID])
GO
ALTER TABLE [dbo].[TariffGroupActivityCodes] CHECK CONSTRAINT [FK_TGAct_TG]
GO
ALTER TABLE [dbo].[TariffGroupHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_TariffGroupHierarchies_TariffGroups_SubTariffGroupID] FOREIGN KEY([SubTariffGroupID])
REFERENCES [dbo].[TariffGroups] ([TariffGroupID])
GO
ALTER TABLE [dbo].[TariffGroupHierarchies] CHECK CONSTRAINT [FK_TariffGroupHierarchies_TariffGroups_SubTariffGroupID]
GO
ALTER TABLE [dbo].[TariffGroupHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_TariffGroupHierarchies_TariffGroups_TariffGroupID] FOREIGN KEY([TariffGroupID])
REFERENCES [dbo].[TariffGroups] ([TariffGroupID])
GO
ALTER TABLE [dbo].[TariffGroupHierarchies] CHECK CONSTRAINT [FK_TariffGroupHierarchies_TariffGroups_TariffGroupID]
GO
ALTER TABLE [dbo].[TariffGroups]  WITH CHECK ADD  CONSTRAINT [FK_TariffGroups_InsuredSumPaymentConditions_InsuredSumPaymentConditionID] FOREIGN KEY([InsuredSumPaymentConditionID])
REFERENCES [dbo].[InsuredSumPaymentConditions] ([InsuredSumPaymentConditionID])
GO
ALTER TABLE [dbo].[TariffGroups] CHECK CONSTRAINT [FK_TariffGroups_InsuredSumPaymentConditions_InsuredSumPaymentConditionID]
GO
ALTER TABLE [dbo].[TariffGroups]  WITH CHECK ADD  CONSTRAINT [FK_TariffGroups_LineOfBusinesses] FOREIGN KEY([LineOfBusinessID])
REFERENCES [dbo].[LineOfBusinesses] ([LineOfBusinessID])
GO
ALTER TABLE [dbo].[TariffGroups] CHECK CONSTRAINT [FK_TariffGroups_LineOfBusinesses]
GO
ALTER TABLE [dbo].[TariffGroups]  WITH CHECK ADD  CONSTRAINT [FK_TariffGroups_PropertyInsuranceGroups] FOREIGN KEY([PropertyInsuranceGroupID])
REFERENCES [dbo].[PropertyInsuranceGroups] ([PropertyInsuranceGroupID])
GO
ALTER TABLE [dbo].[TariffGroups] CHECK CONSTRAINT [FK_TariffGroups_PropertyInsuranceGroups]
GO
ALTER TABLE [dbo].[TariffHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_TariffHierarchies_Tariffs_ParentTariffID] FOREIGN KEY([ParentTariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[TariffHierarchies] CHECK CONSTRAINT [FK_TariffHierarchies_Tariffs_ParentTariffID]
GO
ALTER TABLE [dbo].[TariffHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_TariffHierarchies_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[TariffHierarchies] CHECK CONSTRAINT [FK_TariffHierarchies_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[TariffOverheads]  WITH CHECK ADD  CONSTRAINT [FK_TariffOverheads_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[TariffOverheads] CHECK CONSTRAINT [FK_TariffOverheads_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[TariffPropertyMarkTypes]  WITH CHECK ADD  CONSTRAINT [FK_TariffPropertyMarkTypes_Tariffs] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[TariffPropertyMarkTypes] CHECK CONSTRAINT [FK_TariffPropertyMarkTypes_Tariffs]
GO
ALTER TABLE [dbo].[TariffPropertyMarkTypes]  WITH CHECK ADD  CONSTRAINT [FK_TGPM_ConcernMarkTypes] FOREIGN KEY([ConcernMarkTypeID])
REFERENCES [dbo].[ConcernMarkTypes] ([ConcernMarkTypeID])
GO
ALTER TABLE [dbo].[TariffPropertyMarkTypes] CHECK CONSTRAINT [FK_TGPM_ConcernMarkTypes]
GO
ALTER TABLE [dbo].[TariffPropertyMarkTypes]  WITH CHECK ADD  CONSTRAINT [FK_TGPM_PropertyConcernTypes] FOREIGN KEY([PropertyConcernTypeID])
REFERENCES [dbo].[PropertyConcernTypes] ([PropertyConcernTypeID])
GO
ALTER TABLE [dbo].[TariffPropertyMarkTypes] CHECK CONSTRAINT [FK_TGPM_PropertyConcernTypes]
GO
ALTER TABLE [dbo].[TariffPropertyTypeKingCodes]  WITH CHECK ADD  CONSTRAINT [FK_TariffPropertyTypesKingCode_TariffPropertyTypes] FOREIGN KEY([TariffPropertyTypeID])
REFERENCES [dbo].[TariffPropertyTypes] ([TariffPropertyTypeID])
GO
ALTER TABLE [dbo].[TariffPropertyTypeKingCodes] CHECK CONSTRAINT [FK_TariffPropertyTypesKingCode_TariffPropertyTypes]
GO
ALTER TABLE [dbo].[TariffPropertyTypeKingCodes]  WITH CHECK ADD  CONSTRAINT [FK_TariffPropertyTypesKingCode_TariffRiskTypes] FOREIGN KEY([TariffPropertyTypeKingCodeID])
REFERENCES [dbo].[TariffRiskTypes] ([TariffRiskTypeID])
GO
ALTER TABLE [dbo].[TariffPropertyTypeKingCodes] CHECK CONSTRAINT [FK_TariffPropertyTypesKingCode_TariffRiskTypes]
GO
ALTER TABLE [dbo].[TariffPropertyTypes]  WITH CHECK ADD  CONSTRAINT [FK_TariffGroupPropertyTypes_Tariffs] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[TariffPropertyTypes] CHECK CONSTRAINT [FK_TariffGroupPropertyTypes_Tariffs]
GO
ALTER TABLE [dbo].[TariffPropertyTypes]  WITH CHECK ADD  CONSTRAINT [FK_TGPT_PropertyConcernTypes] FOREIGN KEY([PropertyConcernTypeID])
REFERENCES [dbo].[PropertyConcernTypes] ([PropertyConcernTypeID])
GO
ALTER TABLE [dbo].[TariffPropertyTypes] CHECK CONSTRAINT [FK_TGPT_PropertyConcernTypes]
GO
ALTER TABLE [dbo].[TariffRiskApprovalCorrectionSurcharges]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskApprovalCorrectionSurcharges_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskApprovalCorrectionSurcharges] CHECK CONSTRAINT [FK_TariffRiskApprovalCorrectionSurcharges_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[TariffRiskApprovalCorrectionTypes]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskApprovalCorrectionTypes_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskApprovalCorrectionTypes] CHECK CONSTRAINT [FK_TariffRiskApprovalCorrectionTypes_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[TariffRiskBeneficiaryTypes]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskBeneficiaryTypes_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskBeneficiaryTypes] CHECK CONSTRAINT [FK_TariffRiskBeneficiaryTypes_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[TariffRiskCovers]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskCovers_Covers] FOREIGN KEY([CoverID])
REFERENCES [dbo].[Covers] ([CoverID])
GO
ALTER TABLE [dbo].[TariffRiskCovers] CHECK CONSTRAINT [FK_TariffRiskCovers_Covers]
GO
ALTER TABLE [dbo].[TariffRiskCovers]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskCovers_TariffRisks] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskCovers] CHECK CONSTRAINT [FK_TariffRiskCovers_TariffRisks]
GO
ALTER TABLE [dbo].[TariffRiskHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskHierarchies_TariffRisks_ParentTariffRiskID] FOREIGN KEY([ParentTariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskHierarchies] CHECK CONSTRAINT [FK_TariffRiskHierarchies_TariffRisks_ParentTariffRiskID]
GO
ALTER TABLE [dbo].[TariffRiskHierarchies]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskHierarchies_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskHierarchies] CHECK CONSTRAINT [FK_TariffRiskHierarchies_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[TariffRiskInsuredSumLists]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskInsuredSumLists_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskInsuredSumLists] CHECK CONSTRAINT [FK_TariffRiskInsuredSumLists_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[TariffRiskMarks]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskMarks_TariffRisks_TariffRiskID] FOREIGN KEY([TariffRiskID])
REFERENCES [dbo].[TariffRisks] ([TariffRiskID])
GO
ALTER TABLE [dbo].[TariffRiskMarks] CHECK CONSTRAINT [FK_TariffRiskMarks_TariffRisks_TariffRiskID]
GO
ALTER TABLE [dbo].[TariffRiskRiskAttributeTypes]  WITH CHECK ADD  CONSTRAINT [FK_TariffRiskRiskAttributeTypes_RiskAttributeTypes_RiskAttributeTypeID] FOREIGN KEY([RiskAttributeTypeID])
REFERENCES [dbo].[RiskAttributeTypes] ([RiskAttributeTypeID])
GO
ALTER TABLE [dbo].[TariffRiskRiskAttributeTypes] CHECK CONSTRAINT [FK_TariffRiskRiskAttributeTypes_RiskAttributeTypes_RiskAttributeTypeID]
GO
ALTER TABLE [dbo].[TariffRisks]  WITH CHECK ADD  CONSTRAINT [FK_TariffRisks_Risks_RiskID] FOREIGN KEY([RiskID])
REFERENCES [dbo].[Risks] ([RiskID])
GO
ALTER TABLE [dbo].[TariffRisks] CHECK CONSTRAINT [FK_TariffRisks_Risks_RiskID]
GO
ALTER TABLE [dbo].[TariffRisks]  WITH CHECK ADD  CONSTRAINT [FK_TariffRisks_TariffRiskTypes_TariffRiskTypeID] FOREIGN KEY([TariffRiskTypeID])
REFERENCES [dbo].[TariffRiskTypes] ([TariffRiskTypeID])
GO
ALTER TABLE [dbo].[TariffRisks] CHECK CONSTRAINT [FK_TariffRisks_TariffRiskTypes_TariffRiskTypeID]
GO
ALTER TABLE [dbo].[TariffRisks]  WITH CHECK ADD  CONSTRAINT [FK_TariffRisks_Tariffs_TariffID] FOREIGN KEY([TariffID])
REFERENCES [dbo].[Tariffs] ([TariffID])
GO
ALTER TABLE [dbo].[TariffRisks] CHECK CONSTRAINT [FK_TariffRisks_Tariffs_TariffID]
GO
ALTER TABLE [dbo].[Tariffs]  WITH CHECK ADD  CONSTRAINT [FK_Tariffs_TariffGroups_TariffGroupID] FOREIGN KEY([TariffGroupID])
REFERENCES [dbo].[TariffGroups] ([TariffGroupID])
GO
ALTER TABLE [dbo].[Tariffs] CHECK CONSTRAINT [FK_Tariffs_TariffGroups_TariffGroupID]
GO
ALTER TABLE [dbo].[VinculationCreditors]  WITH CHECK ADD  CONSTRAINT [FK_VinculationCreditors_VinculationCreditorTypes] FOREIGN KEY([VinculationCreditorTypeID])
REFERENCES [dbo].[VinculationCreditorTypes] ([VinculationCreditorTypeID])
GO
ALTER TABLE [dbo].[VinculationCreditors] CHECK CONSTRAINT [FK_VinculationCreditors_VinculationCreditorTypes]
GO
ALTER TABLE [dbo].[VinculationCreditors]  WITH CHECK ADD  CONSTRAINT [FK_VinculationCreditors_Vinculations_VinculationID] FOREIGN KEY([VinculationID])
REFERENCES [dbo].[Vinculations] ([VinculationID])
GO
ALTER TABLE [dbo].[VinculationCreditors] CHECK CONSTRAINT [FK_VinculationCreditors_Vinculations_VinculationID]
GO
ALTER TABLE [dbo].[VinculationDetails]  WITH CHECK ADD  CONSTRAINT [FK_VinculationDetails_ConcernRisks_ConcernRiskID] FOREIGN KEY([ConcernRiskID])
REFERENCES [dbo].[ConcernRisks] ([ConcernRiskID])
GO
ALTER TABLE [dbo].[VinculationDetails] CHECK CONSTRAINT [FK_VinculationDetails_ConcernRisks_ConcernRiskID]
GO
ALTER TABLE [dbo].[VinculationDetails]  WITH CHECK ADD  CONSTRAINT [FK_VinculationDetails_Vinculations_VinculationID] FOREIGN KEY([VinculationID])
REFERENCES [dbo].[Vinculations] ([VinculationID])
GO
ALTER TABLE [dbo].[VinculationDetails] CHECK CONSTRAINT [FK_VinculationDetails_Vinculations_VinculationID]
GO
ALTER TABLE [dbo].[VinculationInsuredPersons]  WITH CHECK ADD  CONSTRAINT [FK_VinculationInsuredPersons_Vinculations_VinculationID] FOREIGN KEY([VinculationID])
REFERENCES [dbo].[Vinculations] ([VinculationID])
GO
ALTER TABLE [dbo].[VinculationInsuredPersons] CHECK CONSTRAINT [FK_VinculationInsuredPersons_Vinculations_VinculationID]
GO
ALTER TABLE [dbo].[Vinculations]  WITH CHECK ADD  CONSTRAINT [FK_Vinculations_VinculationStatuses_StatusID] FOREIGN KEY([StatusID])
REFERENCES [dbo].[VinculationStatuses] ([VinculationStatusID])
GO
ALTER TABLE [dbo].[Vinculations] CHECK CONSTRAINT [FK_Vinculations_VinculationStatuses_StatusID]
GO
ALTER TABLE [dbo].[ConcernPropertyListItems]  WITH CHECK ADD  CONSTRAINT [CK_ConcernPropertyListItems_ItemSum_Positive] CHECK  (([ItemSumInsured]>(0)))
GO
ALTER TABLE [dbo].[ConcernPropertyListItems] CHECK CONSTRAINT [CK_ConcernPropertyListItems_ItemSum_Positive]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs]  WITH CHECK ADD  CONSTRAINT [CK_QCC_OutputMode] CHECK  (([OutputMode]=(4) OR [OutputMode]=(3) OR [OutputMode]=(2) OR [OutputMode]=(1)))
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] CHECK CONSTRAINT [CK_QCC_OutputMode]
GO
ALTER TABLE [dbo].[QuestionComputedConfigs]  WITH CHECK ADD  CONSTRAINT [CK_QCC_OutputTarget_WhenAnswerCode] CHECK  ((NOT ([OutputMode]=(1) AND [OutputTarget] IS NOT NULL)))
GO
ALTER TABLE [dbo].[QuestionComputedConfigs] CHECK CONSTRAINT [CK_QCC_OutputTarget_WhenAnswerCode]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the relationship between an action and a tariff]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs', @level2type=N'COLUMN',@level2name=N'ActionPerTariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija veze između akcije i tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs', @level2type=N'COLUMN',@level2name=N'ActionPerTariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the tariff in the relationship][FK*dbo.Tariffs.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tarife u vezi][FK*dbo.Tariffs.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the action in the relationship][FK*dbo.Actions.ActionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs', @level2type=N'COLUMN',@level2name=N'ActionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija akcije u vezi][FK*dbo.Actions.ActionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs', @level2type=N'COLUMN',@level2name=N'ActionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Relationships between actions and tariffs. Relationship means: action may be applied to the policies for which specified tariff is valid]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Veze između akcija i tarifa. Značenje veze je: akcija se može primeniti na polise za koje važi navedena tarifa]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionPerTariffs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the relationship between a correction, a correction level and an action]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'AllowedCorrectionLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija veze između moguće izmene premije, nivoa na koji se primenjuje korekcija premije i akcije.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'AllowedCorrectionLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the action that includes correction on specified correction level. If there is no tariff, there must be an action and vice versa.][FK*dbo.Actions(ActionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'ActionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija akcije u okviru koje je dozvoljena navedena izmena na navedenom nivou. Ako ne postoji tarifa, mora postojati akcija i obrnuto][FK*dbo.Actions(ActionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'ActionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the correction which is allowed as part of specified action][FK*dbo.Corrections.CorrectionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'CorrectionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija izmene koja je dozvoljena u okviru navedene akcije.][FK*dbo.Corrections.CorrectionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'CorrectionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the correction level to which applies specified correction as part of specified action][FK*dbo.CorrectionLevels.CorrectionLevelID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'CorrectionLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija nivoa na koji se primenjuje navedena izmena premije u okviru navedene akcije.][FK*dbo.CorrectionLevels.CorrectionLevelID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'CorrectionLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the tariff which is allowed as part of specified action. If there is no action, there must be a tariff and vice versa][FK*dbo.Tariff.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tarife koja je dozvoljena u okviru navedene akcije. Ako ne postoji akcija, tarifa mora postojati i obrnuto.][FK*dbo.Tariff.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Relationships between codebooks of possible premium corrections, correction levels and actions. Relationship means: specified correction is allowed for specified correction level as part of of specified action.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Veze između šifarnika mogućih izmena premije, nivoa na koje se primenjuje korekcija premije i akcija. Veza ima sledeće značenje: navedena izmena je dozvoljena na navedenom novou u okviru navedena akcije.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AllowedCorrectionLevels'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a relationship between a concern and an insured persons. The relationship means: the insured person owns the concern]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons', @level2type=N'COLUMN',@level2name=N'ConcernInsuredPersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija veze između jednog predmeta osiguranja i jednog osiguranog lica. Veza ima sledeće značenje: Predmet osiguranja je u vlasništvu osiguranog lica]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons', @level2type=N'COLUMN',@level2name=N'ConcernInsuredPersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the insured person that owns the concern][FK*dbo.InsuredPersons.InsuredPersonID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons', @level2type=N'COLUMN',@level2name=N'InsuredPersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija osiguranog lica koje je vlasnik predmeta osiguranja][FK*dbo.InsuredPersons.InsuredPersonID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons', @level2type=N'COLUMN',@level2name=N'InsuredPersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID oh the concern owned by the insured person][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja koji je u vlasništvu osiguranog lica][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Relationships between concerns and insured persons]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Veze između predmeta osiguranja i osiguranog lica]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernInsuredPersons'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the mark on the concern]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks', @level2type=N'COLUMN',@level2name=N'ConcernMarkID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija oznake na predmetu osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks', @level2type=N'COLUMN',@level2name=N'ConcernMarkID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of concern mark type (dbo.g. HolderOfTheInsurance, ListOfArts ...)][FK*dbo.ConcernMarkTypess.ConcernMarkTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks', @level2type=N'COLUMN',@level2name=N'ConcernMarkTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tipa oznake predmeta osiguranja (dbo.g. NosilacOsiguranja, SpisakUmetnina ...)][FK*dbo.ConcernMarkTypess.ConcernMarkTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks', @level2type=N'COLUMN',@level2name=N'ConcernMarkTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the concern][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Concern marks]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Oznake predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the concern mark type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarkTypes', @level2type=N'COLUMN',@level2name=N'ConcernMarkTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tipa oznake predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarkTypes', @level2type=N'COLUMN',@level2name=N'ConcernMarkTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the concern mark type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarkTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv tipa oznake predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarkTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Description of the concern mark type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarkTypes', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Opis tipa oznake predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernMarkTypes', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Identification of a relationship between a concern and a package. One relationship represents a concern which is insured on risks contained in a package. REMARK: one concern could be insured on several packages, dbo.g. in health insurance]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages', @level2type=N'COLUMN',@level2name=N'ConcernPackageID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija jedne veze između jednog predmeta osiguranja i jednog paketa koji sadrži rizike. Jedna veza predstavlja predmet osiguranja koji je osiguran po rizicima koji pripadaju jednom paketu. NAPOMENA: jedan predmet osiguranja može biti osiguran po više paketa, npr u privatnom zdravstvenom osiguranju]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages', @level2type=N'COLUMN',@level2name=N'ConcernPackageID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the concern which is insured on risks contained in a package.][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja koji je osiguran po rizicima paketa.][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the package containing risks on which the concern is insured][FK*dbo.Packages.PackageID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages', @level2type=N'COLUMN',@level2name=N'PackageID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija paketa po čijim rizicima je osiguran predmet osiguranja][FK*dbo.Packages.PackageID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages', @level2type=N'COLUMN',@level2name=N'PackageID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Relationship between concerns and packages]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Veze između predmeta osiguranja i paketa koji sadrže rizike]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPackages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the concern which is of type "person"][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja koje je tipa "fizičko lice"][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the business entity that is insured - business entity should be of type "individual entity"][FK*dbo.BusinessEntities.BusinessEntityID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija fizičkog lica koje je osigurano][FK*dbo.BusinessEntities.BusinessEntityID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Increased age of the person - used in life insurance calculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'IncreasedAge'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Uvećanje godina za fizičko lice - služi za izračunavanje korekcije premija kod nekih životnih osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'IncreasedAge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Date of birth of the insured person]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'DateOfBirth'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Datum rođenja osiguranog fizičkog lica]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'DateOfBirth'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Height of the insured person]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'Height'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Visina osiguranog fizičkog lica]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'Height'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Weight of the insured person]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'Weight'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Težina osiguranog fizičkog lica]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'Weight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Identification of the gender of the insured person (dbo.g. male, female...)][FK*dbo.Genders.GenderID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'GenderID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija pola osiguranog fizičkog lica (npr. muško, žensko ...)][FK*dbo.Genders.GenderID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'GenderID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Info about insured person]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'PersonInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Infomracije o osigurnanom fizičkom licu]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'PersonInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Body mass index of the insured person]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'BMI'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Indeks telesne mase (BMI) osiguranog fizičkog lica]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons', @level2type=N'COLUMN',@level2name=N'BMI'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Specific data for concern when concern is of type "person", dbo.e. when insured "thing" is a person]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Specifični podaci o predmetu osiguranja u slučaju kada je to fizičko lice]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernPersons'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the concern which is of type "property"][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja koji je tipa "imovina"][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Id of the property concern type (dbo.g. Main object building, main object goods, ...)][FK*dbo.PropertyConcernTypes.PropertyConcernTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'PropertyConcernTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tipa imovinskog predmeta osiguranja (dbo.g. Glavni objekat zgrada, glavni objekat stvari, ...)][FK*dbo.PropertyConcernTypes.PropertyConcernTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'PropertyConcernTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'ConcernBuildingRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'DumpingRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Surface of the concern] ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'Surface'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Površina predmeta osiguranja] ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'Surface'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Value of 1m2]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'ValueM2'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Vrednost po 1m2] ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'ValueM2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*The value of the property(value of the m2 * surface)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'NewValuePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Vrednost nekretnine(vrednost po m2 * površina)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties', @level2type=N'COLUMN',@level2name=N'NewValuePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Specific data for concern when concern is of type "property", dbo.e. when insured "thing" is some property]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernProperties'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the covered risk on the concern of the document calculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'ConcernRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija jednog pokrivenog rizika po jednom predmetu osiguranja na jednom obračunu]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'ConcernRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the concern whose risk is covered][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja na obračunu na koga se odnosi pokriveni rizik][FK*dbo.Concerns.ConcernID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the risk within the tarrif that applies to the concern of the document calculation][FK*dbo.TariffRisks.TariffRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'TariffRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija rizika u okviru tarife koja važi za ovaj predmet osiguranja na ovom obračunu][FK*dbo.TariffRisks.TariffRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'TariffRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Insured sum for the risk]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'InsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Suma osiguranja za rizik]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'InsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Only for non-life: Premium rate used for calculation of premium amount for the risk]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'PremiumRate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Samo za neživot: Premijska stopa koja se koristi prilikom izračunavanja premije za ovaj rizik]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'PremiumRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Only for non-life: Amount of premium for the risk before applying discounts and surcharges. Remark: this field is not always calculated from fields InsuredSum and PremiumRate usig some formula - way of calculating premium depends on tariff apllied]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'Premium'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Samo za neživot: Iznos premije za rizik pre primene popusta i doplataka. Napomena: ovo polje ne mora uvek izračunavati direktno iz polja InsuredSum i PremiumRate uz korišćenje neke formule - način računanja premije zavisi od primenjene tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'Premium'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ordinal number of the risk within concern of the document calculation counting from 1. Risk with ordinal number 1 is called "main risk"]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Redni broj rizika u okviru predmeta osiguranja na ovom obračunu počev od 1. Rizik sa rednim brojem 1 se naziva "glavni rizik"]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Only for life insurance: amount of one premium installment after applying all discounts and surcharges]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'NetoInstallment'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Samo za životno osiguranje: iznos rate premije posle primene svih dodataka i popusta]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'NetoInstallment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*TO BE REMOVED]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'UnderwritingSurcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*OVo polje treba da se obriše]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'UnderwritingSurcharge'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Tax for premium of the covered risk on the concern of the document calculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'Tax'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Porez na premiju za rizik predmeta osiguranja na obračunu]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks', @level2type=N'COLUMN',@level2name=N'Tax'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Covered risks on concerns on document calculations]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Pokriveni rizici po predmetima osiguranja na obračunima]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernRisks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a concern]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'ConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the type of the concern][FK*dbo.ConcernTypes.ConcernTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'ConcernTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tipa predmeta osiguranja][FK*dbo.ConcernTypes.ConcernTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'ConcernTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ordinal number of the concern within document calculation counting from 1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Redni broj predmeta osiguranja u okviru obračuna, brojeći od 1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Insured sum for the concern]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'InsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Suma osiguranja za predmet osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'InsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the document calculation layer to which concern belongs.][FK*dbo.DocumentCalculationLayers.DocumentCalculationLayerID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'DocumentCalculationLayerID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_opis', @value=N'[DF*Identifikacija lejera kome predmet osiguranja pripada][FK*dbo.DocumentCalculationLayers.DocumentCalculationLayerID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'DocumentCalculationLayerID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*In case the concern is a group, this field holds the description of the group]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'GroupDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*U slučaju kada je predmet osiguranja grupa, ovo polje sadrzi opis grupe]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'GroupDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*In case the concern is a group, this fiels holds the number of individual concerns in group]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'NumberOfConcernsInGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*U slučaju kada je predmet osiguranja grupa, ovo polje sadrzi broj pojedinačnih predmeta osiguranja u grupi]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'NumberOfConcernsInGroup'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the concern this concern was created from(needed for technical changes)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'OriginalConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predmeta osiguranja iz koga je predmet osiguranja obracunat(potrebno za tehničke promene)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'OriginalConcernID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the level of risk for concern][FK*dbo.LevelOfRisks.LevelOfRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'LevelOfRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija nivoa rizika predmeta osiguranja][FK*dbo.LevelOfRisks.LevelOfRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'LevelOfRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the currency of the insured sum of the concern][FK*dbo.Currencies.CurrencyID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'CurrencyID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija valute osigurane sume predmeta osiguranja][FK*dbo.Currencies.CurrencyID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns', @level2type=N'COLUMN',@level2name=N'CurrencyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Concerns on document calculations]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Predmeti osiguranja na obračunima]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Concerns'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a concern type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes', @level2type=N'COLUMN',@level2name=N'ConcernTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tipa predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes', @level2type=N'COLUMN',@level2name=N'ConcernTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the concern type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv tipa predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Description of the concern type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Opis tipa predmeta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of concern types (dbo.g. Person, Property, Car ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik tipova predmeta osiguranja, npr lice, imovina, vozilo ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ConcernTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*International numeric code for currency]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'CurrencyID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Međunarodna brojčana oznaka valute]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'CurrencyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*International 3-character code for currency]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Međunarodna troslovna oznaka valute]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Currency name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv valute]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Is the currency  still in use]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Valid'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Da li je valuta u upotrebi]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Valid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Note]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Note'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Napomena]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies', @level2type=N'COLUMN',@level2name=N'Note'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Currencies]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Valute]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Currencies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of industry code level]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodeLevels', @level2type=N'COLUMN',@level2name=N'IndustryCodeLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacije nivoa šifre delatnosti]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodeLevels', @level2type=N'COLUMN',@level2name=N'IndustryCodeLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Industry code level name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodeLevels', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv nivo šifre delatnosti]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodeLevels', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Industry code levels]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodeLevels'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Nivoi šifara vrsta delatnosti]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodeLevels'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of industry code]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'IndustryCodeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija šifre delatnosti]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'IndustryCodeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of industry code level][FK*dbo.IndustryCodeLevels.IndustryCodeLevelID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'IndustryCodeLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacije nivoa šifre delatnosti][FK*dbo.IndustryCodeLevels.IndustryCodeLevelID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'IndustryCodeLevelID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Industry code]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifra delatnosti]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Industry code name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv šifre delatnosti]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Industry code]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifre  vrste delatnosti]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IndustryCodes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of condition for repayment of insured sum]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentConditions', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentConditionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija uslova pod kojim se isplaćuje osigurana suma]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentConditions', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentConditionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the condition for repayment of insured sum (dbo.g. guaranteed repayment sum, repayment in case of insured event, ...  )]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentConditions', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv uslova pod kojim se isplaćuje osigurana suma (npr. garantovana isplata osigurane sume, isplata u slučaju osiguranog događaja, ...  )]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentConditions', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of conditions for repayment of insured sum (dbo.g. guaranteed repayment sum, repayment in case of insured event, ...  )]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentConditions'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik uslova pod kojim se isplaćuje osigurana suma (npr. garantovana isplata osigurane sume, isplata u slučaju osiguranog događaja, ...  )]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentConditions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the way of the repayment of insured sum]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentTypes', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija načina ispalte osigurane sume]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentTypes', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the way of the repayment of insured sum (dbo.g. at once, by program, rent ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv načina isplate osigurane sume (npr. jednokratno, po određenom programu ispalate, isplata rente ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of ways of repayment of insured sum (dbo.g. at once, by program, rent repayment ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik načina isplate osigurane sume (npr. jednokratno, po određenom programu ispalate, isplata rente ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InsuredSumPaymentTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of line of business]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinesses', @level2type=N'COLUMN',@level2name=N'LineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vrste osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinesses', @level2type=N'COLUMN',@level2name=N'LineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of line of bussines in English]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinesses', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv vrste osiguranja na engleskom]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinesses', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Lines of businesses - international code book.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinesses'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Vrste osiguranja - međunarodni šifarnik]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinesses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of line of business extension]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions', @level2type=N'COLUMN',@level2name=N'LineOfBusinessExtensionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*identifikacija podvrste osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions', @level2type=N'COLUMN',@level2name=N'LineOfBusinessExtensionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*code of line business extension]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions', @level2type=N'COLUMN',@level2name=N'Extension'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*šifra podvrste osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions', @level2type=N'COLUMN',@level2name=N'Extension'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of line business extension]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv podvrste osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Line of business extensions. These are not specified by state laws, but insurance companies can create them according to their needs]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Podvrste vrsta osiguranja. Ove podvrste nisu propisane zakonima države, nego ih kreira svaka osiguravajuća kompanija prema svojim potrebama]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessExtensions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID OF hierarchy of lines of businesses]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies', @level2type=N'COLUMN',@level2name=N'LineOfBusinessHierarchyID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*identifikacija sloga koji opisuje hijerahijsku strukturu vrsta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies', @level2type=N'COLUMN',@level2name=N'LineOfBusinessHierarchyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*parent node in parent-child relation in hierachical structure][FK*dbo.LineOfBusinesses.LineOfBusinessID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies', @level2type=N'COLUMN',@level2name=N'LineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*roditelj u relaciji roditelj-dete u hijerarhijskoj strukturi][FK*dbo.LineOfBusinesses.LineOfBusinessID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies', @level2type=N'COLUMN',@level2name=N'LineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*child node in parent-child relation in hierachical structure][FK*dbo.LineOfBusinesses.LineOfBusinessID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies', @level2type=N'COLUMN',@level2name=N'ChildLineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*dete u relaciji roditelj-dete u hijerarhijskoj strukturil][FK*dbo.LineOfBusinesses.LineOfBusinessID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies', @level2type=N'COLUMN',@level2name=N'ChildLineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Hiererchy of lines of businesses]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Hijerarijska struktura vrsta osiguranja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LineOfBusinessHierarchies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the number of insured persons]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NumberOfInsurees', @level2type=N'COLUMN',@level2name=N'NumberOfInsureeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija oznake za broj osiguranika ]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NumberOfInsurees', @level2type=N'COLUMN',@level2name=N'NumberOfInsureeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name for number of insured persons per policy (dbo.g. one insured, two insured, more insured...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NumberOfInsurees', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv oznake za broj osiguranika (npr. jedan osiguranik, dva osiguranika, grupa osiguranih lica ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NumberOfInsurees', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook for number of insured persons per policy (dbo.g. one insured, two insured, group of insured persons ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NumberOfInsurees'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik oznaka za broj osiguranika (npr. jedan osiguranik, dva osiguranika, grupa osiguranih lica ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NumberOfInsurees'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the package containing risks]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Packages', @level2type=N'COLUMN',@level2name=N'PackageID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija paketa koji sadrži rizike]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Packages', @level2type=N'COLUMN',@level2name=N'PackageID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the package containing risks]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Packages', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv paketa koji sadrži rizike]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Packages', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Packages containing risks]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Packages'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Paketi koji sadrže rizike]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Packages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a payment dynamic]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'PaymentDynamicID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija dinamike plaćanja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'PaymentDynamicID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the payment dynamic (dbo.g. in advance, yearly, quaterly, monthly ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv dinamike plaćanja (npr. jednokratno, mesečno, godišnje, kvartalno ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Description of the payment dynamic]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Opis dinamike plaćanja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Number of installment per year]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'NumberOfInstallmentsPerYear'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Broj rata u godini]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics', @level2type=N'COLUMN',@level2name=N'NumberOfInstallmentsPerYear'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of different dynamics of payment]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik dinamike plaćanja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentDynamics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a payment method]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods', @level2type=N'COLUMN',@level2name=N'PaymentMethodID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*ID of a payment method]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods', @level2type=N'COLUMN',@level2name=N'PaymentMethodID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the payment method  (dbo.g. bank account transfer, standing order, direct debit ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv načina plaćanja (npr, bankovni transfer, trajni nalog, direktno zaduženje ...) ]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Description of the payment method]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Opisa načina plaćanja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of payment methods]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik načina plaćanja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PaymentMethods'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the predefined answer]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PredefinedAnswers', @level2type=N'COLUMN',@level2name=N'PredefinedAnswerID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija predefinisanog odgovora]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PredefinedAnswers', @level2type=N'COLUMN',@level2name=N'PredefinedAnswerID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the company to which product belongs][FK*dbo.Companies.CompanyID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'CompanyID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija osiguravajuće kompanije u okviru Uniqa Group kojoj proizvod pripada][FK*dbo.Companies.CompanyID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'CompanyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Indicator whether product belongs to life insurance]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'IsLife'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Indikator da li proizvod pripada životnom osiguranju]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'IsLife'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the product type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'ProductTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vrste proizvoda]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'ProductTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the product type]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv vrste proizvoda]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Internal code of the product type, used for reference to local company codebook of product types]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Interna oznaka vrste proizvoda, služi za povezivanje sa internim šifarskim sistemima vrsta proizvoda]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the product type group to which product type belongs][FK*dbo.Products.ProductID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'ProductID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija grup vrste proizvoda kojoj pripda vrsta proizvoda][FK*dbo.Products.ProductID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes', @level2type=N'COLUMN',@level2name=N'ProductID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of product types (dbo.g. life policy with endowment, MTPL policy ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik vrste proizvoda (npr. životna polisa sa doživljenjem, polisa  auto osiguranja ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the answer to the question about money laundry]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers', @level2type=N'COLUMN',@level2name=N'QuestionnaireAnswerID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija odgovora na pitanje u vezi sa pranjem novca]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers', @level2type=N'COLUMN',@level2name=N'QuestionnaireAnswerID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the question about money laundry][FK*contract.Questions.QuestionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers', @level2type=N'COLUMN',@level2name=N'QuestionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija pitanja u vezi sa pranjem novca][FK*contract.Questions.QuestionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers', @level2type=N'COLUMN',@level2name=N'QuestionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Text of the answer to the question about money laundry]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers', @level2type=N'COLUMN',@level2name=N'Answer'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Tekst odgovora na pitanje u vezi sa pranjem novca]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers', @level2type=N'COLUMN',@level2name=N'Answer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Answers to questions about money laundry]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Odgovori na pitanja u vezi sa pranjem novca]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireAnswers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the question]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questions', @level2type=N'COLUMN',@level2name=N'QuestionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija pitanja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questions', @level2type=N'COLUMN',@level2name=N'QuestionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Text of the question]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questions', @level2type=N'COLUMN',@level2name=N'QuestionText'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Tekst pitanja]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questions', @level2type=N'COLUMN',@level2name=N'QuestionText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the question format (e.g. text, checkbok,..) ][FK*contract.QuestionFormat.QuestionFormatID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Questions', @level2type=N'COLUMN',@level2name=N'QuestionFormatID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the risk]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks', @level2type=N'COLUMN',@level2name=N'RiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija jednog rizika]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks', @level2type=N'COLUMN',@level2name=N'RiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the risk]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv rizika]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Description of the risk]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Opis rizika]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of all risks tha can be included in insurance]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik svih rizika koji se mogu uključiti u osiguranje]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Risks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the state]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'StateID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija države]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'StateID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the state]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv države]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*International 3-letter code of the state]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Međunarodna troslovna oznaka države]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*International 2-letter code of the state]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'AlfaCode'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Međunarodna dvoslovna oznaka države]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'AlfaCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*International numeric code of the state]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'NumericCode'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Međunarodni brojčani kod države]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'NumericCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the currency which is official currency of the state][FK*dbo.Currencies.CurrencyID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'OfficialCurrencyID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija valute koja je zvačnična valuta države][FK*dbo.Currencies.CurrencyID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'OfficialCurrencyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the state in old local database]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'OldID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija države u staroj bazi podataka]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States', @level2type=N'COLUMN',@level2name=N'OldID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of states]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik država]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'States'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the hirerachy relationship between tariff groups]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies', @level2type=N'COLUMN',@level2name=N'TariffGroupHierarchyID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija jednog hijerarhijskog odnosa između tarifnih grupa]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies', @level2type=N'COLUMN',@level2name=N'TariffGroupHierarchyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the parent node in the hirerachy relationship between tariff groups][FK*dbo.TariffGroups.TariffGroupID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies', @level2type=N'COLUMN',@level2name=N'TariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija nadređene tarifne grupe][FK*dbo.TariffGroups.TariffGroupID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies', @level2type=N'COLUMN',@level2name=N'TariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the child node in the hirerachy relationship between tariff groups][FK*dbo.TariffGroups.TariffGroupID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies', @level2type=N'COLUMN',@level2name=N'SubTariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija podređene tarifne grupe][FK*dbo.TariffGroups.TariffGroupID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies', @level2type=N'COLUMN',@level2name=N'SubTariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Hierarchy relationships between tariff groups]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Hijerahiski odnosi između tarifnih grupa]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroupHierarchies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a tariff group]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'TariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tarifne grupe]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'TariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of line of business to which tariff group belongs][FK*dbo.LineOfBusinesses.LineOfBusinessID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'LineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vrste osiguranja kojoj pripada tarifna grupa][FK*dbo.LineOfBusinesses.LineOfBusinessID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'LineOfBusinessID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Code of the tariff group]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifra tarifne grupe]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the tariff group]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv tarifne grupe]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the dynamic of the repayment of insured sum (dbo.g. at once, by program, rent repayment ...)][FK*dbo.InsuredSumPaymentTypes.InsuredSumPaymentTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija dinamike isplate osigurane sume (npr. jednokratno, po određenom programu ispalate, isplata rente ...)][FK*dbo.InsuredSumPaymentTypes.InsuredSumPaymentTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the number of insured persons (dbo.g. one insured, two insured, more insured...)][FK*dbo.NumberOfInsurers.NumberOfInsurerID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'NumberOfInsureeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija oznake za broj osiguranika (npr. jedan osiguranik, dva osiguranika, grupa osiguranih lica ...)][FK*dbo.NumberOfInsurers.NumberOfInsurerID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'NumberOfInsureeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of condition for repayment of insured sum (dbo.g. guaranteed repayment sum, repayment in case of insured event, ...  )][FK*dbo.InsuredSumPaymentConditions.InsuredSumPaymentConditionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentConditionID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija uslova pod kojim se isplaćuje osigurana suma (npr. garantovana isplata osigurane sume, isplata u slučaju osiguranog događaja, ...  )][FK*dbo.InsuredSumPaymentConditions.InsuredSumPaymentConditionID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups', @level2type=N'COLUMN',@level2name=N'InsuredSumPaymentConditionID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Groups of tariffs]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Tarifne grupe]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffGroups'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the tariff overhead]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'TariffOverheadID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija režijskog troška za tarifu]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'TariffOverheadID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Starting date of tariff overhead validity]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Početak važnosti režijskog troška]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ending date of tariff overhead validity]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Istek važnosti režijskog troška]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the tariff to which overhead reffers][FK*dbo.Tariffs.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tarife na koju se odnosi režijski trošak][FK*dbo.Tariffs.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Rate of the overhaed]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'NetPremiumRate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Stopa po kojoj se računa režijski trošak]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads', @level2type=N'COLUMN',@level2name=N'NetPremiumRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Overheads of tariffs]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Režijski troškovi za tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffOverheads'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the relationship between a beneficiary type and a tariff risk. The meaning of the releationship is: specified beneficiary type must be defined on the policy for specified risk on specified tariff.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes', @level2type=N'COLUMN',@level2name=N'TariffRiskBeneficiaryTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacije veze između jedne vrste korisnika osiguranja i jednog rizika na jednoj tarifi. Značenje veze je sledeće: navedena vrsta korisnika osiguranja mora da bude definisana u polisi za navedeni rizik po na navedenoj tarifi.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes', @level2type=N'COLUMN',@level2name=N'TariffRiskBeneficiaryTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the relationship between tariff and risk for which beneficiary type must be defined][FK*dbo.TariffRisks.TariffRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes', @level2type=N'COLUMN',@level2name=N'TariffRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija veze između rizika i tarife za koju mora biti definisana vrsta korisnika osiguranja][FK*dbo.TariffRisks.TariffRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes', @level2type=N'COLUMN',@level2name=N'TariffRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the beneficiary type in the relationship][FK*dbo.BeneficiaryTypes.BeneficiaryTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes', @level2type=N'COLUMN',@level2name=N'BeneficiaryTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vrste korisnika osiguranja u definisanoj vezi][FK*dbo.BeneficiaryTypes.BeneficiaryTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes', @level2type=N'COLUMN',@level2name=N'BeneficiaryTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Relationships between beneficiary types and tariff risks]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Veze između vrste korisnika osiguranja i rizika na tarifi]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskBeneficiaryTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the relationship between a tariff and a risk.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'TariffRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija veze između jedne tarife i jednog rizika.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'TariffRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the tariff that includes the risk][FK*dbo.Tariffs.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tarife koja u sebe uključuje rizik][FK*dbo.Tariffs.TariffID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the risk that is included in the tariff][FK*dbo.Risks.RiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'RiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija rizika koji je uključen u tarifu][FK*dbo.Risks.RiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'RiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Indicator: whether insured sum by the risk on the tariff has only limited set of values, dbo.g. for risk "hospital day" could be repayed only dbo.000 RSD or dbo.500 RSD]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'IsInsuredSumLimitedBySetOfValues'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Indikator: da li osigurana suma ima samo određene vrednosti. Npr. osigurana suma za rizik "bolnički dan" bolnički dan može biti samo dbo.000 dinara ili dbo.500 dinara]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'IsInsuredSumLimitedBySetOfValues'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Coefficient to multiply insured sum for main risk in order to calculate insured sum for current risk. dbo.g. if insured sum for main risk is 3000 and this coefficient is 2, then insured sum for current risk is 6000.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'MainEventCoeficient'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Koeficijent kojim se množi osigurana suma za glavni rizik da bi se izračunala osigurana suma za tekući rizik. Npr. ako je osigurana suma za glavni rizik 3000, a ovaj koeficijent je2, onda je osigurana suma za tekući rizik 6000]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'MainEventCoeficient'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ordinal number of risk within tariff counting from dbo.This ordinal is used when printing policy.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Redni broj rizika u okviru tarife, brojeći od 1. Služi za određivanje redosleda štampanja rizika na polisi.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the type of the risk within a tariff (dbo.g. Main base risk, main risk, additional risk ...)][FK*dbo.TariffRiskTypes.TariffRiskTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'TariffRiskTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vrste rizika u okviru jedne tarife (npr. glavni osnovni rizik, glavni rizik, dodatni rizik)][FK*dbo.TariffRiskTypes.TariffRiskTypeID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'TariffRiskTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*The same description as for field dbo.TariffRisks.MainEventCoeficient, except for fact that this value depends on field GenderID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'MainEventCoeficientGender'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Isti opis kao i za polje dbo.TariffRisks.MainEventCoeficient, samo što ova vrednost zavisi i od polja GenderID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'MainEventCoeficientGender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the gender. Field MainEventCoeficientGender depends on it][FK*dbo.Genders.GenderID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'GenderID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija pola. Polje MainEventCoeficientGender zavisi od ovog polja][FK*dbo.Genders.GenderID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks', @level2type=N'COLUMN',@level2name=N'GenderID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Relationships between tariffs and risks. Relationships means: the risk is included in the tariff.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Veze između tarifa i rizika. Značenje veze je sledeće: navedeni rizik je uključen u nevednu tarifu.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRisks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the type of the risk within a tariff]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskTypes', @level2type=N'COLUMN',@level2name=N'TariffRiskTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vrste rizika u okviru jedne tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskTypes', @level2type=N'COLUMN',@level2name=N'TariffRiskTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the type of the risk within a tariff (dbo.g. Main base risk, main risk, additional risk ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv vrste rizika u okviru jedne tarife (npr. glavni osnovni rizik, glavni rizik, dodatni rizik) Name of the type of the risk within a tariff (dbo.g. Main base risk, main risk, additional risk ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of types of risks within a tariff (dbo.g. Main base risk, main risk, additional risk ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik vrsta rizika u okviru jedne tarife (npr. glavni osnovni rizik, glavni rizik, dodatni rizik)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TariffRiskTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the tariff]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'TariffID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the tariff group to which tariff belongs][DF*dbo.TariffGroups.TariffGroupID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'TariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija tarifne grupe kojoj tarifa pripada][DF*dbo.TariffGroups.TariffGroupID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'TariffGroupID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Version number of the tariff]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'VersionNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Broj verzije tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'VersionNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the tariff]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Description of the tariff]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Opis tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Starting date of tariff validity]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'RowStartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Početni datum važenja tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'RowStartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ending date of tariff validity]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'RowEndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Završni datum važenja tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'RowEndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Code of the tariff]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifra tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Shortened tariff name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'ShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Skraćeni naziv tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'ShortName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Full tariff name]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'FullName'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Pun naziv tarife]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs', @level2type=N'COLUMN',@level2name=N'FullName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of tariffs]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Šifarnik tarifa]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tariffs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the bank involvment in the vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'VinculationCreditorID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija učešća jedne banke u jednoj vinkulaciji]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'VinculationCreditorID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the vinculation in which the bank is involved][FK*dbo.Vinculations.VinculationID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vinkulacije u kojoj učestvuje banka][FK*dbo.Vinculations.VinculationID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the bank involved in the vinculation][FK*dbo.Banks.BankID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'BankID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija banke koja učestvuje u vinkulaciji][FK*dbo.Banks.BankID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'BankID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Part of the insured sum that belongs to the bank in case of insured event. For example id banks A and B are involved in the same vinculation, and bank A have this number set to 0,4, this means that 40% of insured sum belongs to the bank A.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'Rate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Deo osigurane sume koji pripada banci u slučaju dešavanja osiguranog slučaja. Na primer, ako u vinkulaciji učestvuju banke A i B, a za banku A je ovaj broj postavljen na 0,4, to znači da banci A pripada 40% osigurane sume.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'Rate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ordinal number of the bank involved in the vinculation within one vinculation. Numbering starts from 1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Redni broj banke koja učestvuje u vinkulaciji u okviru jedne vinkulacije brojeći od 1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors', @level2type=N'COLUMN',@level2name=N'Ordinal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Banks involvment in vinculations. Several banks can share one vinculation. Each of them is described in a separate record of this table.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Učešće banaka u vinkulacijama. Na jednoj vinkulaciji može učestvivati više banaka. Svako takvo učešće se opisuje u zasebnom zapisu ove tabele.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationCreditors'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the relationship between the vinculation and the risk on concern on calculation. Relationship means: the risk is included in the vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'VinculationDetailID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija veze između jedne vinkulacije i jednog rizika jednog predmeta osiguranja sa jednog obračuna. Značenje veze je sledeće: Rizik je uključen u vinkulaciju.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'VinculationDetailID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the vinculation in the relationship][FK*dbo.Vinculations.VinculationID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vinkulacije u vezi][FK*dbo.Vinculations.VinculationID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the risk on concern on calculation that is in relationship with vinculation][FK*dbo.ConcernRisks.ConcernRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'ConcernRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija rizika predmeta osiguranja na obračunu koji je u vezi sa vinkulacijom][FK*dbo.ConcernRisks.ConcernRiskID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'ConcernRiskID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ordinal number of the concern risk within the vinculation counting from 1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Redni broj rizika predmeta osiguranja u okviru vinkulacije. Brojanje počinje od 1]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*For non-life insurance: vinculated insured sum by the risk. For life insurance: vinculated insured sum for the concern (including all risks) - should be specified only for main risk on concern. For all non-main risk on life insurance this field should remain NULL]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'VinculatedInsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Za neživotna osiguranja: vinkulirana osigurana suma po riziku. Za životna osiguranja: vinkulirana osigurana suma za predmet osiguranja (uključujući sve rizike) - navodi se samo za glavni rizik. Za sve rizike osim glavnog kod životnog osiguranja, ovaj podatak ostaje nepopunjen]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'VinculatedInsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Remark about the risk that is included in vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Napomena u vezi sa rizikom koji je uključen u vinkulaciju.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Relationships between vinculations and risks on concerns on calculations]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Veze između vinkulacija i rizika na predmetima osiguranja na obračunima]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a beneficiary on vinculated policy that is included in vinculation.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'VinculationInsuredPersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija korisnika na vinkuliranoj polisi koji je uključen u vinkulaciju.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'VinculationInsuredPersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the vinculation containing list of beneficiaries included in the vinculation][FK*dbo.Vinculations.VinculationID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vinkulacije koja sadrži listu korisnika koji su uključeni u nju][FK*dbo.Vinculations.VinculationID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the beneficiary that is included in the vinculation.][FK*dbo.BusinessEntities.BusinessEntityID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija korisnika osiguranja koji je uključen u vinkulaciju.][FK*dbo.BusinessEntities.BusinessEntityID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'PersonID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Part of the insured sum (expressed as ratio, dbo.g. 0,4 means 40%) belonging to the insured person that is included in the vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'RateShare'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Deo osigurane sume (izražen kao decimalni broj, npr. 0,4 znači 40%) koji pripada korisniku koji je uključen u vinkulaciju]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'RateShare'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Remarks about the beneficiary that is included in the vinculation.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Primedba u vezi sa korisnikom osiguranja koji je uključen u vinkulaciju]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Beneficaries on vinculated policies that are included in vinculation. This list is necessary since there can be several beneficiaries on a vinculated policy, and not necessarily all of them should be included in vinculation.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Korisnici sa vinkuliranih polisa koji su uključeni u vinkulaciju. Ova lista je neophodna jer na vinkuliranoj polisi može postojati više korisnika, a ne moraju svi biti uključeni u vinkulaciju]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationInsuredPersons'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the vinculation of the insurance policy]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija jedne vinkulacije po polisi]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'VinculationID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the status of the vinculation (dbo.g. active, passive, ...)][FK*dbo.VinculationStatuses.VinculationStatusID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'StatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija statusa vinkulacije (npr. aktivna, pasivna, ...)][FK*dbo.VinculationStatuses.VinculationStatusID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'StatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the policy to which vinculation refers][FK*dbo.Documents.DocumentID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'DocumentID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija vinkulirane polise][FK*dbo.Documents.DocumentID]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'DocumentID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ordinal number of the vinculation within the insurance policy]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Redni broj vinkulacije u okviru jedne polise]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'OrdinalNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Insured sum covered by the vinculation ]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'InsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Suma osiguranja na vinkulaciji]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'InsuredSum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Issuing date of the vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'IssuingDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Datum izdavanja vinkulacije]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'IssuingDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Description of the concern covered by the vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'ConcernDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Opis predmeta vinkulacije]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'ConcernDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Starting date of vinculation validity]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Početni datum važenja vinkulacije]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'StartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Ending date of vinculation validity]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Završni datum važenja vinkulacije]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'EndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Remark about vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'Note'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Napomena u vezi sa vinkulacijom]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'Note'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Date when devinculation occured, dbo.e. end of vinculation validity. This is not the sameas filed EndDate, because EndDate contains scheduled date of end of vinculation, and DevinculationDate contains real date of devinculation. In the case of early loan repayment these dates are different.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'DevinculationDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Datum nastupanje devinkulacije, tj. prestanka važenja vinkulacije. Podatak se razlikuje od podatka EndDate jer EndDate sadrži predviđeni datum prestanka vinkulacije, a DevinculationDate sadrži stvarni datum prestanka vinkulacije. U slučaju prevremene otplate kredita ova dva datuma nisu ista.]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'DevinculationDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Remark about devinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'DevinculationNote'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Napomena u vezi sa devinkulacijom]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'DevinculationNote'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Date of the most recent change of the record]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'ChangeDate'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Datum najnovije izmene zapisa]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'ChangeDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of the user that made the most recent change]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'ChangeUserID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija korisnika koji je obavio najnoviju izmenu zapisa]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'ChangeUserID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Nobody knows the purpose of the field. Probalz deserves deleting?]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'Vinculator'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Niko ne zna čemu ovo služi. Možda ga treba brisati?]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations', @level2type=N'COLUMN',@level2name=N'Vinculator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Vinculations of insurance policies]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*VInkulacije po polisama]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Vinculations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*ID of a status of vinculation]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationStatuses', @level2type=N'COLUMN',@level2name=N'VinculationStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Identifikacija jednog statusa vinkulacije]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationStatuses', @level2type=N'COLUMN',@level2name=N'VinculationStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Name of the status of vinculation (dbo.g. active, passive ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationStatuses', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Naziv jednog statusa vinkulacije (npr. aktivna, pasivna, ...)]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationStatuses', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'[DF*Codebook of statuses of vinculations]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationStatuses'
GO
EXEC sys.sp_addextendedproperty @name=N'SR_Opis', @value=N'[DF*Đifarnik statusa vinkulacije]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VinculationStatuses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "bcm"
            Begin Extent = 
               Top = 26
               Left = 73
               Bottom = 189
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ct"
            Begin Extent = 
               Top = 1
               Left = 537
               Bottom = 120
               Right = 762
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ewm"
            Begin Extent = 
               Top = 203
               Left = 671
               Bottom = 322
               Right = 919
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cm"
            Begin Extent = 
               Top = 197
               Left = 969
               Bottom = 316
               Right = 1217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rcm"
            Begin Extent = 
               Top = 7
               Left = 1228
               Bottom = 126
               Right = 1484
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   En' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_BuildingCategoryMatrix'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'd
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_BuildingCategoryMatrix'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_BuildingCategoryMatrix'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "q"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qf"
            Begin Extent = 
               Top = 7
               Left = 349
               Bottom = 126
               Right = 565
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qrt"
            Begin Extent = 
               Top = 7
               Left = 613
               Bottom = 170
               Right = 918
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pa"
            Begin Extent = 
               Top = 7
               Left = 966
               Bottom = 170
               Right = 1196
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pasq"
            Begin Extent = 
               Top = 7
               Left = 1244
               Bottom = 148
               Right = 1558
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pasqq"
            Begin Extent = 
               Top = 126
               Left = 349
               Bottom = 289
               Right = 602
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 117' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_GetQuestionsWithRelations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'0
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_GetQuestionsWithRelations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_GetQuestionsWithRelations'
GO
