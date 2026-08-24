$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$errors = [System.Collections.Generic.List[string]]::new()

function Assert-Release {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { $script:errors.Add($Message) }
}

function Read-Utf8 {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

$zhSpec = Read-Utf8 (Join-Path $RepoRoot 'docs/framework.zh-CN.md')
$zhPrompt = Read-Utf8 (Join-Path $RepoRoot 'prompts/cpaf.zh-CN.md')
$enPrompt = Read-Utf8 (Join-Path $RepoRoot 'prompts/cpaf.en.md')
$readmeZh = Read-Utf8 (Join-Path $RepoRoot 'README.zh-CN.md')
$readmeEn = Read-Utf8 (Join-Path $RepoRoot 'README.md')

Assert-Release ($zhSpec.Contains('CPAF v1.1.0')) 'Chinese specification lacks CPAF v1.1.0 mapping.'
Assert-Release ($zhSpec.Contains('v3.1.1 Final')) 'Chinese specification lacks v3.1.1 Final.'
Assert-Release ($zhPrompt.Contains('CPAF v1.1.0 / CORE-3.1.1')) 'Chinese runtime prompt version mismatch.'
Assert-Release ($enPrompt.Contains('CPAF v1.1.0 / CORE-3.1.1')) 'English runtime prompt version mismatch.'
Assert-Release ($zhPrompt.Contains('偏差只作为待检验假设')) 'Chinese runtime prompt lacks the observer-bias boundary.'
Assert-Release (-not $zhPrompt.Contains('第一人称体验本身不证明')) 'Rejected claim-transition patch leaked into the runtime prompt.'
Assert-Release (-not $zhPrompt.Contains('暴露减少')) 'Rejected outcome-mechanism patch leaked into the runtime prompt.'
Assert-Release ($readmeZh.Contains('公开版本：** v1.1.0')) 'Chinese README public version mismatch.'
Assert-Release ($readmeEn.Contains('Public release:** v1.1.0')) 'English README public version mismatch.'

$initialGenerations = Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/initial-generations.json') | ConvertFrom-Json
$initialJudgments = Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/initial-judgments.json') | ConvertFrom-Json
$repeatGenerations = Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/observer-repeat-generations.json') | ConvertFrom-Json
$repeatJudgments = Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/observer-repeat-judgments.json') | ConvertFrom-Json

Assert-Release ($initialGenerations.Count -eq 18) 'Initial generation count must be 18.'
Assert-Release ($initialJudgments.Count -eq 9) 'Initial blind-pair count must be 9.'
Assert-Release ($repeatGenerations.Count -eq 12) 'Observer repeat generation count must be 12.'
Assert-Release ($repeatJudgments.Count -eq 6) 'Observer repeat blind-pair count must be 6.'

$observerTargets = @($initialJudgments | Where-Object { $_.patch -eq 'observer' -and $_.kind -eq 'target' }) + @($repeatJudgments | Where-Object kind -eq 'target')
$observerControls = @($initialJudgments | Where-Object { $_.patch -eq 'observer' -and $_.kind -eq 'control' }) + @($repeatJudgments | Where-Object kind -eq 'control')
Assert-Release (@($observerTargets | Where-Object winner_condition -eq 'patched').Count -eq 3) 'Observer target patched wins must be 3.'
Assert-Release (@($observerTargets | Where-Object winner_condition -eq 'baseline').Count -eq 0) 'Observer target baseline wins must be 0.'
Assert-Release (@($observerTargets | Where-Object winner_condition -eq 'tie').Count -eq 3) 'Observer target ties must be 3.'
Assert-Release (@($observerControls | Where-Object winner_condition -eq 'tie').Count -eq 3) 'Observer control ties must be 3.'
Assert-Release (@($initialJudgments | Where-Object { $_.patch -eq 'claim' -and $_.winner_condition -eq 'tie' }).Count -eq 3) 'Claim-transition comparisons must all tie.'
Assert-Release (@($initialJudgments | Where-Object { $_.patch -eq 'outcome' -and $_.winner_condition -eq 'tie' }).Count -eq 3) 'Outcome-mechanism comparisons must all tie.'

$releaseGenerations = Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/release-gate/generations.json') | ConvertFrom-Json
$releaseJudgments = Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/release-gate/judgments.json') | ConvertFrom-Json
Assert-Release ($releaseGenerations.Count -eq 30) 'Exact-runtime release gate must contain 30 answers.'
Assert-Release ($releaseJudgments.Count -eq 15) 'Exact-runtime release gate must contain 15 blind pairs.'
$releaseObserverTargets = @($releaseJudgments | Where-Object { $_.patch -eq 'observer' -and $_.kind -eq 'target' })
$releaseObserverControls = @($releaseJudgments | Where-Object { $_.patch -eq 'observer' -and $_.kind -eq 'control' })
Assert-Release (@($releaseObserverTargets | Where-Object winner_condition -eq 'release').Count -eq 3) 'Release-gate observer target release wins must be 3.'
Assert-Release (@($releaseObserverTargets | Where-Object winner_condition -eq 'baseline').Count -eq 1) 'Release-gate observer target baseline wins must be 1.'
Assert-Release (@($releaseObserverTargets | Where-Object winner_condition -eq 'tie').Count -eq 2) 'Release-gate observer target ties must be 2.'
Assert-Release (@($releaseObserverControls | Where-Object winner_condition -eq 'tie').Count -eq 3) 'Release-gate observer controls must all tie.'
Assert-Release (@($releaseJudgments | Where-Object { $_.hard_failure_A -or $_.hard_failure_B }).Count -eq 0) 'Release gate must contain no hard failures.'

foreach ($row in $initialGenerations) {
    $path = Join-Path $RepoRoot "evals/v1.1/outputs/$($row.id)_$($row.condition).md"
    Assert-Release ((Read-Utf8 $path).Trim() -eq $row.content.Trim()) "Output mismatch: $path"
}
foreach ($row in $repeatGenerations) {
    $path = Join-Path $RepoRoot "evals/v1.1/observer-repeat-outputs/$($row.id)_r$($row.repeat)_$($row.condition).md"
    Assert-Release ((Read-Utf8 $path).Trim() -eq $row.content.Trim()) "Output mismatch: $path"
}
foreach ($row in $releaseGenerations) {
    $path = Join-Path $RepoRoot "evals/v1.1/release-gate/outputs/$($row.id)_r$($row.repeat)_$($row.condition).md"
    Assert-Release ((Read-Utf8 $path).Trim() -eq $row.content.Trim()) "Output mismatch: $path"
}

$paths = git -C $RepoRoot ls-files --cached --others --exclude-standard
foreach ($relative in $paths) {
    $path = Join-Path $RepoRoot $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { continue }
    $bytes = [System.IO.File]::ReadAllBytes($path)
    Assert-Release (-not ($bytes -contains 0)) "NUL byte found: $relative"
    if ([System.IO.Path]::GetExtension($path) -ne '.md') { continue }
    $text = Read-Utf8 $path
    Assert-Release (([regex]::Matches($text, '(?m)^```').Count % 2) -eq 0) "Unpaired backtick fence: $relative"
    Assert-Release (([regex]::Matches($text, '(?m)^~~~').Count % 2) -eq 0) "Unpaired tilde fence: $relative"
    foreach ($match in [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value.Split('#')[0]
        if (-not $target -or $target -match '^(https?://|mailto:)') { continue }
        $resolved = Join-Path (Split-Path -Parent $path) ([uri]::UnescapeDataString($target))
        Assert-Release (Test-Path -LiteralPath $resolved) "Broken Markdown link in $relative -> $target"
    }
}

$publicJson = (Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/initial-generations.json')) + (Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/observer-repeat-generations.json')) + (Read-Utf8 (Join-Path $RepoRoot 'evals/v1.1/release-gate/generations.json'))
Assert-Release ($publicJson -notmatch '[A-Za-z]:\\') 'Published generation JSON contains a Windows absolute path.'

if ($errors.Count) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'PASS: CPAF v1.1.0 release verification'
Write-Output "files=$($paths.Count) candidate_answers=$($initialGenerations.Count + $repeatGenerations.Count) release_gate_answers=$($releaseGenerations.Count) blind_pairs=$($initialJudgments.Count + $repeatJudgments.Count + $releaseJudgments.Count)"
