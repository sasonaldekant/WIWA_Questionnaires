namespace Wiwa.Questionnaire.API.Controllers;

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Data;
using Wiwa.Questionnaire.API.Domain;
using Wiwa.Questionnaire.API.DTOs;

[ApiController]
[Route("api/[controller]")]
public class QuestionnaireSubmissionController : ControllerBase
{
    private readonly WiwaDbContext _context;

    public QuestionnaireSubmissionController(WiwaDbContext context)
    {
        _context = context;
    }

    [HttpGet("existing/{questionnaireTypeId}/{idTypeId}/{idValue}")]
    public async Task<ActionResult<QuestionnaireSubmissionDto>> GetExisting(int questionnaireTypeId, int idTypeId, string idValue)
    {
        var identificator = await _context.QuestionnaireIdentificators
            .FirstOrDefaultAsync(qi => qi.QuestionnaireIdentificatorTypeID == idTypeId && qi.Identificator == idValue);

        if (identificator == null) return NotFound();

        // Find the latest questionnaire of this type for this identifier
        var instance = await _context.QuestionnaireByQuestionnaireIdentificators
            .Where(q => q.QuestionnaireIdentificatorID == identificator.QuestionnaireIdentificatorID && q.QuestionnaireTypeID == (short)questionnaireTypeId)
            .OrderByDescending(q => q.StartDateTime)
            .FirstOrDefaultAsync();

        if (instance == null) return NotFound();

        var answers = await _context.QuestionnaireAnswers
            .Where(a => a.QuestionnaireByQuestionnaireIdentificatorID == instance.QuestionnaireByQuestionnaireIdentificatorID)
            .ToListAsync();

        var dto = new QuestionnaireSubmissionDto
        {
            InstanceID = instance.QuestionnaireByQuestionnaireIdentificatorID,
            QuestionnaireTypeID = questionnaireTypeId,
            IdentificatorValue = idValue,
            IdentificatorTypeID = idTypeId,
            Answers = answers.GroupBy(a => a.QuestionID).ToDictionary(
                g => g.Key,
                g => new AnswerSubmissionDto
                {
                    Value = g.FirstOrDefault(a => a.PredefinedAnswerID == null)?.Answer,
                    SelectedAnswerIds = g.Where(a => a.PredefinedAnswerID != null).Select(a => a.PredefinedAnswerID!.Value).ToList()
                }
            )
        };

        return Ok(dto);
    }

    [HttpPost]
    public async Task<IActionResult> Submit([FromBody] QuestionnaireSubmissionDto submission)
    {
        return await SaveSubmission(submission, false);
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] QuestionnaireSubmissionDto submission)
    {
        if (submission.InstanceID == null) return BadRequest("InstanceID is required for update.");
        return await SaveSubmission(submission, true);
    }

    private async Task<IActionResult> SaveSubmission(QuestionnaireSubmissionDto submission, bool isUpdate)
    {
        if (submission == null || submission.Answers == null)
        {
            return BadRequest("Invalid submission data.");
        }

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            QuestionnaireByQuestionnaireIdentificator instance;

            if (isUpdate)
            {
                instance = await _context.QuestionnaireByQuestionnaireIdentificators
                    .FirstOrDefaultAsync(q => q.QuestionnaireByQuestionnaireIdentificatorID == submission.InstanceID);
                
                if (instance == null) return NotFound("Instance not found.");

                // Delete old answers
                var oldAnswers = await _context.QuestionnaireAnswers
                    .Where(a => a.QuestionnaireByQuestionnaireIdentificatorID == instance.QuestionnaireByQuestionnaireIdentificatorID)
                    .ToListAsync();
                _context.QuestionnaireAnswers.RemoveRange(oldAnswers);
                
                instance.LastChange = DateTime.UtcNow;
            }
            else 
            {
                // 1. Find or Create Identificator
                var identificator = await _context.QuestionnaireIdentificators
                    .FirstOrDefaultAsync(qi => 
                        qi.QuestionnaireIdentificatorTypeID == submission.IdentificatorTypeID && 
                        qi.Identificator == submission.IdentificatorValue);

                if (identificator == null)
                {
                    identificator = new QuestionnaireIdentificator
                    {
                        QuestionnaireIdentificatorTypeID = submission.IdentificatorTypeID,
                        Identificator = submission.IdentificatorValue,
                        UserID = 1,
                        PoliticalPerson = false
                    };
                    _context.QuestionnaireIdentificators.Add(identificator);
                    await _context.SaveChangesAsync();
                }

                instance = new QuestionnaireByQuestionnaireIdentificator
                {
                    QuestionnaireIdentificatorID = identificator.QuestionnaireIdentificatorID,
                    QuestionnaireTypeID = (short)submission.QuestionnaireTypeID,
                    StartDateTime = DateTime.UtcNow,
                    FinishDateTime = DateTime.UtcNow,
                    Locked = true,
                    LastChange = DateTime.UtcNow
                };
                _context.QuestionnaireByQuestionnaireIdentificators.Add(instance);
                await _context.SaveChangesAsync();
            }

            // 3. Save Answers
            var answersToAdd = new List<QuestionnaireAnswer>();

            foreach (var item in submission.Answers)
            {
                int questionId = item.Key;
                var answerData = item.Value;

                if (answerData.SelectedAnswerIds != null && answerData.SelectedAnswerIds.Any())
                {
                    foreach (var predefinedId in answerData.SelectedAnswerIds)
                    {
                        answersToAdd.Add(new QuestionnaireAnswer
                        {
                            QuestionnaireByQuestionnaireIdentificatorID = instance.QuestionnaireByQuestionnaireIdentificatorID,
                            QuestionID = questionId,
                            PredefinedAnswerID = predefinedId
                        });
                    }
                }
                
                if (!string.IsNullOrEmpty(answerData.Value))
                {
                     answersToAdd.Add(new QuestionnaireAnswer
                     {
                        QuestionnaireByQuestionnaireIdentificatorID = instance.QuestionnaireByQuestionnaireIdentificatorID,
                        QuestionID = questionId,
                        Answer = answerData.Value
                     });
                }
            }

            if (answersToAdd.Any())
            {
                _context.QuestionnaireAnswers.AddRange(answersToAdd);
                await _context.SaveChangesAsync();
            }

            await transaction.CommitAsync();

            return Ok(new { 
                Message = isUpdate ? "Changes saved successfully." : "Submission saved successfully.", 
                InstanceID = instance.QuestionnaireByQuestionnaireIdentificatorID 
            });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }
}
