using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Data;
using Wiwa.Questionnaire.API.Domain;
using Wiwa.Admin.API.DTOs;
using QuestionnaireEntity = Wiwa.Questionnaire.API.Domain.Questionnaire;
using Wiwa.Admin.API.Services;
using System.Data;

namespace Wiwa.Admin.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FlowController : ControllerBase
{
    private readonly WiwaDbContext _context;
    private readonly ILogger<FlowController> _logger;
    private readonly IFlowLoaderService _flowLoaderService;

    public FlowController(WiwaDbContext context, ILogger<FlowController> logger, IFlowLoaderService flowLoaderService)
    {
        _context = context;
        _logger = logger;
        _flowLoaderService = flowLoaderService;
    }

    [HttpGet("GetUserReferenceTables/{questionnaireTypeId}")]
    public async Task<IActionResult> GetUserReferenceTables(int questionnaireTypeId)
    {
        var tables = await _context.QuestionnaireTypeReferenceTables
            .Where(t => t.QuestionnaireTypeID == questionnaireTypeId)
            .Select(t => new { t.QuestionnaireTypeReferenceTableID, t.TableName })
            .ToListAsync();

        return Ok(tables);
    }

    [HttpPost("Save")]
    public async Task<ActionResult<SaveFlowResponseDto>> SaveFlow([FromBody] SaveFlowDto flowDto)
    {
        var response = new SaveFlowResponseDto();

        try
        {
            // Step 1: Validate
            if (!flowDto.Nodes.Any(n => n.Type == "questionNode"))
            {
                response.Errors.Add("Flow must contain at least one question");
                return BadRequest(response);
            }

            short questionnaireTypeId;
            var existingQIds = new HashSet<int>();
            var existingAIds = new HashSet<int>();

            if (flowDto.ExistingQuestionnaireTypeID.HasValue)
            {
                questionnaireTypeId = (short)flowDto.ExistingQuestionnaireTypeID.Value;
                
                if (flowDto.IsUpdate)
                {
                    var graphIds = await GetExistingGraphIds(questionnaireTypeId);
                    existingQIds = graphIds.QuestionIds;
                    existingAIds = graphIds.AnswerIds;
                }
                
                // Clear existing root mappings
                var existingMappings = await _context.Questionnaires
                    .Where(q => q.QuestionnaireTypeID == questionnaireTypeId)
                    .ToListAsync();

                if (existingMappings.Any())
                {
                    _context.Questionnaires.RemoveRange(existingMappings);
                }

                // Clear existing layout metadata for this type
                var existingLayouts = await _context.FlowLayouts
                    .Where(l => l.QuestionnaireTypeID == questionnaireTypeId)
                    .ToListAsync();
                
                if (existingLayouts.Any())
                {
                    _context.FlowLayouts.RemoveRange(existingLayouts);
                }

                await _context.SaveChangesAsync();
            }
            else
            {
                var newType = new QuestionnaireType
                {
                    Name = flowDto.QuestionnaireTypeName,
                    Code = flowDto.QuestionnaireTypeCode ?? flowDto.QuestionnaireTypeName.ToUpper().Replace(" ", "_")
                };
                _context.QuestionnaireTypes.Add(newType);
                await _context.SaveChangesAsync();
                questionnaireTypeId = newType.QuestionnaireTypeID;
            }

            // Step 3: Create or Get QuestionnaireIdentificatorType
            int identificatorTypeId;
            if (flowDto.ExistingQuestionnaireIdentificatorTypeID.HasValue)
            {
                identificatorTypeId = flowDto.ExistingQuestionnaireIdentificatorTypeID.Value;
            }
            else
            {
                var newIdType = new QuestionnaireIdentificatorType
                {
                    Name = flowDto.QuestionnaireIdentificatorTypeName
                };
                _context.QuestionnaireIdentificatorTypes.Add(newIdType);
                await _context.SaveChangesAsync();
                identificatorTypeId = newIdType.QuestionnaireIdentificatorTypeID;
            }

            var nodeIdToQuestionId = new Dictionary<string, int>();
            var questionNodes = flowDto.Nodes.Where(n => n.Type == "questionNode").ToList();

            foreach (var node in questionNodes)
            {
                // Step 4: Map Question node to Entity
                Question question = null;
                int qIdParsed;
                string idPart = node.Id.StartsWith("q-") ? node.Id.Substring(2) : node.Id;
                
                if (int.TryParse(idPart, out qIdParsed) && existingQIds.Contains(qIdParsed))
                {
                    question = await _context.Questions.FindAsync(qIdParsed);
                }

                if (question == null)
                {
                    question = new Question();
                    _context.Questions.Add(question);
                }

                question.QuestionText = node.Data.QuestionText ?? "Untitled Question";
                question.QuestionLabel = node.Data.QuestionLabel;
                question.QuestionOrder = node.Data.QuestionOrder;
                question.QuestionFormatID = node.Data.QuestionFormatID;
                question.SpecificQuestionTypeID = node.Data.SpecificQuestionTypeID;
                question.ReadOnly = node.Data.ReadOnly;
                question.IsRequired = node.Data.IsRequired;
                question.ValidationPattern = node.Data.ValidationPattern;

                await _context.SaveChangesAsync();
                
                nodeIdToQuestionId[node.Id] = question.QuestionID;

                // Save Layout
                var layout = new FlowLayout
                {
                    QuestionnaireTypeID = questionnaireTypeId,
                    ElementType = "Question",
                    ElementID = $"q-{question.QuestionID}",
                    PositionX = node.Position?.X ?? 0,
                    PositionY = node.Position?.Y ?? 0
                };
                _context.FlowLayouts.Add(layout);

                // Step 5: Check if has computed config
                if (node.Data.IsComputed == true)
                {
                    var computedConfig = new QuestionComputedConfig
                    {
                        QuestionID = question.QuestionID,
                        ComputeMethodID = node.Data.ComputeMethodID ?? 1,
                        RuleName = node.Data.RuleName ?? "Default Rule",
                        RuleDescription = node.Data.RuleDescription,
                        MatrixObjectName = node.Data.MatrixObjectName,
                        OutputMode = node.Data.OutputMode ?? 0,
                        OutputTarget = node.Data.OutputTarget,
                        MatrixOutputColumnName = node.Data.MatrixOutputColumnName,
                        FormulaExpression = node.Data.FormulaExpression,
                        Priority = node.Data.Priority ?? 1,
                        IsActive = node.Data.IsActive ?? true
                    };
                    _context.QuestionComputedConfigs.Add(computedConfig);
                }

                // Step 6: Reference Table/Column - User Defined (Check or Create)
                if (!string.IsNullOrEmpty(node.Data.ReferenceTable))
                {
                    var refTable = await _context.QuestionnaireTypeReferenceTables
                        .FirstOrDefaultAsync(rt => rt.QuestionnaireTypeID == questionnaireTypeId && rt.TableName == node.Data.ReferenceTable);

                    if (refTable == null)
                    {
                        refTable = new QuestionnaireTypeReferenceTable
                        {
                             QuestionnaireTypeID = questionnaireTypeId,
                             TableName = node.Data.ReferenceTable
                        };
                        _context.QuestionnaireTypeReferenceTables.Add(refTable);
                        await _context.SaveChangesAsync(); // Save to get the ID
                    }

                    var refColumn = new QuestionReferenceColumn
                    {
                        QuestionID = question.QuestionID,
                        QuestionnaireTypeReferenceTableID = refTable.QuestionnaireTypeReferenceTableID,
                        ReferenceColumnName = node.Data.ReferenceColumn
                    };
                    _context.QuestionReferenceColumns.Add(refColumn);
                }
                await _context.SaveChangesAsync();
            }

            // Step 7: Process Answers
            var answerNodes = flowDto.Nodes.Where(n => n.Type == "answerNode").ToList();
            var nodeIdToAnswerId = new Dictionary<string, int>();

            foreach (var answerNode in answerNodes)
            {
                var parentEdge = flowDto.Edges.FirstOrDefault(e => e.Target == answerNode.Id);
                if (parentEdge == null || !nodeIdToQuestionId.ContainsKey(parentEdge.Source))
                {
                    response.Errors.Add($"Answer '{answerNode.Data.Label}' must be connected to a question");
                    continue;
                }

                var parentQuestionId = nodeIdToQuestionId[parentEdge.Source];

                PredefinedAnswer answer = null;
                int aIdParsed;
                string aIdPart = answerNode.Id.StartsWith("a-") ? answerNode.Id.Substring(2) : answerNode.Id;

                if (int.TryParse(aIdPart, out aIdParsed) && existingAIds.Contains(aIdParsed))
                {
                     answer = await _context.PredefinedAnswers.FindAsync(aIdParsed);
                }

                if (answer == null)
                {
                    answer = new PredefinedAnswer();
                    _context.PredefinedAnswers.Add(answer);
                }

                answer.QuestionID = parentQuestionId;
                answer.Answer = answerNode.Data.AnswerText ?? "Untitled Answer";
                answer.Code = answerNode.Data.Code;
                answer.PreSelected = answerNode.Data.IsPreSelected;
                answer.StatisticalWeight = answerNode.Data.StatisticalWeight;
                answer.DisplayOrder = answerNode.Data.DisplayOrder ?? 0;

                await _context.SaveChangesAsync();

                nodeIdToAnswerId[answerNode.Id] = answer.PredefinedAnswerID;

                // Save Layout
                var layout = new FlowLayout
                {
                    QuestionnaireTypeID = questionnaireTypeId,
                    ElementType = "Answer",
                    ElementID = $"a-{answer.PredefinedAnswerID}",
                    PositionX = answerNode.Position?.X ?? 0,
                    PositionY = answerNode.Position?.Y ?? 0
                };
                _context.FlowLayouts.Add(layout);
            }

            // Step 7.5: Reset Connections (Clear existing edges for processed nodes)
            var allQIds = nodeIdToQuestionId.Values.ToList();
            if (allQIds.Any())
            {
                 await _context.Questions.Where(q => allQIds.Contains(q.QuestionID))
                     .ExecuteUpdateAsync(s => s.SetProperty(q => q.ParentQuestionID, (int?)null));
            }

            var allAIds = nodeIdToAnswerId.Values.ToList();
            if (allAIds.Any())
            {
                await _context.PredefinedAnswerSubQuestions.Where(x => allAIds.Contains(x.PredefinedAnswerID))
                    .ExecuteDeleteAsync();
            }

            // Step 8: Process Branching (Edges)
            foreach (var edge in flowDto.Edges)
            {
                var sourceIsAnswer = nodeIdToAnswerId.ContainsKey(edge.Source);
                var targetIsQuestion = nodeIdToQuestionId.ContainsKey(edge.Target);
                var sourceIsQuestion = nodeIdToQuestionId.ContainsKey(edge.Source);

                if (sourceIsAnswer && targetIsQuestion)
                {
                    var branching = new PredefinedAnswerSubQuestion
                    {
                        PredefinedAnswerID = nodeIdToAnswerId[edge.Source],
                        SubQuestionID = nodeIdToQuestionId[edge.Target]
                    };
                    _context.PredefinedAnswerSubQuestions.Add(branching);
                }
                else if (sourceIsQuestion && targetIsQuestion)
                {
                    // Question -> Question (Group/Sequence)
                    var parentId = nodeIdToQuestionId[edge.Source];
                    var childId = nodeIdToQuestionId[edge.Target];
                    
                    var childQ = _context.Questions.Local.FirstOrDefault(q => q.QuestionID == childId);
                    if (childQ == null) 
                    {
                        childQ = new Question { QuestionID = childId };
                        _context.Questions.Attach(childQ);
                    }
                    
                    childQ.ParentQuestionID = parentId;
                    // Force modified state because DB is NULL now
                    _context.Entry(childQ).Property(p => p.ParentQuestionID).IsModified = true;
                }
                
                string newSourceId = nodeIdToQuestionId.ContainsKey(edge.Source) 
                    ? $"q-{nodeIdToQuestionId[edge.Source]}" 
                    : nodeIdToAnswerId.ContainsKey(edge.Source) 
                        ? $"a-{nodeIdToAnswerId[edge.Source]}" 
                        : edge.Source;

                string newTargetId = nodeIdToQuestionId.ContainsKey(edge.Target)
                    ? $"q-{nodeIdToQuestionId[edge.Target]}"
                    : nodeIdToAnswerId.ContainsKey(edge.Target)
                        ? $"a-{nodeIdToAnswerId[edge.Target]}"
                        : edge.Target;

                // Determine edge ID format:
                // Q->Q: e-group-{source}-{target}
                // Others: e-{source}-{target}
                bool isQtoQ = nodeIdToQuestionId.ContainsKey(edge.Source) && nodeIdToQuestionId.ContainsKey(edge.Target);
                string newEdgeId = isQtoQ ? $"e-group-{newSourceId}-{newTargetId}" : $"e-{newSourceId}-{newTargetId}";

                // Edge layout
                var edgeLayout = new FlowLayout
                {
                    QuestionnaireTypeID = questionnaireTypeId,
                    ElementType = "Edge",
                    ElementID = newEdgeId,
                    Metadata = System.Text.Json.JsonSerializer.Serialize(new { 
                        edge.SourceHandle, 
                        edge.TargetHandle 
                    })
                };
                _context.FlowLayouts.Add(edgeLayout);
            }

            await _context.SaveChangesAsync();

            // Step 9: Create Questionnaire Roots
            var rootNodes = questionNodes.Where(n => !flowDto.Edges.Any(e => e.Target == n.Id)).ToList();
            foreach (var rootNode in rootNodes)
            {
                var questionnaire = new QuestionnaireEntity
                {
                    QuestionnaireTypeID = questionnaireTypeId,
                    QuestionID = nodeIdToQuestionId[rootNode.Id]
                };
                _context.Questionnaires.Add(questionnaire);
            }
            await _context.SaveChangesAsync();

            // Step 10: Deep Cleanup
            await CleanupOrphanedQuestions();

            response.Success = true;
            response.Message = "Flow saved successfully";
            response.QuestionnaireTypeID = questionnaireTypeId;
            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error saving flow");
            response.Success = false;
            response.Message = "An error occurred while saving the flow";
            response.Errors.Add(ex.Message);
            return StatusCode(500, response);
        }
    }

