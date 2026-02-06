
$ErrorActionPreference = "Stop"
try {
    $result = Invoke-Sqlcmd -ServerInstance "localhost" -Database "WIWA_DB_NEW" -InputFile "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\generate_json_veliki.sql" -MaxCharLength 2147483647
    
    # The result is a DataRow or similar. We expect one column named 'Json'.
    # If multiple result sets, it might be an array. The script puts JSON at the end.
    
    # We need the LAST result set which has the JSON.
    # Invoke-Sqlcmd with script that has multiple batches/results might return an array of objects.
    
    # But generate_json_veliki.sql creates temp tables. Invoke-Sqlcmd might return nothing for those.
    # The final SELECT is the JSON.
    
    if ($result -is [array]) {
        $json = $result[-1].Json
    } else {
        $json = $result.Json
    }
    
    if ([string]::IsNullOrWhiteSpace($json)) {
        Write-Error "JSON output is empty."
    }
    
    $json | Set-Content -Path "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\veliki_strict.json" -Encoding UTF8
    Write-Host "JSON generated successfully."
} catch {
    Write-Error $_
}
