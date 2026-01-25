/*
===============================================================
  FAZA 10: ComputedQuestions - BMI Logika
  Opis: Povezivanje BMI pitanja sa metodom kalkulacije
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

-- 1. Osigurati da postoje ComputeMethods i OutputModes
IF NOT EXISTS (SELECT 1 FROM ComputeMethods WHERE Code = 'BMI_CALC')
BEGIN
    INSERT INTO ComputeMethods (Name, Code, Description)
    VALUES (N'BMI Calculator', N'BMI_CALC', N'Standard BMI calculation: Weight / (Height/100)^2');
END

IF NOT EXISTS (SELECT 1 FROM ComputedOutputModes WHERE Code = 'READONLY_DISPLAY')
BEGIN
    INSERT INTO ComputedOutputModes (Name, Code, Description)
    VALUES (N'Read Only Display', N'READONLY_DISPLAY', N'Display computed value as read-only text');
END

-- 2. Povezivanje Pitanja 102 (BMI Index)
DECLARE @BMI_MethodID INT = (SELECT ComputeMethodID FROM ComputeMethods WHERE Code = 'BMI_CALC');
DECLARE @Display_ModeID INT = (SELECT OutputModeID FROM ComputedOutputModes WHERE Code = 'READONLY_DISPLAY');

IF NOT EXISTS (SELECT 1 FROM ComputedQuestions WHERE QuestionID = 102)
BEGIN
    INSERT INTO ComputedQuestions (QuestionID, ComputeMethodID, OutputModeID)
    VALUES (102, @BMI_MethodID, @Display_ModeID);
END

-- Validacija
SELECT q.QuestionText, cm.Name as Method, com.Name as Mode
FROM ComputedQuestions cq
JOIN Questions q ON cq.QuestionID = q.QuestionID
JOIN ComputeMethods cm ON cq.ComputeMethodID = cm.ComputeMethodID
JOIN ComputedOutputModes com ON cq.OutputModeID = com.OutputModeID;

COMMIT;
