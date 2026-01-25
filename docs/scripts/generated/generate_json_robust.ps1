
$ErrorActionPreference = "Stop"
try {
    # Increase timeout and max length
    $conn = New-Object System.Data.SqlClient.SqlConnection("Server=localhost;Database=WIWA_DB_NEW;Integrated Security=True")
    $conn.Open()
    
    # Read script
    $script = Get-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\generate_json_veliki.sql" -Raw
    
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $script
    $cmd.CommandTimeout = 120
    
    $reader = $cmd.ExecuteReader()
    
    $sb = New-Object System.Text.StringBuilder
    
    do {
        while ($reader.Read()) {
            # Try to find a column named 'Json' or just take the first column if it looks like nvarchar
            # In the script, the final select is SELECT [Json] = (...)
            # So column name is 'Json'.
            try {
                $val = $reader["Json"]
                if ($val -ne [DBNull]::Value) {
                    [void]$sb.Append($val)
                }
            } catch {
                # Ignore result sets that don't have 'Json' column (e.g. intermediate steps?)
                # Actually generate_json_veliki.sql uses temp tables, so there might be intermediate empty results?
                # No, SET NOCOUNT ON is used. But just in case.
                # If we are in the FINAL result set, field count should be 1 and name 'Json'.
            }
        }
    } while ($reader.NextResult())
    
    $conn.Close()
    
    $finalJson = $sb.ToString()
    
    if ([string]::IsNullOrWhiteSpace($finalJson)) {
        Write-Error "Generated JSON is empty."
    } else {
        $finalJson | Set-Content -Path "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\veliki_strict.json" -Encoding UTF8
        Write-Host "JSON generated successfully. Length: $($finalJson.Length)"
    }
    
} catch {
    Write-Error $_
}
