/*
    WIWA – Questionnaire JSON generator (v7 - Veliki Upitnik Variant)
    ---------------------------------------------------------------------------
    Purpose: Generate JSON for QuestionnaireTypeID = 3 (Veliki Upitnik)
*/

DECLARE @QuestionnaireTypeID SMALLINT = 3; -- Veliki upitnik

SET NOCOUNT ON;

-------------------------------------------------------------------------------
-- 0) Helper: map QuestionFormatName -> UiControl (front-end control type)
-------------------------------------------------------------------------------
DECLARE @UiControlMap TABLE (
    Pattern NVARCHAR(100) NOT NULL,
    UiControl NVARCHAR(50) NOT NULL
);
INSERT INTO @UiControlMap(Pattern, UiControl)
VALUES
 (N'%Radio%',  N'radio'),
 (N'%Select%', N'select'),
 (N'%Dropdown%', N'select'),
 (N'%Autocomplete%', N'select'), -- New Mapping for Sport Question
 (N'%Check%',  N'checkbox'),
 (N'%Text%',   N'textarea'),
 (N'%Input%',  N'input'),
 (N'%Hidden%', N'hidden');

-------------------------------------------------------------------------------
-- 1) Select questions
-------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#QQ', 'U') IS NOT NULL DROP TABLE #QQ;
CREATE TABLE #QQ
(
    [QuestionnaireID] INT NULL,
    [QuestionID]      INT NOT NULL PRIMARY KEY
);

INSERT INTO #QQ ([QuestionnaireID], [QuestionID])
SELECT qn.[QuestionnaireID], qn.[QuestionID]
FROM [dbo].[Questionnaires] qn
WHERE qn.[QuestionnaireTypeID] = @QuestionnaireTypeID;

-- Add SubQuestions Closure
WHILE 1 = 1
BEGIN
    ;WITH Missing AS
    (
        SELECT DISTINCT pasq.[SubQuestionID] AS [QuestionID]
        FROM [dbo].[PredefinedAnswers] pa
        JOIN [dbo].[PredefinedAnswerSubQuestions] pasq
          ON pasq.[PredefinedAnswerID] = pa.[PredefinedAnswerID]
        JOIN #QQ sel
          ON sel.[QuestionID] = pa.[QuestionID]
        LEFT JOIN #QQ already
          ON already.[QuestionID] = pasq.[SubQuestionID]
        WHERE already.[QuestionID] IS NULL
    )
    INSERT INTO #QQ ([QuestionnaireID], [QuestionID])
    SELECT NULL, m.[QuestionID]
    FROM Missing m;

    IF @@ROWCOUNT = 0 BREAK;
END;

-- Add AlwaysVisible Children Closure
WHILE 1 = 1
BEGIN
    ;WITH MissingChildren AS
    (
        SELECT DISTINCT c.[QuestionID]
        FROM [dbo].[Questions] c
        JOIN #QQ parentSel
          ON parentSel.[QuestionID] = c.[ParentQuestionID]
        LEFT JOIN #QQ already
          ON already.[QuestionID] = c.[QuestionID]
        WHERE already.[QuestionID] IS NULL
    )
    INSERT INTO #QQ ([QuestionnaireID], [QuestionID])
    SELECT NULL, mc.[QuestionID]
    FROM MissingChildren mc;

    IF @@ROWCOUNT = 0 BREAK;
END;

-------------------------------------------------------------------------------
-- 2) Build nested SubQuestion JSON
-------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#SubQJson', 'U') IS NOT NULL DROP TABLE #SubQJson;
CREATE TABLE #SubQJson
(
    [QuestionID] INT NOT NULL PRIMARY KEY,
    [Json]       NVARCHAR(MAX) NOT NULL
);

