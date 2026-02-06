
$ErrorActionPreference = "Stop"
try {
    $results = Invoke-Sqlcmd -ServerInstance "localhost" -Database "WIWA_DB_NEW" -InputFile "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\debug_flat_audit_veliki.sql" -MaxCharLength 65535
    
    $results | Format-Table -AutoSize | Out-String -Width 8192 | Set-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\flat_audit_veliki.txt"
    Write-Host "Flat audit saved to flat_audit_veliki.txt"
} catch {
    Write-Error $_
}
