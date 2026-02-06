using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Data;
using Wiwa.Questionnaire.API.Domain;

namespace Wiwa.Admin.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SpecificQuestionTypesController : ControllerBase
{
    private readonly WiwaDbContext _context;

    public SpecificQuestionTypesController(WiwaDbContext context)
    {
        _context = context;
    }

    // GET: api/SpecificQuestionTypes
    [HttpGet]
    public async Task<ActionResult<IEnumerable<SpecificQuestionType>>> GetAll()
    {
        return await _context.SpecificQuestionTypes.ToListAsync();
    }
}
