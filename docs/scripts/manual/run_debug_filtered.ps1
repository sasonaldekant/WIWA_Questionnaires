
$ErrorActionPreference = "Stop"
try {
    $results = Invoke-Sqlcmd -ServerInstance "localhost" -Database "WIWA_DB_NEW" -InputFile "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\debug_hierarchy_full_filtered.sql"
    
    $results | Format-Table -AutoSize | Out-String -Width 4096 | Set-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\hierarchy_filtered_audit.txt"
    Write-Host "Filtered audit saved."
} catch {
    Write-Error $_
}
