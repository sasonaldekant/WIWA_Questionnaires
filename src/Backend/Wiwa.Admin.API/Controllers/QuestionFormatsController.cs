using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Data;
using Wiwa.Questionnaire.API.Domain;

namespace Wiwa.Admin.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class QuestionFormatsController : ControllerBase
{
    private readonly WiwaDbContext _context;

    public QuestionFormatsController(WiwaDbContext context)
    {
        _context = context;
    }

    // GET: api/QuestionFormats
    [HttpGet]
    public async Task<ActionResult<IEnumerable<QuestionFormat>>> GetAll()
    {
        return await _context.QuestionFormats.ToListAsync();
    }
}
