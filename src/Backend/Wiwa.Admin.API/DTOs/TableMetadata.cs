namespace Wiwa.Admin.API.DTOs;

public class TableMetadata
{
    public string TableName { get; set; } = string.Empty;
    public List<string> Columns { get; set; } = new();
}
