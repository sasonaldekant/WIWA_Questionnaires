
DECLARE @QID_Alk_Vrsta INT;
DECLARE @QID_Alk_Kol INT;
DECLARE @QID_Cig_Kol INT;
DECLARE @QID_Cig_Traj INT;

-- Standardize Text
UPDATE Questions SET QuestionText = 'Droga/Narkotici' WHERE QuestionID = 99;

-- Insert Questions for Alcohol
INSERT INTO Questions (QuestionText, QuestionFormatID, SpecificQuestionTypeID, IsRequired, ReadOnly, QuestionOrder)
VALUES ('Vrsta pića:', 1, 2, 1, 0, 1);
SET @QID_Alk_Vrsta = SCOPE_IDENTITY();

INSERT INTO Questions (QuestionText, QuestionFormatID, SpecificQuestionTypeID, IsRequired, ReadOnly, QuestionOrder)
VALUES ('Dnevna količina:', 1, 2, 1, 0, 2);
SET @QID_Alk_Kol = SCOPE_IDENTITY();

-- Insert Questions for Cigarettes
INSERT INTO Questions (QuestionText, QuestionFormatID, SpecificQuestionTypeID, IsRequired, ReadOnly, QuestionOrder)
VALUES ('Dnevna količina (kom):', 1, 2, 1, 0, 1);
SET @QID_Cig_Kol = SCOPE_IDENTITY();

INSERT INTO Questions (QuestionText, QuestionFormatID, SpecificQuestionTypeID, IsRequired, ReadOnly, QuestionOrder)
VALUES ('Koliko dugo konzumirate (god):', 1, 2, 1, 0, 2);
SET @QID_Cig_Traj = SCOPE_IDENTITY();

-- Link to Alcohol Answers (128 - Umereno, 129 - Prekomerno)
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID) VALUES (128, @QID_Alk_Vrsta);
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID) VALUES (128, @QID_Alk_Kol);
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID) VALUES (129, @QID_Alk_Vrsta);
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID) VALUES (129, @QID_Alk_Kol);

-- Link to Cigarettes Answer (137 - Da) -- Correct ID for 'Da' is 137 based on previous select
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID) VALUES (137, @QID_Cig_Kol);
INSERT INTO PredefinedAnswerSubQuestions (PredefinedAnswerID, SubQuestionID) VALUES (137, @QID_Cig_Traj);

SELECT * FROM Questions WHERE QuestionID IN (@QID_Alk_Vrsta, @QID_Alk_Kol, @QID_Cig_Kol, @QID_Cig_Traj);