WHILE EXISTS (SELECT 1 FROM #QQ sel LEFT JOIN #SubQJson done ON done.[QuestionID] = sel.[QuestionID] WHERE done.[QuestionID] IS NULL)
BEGIN
    ;WITH Ready AS
    (
        SELECT q.[QuestionID]
        FROM [dbo].[Questions] q
        JOIN #QQ sel ON sel.[QuestionID] = q.[QuestionID]
        LEFT JOIN #SubQJson done ON done.[QuestionID] = q.[QuestionID]
        WHERE done.[QuestionID] IS NULL
          AND NOT EXISTS (
              SELECT 1 FROM [dbo].[PredefinedAnswers] pa
              JOIN [dbo].[PredefinedAnswerSubQuestions] pasq ON pasq.[PredefinedAnswerID] = pa.[PredefinedAnswerID]
              JOIN #QQ selChild ON selChild.[QuestionID] = pasq.[SubQuestionID]
              LEFT JOIN #SubQJson childDone ON childDone.[QuestionID] = pasq.[SubQuestionID]
              WHERE pa.[QuestionID] = q.[QuestionID] AND childDone.[QuestionID] IS NULL
          )
          AND NOT EXISTS (
              SELECT 1 FROM [dbo].[Questions] ch
              JOIN #QQ selCh ON selCh.[QuestionID] = ch.[QuestionID]
              LEFT JOIN #SubQJson chDone ON chDone.[QuestionID] = ch.[QuestionID]
              WHERE ch.[ParentQuestionID] = q.[QuestionID] AND chDone.[QuestionID] IS NULL
          )
    )
    INSERT INTO #SubQJson ([QuestionID], [Json])
    SELECT
        q.[QuestionID],
        (
            SELECT
                q.[QuestionID]       AS [QuestionID],
                q.[QuestionLabel]    AS [QuestionLabel],
                q.[QuestionText]     AS [QuestionText],
                q.[QuestionOrder]    AS [QuestionOrder],
                q.[QuestionFormatID] AS [QuestionFormatID],
                qf.[Name]            AS [SubQuestionFormat],
                q.[SpecificQuestionTypeID] AS [SpecificQuestionTypeID],
                sqt.[Name]                 AS [SpecificQuestionTypeName],
                q.[ReadOnly]               AS [ReadOnly],
                q.[ParentQuestionID]       AS [ParentQuestionID],
                Children = JSON_QUERY(COALESCE((
                    SELECT N'[' + STRING_AGG(ch.[Json], N',') WITHIN GROUP (ORDER BY qc2.[QuestionOrder], qc2.[QuestionID]) + N']'
                    FROM [dbo].[Questions] qc2 JOIN #SubQJson ch ON ch.[QuestionID] = qc2.[QuestionID]
                    WHERE qc2.[ParentQuestionID] = q.[QuestionID]
                ), N'[]')),
                SubAnswers = JSON_QUERY(COALESCE((
                    SELECT
                        pa.[PredefinedAnswerID]  AS [PredefinedAnswerID],
                        pa.[Answer]              AS [Answer],
                        pa.[Code]                AS [Code],
                        pa.[PreSelected]         AS [PreSelected],
                        SubQuestions = JSON_QUERY(COALESCE((
                            SELECT N'[' + STRING_AGG(sq.[Json], N',') WITHIN GROUP (ORDER BY qc.[QuestionOrder], qc.[QuestionID]) + N']'
                            FROM [dbo].[PredefinedAnswerSubQuestions] pasq2
                            JOIN #SubQJson sq ON sq.[QuestionID] = pasq2.[SubQuestionID]
                            JOIN [dbo].[Questions] qc ON qc.[QuestionID] = pasq2.[SubQuestionID]
                            WHERE pasq2.[PredefinedAnswerID] = pa.[PredefinedAnswerID]
                        ), N'[]'))
                    FROM [dbo].[PredefinedAnswers] pa
                    WHERE pa.[QuestionID] = q.[QuestionID]
                    ORDER BY pa.[PredefinedAnswerID]
                    FOR JSON PATH
                ), N'[]'))
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS [Json]
    FROM [dbo].[Questions] q
    JOIN Ready r ON r.[QuestionID] = q.[QuestionID]
    LEFT JOIN [dbo].[QuestionFormats] qf ON qf.[QuestionFormatID] = q.[QuestionFormatID]
    LEFT JOIN [dbo].[SpecificQuestionTypes] sqt ON sqt.[SpecificQuestionTypeID] = q.[SpecificQuestionTypeID];

    IF @@ROWCOUNT = 0 BREAK;
END;

-------------------------------------------------------------------------------
-- 3) Root questions
-------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#RootQJson', 'U') IS NOT NULL DROP TABLE #RootQJson;
CREATE TABLE #RootQJson ([QuestionID] INT NOT NULL PRIMARY KEY, [QuestionOrder] INT NOT NULL, [Json] NVARCHAR(MAX) NOT NULL);

INSERT INTO #RootQJson ([QuestionID], [QuestionOrder], [Json])
SELECT
    q.[QuestionID],
    ISNULL(q.[QuestionOrder], 0),
    (
        SELECT
            q.[QuestionID]       AS [QuestionID],
            q.[QuestionLabel]    AS [QuestionLabel],
            q.[QuestionText]     AS [QuestionText],
            q.[QuestionOrder]    AS [QuestionOrder],
            q.[QuestionFormatID] AS [QuestionFormatID],
            qf.[Name]            AS [QuestionFormatName],
            UiControl = (SELECT TOP 1 m.UiControl FROM @UiControlMap m WHERE qf.[Name] LIKE m.Pattern),
            q.[SpecificQuestionTypeID],
            sqt.Name AS [SpecificQuestionType],
            q.[ReadOnly],
            q.[ParentQuestionID],
            Children = JSON_QUERY(COALESCE((
                SELECT N'[' + STRING_AGG(ch.[Json], N',') WITHIN GROUP (ORDER BY qc2.[QuestionOrder], qc2.[QuestionID]) + N']'
                FROM [dbo].[Questions] qc2 JOIN #SubQJson ch ON ch.[QuestionID] = qc2.[QuestionID]
                WHERE qc2.[ParentQuestionID] = q.[QuestionID]
            ), N'[]')),
            Answers = JSON_QUERY(COALESCE((
                SELECT pa.[PredefinedAnswerID], pa.[Answer], pa.[Code], pa.[PreSelected],
                    SubQuestions = JSON_QUERY(COALESCE((
                        SELECT N'[' + STRING_AGG(sq.[Json], N',') WITHIN GROUP (ORDER BY qc.[QuestionOrder], qc.[QuestionID]) + N']'
                        FROM [dbo].[PredefinedAnswerSubQuestions] pasq2
                        JOIN #SubQJson sq ON sq.[QuestionID] = pasq2.[SubQuestionID]
                        JOIN [dbo].[Questions] qc ON qc.[QuestionID] = pasq2.[SubQuestionID]
                        WHERE pasq2.[PredefinedAnswerID] = pa.[PredefinedAnswerID]
                    ), N'[]'))
                FROM [dbo].[PredefinedAnswers] pa
                WHERE pa.[QuestionID] = q.[QuestionID]
                ORDER BY pa.[PredefinedAnswerID]
                FOR JSON PATH
            ), N'[]'))
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )
FROM [dbo].[Questions] q
JOIN #QQ sel ON sel.[QuestionID] = q.[QuestionID]
LEFT JOIN [dbo].[QuestionFormats] qf ON qf.[QuestionFormatID] = q.[QuestionFormatID]
LEFT JOIN [dbo].[SpecificQuestionTypes] sqt ON sqt.[SpecificQuestionTypeID] = q.[SpecificQuestionTypeID]
WHERE q.[ParentQuestionID] IS NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[PredefinedAnswerSubQuestions] x WHERE x.[SubQuestionID] = q.[QuestionID]);