    [HttpGet("CheckCombination")]
    public async Task<ActionResult<object>> CheckCombination(short questionnaireTypeId, int identificatorTypeId)
    {
        try
        {
            var exists = await _context.QuestionnaireByQuestionnaireIdentificators
                .AnyAsync(q => q.QuestionnaireTypeID == questionnaireTypeId && 
                              q.QuestionnaireIdentificator.QuestionnaireIdentificatorTypeID == identificatorTypeId);

            return Ok(new { exists, canUse = true });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking combination");
            return StatusCode(500, new { error = ex.Message });
        }
    }

    [HttpGet("GetFlow/{questionnaireTypeId}")]
    public async Task<ActionResult<FlowDto>> GetFlow(int questionnaireTypeId)
    {
        try
        {
            var flow = await _flowLoaderService.LoadFlowAsync(questionnaireTypeId);
            if (flow == null) return NotFound($"Questionnaire Type ID {questionnaireTypeId} not found.");
            return Ok(flow);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error loading flow");
            return StatusCode(500, ex.Message);
        }
    }

    [HttpGet("GetQuestionnaireTypes")]
    public async Task<ActionResult<object>> GetQuestionnaireTypes()
    {
        try
        {
            var types = await _context.QuestionnaireTypes
                .Select(t => new { t.QuestionnaireTypeID, t.Name, t.Code, QuestionnaireCount = t.Questionnaires.Count })
                .ToListAsync();
            return Ok(types);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting questionnaire types");
            return StatusCode(500, ex.Message);
        }
    }

