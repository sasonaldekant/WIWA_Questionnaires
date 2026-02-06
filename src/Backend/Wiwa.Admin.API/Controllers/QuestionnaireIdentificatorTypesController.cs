using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Data;
using Wiwa.Questionnaire.API.Domain;

namespace Wiwa.Admin.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class QuestionnaireIdentificatorTypesController : ControllerBase
{
    private readonly WiwaDbContext _context;

    public QuestionnaireIdentificatorTypesController(WiwaDbContext context)
    {
        _context = context;
    }

    // GET: api/QuestionnaireIdentificatorTypes
    [HttpGet]
    public async Task<ActionResult<IEnumerable<QuestionnaireIdentificatorType>>> GetAll()
    {
        return await _context.QuestionnaireIdentificatorTypes.ToListAsync();
    }

    // POST: api/QuestionnaireIdentificatorTypes
    [HttpPost]
    public async Task<ActionResult<QuestionnaireIdentificatorType>> Create(QuestionnaireIdentificatorType type)
    {
        _context.QuestionnaireIdentificatorTypes.Add(type);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetAll), new { id = type.QuestionnaireIdentificatorTypeID }, type);
    }
}