-------------------------------------------------------------------------------
-- 4-7) Dictionaries, Rules, References (With fix for ReferenceColumnName)
-------------------------------------------------------------------------------
DECLARE @QuestionFormatsJson NVARCHAR(MAX) = (SELECT qf.QuestionFormatID, qf.Name, UiControl=(SELECT TOP 1 m.UiControl FROM @UiControlMap m WHERE qf.[Name] LIKE m.Pattern) FROM dbo.QuestionFormats qf FOR JSON PATH);
DECLARE @SpecificTypesJson NVARCHAR(MAX) = (SELECT st.SpecificQuestionTypeID, st.Name FROM dbo.SpecificQuestionTypes st FOR JSON PATH);
DECLARE @QuestionnaireTypeRulesJson NVARCHAR(MAX) = (SELECT * FROM dbo.QuestionnaireTypeRules r WHERE r.QuestionnaireTypeID = @QuestionnaireTypeID FOR JSON PATH);

DECLARE @ReferenceMappingsJson NVARCHAR(MAX) = (
    SELECT
        qrc.QuestionID,
        qtrt.TableName,
        qrc.ReferenceColumnName -- ADDED THIS
    FROM dbo.QuestionnaireTypeReferenceTables qtrt
    LEFT JOIN dbo.QuestionReferenceColumns qrc ON qrc.QuestionnaireTypeReferenceTableID = qtrt.QuestionnaireTypeReferenceTableID
    WHERE qtrt.QuestionnaireTypeID = @QuestionnaireTypeID
    ORDER BY qtrt.TableName, qrc.QuestionID
    FOR JSON PATH
);