    [HttpGet("GetReferenceTables/{questionnaireTypeId}")]
    public async Task<ActionResult<List<string>>> GetReferenceTables(short questionnaireTypeId)
    {
        try
        {
            var tables = await _context.QuestionnaireTypeReferenceTables
                .Where(rt => rt.QuestionnaireTypeID == questionnaireTypeId)
                .Select(rt => rt.TableName)
                .ToListAsync();
            return Ok(tables);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting reference tables");
            return StatusCode(500, ex.Message);
        }
    }

    [HttpGet("GetReferenceTableMetadata/{questionnaireTypeId}")]
    public async Task<ActionResult<object>> GetReferenceTableMetadata(short questionnaireTypeId)
    {
        try
        {
            var tables = await _context.QuestionnaireTypeReferenceTables
                .Where(rt => rt.QuestionnaireTypeID == questionnaireTypeId)
                .Select(rt => new {
                    rt.TableName,
                    PreferredColumnName = _context.QuestionReferenceColumns
                        .Where(qrc => qrc.QuestionnaireTypeReferenceTableID == rt.QuestionnaireTypeReferenceTableID)
                        .Select(qrc => qrc.ReferenceColumnName)
                        .FirstOrDefault()
                })
                .ToListAsync();
            return Ok(tables);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting reference table metadata");
            return StatusCode(500, ex.Message);
        }
    }

