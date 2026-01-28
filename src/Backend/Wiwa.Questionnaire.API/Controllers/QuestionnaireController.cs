using Microsoft.AspNetCore.Mvc;
using Wiwa.Questionnaire.API.DTOs;
using Wiwa.Questionnaire.API.Services;

namespace Wiwa.Questionnaire.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class QuestionnaireController : ControllerBase
{
    private readonly IQuestionnaireService _service;

    public QuestionnaireController(IQuestionnaireService service)
    {
        _service = service;
    }

    [HttpGet("types")]
    public async Task<ActionResult<List<QuestionTypeDto>>> GetTypes()
    {
        var result = await _service.GetQuestionnaireTypesAsync();
        return Ok(result);
    }

    [HttpGet("schema/{typeCode}")]
    public async Task<ActionResult<QuestionnaireSchemaDto>> GetSchema(string typeCode)
    {
        var result = await _service.GetQuestionnaireSchemaAsync(typeCode);
        if (result == null) return NotFound($"Questionnaire type '{typeCode}' not found.");
        return Ok(result);
    }

    [HttpPost("evaluate-rule")]
    public async Task<ActionResult<string>> EvaluateRule([FromBody] EvaluateRuleRequest request)
    {
        try 
        {
            var result = await _service.EvaluateRuleAsync(request.RuleId, request.Inputs);
            // Return Ok(null) if calculation not possible (e.g. missing inputs), or the value.
            return Ok(new { Value = result });
        }
        catch (Exception ex)
        {
            // In dev, return message.
            return BadRequest(ex.Message);
        }
    }
}
