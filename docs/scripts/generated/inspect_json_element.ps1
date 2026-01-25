
try {
    $jsonContent = Get-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\veliki_strict.json" -Raw -Encoding UTF8
    $json = $jsonContent | ConvertFrom-Json

    $q0 = $json.questions[0]
    Write-Host "Element [0] Type: $($q0.GetType().FullName)"
    Write-Host "Element [0] Content:"
    Write-Host ($q0 | Out-String)
    
} catch {
    Write-Error $_.Exception.Message
}