IF OBJECT_ID('tempdb..#RefTables', 'U') IS NOT NULL DROP TABLE #RefTables;
CREATE TABLE #RefTables (TableName NVARCHAR(200) NOT NULL PRIMARY KEY, Json NVARCHAR(MAX) NULL);
INSERT INTO #RefTables(TableName) SELECT DISTINCT TableName FROM dbo.QuestionnaireTypeReferenceTables WHERE QuestionnaireTypeID = @QuestionnaireTypeID;

DECLARE @tbl NVARCHAR(200), @sql NVARCHAR(MAX), @json NVARCHAR(MAX);
DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT TableName FROM #RefTables;
OPEN cur; FETCH NEXT FROM cur INTO @tbl;
WHILE @@FETCH_STATUS = 0 BEGIN
     SET @sql = N'SET @jsonOUT = (SELECT * FROM dbo.' + QUOTENAME(@tbl) + N' FOR JSON PATH);';
     SET @json = NULL;
     EXEC sp_executesql @sql, N'@jsonOUT NVARCHAR(MAX) OUTPUT', @jsonOUT = @json OUTPUT;
     UPDATE #RefTables SET Json = COALESCE(@json, N'[]') WHERE TableName = @tbl;
     FETCH NEXT FROM cur INTO @tbl;
END
CLOSE cur; DEALLOCATE cur;

DECLARE @ReferenceTablesJson NVARCHAR(MAX) = (SELECT CASE WHEN COUNT(*) = 0 THEN N'{}' ELSE N'{' + STRING_AGG(N'"' + REPLACE(TableName, N'"', N'\\"') + N'":' + COALESCE(Json, N'[]'), N',') + N'}' END FROM #RefTables);

DECLARE @RulesJson NVARCHAR(MAX) = (
    SELECT qcc.QuestionID AS questionId, cm.Code AS kind, qcc.RuleName AS ruleName,
        inputQuestionIds = JSON_QUERY((SELECT '[' + STRING_AGG(c.QuestionID, ',') + ']' FROM dbo.Questions c WHERE c.ParentQuestionID = qcc.QuestionID))
    FROM dbo.QuestionComputedConfigs qcc
    JOIN dbo.ComputeMethods cm ON qcc.ComputeMethodID = cm.ComputeMethodID
     WHERE EXISTS (SELECT 1 FROM dbo.Questionnaires qn WHERE qn.QuestionID = qcc.QuestionID AND qn.QuestionnaireTypeID = @QuestionnaireTypeID)
    FOR JSON PATH
);

SELECT [Json] = (
    SELECT
        meta = JSON_QUERY((SELECT schemaVersion = N'v3_MODEL', dbModel = N'WIWA_DB_NEW', generatedAt = CONVERT(VARCHAR(33), SYSUTCDATETIME(), 126) + 'Z', questionnaireTypeId = @QuestionnaireTypeID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
        questionnaire = JSON_QUERY((SELECT QuestionnaireTypeID AS id, Name AS typeName FROM dbo.QuestionnaireTypes WHERE QuestionnaireTypeID = @QuestionnaireTypeID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
        dictionaries = JSON_QUERY((SELECT JSON_QUERY(COALESCE(@QuestionFormatsJson, N'[]')) AS questionFormats, JSON_QUERY(COALESCE(@SpecificTypesJson, N'[]')) AS specificQuestionTypes FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)),
        referenceMappings = JSON_QUERY(COALESCE(@ReferenceMappingsJson, N'[]')),
        referenceTables   = JSON_QUERY(COALESCE(@ReferenceTablesJson, N'{}')),
        rules             = JSON_QUERY(COALESCE(@RulesJson, N'[]')),
        questions         = JSON_QUERY(COALESCE((SELECT N'[' + STRING_AGG(r.[Json], N',') WITHIN GROUP (ORDER BY r.QuestionOrder, r.QuestionID) + N']' FROM #RootQJson r), N'[]'))
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
);
