/*
===============================================================
  FAZA 5: Branching - Veliki Upitnik
  Opis: Definisanje grananja (prikazivanje podpitanja na osnovu odgovora)
  Autor: Antigravity Agent
  Datum: 2026-01-24
===============================================================
*/

BEGIN TRANSACTION;

-- Table [dbo].[PredefinedAnswerSubQuestions]
-- Columns: [PredefinedAnswerSubQuestionID] (Identity), [PredefinedAnswerID], [SubQuestionID], [Order] (optional if exists)

-- ============================================
-- Grananje: Pitanje 110 (Bolesti srca) → Pod-pitanja 111, 112, 113
-- ============================================

-- Ako je odgovor "Da" (1100) na pitanje 110, prikaži pod-opcije
IF NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerID = 1100 AND SubQuestionID = 111)
BEGIN
    INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID)
    VALUES (1100, 111); -- Da → Povišen pritisak
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerID = 1100 AND SubQuestionID = 112)
BEGIN
    INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID)
    VALUES (1100, 112); -- Da → Bolesti srčanih zalistaka
END

IF NOT EXISTS (SELECT 1 FROM PredefinedAnswerSubQuestions WHERE PredefinedAnswerID = 1100 AND SubQuestionID = 113)
BEGIN
    INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID)
    VALUES (1100, 113); -- Da → Koronarna bolest
END

-- Validacija
SELECT 
    pa.Answer AS ParentAnswer,
    q_parent.QuestionText AS ParentQuestion,
    q_sub.QuestionText AS SubQuestion
FROM PredefinedAnswerSubQuestions pasq
JOIN PredefinedAnswers pa ON pasq.PredefinedAnswerID = pa.PredefinedAnswerID
JOIN Questions q_parent ON pa.QuestionID = q_parent.QuestionID
JOIN Questions q_sub ON pasq.SubQuestionID = q_sub.QuestionID
WHERE q_parent.QuestionID = 110;

COMMIT;