    private async Task CleanupOrphanedQuestions()
    {
        try
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();
            using var command = connection.CreateCommand();
            command.CommandText = @"
                WITH Tree AS (
                    SELECT QuestionID FROM Questionnaires
                    UNION ALL
                    SELECT Q.QuestionID FROM Tree T JOIN Questions Q ON Q.ParentQuestionID = T.QuestionID
                    UNION ALL
                    SELECT PASQ.SubQuestionID FROM Tree T JOIN PredefinedAnswers PA ON T.QuestionID = PA.QuestionID JOIN PredefinedAnswerSubQuestions PASQ ON PA.PredefinedAnswerID = PASQ.PredefinedAnswerID
                )
                DELETE FROM Questions WHERE QuestionID NOT IN (SELECT QuestionID FROM Tree);";
            await command.ExecuteNonQueryAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error cleaning up orphaned questions");
        }
    }
    private async Task<(HashSet<int> QuestionIds, HashSet<int> AnswerIds)> GetExistingGraphIds(int questionnaireTypeId)
    {
        var qIds = new HashSet<int>();
        var aIds = new HashSet<int>();
        
        var connection = _context.Database.GetDbConnection();
        if (connection.State != ConnectionState.Open) await connection.OpenAsync();
        
        // 1. Questions
        using (var command = connection.CreateCommand())
        {
            command.CommandText = @"
                WITH Tree AS (
                    SELECT QuestionID FROM Questionnaires WHERE QuestionnaireTypeID = @TypeId
                    UNION ALL
                    SELECT Q.QuestionID FROM Tree T JOIN Questions Q ON Q.ParentQuestionID = T.QuestionID
                    UNION ALL
                    SELECT PASQ.SubQuestionID FROM Tree T JOIN PredefinedAnswers PA ON T.QuestionID = PA.QuestionID JOIN PredefinedAnswerSubQuestions PASQ ON PA.PredefinedAnswerID = PASQ.PredefinedAnswerID
                )
                SELECT QuestionID FROM Tree";
            var p = command.CreateParameter(); p.ParameterName = "@TypeId"; p.Value = questionnaireTypeId; command.Parameters.Add(p);
            
            using (var reader = await command.ExecuteReaderAsync()) {
                while(await reader.ReadAsync()) qIds.Add(reader.GetInt32(0));
            }
        }

        // 2. Answers
        if (qIds.Count > 0)
        {
             using (var command = connection.CreateCommand())
            {
                command.CommandText = @"
                WITH Tree AS (
                    SELECT QuestionID FROM Questionnaires WHERE QuestionnaireTypeID = @TypeId
                    UNION ALL
                    SELECT Q.QuestionID FROM Tree T JOIN Questions Q ON Q.ParentQuestionID = T.QuestionID
                    UNION ALL
                    SELECT PASQ.SubQuestionID FROM Tree T JOIN PredefinedAnswers PA ON T.QuestionID = PA.QuestionID JOIN PredefinedAnswerSubQuestions PASQ ON PA.PredefinedAnswerID = PASQ.PredefinedAnswerID
                )
                SELECT PredefinedAnswerID FROM PredefinedAnswers WHERE QuestionID IN (SELECT QuestionID FROM Tree)";
                var p = command.CreateParameter(); p.ParameterName = "@TypeId"; p.Value = questionnaireTypeId; command.Parameters.Add(p);

                using (var reader = await command.ExecuteReaderAsync()) {
                    while(await reader.ReadAsync()) aIds.Add(reader.GetInt32(0));
                }
            }
        }
        
        return (qIds, aIds);
    }
}
