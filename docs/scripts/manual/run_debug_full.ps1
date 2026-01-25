
$ErrorActionPreference = "Stop"
try {
    $results = Invoke-Sqlcmd -ServerInstance "localhost" -Database "WIWA_DB_NEW" -InputFile "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\debug_hierarchy_full.sql"
    
    # The script returns two result sets. 
    # If using Invoke-Sqlcmd, it might return them as a flat array or mixed.
    # We can pipe all to Format-Table.
    
    $results | Format-Table -AutoSize | Out-String -Width 4096 | Set-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\manual\hierarchy_full_audit.txt"
    Write-Host "Full audit saved."
} catch {
    Write-Error $_
}
