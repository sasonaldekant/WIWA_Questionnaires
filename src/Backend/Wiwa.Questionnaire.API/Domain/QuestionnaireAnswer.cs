namespace Wiwa.Questionnaire.API.Domain;

using System;
using System.Collections.Generic;

public class QuestionnaireIdentificator
{
    public long QuestionnaireIdentificatorID { get; set; }
    public int QuestionnaireIdentificatorTypeID { get; set; }
    public string Identificator { get; set; } = string.Empty;
    public int UserID { get; set; }
    public bool PoliticalPerson { get; set; }

    // Navigation
    public ICollection<QuestionnaireByQuestionnaireIdentificator> Questionnaires { get; set; } = new List<QuestionnaireByQuestionnaireIdentificator>();
}

public class QuestionnaireByQuestionnaireIdentificator
{
    public int QuestionnaireByQuestionnaireIdentificatorID { get; set; }
    public long QuestionnaireIdentificatorID { get; set; }
    public short QuestionnaireTypeID { get; set; }
    public DateTime StartDateTime { get; set; }
    public DateTime? FinishDateTime { get; set; }
    public bool? Locked { get; set; }
    public DateTime? LastChange { get; set; }

    // Navigation
    public QuestionnaireIdentificator QuestionnaireIdentificator { get; set; } = null!;
    public QuestionnaireType QuestionnaireType { get; set; } = null!;
    public ICollection<QuestionnaireAnswer> Answers { get; set; } = new List<QuestionnaireAnswer>();
}

public class QuestionnaireAnswer
{
    public int QuestionnaireAnswerID { get; set; }
    public int QuestionID { get; set; }
    public string? Answer { get; set; }
    public int? AnswerPoints { get; set; }
    public int QuestionnaireByQuestionnaireIdentificatorID { get; set; }
    public int? PredefinedAnswerID { get; set; }

    // Navigation
    public Question Question { get; set; } = null!;
    public QuestionnaireByQuestionnaireIdentificator QuestionnaireByQuestionnaireIdentificator { get; set; } = null!;
    public PredefinedAnswer? PredefinedAnswer { get; set; }
}
