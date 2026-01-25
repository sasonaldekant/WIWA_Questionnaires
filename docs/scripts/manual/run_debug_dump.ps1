
$ErrorActionPreference = "Stop"
try {
    $results = Invoke-Sqlcmd -ServerInstance "localhost" -Database "WIWA_DB_NEW" -InputFile "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\debug_hierarchy_dump.sql"
    
    # Format as table and save
    $results | Format-Table -AutoSize | Out-String -Width 4096 | Set-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\hierarchy_audit.txt"
    Write-Host "Audit saved to hierarchy_audit.txt"
} catch {
    Write-Error $_
}
