USE [WIWA_Questionnaires_DB];
GO
SET NOCOUNT ON;
GO

IF OBJECT_ID('tempdb..#Map_QuestionnaireIdentificatorTypes') IS NOT NULL DROP TABLE #Map_QuestionnaireIdentificatorTypes;
CREATE TABLE #Map_QuestionnaireIdentificatorTypes (OldID INT, NewID INT);

PRINT 'Debug Migrating QuestionnaireIdentificatorTypes...';

MERGE INTO [QuestionnaireIdentificatorTypes] AS Target
USING (
    SELECT Source.[Name], Source.[QuestionnaireIdentificatorTypeID] AS OldID_Source
    FROM [WIWA_DB_NEW].[dbo].[QuestionnaireIdentificatorTypes] Source
) AS SourceData
ON 1 = 0
WHEN NOT MATCHED THEN
    INSERT ([Name])
    VALUES (SourceData.[Name])
    OUTPUT SourceData.OldID_Source, Inserted.[QuestionnaireIdentificatorTypeID] INTO #Map_QuestionnaireIdentificatorTypes;
GO

SELECT * FROM #Map_QuestionnaireIdentificatorTypes;
SELECT count(*) FROM [QuestionnaireIdentificatorTypes];
