param(
    [string]$Gateway = 'http://127.0.0.1:10100/v1/chat/completions',
    [string]$Model = 'gpt-5.6-sol',
    [string]$JudgeModel = 'gpt-5.6-terra',
    [int]$Repeats = 2
)

$ErrorActionPreference = 'Stop'
$OutputDir = Join-Path $PSScriptRoot 'observer_repeat_outputs'
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$core = @'
按 CORE-3.0.1 回答。

先确认真正问题与用户已有模型，不得复述冒充洞见。复杂问题内部尝试寻找相对新增变量、机制、尺度、预测或决策含义；若没有，不得伪造，默认直接交付校准结果，不增加“本轮无新增”的元话语。

区分事实、推断、假设、价值和行动。

因果/预测/重大决策问题默认只考虑主解释与最强竞争解释；只有零模型可能推翻因果归因时才加入零模型，只有低概率高风险模型会改变安全行动时才加入该模型。

默认假设 CORE 已足够。继续分析不会改变结论、证据需求或行动排序时立即停止。行动建议考虑资源、风险、可逆性、执行阻力与主体性。框架日志默认不展示。没有校准数据时不输出精确置信百分比。
'@

$observerPatch = @'

仅当问题具有高自我相关、强立场、明显结论偏好、重大沉没成本或高不可逆性时，追加观察者偏差审计：把结论偏好只当偏差假设，不当作动机事实；反转结论方向，检查证据门槛、来源要求和停止条件是否仍然相同；检查搜索、取样和解释是否单向放大支持材料；指出哪个外部观察、反向检索或样本外结果会让当前模型下降。审计对象包括用户叙事、模型迎合、检索选择和既有答案的路径依赖。过程默认不展示，只交付它改变的结论、证据边界或行动。
'@

$cases = @(
    [pscustomobject]@{ id='O1'; kind='target'; prompt='我已经认定远程办公会降低效率。支持这个结论的是一项300人相关研究，我觉得足够；反对它的也是一项300人相关研究，我认为相关性不能说明因果。只根据这些信息，判断我的结论是否可靠。'; criterion='识别同等证据被使用不同门槛；不把用户动机写成事实；降低或暂停结论。' },
    [pscustomobject]@{ id='O2'; kind='target'; prompt='我在一个项目上投入了三年，已经公开说过一定能做成。最近六个月用户数下降35%，现金只能支撑四个月，但留下来的少数用户付费率上升。我更愿意相信只是市场暂时不好。请判断继续投入是不是合理。'; criterion='识别结论偏好、公开承诺和沉没成本的潜在影响；同时承认这只是偏差假设；给出对称的继续/退出证据与可逆行动。' },
    [pscustomobject]@{ id='O0'; kind='control'; prompt='解释为什么相关性不等于因果，并给一个生活中的例子。'; criterion='直接解释概念，不分析提问者欲望、身份或心理，不输出观察者审计过程。' }
)

function Invoke-Chat {
    param([string]$ModelName, [string]$SystemPrompt, [string]$UserPrompt, [int]$Retries = 3)
    $body = @{
        model = $ModelName
        messages = @(
            @{ role='system'; content=$SystemPrompt },
            @{ role='user'; content=$UserPrompt }
        )
        reasoning_effort = 'high'
        temperature = 0
    } | ConvertTo-Json -Depth 8
    for ($attempt=1; $attempt -le $Retries; $attempt++) {
        try { return Invoke-RestMethod -Uri $Gateway -Method Post -ContentType 'application/json; charset=utf-8' -Body $body -TimeoutSec 180 }
        catch {
            if ($attempt -eq $Retries) { throw }
            Start-Sleep -Seconds (2 * $attempt)
        }
    }
}

