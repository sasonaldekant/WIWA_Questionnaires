
try {
    $jsonContent = Get-Content "c:\Users\mgasic\Documents\AIProjects\Wiener\WIWA_Questionnaires\docs\scripts\generated\veliki_strict.json" -Raw -Encoding UTF8
    $json = $jsonContent | ConvertFrom-Json

    Write-Host "Total Root Questions: $($json.questions.Count)"

    # Check Q1 (ID 1000)
    $q1 = $json.questions | Where-Object { $_.QuestionID -eq 1000 }
    if ($q1) {
        Write-Host "Q1 Found: $($q1.QuestionLabel)"
        
        # Check Answer 1.2
        $a12 = $q1.Answers | Where-Object { $_.Code -eq '1.2' }
        if ($a12) {
            Write-Host "  Answer 1.2 Found"
            Write-Host "  Answer 1.2 SubQuestions Count: $($a12.SubQuestions.Count)"
            
            # Check SubQuestion 1200 (Heart Diseases List)
            $q1200 = $a12.SubQuestions | Where-Object { $_.QuestionID -eq 1200 }
            if ($q1200) {
                Write-Host "    SubQuestion 1200 Found (Label: $($q1200.QuestionLabel))"
                
                # Check Answer 1.2.1 (High BP)
                # Note: The JSON property might be 'Answers' or 'SubAnswers' depending on the SQL generator version.
                # In generate_json_veliki.sql line 138, it selects 'SubAnswers' for sub-questions!
                # But root questions have 'Answers'.
                # Let's check which property exists.
                
                $answersProp = $q1200.SubAnswers 
                if ($null -eq $answersProp) { $answersProp = $q1200.Answers }
                
                Write-Host "    Q1200 Answers Count: $($answersProp.Count)"
                
                $a121 = $answersProp | Where-Object { $_.Code -eq '1.2.1' }
                if ($a121) {
                    Write-Host "      Answer 1.2.1 Found"
                    Write-Host "      Answer 1.2.1 SubQuestions Count: $($a121.SubQuestions.Count)"
                    
                    if ($a121.SubQuestions.Count -gt 0) {
                         Write-Host "        SubQuestion ID: $($a121.SubQuestions[0].QuestionID)"
                         Write-Host "        SubQuestion Label: $($a121.SubQuestions[0].QuestionLabel)"
                    } else {
                        Write-Host "        !! NO SUBQUESTIONS FOR 1.2.1 !!"
                    }
                } else {
                    Write-Host "      !! Answer 1.2.1 NOT Found !!"
                }
            } else {
                Write-Host "    !! SubQuestion 1200 NOT Found !!"
            }
        } else {
            Write-Host "  !! Answer 1.2 NOT Found !!"
        }
    } else {
        Write-Host "!! Q1 NOT Found !!"
    }
} catch {
    Write-Error $_.Exception.Message
}
