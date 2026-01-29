namespace Wiwa.Questionnaire.API.DTOs;

using System.Collections.Generic;

public class QuestionnaireSubmissionDto
{
    public int? InstanceID { get; set; } // Optional: used for updates
    public int QuestionnaireTypeID { get; set; }
    public string IdentificatorValue { get; set; } = string.Empty;
    public int IdentificatorTypeID { get; set; }
    public Dictionary<int, AnswerSubmissionDto> Answers { get; set; } = new();
}

public class AnswerSubmissionDto
{
    public string? Value { get; set; }
    public List<int>? SelectedAnswerIds { get; set; }
}
