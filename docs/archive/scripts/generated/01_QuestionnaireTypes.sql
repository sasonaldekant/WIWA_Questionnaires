/*
===============================================================
  FAZA 1: QuestionnaireTypes
  Opis: Definisanje 5 osnovnih tipova upitnika
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

SET IDENTITY_INSERT QuestionnaireTypes ON;

-- 1. Veliki upitnik
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE Code = 'GREAT_QUEST')
BEGIN
    INSERT INTO QuestionnaireTypes 
    (QuestionnaireTypeID, Name, Description, Code, HasQuestions, RequiresSignature, IsPrintedWithApplication, IsInfoOnly)
    VALUES
    (1, N'Veliki upitnik', 
        N'Detaljan zdravstveni upitnik za veće osigurane sume i posebne rizike', 
        N'GREAT_QUEST', 
        1, -- HasQuestions
        1, -- RequiresSignature
        1, -- IsPrintedWithApplication
        0); -- IsInfoOnly
END

-- 2. Skraćeni upitnik
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE Code = 'SHORT_QUEST')
BEGIN
    INSERT INTO QuestionnaireTypes 
    (QuestionnaireTypeID, Name, Description, Code, HasQuestions, RequiresSignature, IsPrintedWithApplication, IsInfoOnly)
    VALUES
    (2, N'Skraćeni upitnik', 
        N'Skraćeni zdravstveni upitnik za srednje osigurane sume', 
        N'SHORT_QUEST', 
        1, 1, 1, 0);
END

-- 3. Izjava
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE Code = 'DECLARATION')
BEGIN
    INSERT INTO QuestionnaireTypes 
    (QuestionnaireTypeID, Name, Description, Code, HasQuestions, RequiresSignature, IsPrintedWithApplication, IsInfoOnly)
    VALUES
    (3, N'Izjava', 
        N'Izjava o zdravstvenom stanju - bez detaljnih pitanja', 
        N'DECLARATION', 
        0, -- Nema pitanja (tekstualni prikaz)
        1, -- Potpis obavezan
        1, -- Štampa se sa ponudom
        1); -- Samo informativno
END

-- 4. Upitnik za funkcionera
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE Code = 'FUNCTIONARY_QUEST')
BEGIN
    INSERT INTO QuestionnaireTypes 
    (QuestionnaireTypeID, Name, Description, Code, HasQuestions, RequiresSignature, IsPrintedWithApplication, IsInfoOnly)
    VALUES
    (4, N'Upitnik za funkcionera', 
        N'AML upitnik za identifikaciju politički eksponiranih osoba (PEP)', 
        N'FUNCTIONARY_QUEST', 
        1, 1, 0, -- Ne štampa se automatski sa ponudom (zaseban dokument)
        0);
END

-- 5. Obrazac za procenu rizika
IF NOT EXISTS (SELECT 1 FROM QuestionnaireTypes WHERE Code = 'RISK_ASSESSMENT')
BEGIN
    INSERT INTO QuestionnaireTypes 
    (QuestionnaireTypeID, Name, Description, Code, HasQuestions, RequiresSignature, IsPrintedWithApplication, IsInfoOnly)
    VALUES
    (5, N'Obrazac za procenu rizika', 
        N'AML obrazac za procenu nivoa rizika klijenta (Bodovanje)', 
        N'RISK_ASSESSMENT', 
        1, 0, -- Ne zahteva potpis klijenta (interni dokument)
        0, 
        0);
END

SET IDENTITY_INSERT QuestionnaireTypes OFF;

-- Validacija
SELECT * FROM QuestionnaireTypes WHERE Code LIKE '%QUEST%' OR Code LIKE '%DECLARATION%' OR Code LIKE '%RISK%';

COMMIT;
