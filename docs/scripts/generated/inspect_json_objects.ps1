
try {
    $jsonContent = Get-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\veliki_strict.json" -Raw -Encoding UTF8
    $json = $jsonContent | ConvertFrom-Json

    Write-Host "Questions Array Type: $($json.questions.GetType().Name)"
    Write-Host "Questions Count: $($json.questions.Count)"

    # Inspect first 5 elements
    for ($i = 0; $i -lt [Math]::Min($json.questions.Count, 5); $i++) {
        $q = $json.questions[$i]
        Write-Host "--- Question [$i] ---"
        if ($q -eq $null) {
            Write-Host "  Object is NULL"
        } else {
             $props = $q | Get-Member -MemberType NoteProperty
             foreach ($p in $props) {
                 $val = $q.($p.Name)
                 if ($p.Name -eq "QuestionID") {
                     Write-Host "  QuestionID: $val (Type: $($val.GetType().Name))"
                 }
                 #Write-Host "  $($p.Name): $val"
             }
        }
    }
} catch {
    Write-Error $_.Exception.Message
}
