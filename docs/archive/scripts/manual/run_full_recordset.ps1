
$ErrorActionPreference = "Stop"
try {
    $results = Invoke-Sqlcmd -ServerInstance "localhost" -Database "WIWA_DB_NEW" -InputFile "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\debug_full_recordset_veliki.sql" -MaxCharLength 65535
    
    $results | Format-Table -AutoSize | Out-String -Width 8192 | Set-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\veliki_full_recordset.txt"
    Write-Host "Full recordset saved to veliki_full_recordset.txt"
} catch {
    Write-Error $_
}
