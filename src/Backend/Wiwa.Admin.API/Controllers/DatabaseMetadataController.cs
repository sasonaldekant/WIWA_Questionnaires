using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Data;
using System.Data;
using Wiwa.Admin.API.DTOs;

namespace Wiwa.Admin.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DatabaseMetadataController : ControllerBase
{
    private readonly WiwaDbContext _context;

    // List of system tables to exclude from the UI dropdowns
    private readonly List<string> _systemTables = new List<string>
    {
        "__EFMigrationsHistory",
        "QuestionnaireTypes",
        "QuestionnaireItems",
        "Questions", // Just in case
        "Answers",
        "QuestionComputedConfigs",
        "SpecificQuestionTypes",
        "QuestionFormats",
        "QuestionnaireIdentificatorTypes",
        "Indicators",
        "FlowLayouts",
        "ComputeMethods",
        "PredefinedAnswers",
        "PredefinedAnswersSubQuestions",
        "ProductQuestionaryTypes",
        "QuestionnaireTypeReferenceTables"
    };

    public DatabaseMetadataController(WiwaDbContext context)
    {
        _context = context;
    }

    private string GetSystemTableExclusionClause()
    {
        var formattedTables = string.Join(",", _systemTables.Select(t => $"'{t}'"));
        return $"AND TABLE_NAME NOT IN ({formattedTables})";
    }

    /// <summary>
    /// Returns all table names and their columns from the database
    /// </summary>
    [HttpGet("tables")]
    public async Task<IActionResult> GetTablesAndColumns()
    {
        try
        {
            var connection = _context.Database.GetDbConnection();
            await connection.OpenAsync();

            var tables = new List<TableMetadata>();

            // Query to get all user tables
            var tableQuery = $@"
                SELECT 
                    TABLE_NAME
                FROM 
                    INFORMATION_SCHEMA.TABLES
                WHERE 
                    TABLE_TYPE = 'BASE TABLE'
                    AND TABLE_SCHEMA = 'dbo'
                    {GetSystemTableExclusionClause()}
                ORDER BY 
                    TABLE_NAME";

            using (var command = connection.CreateCommand())
            {
                command.CommandText = tableQuery;
                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        var tableName = reader.GetString(0);
                        tables.Add(new TableMetadata 
                        { 
                            TableName = tableName,
                            Columns = new List<string>()
                        });
                    }
                }
            }

            // For each table, get columns
            foreach (var table in tables)
            {
                var columnQuery = @"
                    SELECT 
                        COLUMN_NAME
                    FROM 
                        INFORMATION_SCHEMA.COLUMNS
                    WHERE 
                        TABLE_NAME = @TableName
                        AND TABLE_SCHEMA = 'dbo'
                    ORDER BY 
                        ORDINAL_POSITION";

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = columnQuery;
                    var param = command.CreateParameter();
                    param.ParameterName = "@TableName";
                    param.Value = table.TableName;
                    command.Parameters.Add(param);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            table.Columns.Add(reader.GetString(0));
                        }
                    }
                }
            }

            await connection.CloseAsync();

            return Ok(tables);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message });
        }
    }

    /// <summary>
    /// Returns just table names
    /// </summary>
    [HttpGet("tables/names")]
    public async Task<IActionResult> GetTableNames()
    {
        try
        {
            var connection = _context.Database.GetDbConnection();
            await connection.OpenAsync();

            var tableNames = new List<string>();

            var query = $@"
                SELECT 
                    TABLE_NAME
                FROM 
                    INFORMATION_SCHEMA.TABLES
                WHERE 
                    TABLE_TYPE = 'BASE TABLE'
                    AND TABLE_SCHEMA = 'dbo'
                    {GetSystemTableExclusionClause()}
                ORDER BY 
                    TABLE_NAME";

            using (var command = connection.CreateCommand())
            {
                command.CommandText = query;
                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        tableNames.Add(reader.GetString(0));
                    }
                }
            }

            await connection.CloseAsync();

            return Ok(tableNames);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message });
        }
    }

    /// <summary>
    /// Returns columns for a specific table
    /// </summary>
    [HttpGet("tables/{tableName}/columns")]
    public async Task<IActionResult> GetTableColumns(string tableName)
    {
        try
        {
            var connection = _context.Database.GetDbConnection();
            await connection.OpenAsync();

            var columns = new List<string>();

            var query = @"
                SELECT 
                    COLUMN_NAME
                FROM 
                    INFORMATION_SCHEMA.COLUMNS
                WHERE 
                    TABLE_NAME = @TableName
                    AND TABLE_SCHEMA = 'dbo'
                ORDER BY 
                    ORDINAL_POSITION";

            using (var command = connection.CreateCommand())
            {
                command.CommandText = query;
                var param = command.CreateParameter();
                param.ParameterName = "@TableName";
                param.Value = tableName;
                command.Parameters.Add(param);

                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        columns.Add(reader.GetString(0));
                    }
                }
            }

            await connection.CloseAsync();

            return Ok(columns);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message });
        }
    }
}

