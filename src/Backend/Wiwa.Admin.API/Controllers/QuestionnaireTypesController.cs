using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Data;
using Wiwa.Questionnaire.API.Domain;

namespace Wiwa.Admin.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class QuestionnaireTypesController : ControllerBase
{
    private readonly WiwaDbContext _context;
    private readonly ILogger<QuestionnaireTypesController> _logger;

    public QuestionnaireTypesController(WiwaDbContext context, ILogger<QuestionnaireTypesController> logger)
    {
        _context = context;
        _logger = logger;
    }

    // GET: api/QuestionnaireTypes
    [HttpGet]
    public async Task<ActionResult<IEnumerable<QuestionnaireType>>> GetQuestionnaireTypes()
    {
        return await _context.QuestionnaireTypes.ToListAsync();
    }

    // GET: api/QuestionnaireTypes/5
    [HttpGet("{id}")]
    public async Task<ActionResult<QuestionnaireType>> GetQuestionnaireType(short id)
    {
        var questionnaireType = await _context.QuestionnaireTypes.FindAsync(id);

        if (questionnaireType == null)
        {
            return NotFound();
        }

        return questionnaireType;
    }

    // POST: api/QuestionnaireTypes
    [HttpPost]
    public async Task<ActionResult<QuestionnaireType>> CreateQuestionnaireType(QuestionnaireType questionnaireType)
    {
        _context.QuestionnaireTypes.Add(questionnaireType);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetQuestionnaireType), new { id = questionnaireType.QuestionnaireTypeID }, questionnaireType);
    }

    // PUT: api/QuestionnaireTypes/5
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateQuestionnaireType(short id, QuestionnaireType questionnaireType)
    {
        if (id != questionnaireType.QuestionnaireTypeID)
        {
            return BadRequest();
        }

        _context.Entry(questionnaireType).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!QuestionnaireTypeExists(id))
            {
                return NotFound();
            }
            throw;
        }

        return NoContent();
    }

    // DELETE: api/QuestionnaireTypes/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteQuestionnaireType(short id)
    {
        var questionnaireType = await _context.QuestionnaireTypes.FindAsync(id);
        if (questionnaireType == null)
        {
            return NotFound();
        }

        _context.QuestionnaireTypes.Remove(questionnaireType);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool QuestionnaireTypeExists(short id)
    {
        return _context.QuestionnaireTypes.Any(e => e.QuestionnaireTypeID == id);
    }
}
