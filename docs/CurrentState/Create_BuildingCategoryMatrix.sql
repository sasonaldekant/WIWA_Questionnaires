USE [WIWA_Questionnaires_DB]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BuildingCategoryMatrix]') AND type in (N'U'))
BEGIN
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
END
GO

SET IDENTITY_INSERT [dbo].[BuildingCategoryMatrix] ON 
GO

INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (1, 2, 2, 1, 6)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (2, 1, 2, 2, 7)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (3, 2, 3, 2, 7)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (4, 3, 1, 1, 7)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (5, 3, 2, 1, 7)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (6, 3, 3, 2, 7)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (7, 1, 1, 1, 8)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (8, 1, 2, 1, 8)
INSERT [dbo].[BuildingCategoryMatrix] ([BuildingCategoryMatrixID], [ExternalWallMaterialID], [ConstructionMaterialID], [RoofCoveringMaterialID], [ConstructionTypeID]) VALUES (9, 2, 1, 1, 8)
GO

SET IDENTITY_INSERT [dbo].[BuildingCategoryMatrix] OFF
GO
