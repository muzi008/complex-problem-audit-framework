param(
    [string]$Gateway = 'http://127.0.0.1:10100/v1/chat/completions',
    [string]$Model = 'gpt-5.6-sol',
    [string]$JudgeModel = 'gpt-5.6-terra'
)

$ErrorActionPreference = 'Stop'
$EvalRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$RepoRoot = (Resolve-Path (Join-Path $EvalRoot '..\..')).Path
$OutputDir = Join-Path $EvalRoot 'release-gate'
$AnswerDir = Join-Path $OutputDir 'outputs'
New-Item -ItemType Directory -Path $AnswerDir -Force | Out-Null

function Get-PromptBlock {
    param([string]$Markdown)
    $match = [regex]::Match($Markdown, '(?s)~~~text\s*(.*?)\s*~~~')
    if (-not $match.Success) { throw 'Runtime prompt block not found.' }
    return $match.Groups[1].Value.Trim()
}

function Invoke-Chat {
    param([string]$ModelName, [string]$SystemPrompt, [string]$UserPrompt, [int]$Retries = 3)
    $body = @{
        model = $ModelName
        messages = @(
            @{ role = 'system'; content = $SystemPrompt },
            @{ role = 'user'; content = $UserPrompt }
        )
        reasoning_effort = 'high'
        temperature = 0
    } | ConvertTo-Json -Depth 8

    for ($attempt = 1; $attempt -le $Retries; $attempt++) {
        try {
            return Invoke-RestMethod -Uri $Gateway -Method Post -ContentType 'application/json; charset=utf-8' -Body $body -TimeoutSec 180
        } catch {
            if ($attempt -eq $Retries) { throw }
            Start-Sleep -Seconds (2 * $attempt)
        }
    }
}

$baselineMarkdown = (git -C $RepoRoot show 'v1.0.1:prompts/cpaf.zh-CN.md') -join "`n"
if ($LASTEXITCODE -ne 0) { throw 'Unable to read the v1.0.1 runtime prompt.' }
$releaseMarkdown = Get-Content -LiteralPath (Join-Path $RepoRoot 'prompts/cpaf.zh-CN.md') -Raw -Encoding UTF8
$prompts = @{
    baseline = Get-PromptBlock $baselineMarkdown
    release = Get-PromptBlock $releaseMarkdown
}

$source = Get-Content -LiteralPath (Join-Path $EvalRoot 'initial-generations.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$cases = @($source | Group-Object id | ForEach-Object { $_.Group[0] } | Sort-Object id)
$runs = @()
foreach ($case in $cases) {
    $runs += [pscustomobject]@{ case = $case; repeat = 1 }
}
foreach ($repeat in 2..3) {
    foreach ($case in ($cases | Where-Object patch -eq 'observer')) {
        $runs += [pscustomobject]@{ case = $case; repeat = $repeat }
    }
}

$generations = @()
$totalGenerations = $runs.Count * 2
$generationIndex = 0
foreach ($run in $runs) {
    foreach ($condition in @('baseline', 'release')) {
        $generationIndex++
        $case = $run.case
        Write-Output "GEN $generationIndex/$totalGenerations $($case.id) repeat=$($run.repeat) $condition"
        $response = Invoke-Chat -ModelName $Model -SystemPrompt $prompts[$condition] -UserPrompt $case.prompt
        $content = $response.choices[0].message.content
        $name = "$($case.id)_r$($run.repeat)_$condition.md"
        Set-Content -LiteralPath (Join-Path $AnswerDir $name) -Value $content -Encoding UTF8
        $generations += [pscustomobject]@{
            id = $case.id
            patch = $case.patch
            kind = $case.kind
            repeat = $run.repeat
            condition = $condition
            prompt = $case.prompt
            criterion = $case.criterion
            chars = $content.Length
            prompt_tokens = $response.usage.prompt_tokens
            completion_tokens = $response.usage.completion_tokens
            content = $content
        }
    }
}
$generations | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $OutputDir 'generations.json') -Encoding UTF8

$judgments = @()
$judgeIndex = 0
foreach ($run in $runs) {
    $judgeIndex++
    $case = $run.case
    $baseline = ($generations | Where-Object { $_.id -eq $case.id -and $_.repeat -eq $run.repeat -and $_.condition -eq 'baseline' }).content
    $release = ($generations | Where-Object { $_.id -eq $case.id -and $_.repeat -eq $run.repeat -and $_.condition -eq 'release' }).content
    $swap = ($judgeIndex % 2 -eq 0)
    $answerA = if ($swap) { $release } else { $baseline }
    $answerB = if ($swap) { $baseline } else { $release }
    $judgePrompt = @"
题目：
$($case.prompt)

验收标准：
$($case.criterion)

答案 A：
$answerA

答案 B：
$answerB

请盲评哪份答案更符合验收标准。目标题看是否减少指定错误，控制题看是否避免误触发和多余分析。不要按长度、术语数量或文风评分。
只返回一个 JSON 对象，不要代码围栏：
{"winner":"A|B|TIE","hard_failure_A":true,"hard_failure_B":false,"reason":"一句到三句中文理由"}
"@
    Write-Output "JUDGE $judgeIndex/$($runs.Count) $($case.id) repeat=$($run.repeat)"
    $response = Invoke-Chat -ModelName $JudgeModel -SystemPrompt '你是匿名回归测试评审。只按题目与验收标准判断，不猜答案来自哪个框架。' -UserPrompt $judgePrompt
    $raw = $response.choices[0].message.content.Trim()
    $clean = $raw -replace '^```json\s*', '' -replace '\s*```$', ''
    try {
        $parsed = $clean | ConvertFrom-Json
    } catch {
        $parsed = [pscustomobject]@{ winner = 'PARSE_ERROR'; hard_failure_A = $null; hard_failure_B = $null; reason = $raw }
    }
    $winnerCondition = switch ($parsed.winner) {
        'A' { if ($swap) { 'release' } else { 'baseline' } }
        'B' { if ($swap) { 'baseline' } else { 'release' } }
        'TIE' { 'tie' }
        default { 'parse_error' }
    }
    $judgments += [pscustomobject]@{
        id = $case.id
        patch = $case.patch
        kind = $case.kind
        repeat = $run.repeat
        swapped = $swap
        winner_label = $parsed.winner
        winner_condition = $winnerCondition
        hard_failure_A = $parsed.hard_failure_A
        hard_failure_B = $parsed.hard_failure_B
        reason = $parsed.reason
    }
}
$judgments | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $OutputDir 'judgments.json') -Encoding UTF8

$summary = $judgments | Group-Object patch, kind | ForEach-Object {
    $group = $_.Group
    [pscustomobject]@{
        patch = $group[0].patch
        kind = $group[0].kind
        release_wins = @($group | Where-Object winner_condition -eq 'release').Count
        baseline_wins = @($group | Where-Object winner_condition -eq 'baseline').Count
        ties = @($group | Where-Object winner_condition -eq 'tie').Count
        parse_errors = @($group | Where-Object winner_condition -eq 'parse_error').Count
        hard_failures = @($group | Where-Object { $_.hard_failure_A -or $_.hard_failure_B }).Count
    }
}
$summary | Export-Csv -LiteralPath (Join-Path $OutputDir 'summary.csv') -NoTypeInformation -Encoding UTF8
$summary | Sort-Object patch, kind | Format-Table -AutoSize
