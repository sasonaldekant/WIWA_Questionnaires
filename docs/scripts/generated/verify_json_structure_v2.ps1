
try {
    $jsonContent = Get-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\veliki_strict.json" -Raw -Encoding UTF8
    $json = $jsonContent | ConvertFrom-Json

    Write-Host "Root Questions IDs found:"
    $json.questions | ForEach-Object { Write-Host " - ID: $($_.QuestionID) (Type: $($_.QuestionID.GetType().Name)) Label: $($_.QuestionLabel)" }

    $q1 = $json.questions | Where-Object { $_.QuestionID -eq 1000 }
    
    if (-not $q1) {
        # Try finding by Label if ID lookup fails
        Write-Host "Lookup by ID 1000 failed. Trying Label 'Q1'..."
        $q1 = $json.questions | Where-Object { $_.QuestionLabel -eq 'Q1' }
    }

    if ($q1) {
        Write-Host "Q1 Found: $($q1.QuestionID)"
        # Rest of the check...
        $answers = $q1.Answers
        if (-not $answers) { Write-Host "No 'Answers' property on Q1" }
        else {
             $a12 = $answers | Where-Object { $_.Code -eq '1.2' }
             if ($a12) {
                 Write-Host "Answer 1.2 Found"
                 Write-Host "SubQuestions Count: $($a12.SubQuestions.Count)"
                 if ($a12.SubQuestions.Count -gt 0) {
                     $sq = $a12.SubQuestions[0]
                     Write-Host "SubQ ID: $($sq.QuestionID)"
                     
                     # Check deep nesting
                     $subAnswers = $sq.SubAnswers
                     if (-not $subAnswers) { $subAnswers = $sq.Answers }
                     
                     if ($subAnswers) {
                         Write-Host "SubAnswer Count: $($subAnswers.Count)"
                         $deepAnsw = $subAnswers | Where-Object { $_.Code -eq '1.2.1' }
                         if ($deepAnsw) {
                             Write-Host "Deep Answer 1.2.1 Found. SubQs: $($deepAnsw.SubQuestions.Count)"
                         } else {
                             Write-Host "Deep Answer 1.2.1 NOT found"
                         }
                     } else {
                         Write-Host "No SubAnswers/Answers on SubQuestion"
                     }
                 }
             } else {
                 Write-Host "Answer 1.2 NOT found"
             }
        }
    }
} catch {
    Write-Error $_.Exception.Message
}
