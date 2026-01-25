---
description: Kreiranje nove lookup tabele ili matrice
---

# Kreiranje Lookup Tabele / Matrice

## Scenario

Potrebna je nova referentna tabela za lookup vrednosti ili nova matrica za computed izračunavanja.

## Koraci za Lookup Tabelu

### 1. Definiši strukturu

```sql
-- Primer: Nova lookup tabela za vrste goriva
CREATE TABLE [dbo].[FuelTypes] (
    [FuelTypeID] INT IDENTITY(1,1) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
    [Code] NVARCHAR(10) NOT NULL,
    
    CONSTRAINT [PK_FuelTypes] PRIMARY KEY CLUSTERED ([FuelTypeID]),
    CONSTRAINT [UQ_FuelTypes_Code] UNIQUE ([Code])
);
```

### 2. Popuni podatke

```sql
INSERT INTO FuelTypes (Name, Code)
VALUES 
    (N'Benzin', N'BNZ'),
    (N'Dizel', N'DZL'),
    (N'Električna', N'ELE'),
    (N'Hibrid', N'HBR');
```

### 3. Registruj za questionnaire type

```sql
INSERT INTO QuestionnaireTypeReferenceTables (
    QuestionnaireTypeID, 
    TableName
)
VALUES (@QuestionnaireTypeID, N'FuelTypes');
```

## Koraci za Matricu

### 1. Definiši strukturu

```sql
-- Primer: Matrica za premiju po kategorijama
CREATE TABLE [dbo].[PremiumRateMatrix] (
    [PremiumRateMatrixID] INT IDENTITY(1,1) NOT NULL,
    [HazardClassID] INT NOT NULL,
    [ProtectionClassID] INT NOT NULL,
    [ConstructionTypeID] INT NOT NULL,
    [PremiumRate] DECIMAL(10,4) NOT NULL,
    
    CONSTRAINT [PK_PremiumRateMatrix] PRIMARY KEY CLUSTERED ([PremiumRateMatrixID]),
    CONSTRAINT [UQ_PremiumRateMatrix_Combination] UNIQUE (
        [HazardClassID], [ProtectionClassID], [ConstructionTypeID]
    )
);
```

### 2. Definiši FK (opcionalno ali preporučeno)

```sql
ALTER TABLE [dbo].[PremiumRateMatrix]
ADD CONSTRAINT [FK_PremiumRateMatrix_HazardClasses]
    FOREIGN KEY ([HazardClassID]) 
    REFERENCES [dbo].[HazardClasses]([HazardClassID]);

-- Ponovi za ostale FK...
```

### 3. Popuni kombinacije

```sql
INSERT INTO PremiumRateMatrix 
    (HazardClassID, ProtectionClassID, ConstructionTypeID, PremiumRate)
VALUES 
    (1, 1, 1, 0.0015),
    (1, 1, 2, 0.0020),
    (1, 2, 1, 0.0018),
    -- ... sve kombinacije
```

### 4. Registruj za questionnaire type

```sql
INSERT INTO QuestionnaireTypeReferenceTables (
    QuestionnaireTypeID, 
    TableName
)
VALUES (@QuestionnaireTypeID, N'PremiumRateMatrix');

DECLARE @RefTableID INT = SCOPE_IDENTITY();
```

### 5. Mapiraj pitanja na kolone

```sql
INSERT INTO QuestionReferenceColumns (
    QuestionID,
    QuestionnaireTypeReferenceTableID,
    ReferenceColumnName
)
VALUES 
    (@HazardQuestionID, @RefTableID, N'HazardClassID'),
    (@ProtectionQuestionID, @RefTableID, N'ProtectionClassID'),
    (@ConstructionQuestionID, @RefTableID, N'ConstructionTypeID');
```

## Naming Konvencije

- Lookup tabela: `[EntityName]s` (množina) - npr. `FuelTypes`
- Matrica: `[Purpose]Matrix` - npr. `PremiumRateMatrix`
- PK: `[TableName]ID`
- FK kolone: ime kao u parent tabeli

## Verifikacija

```sql
-- Proveri da je tabela kreirana
SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'NovaTabela';

-- Proveri da je registrovana
SELECT * FROM QuestionnaireTypeReferenceTables
WHERE TableName = 'NovaTabela';

-- Proveri da su mappings ispravni
SELECT * FROM QuestionReferenceColumns qrc
JOIN QuestionnaireTypeReferenceTables qtrt 
    ON qtrt.QuestionnaireTypeReferenceTableID = qrc.QuestionnaireTypeReferenceTableID
WHERE qtrt.TableName = 'NovaTabela';
```
