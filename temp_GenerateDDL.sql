SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

SELECT 'USE [master];'
SELECT 'GO'
SELECT 'IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = ''WIWA_Questionnaires_DB'')'
SELECT 'BEGIN'
SELECT '    CREATE DATABASE [WIWA_Questionnaires_DB]'
SELECT 'END'
SELECT 'GO'
SELECT 'USE [WIWA_Questionnaires_DB];'
SELECT 'GO'

DECLARE @Tables TABLE (Name NVARCHAR(128))
INSERT INTO @Tables VALUES
('Questionnaires'), ('QuestionnaireTypes'), ('Questions'), ('SpecificQuestionTypes'), ('QuestionFormats'), ('PredefinedAnswers'), ('PredefinedAnswerSubQuestions'), ('QuestionComputedConfigs'), ('QuestionnaireIdentificators'), ('QuestionnaireByQuestionnaireIdentificators'), ('QuestionnaireAnswers'), ('QuestionnaireIdentificatorTypes'), ('QuestionnaireTypeRules'), ('ComputeMethods'), ('Indicators'), ('Ranks'), ('RiskLevels'), ('QuestionReferenceColumns'), ('QuestionnaireTypeReferenceTables'), ('ProductQuestionaryTypes')

DECLARE @TableName NVARCHAR(128)
DECLARE @SchemaName NVARCHAR(128) = 'dbo'
DECLARE @SQL NVARCHAR(MAX) = ''
DECLARE @Cols NVARCHAR(MAX)

DECLARE table_cursor CURSOR FOR SELECT Name FROM @Tables
OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Identify PK Column Name
    DECLARE @PKColumnName NVARCHAR(128)
    SELECT TOP 1 @PKColumnName = c.name
    FROM sys.indexes i
    INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    INNER JOIN sys.tables t ON t.object_id = c.object_id
    WHERE t.name = @TableName AND i.is_primary_key = 1
    
    SET @SQL = 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '] (' + CHAR(13) + CHAR(10)
    
    -- Generate Columns
    -- Rule: If Column is PK and Type is INT/SMALLINT/etc, Force IDENTITY(1,1)
    SELECT @Cols = STUFF((
        SELECT ',' + CHAR(13) + CHAR(10) + '    [' + c.COLUMN_NAME + '] ' + 
        c.DATA_TYPE + 
        CASE 
            WHEN c.DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar') AND c.CHARACTER_MAXIMUM_LENGTH = -1 THEN '(MAX)'
            WHEN c.DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar') THEN '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
            WHEN c.DATA_TYPE IN ('decimal', 'numeric') THEN '(' + CAST(c.NUMERIC_PRECISION AS VARCHAR(10)) + ', ' + CAST(c.NUMERIC_SCALE AS VARCHAR(10)) + ')'
            ELSE '' 
        END +
        CASE WHEN c.IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE ' NULL' END +
        CASE WHEN c.COLUMN_DEFAULT IS NOT NULL THEN ' DEFAULT ' + c.COLUMN_DEFAULT ELSE '' END +
        CASE 
            WHEN c.COLUMN_NAME = @PKColumnName AND c.DATA_TYPE IN ('int', 'smallint', 'bigint', 'tinyint') THEN ' IDENTITY(1,1)'
            WHEN COLUMNPROPERTY(OBJECT_ID(c.TABLE_SCHEMA + '.' + c.TABLE_NAME), c.COLUMN_NAME, 'IsIdentity') = 1 THEN ' IDENTITY(1,1)' 
            ELSE '' 
        END
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE c.TABLE_NAME = @TableName AND c.TABLE_SCHEMA = @SchemaName
        ORDER BY c.ORDINAL_POSITION
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '    ')
    
    SET @SQL = @SQL + @Cols + ',' + CHAR(13) + CHAR(10)

    -- PK Constraint
    DECLARE @PKName NVARCHAR(128) = NULL
    DECLARE @PKCols NVARCHAR(MAX) = NULL

    SELECT TOP 1 @PKName = kz.name
    FROM sys.indexes kz
    INNER JOIN sys.tables t ON t.object_id = kz.object_id
    WHERE t.name = @TableName AND kz.is_primary_key = 1

    IF @PKName IS NOT NULL
    BEGIN
         SET @SQL = @SQL + '    CONSTRAINT [' + @PKName + '] PRIMARY KEY CLUSTERED ('
         SELECT @PKCols = STUFF((
            SELECT ', [' + c.name + '] ASC'
            FROM sys.index_columns ic
            INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            INNER JOIN sys.tables t ON t.object_id = c.object_id
            INNER JOIN sys.indexes i ON i.object_id = ic.object_id AND i.index_id = ic.index_id
            WHERE t.name = @TableName AND i.is_primary_key = 1
            ORDER BY ic.key_ordinal
            FOR XML PATH('')
        ), 1, 2, '')
        SET @SQL = @SQL + @PKCols + ')' + CHAR(13) + CHAR(10)
    END
    ELSE
    BEGIN
         -- remove comma
         SET @SQL = LEFT(@SQL, LEN(@SQL) - 3) + CHAR(13) + CHAR(10)
    END

    SET @SQL = @SQL + ');' + CHAR(13) + CHAR(10)
    SET @SQL = @SQL + 'GO'
    
    SELECT @SQL 
    
    FETCH NEXT FROM table_cursor INTO @TableName
END
CLOSE table_cursor
DEALLOCATE table_cursor

-- FKs
DECLARE fk_cursor CURSOR FOR 
    SELECT t1.name, obj.name, c.name, t2.name, c2.name
    FROM sys.foreign_key_columns fkc
    INNER JOIN sys.objects obj ON obj.object_id = fkc.constraint_object_id
    INNER JOIN sys.tables t1 ON t1.object_id = fkc.parent_object_id
    INNER JOIN sys.tables t2 ON t2.object_id = fkc.referenced_object_id
    INNER JOIN sys.columns c ON c.column_id = fkc.parent_column_id AND c.object_id = fkc.parent_object_id
    INNER JOIN sys.columns c2 ON c2.column_id = fkc.referenced_column_id AND c2.object_id = fkc.referenced_object_id
    WHERE t1.name IN (SELECT Name FROM @Tables) AND t2.name IN (SELECT Name FROM @Tables)

DECLARE @FKTable NVARCHAR(128), @FKName NVARCHAR(128), @FKCol NVARCHAR(128), @RefTable NVARCHAR(128), @RefCol NVARCHAR(128)

OPEN fk_cursor
FETCH NEXT FROM fk_cursor INTO @FKTable, @FKName, @FKCol, @RefTable, @RefCol

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT 'ALTER TABLE [dbo].[' + @FKTable + '] WITH CHECK ADD CONSTRAINT [' + @FKName + '] FOREIGN KEY([' + @FKCol + ']) REFERENCES [dbo].[' + @RefTable + '] ([' + @RefCol + ']);'
    SELECT 'GO'
    SELECT 'ALTER TABLE [dbo].[' + @FKTable + '] CHECK CONSTRAINT [' + @FKName + '];'
    SELECT 'GO'
    FETCH NEXT FROM fk_cursor INTO @FKTable, @FKName, @FKCol, @RefTable, @RefCol
END
CLOSE fk_cursor
DEALLOCATE fk_cursor