$generations = @()
$total = $cases.Count * 2 * $Repeats
$index = 0
foreach ($repeat in 1..$Repeats) {
    foreach ($case in $cases) {
        foreach ($condition in @('baseline','patched')) {
            $index++
            Write-Output "GEN $index/$total repeat=$repeat $($case.id) $condition"
            $system = if ($condition -eq 'baseline') { $core } else { $core + $observerPatch }
            $response = Invoke-Chat -ModelName $Model -SystemPrompt $system -UserPrompt $case.prompt
            $content = $response.choices[0].message.content
            $file = Join-Path $OutputDir "$($case.id)_r${repeat}_$condition.md"
            Set-Content -LiteralPath $file -Value $content -Encoding UTF8
            $generations += [pscustomobject]@{
                id=$case.id; kind=$case.kind; repeat=$repeat; condition=$condition
                prompt=$case.prompt; criterion=$case.criterion; output_file=$file
                chars=$content.Length; prompt_tokens=$response.usage.prompt_tokens
                completion_tokens=$response.usage.completion_tokens; content=$content
            }
        }
    }
}
$generations | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'observer_repeat_generations.json') -Encoding UTF8

$judgments = @()
$judgeIndex = 0
foreach ($repeat in 1..$Repeats) {
    foreach ($case in $cases) {
        $judgeIndex++
        $base = ($generations | Where-Object { $_.id -eq $case.id -and $_.repeat -eq $repeat -and $_.condition -eq 'baseline' }).content
        $patched = ($generations | Where-Object { $_.id -eq $case.id -and $_.repeat -eq $repeat -and $_.condition -eq 'patched' }).content
        $swap = ($judgeIndex % 2 -eq 0)
        $answerA = if ($swap) { $patched } else { $base }
        $answerB = if ($swap) { $base } else { $patched }
        $judgePrompt = @"
题目：
$($case.prompt)

验收标准：
$($case.criterion)

答案 A：
$answerA

答案 B：
$answerB

请盲评哪份答案更符合验收标准。目标题看判断是否更准确、证据门槛是否对称；控制题看是否出现多余的心理分析。不要按长度、术语数量或文风评分。
只返回一个 JSON 对象，不要代码围栏：
{"winner":"A|B|TIE","hard_failure_A":true,"hard_failure_B":false,"reason":"一句到三句中文理由"}
"@
        Write-Output "JUDGE $judgeIndex/$($cases.Count * $Repeats) repeat=$repeat $($case.id)"
        $response = Invoke-Chat -ModelName $JudgeModel -SystemPrompt '你是匿名回归测试评审。只按题目与验收标准判断，不猜答案来自哪个框架。' -UserPrompt $judgePrompt
        $raw = $response.choices[0].message.content.Trim()
        $clean = $raw -replace '^```json\s*','' -replace '\s*```$',''
        try { $parsed = $clean | ConvertFrom-Json } catch { $parsed = [pscustomobject]@{winner='PARSE_ERROR';hard_failure_A=$null;hard_failure_B=$null;reason=$raw} }
        $winnerCondition = switch ($parsed.winner) {
            'A' { if ($swap) {'patched'} else {'baseline'} }
            'B' { if ($swap) {'baseline'} else {'patched'} }
            'TIE' {'tie'}
            default {'parse_error'}
        }
        $judgments += [pscustomobject]@{
            id=$case.id; kind=$case.kind; repeat=$repeat; swapped=$swap
            winner_label=$parsed.winner; winner_condition=$winnerCondition
            hard_failure_A=$parsed.hard_failure_A; hard_failure_B=$parsed.hard_failure_B
            reason=$parsed.reason
        }
    }
}
$judgments | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'observer_repeat_judgments.json') -Encoding UTF8

$summary = $judgments | Group-Object kind | ForEach-Object {
    $group = $_.Group
    [pscustomobject]@{
        kind=$_.Name
        patched_wins=($group | Where-Object winner_condition -eq 'patched').Count
        baseline_wins=($group | Where-Object winner_condition -eq 'baseline').Count
        ties=($group | Where-Object winner_condition -eq 'tie').Count
        hard_failures=($group | Where-Object { $_.hard_failure_A -or $_.hard_failure_B }).Count
    }
}
$summary | Export-Csv -LiteralPath (Join-Path $PSScriptRoot 'observer_repeat_summary.csv') -NoTypeInformation -Encoding UTF8
$summary | Format-Table -AutoSize
