/*
===============================================================
  FAZA 13: AML & Compliance Infrastructure (DDL)
  Opis: Kreiranje tabela za AML procese, funkcionere i procenu rizika
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

-- ============================================================
-- 1. BeneficialOwners - Stvarni Vlasnici (za pravna lica)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BeneficialOwners]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BeneficialOwners](
        [BeneficialOwnerID] [int] IDENTITY(1,1) NOT NULL,
        [ConcernID] [int] NOT NULL, -- FK ka klijentu (pravnom licu)
        [OwnerName] [nvarchar](500) NOT NULL,
        [BirthPlace] [nvarchar](200) NOT NULL,
        [OwnershipPercentage] [decimal](5,2) NOT NULL,
        [QuestionnaireInstanceID] [int] NULL, -- FK ka popunjenom upitniku
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [ModifiedDate] [datetime] NULL,
        CONSTRAINT [PK_BeneficialOwners] PRIMARY KEY CLUSTERED ([BeneficialOwnerID] ASC),
        CONSTRAINT [FK_BeneficialOwners_Concerns] FOREIGN KEY([ConcernID]) REFERENCES [dbo].[Concerns] ([ConcernID]),
        CONSTRAINT [CHK_BeneficialOwners_Ownership] CHECK ([OwnershipPercentage] >= 0 AND [OwnershipPercentage] <= 100)
    );
    
    CREATE INDEX [IDX_BeneficialOwners_Concern] ON [dbo].[BeneficialOwners]([ConcernID]);
END

-- ============================================================
-- 2. AMLMarkers - Markeri i Flagovi
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AMLMarkers]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AMLMarkers](
        [AMLMarkerID] [int] IDENTITY(1,1) NOT NULL,
        [ConcernID] [int] NOT NULL,
        [MarkerType] [nvarchar](100) NOT NULL, -- 'PEP', 'HIGH_RISK_COUNTRY', 'SANCTION', 'HIGH_PREMIUM'
        [MarkerSource] [nvarchar](100) NOT NULL, -- 'FUNCTIONARY_QUEST', 'RISK_ASSESSMENT', 'EXTERNAL_LIST'
        [MarkerDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [ResolvedDate] [datetime] NULL,
        [IsResolved] [bit] NOT NULL DEFAULT 0,
        [ResolvedByUserID] [int] NULL,
        [Notes] [nvarchar](max) NULL,
        CONSTRAINT [PK_AMLMarkers] PRIMARY KEY CLUSTERED ([AMLMarkerID] ASC),
        CONSTRAINT [FK_AMLMarkers_Concerns] FOREIGN KEY([ConcernID]) REFERENCES [dbo].[Concerns] ([ConcernID])
    );

    CREATE INDEX [IDX_AMLMarkers_Concern_Active] ON [dbo].[AMLMarkers]([ConcernID], [IsResolved]);
END

-- ============================================================
-- 3. RiskLevelRules - Pravila za Nivoe Rizika
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RiskLevelRules]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[RiskLevelRules](
        [RiskLevelRuleID] [int] IDENTITY(1,1) NOT NULL,
        [RiskLevel] [char](1) NOT NULL, -- 'N', 'S', 'V'
        [MinScore] [int] NOT NULL,
        [MaxScore] [int] NULL, -- NULL = infinity
        [Description] [nvarchar](500) NULL,
        [RequiresAMLReview] [bit] NOT NULL DEFAULT 0,
        [RequiresUWNotification] [bit] NOT NULL DEFAULT 0,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_RiskLevelRules] PRIMARY KEY CLUSTERED ([RiskLevelRuleID] ASC),
        CONSTRAINT [CHK_RiskLevelRules_Level] CHECK ([RiskLevel] IN ('N', 'S', 'V'))
    );
END

-- Seed Data za RiskLevelRules
MERGE [dbo].[RiskLevelRules] AS TARGET
USING (VALUES 
    ('N', 0, 5, N'Nizak rizik', 0, 0),
    ('S', 6, 9, N'Srednji rizik', 1, 1),
    ('V', 10, NULL, N'Visok rizik', 1, 1)
) AS SOURCE ([RiskLevel], [MinScore], [MaxScore], [Description], [RequiresAMLReview], [RequiresUWNotification])
ON TARGET.[RiskLevel] = SOURCE.[RiskLevel]
WHEN MATCHED THEN
    UPDATE SET 
        [MinScore] = SOURCE.[MinScore],
        [MaxScore] = SOURCE.[MaxScore],
        [RequiresAMLReview] = SOURCE.[RequiresAMLReview],
        [RequiresUWNotification] = SOURCE.[RequiresUWNotification]
WHEN NOT MATCHED THEN
    INSERT ([RiskLevel], [MinScore], [MaxScore], [Description], [RequiresAMLReview], [RequiresUWNotification])
    VALUES (SOURCE.[RiskLevel], SOURCE.[MinScore], SOURCE.[MaxScore], SOURCE.[Description], SOURCE.[RequiresAMLReview], SOURCE.[RequiresUWNotification]);


-- ============================================================
-- 4. RiskAssessmentResults - Rezultati Procene
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RiskAssessmentResults]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[RiskAssessmentResults](
        [RiskAssessmentResultID] [int] IDENTITY(1,1) NOT NULL,
        [ConcernID] [int] NOT NULL,
        [QuestionnaireInstanceID] [int] NULL, -- Link ka konkretnom popunjenom upitniku
        [TotalScore] [int] NOT NULL,
        [RiskLevel] [char](1) NOT NULL,
        [AssessmentDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [CalculatedByRuleID] [int] NULL,
        [ReviewedByAML] [bit] NOT NULL DEFAULT 0,
        [AMLReviewDate] [datetime] NULL,
        [AMLDecision] [nvarchar](50) NULL, -- 'APPROVED', 'REJECTED', 'ADDITIONAL_DOCS'
        [Notes] [nvarchar](max) NULL,
        CONSTRAINT [PK_RiskAssessmentResults] PRIMARY KEY CLUSTERED ([RiskAssessmentResultID] ASC),
        CONSTRAINT [FK_RiskAssessmentResults_Concerns] FOREIGN KEY([ConcernID]) REFERENCES [dbo].[Concerns] ([ConcernID]),
        CONSTRAINT [FK_RiskAssessmentResults_Rules] FOREIGN KEY([CalculatedByRuleID]) REFERENCES [dbo].[RiskLevelRules] ([RiskLevelRuleID]),
        CONSTRAINT [CHK_RiskAssessmentResults_Level] CHECK ([RiskLevel] IN ('N', 'S', 'V'))
    );
END

COMMIT;
