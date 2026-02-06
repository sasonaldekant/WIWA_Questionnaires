/*
===============================================================
  FAZA 14: Questionnaire Logic Infrastructure (DDL)
  Opis: Kreiranje tabela za logiku prikazivanja i instance upitnika
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

-- ============================================================
-- 1. QuestionnaireDisplayRules - Logika Prikazivanja
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionnaireDisplayRules]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[QuestionnaireDisplayRules](
        [DisplayRuleID] [int] IDENTITY(1,1) NOT NULL,
        [ProductTypeID] [int] NULL, -- NULL = svi proizvodi
        [SumInsuredFrom] [decimal](18,2) NULL, -- Donja granica OS
        [SumInsuredTo] [decimal](18,2) NULL, -- Gornja granica OS
        [CarencyYears] [int] NULL, -- Specifična karenca (npr. 1 god)
        [AdditionalRiskCode] [nvarchar](50) NULL, -- Npr. 'U0' za bez dopunskih rizika
        [QuestionnaireTypeID] [smallint] NOT NULL,
        [Priority] [int] NOT NULL DEFAULT 0, -- Veći broj = veći prioritet
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_QuestionnaireDisplayRules] PRIMARY KEY CLUSTERED ([DisplayRuleID] ASC),
        CONSTRAINT [FK_QuestionnaireDisplayRules_Types] FOREIGN KEY([QuestionnaireTypeID]) REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID])
        -- FK ka products ako tabela postoji, ali ovde ostavljamo loose coupling za sada
    );

    CREATE INDEX [IDX_QuestionnaireDisplayRules_Lookup] ON [dbo].[QuestionnaireDisplayRules]([ProductTypeID], [SumInsuredFrom], [IsActive]);
END

-- Seed Data: Osnovna pravila iz specifikacije
-- 1. Izjava (OS < 3000, Karenca 1, U0)
INSERT INTO QuestionnaireDisplayRules
(ProductTypeID, SumInsuredFrom, SumInsuredTo, CarencyYears, AdditionalRiskCode, QuestionnaireTypeID, Priority)
SELECT NULL, 0, 3000, 1, 'U0', (SELECT QuestionnaireTypeID FROM QuestionnaireTypes WHERE Code = 'DECLARATION'), 100
WHERE NOT EXISTS (SELECT 1 FROM QuestionnaireDisplayRules WHERE CarencyYears = 1 AND AdditionalRiskCode = 'U0');

-- 2. Veliki Upitnik (OS > 3000)
INSERT INTO QuestionnaireDisplayRules
(ProductTypeID, SumInsuredFrom, SumInsuredTo, CarencyYears, AdditionalRiskCode, QuestionnaireTypeID, Priority)
SELECT NULL, 3001, 999999999, NULL, NULL, (SELECT QuestionnaireTypeID FROM QuestionnaireTypes WHERE Code = 'GREAT_QUEST'), 50
WHERE NOT EXISTS (SELECT 1 FROM QuestionnaireDisplayRules WHERE SumInsuredFrom = 3001);


-- ============================================================
-- 2. QuestionnaireInstances - Instance Popunjenih Upitnika
-- ============================================================
-- Omogućava više upitnika istog tipa za istog klijenta (npr. više vlasnika)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuestionnaireInstances]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[QuestionnaireInstances](
        [QuestionnaireInstanceID] [int] IDENTITY(1,1) NOT NULL,
        [ConcernID] [int] NOT NULL,
        [QuestionnaireTypeID] [smallint] NOT NULL,
        [InstanceNumber] [int] NOT NULL DEFAULT 1, -- Redni broj instance (1, 2, 3...)
        [BeneficialOwnerID] [int] NULL, -- Ako je vezan za specifičnog vlasnika
        [Status] [nvarchar](50) NOT NULL DEFAULT 'DRAFT', -- 'DRAFT', 'COMPLETED', 'SIGNED'
        [CompletedDate] [datetime] NULL,
        [UploadedDocumentPath] [nvarchar](500) NULL,
        [DMSDocumentID] [nvarchar](100) NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [ModifiedDate] [datetime] NULL,
        CONSTRAINT [PK_QuestionnaireInstances] PRIMARY KEY CLUSTERED ([QuestionnaireInstanceID] ASC),
        CONSTRAINT [FK_QuestionnaireInstances_Concerns] FOREIGN KEY([ConcernID]) REFERENCES [dbo].[Concerns] ([ConcernID]),
        CONSTRAINT [FK_QuestionnaireInstances_Types] FOREIGN KEY([QuestionnaireTypeID]) REFERENCES [dbo].[QuestionnaireTypes] ([QuestionnaireTypeID]),
        CONSTRAINT [FK_QuestionnaireInstances_Owners] FOREIGN KEY([BeneficialOwnerID]) REFERENCES [dbo].[BeneficialOwners] ([BeneficialOwnerID]),
        CONSTRAINT [UQ_QuestionnaireInstances_Key] UNIQUE ([ConcernID], [QuestionnaireTypeID], [InstanceNumber])
    );
END

COMMIT;
