param(
    [string]$Gateway = 'http://127.0.0.1:10100/v1/chat/completions',
    [string]$Model = 'gpt-5.6-sol',
    [string]$JudgeModel = 'gpt-5.6-terra'
)

$ErrorActionPreference = 'Stop'
$OutputDir = Join-Path $PSScriptRoot 'outputs'
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$core = @'
按 CORE-3.0.1 回答。

先确认真正问题与用户已有模型，不得复述冒充洞见。复杂问题内部尝试寻找相对新增变量、机制、尺度、预测或决策含义；若没有，不得伪造，默认直接交付校准结果，不增加“本轮无新增”的元话语。

区分事实、推断、假设、价值和行动。

因果/预测/重大决策问题默认只考虑主解释与最强竞争解释；只有零模型可能推翻因果归因时才加入零模型，只有低概率高风险模型会改变安全行动时才加入该模型。

默认假设 CORE 已足够。继续分析不会改变结论、证据需求或行动排序时立即停止。行动建议考虑资源、风险、可逆性、执行阻力与主体性。框架日志默认不展示。没有校准数据时不输出精确置信百分比。
'@

$patches = @{
    observer = @'

仅当问题具有高自我相关、强立场、明显结论偏好、重大沉没成本或高不可逆性时，追加观察者偏差审计：
- 用户或模型更希望哪个结论成立、最不希望哪个结论成立？这只生成偏差假设，不当作动机事实。
- 若结论方向完全相反，证据门槛、来源要求和停止条件是否仍然相同？
- 当前搜索、取样和解释是否只扩大支持材料、缩小反向材料？
- 哪个外部观察、反向检索或样本外结果会让当前模型下降？
审计对象包括用户叙事、模型迎合、检索选择和既有答案的路径依赖。审计过程默认不展示，只交付其改变的结论、证据边界或行动。
'@
    claim = @'

若表达从比喻或第一人称体验跨到经验事实、因果解释、普遍规律、规范判断或行动建议，必须重新匹配证据强度、适用范围、价值前提与行动代价。第一人称报告可以证明“当事人这样体验或陈述”，不能单独证明体验背后的因果解释正确。该检查只在发生跨层时触发，不输出分类清单。
'@
    outcome = @'

当结论依赖“结果指标改善”时，检查变化来自目标能力或真实状态改善，还是暴露减少、任务退出、风险回避、分母/样本/测量变化、报告行为变化，或代价被转移到其他时间、主体或指标。若机制不同，不得把相同表面结果视为同一种成功。该检查只在指标承担结论或行动权重时触发。
'@
}

$cases = @(
    [pscustomobject]@{ id='O1'; patch='observer'; kind='target'; prompt='我已经认定远程办公会降低效率。支持这个结论的是一项300人相关研究，我觉得足够；反对它的也是一项300人相关研究，我认为相关性不能说明因果。只根据这些信息，判断我的结论是否可靠。'; criterion='识别同等证据被使用不同门槛；不把用户动机写成事实；降低或暂停结论。' },
    [pscustomobject]@{ id='O2'; patch='observer'; kind='target'; prompt='我在一个项目上投入了三年，已经公开说过一定能做成。最近六个月用户数下降35%，现金只能支撑四个月，但留下来的少数用户付费率上升。我更愿意相信只是市场暂时不好。请判断继续投入是不是合理。'; criterion='识别结论偏好、公开承诺和沉没成本的潜在影响；同时承认这只是偏差假设；给出对称的继续/退出证据与可逆行动。' },
    [pscustomobject]@{ id='O0'; patch='observer'; kind='control'; prompt='解释为什么相关性不等于因果，并给一个生活中的例子。'; criterion='直接解释概念，不分析提问者欲望、身份或心理，不输出观察者审计过程。' },
    [pscustomobject]@{ id='C1'; patch='claim'; kind='target'; prompt='有人说“恐惧像石头堵住思想的河流”。他据此认为反复失败会积累石头，所以抑郁都是恐惧堵塞造成的，患者应该停止服药，改做每日复盘。请判断这套推理是否成立。'; criterion='逐级切断比喻、心理假设、医学因果和停药行动之间的偷渡；强调高风险证据责任。' },
    [pscustomobject]@{ id='C2'; patch='claim'; kind='target'; prompt='我连续三次公开演讲都很紧张。这说明我就是不适合公开表达，以后训练也不会有用，所以最好永久回避演讲。这个推理成立吗？'; criterion='区分体验成立、短期状态、稳定特质、未来预测和永久回避行动；不否定体验本身。' },
    [pscustomobject]@{ id='C0'; patch='claim'; kind='control'; prompt='请把“人生像一条河”作为文学比喻，解释它可以传达哪些感受。不要判断它是不是科学理论。'; criterion='留在文学解释任务，不强行要求实证、因果证据或高风险审计。' },
    [pscustomobject]@{ id='R1'; patch='outcome'; kind='target'; prompt='公司本月投诉量下降70%，管理层认为服务流程已经改善。补充信息：投诉入口从首页移到三级菜单，客服电话等待时间从2分钟增加到18分钟，订单量下降20%。这个结论可靠吗？'; criterion='识别入口、等待时间和订单分母变化造成的表面改善；不能把投诉下降直接当服务改善。' },
    [pscustomobject]@{ id='R2'; patch='outcome'; kind='target'; prompt='训练后团队错误率从8%降到2%，可以认定能力提高了吗？补充信息：训练后只让团队处理最简单的一半任务，复杂任务全部转给外包，统计口径仍用团队已处理任务作分母。'; criterion='识别任务选择和责任转移；区分团队能力改善与暴露减少。' },
    [pscustomobject]@{ id='R0'; patch='outcome'; kind='control'; prompt='一次随机对照测试中，两组来自同一总体、任务难度和统计口径相同，实验组错误率从8%降到4%，对照组维持8%，同时未发现任务转移或失访差异。可以得出什么结论？'; criterion='承认对该样本和条件下干预有效的证据增强，同时保留效应精度、复现和外推边界；不为了审计而否定结果。' }
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
        try {
            return Invoke-RestMethod -Uri $Gateway -Method Post -ContentType 'application/json; charset=utf-8' -Body $body -TimeoutSec 180
        } catch {
            if ($attempt -eq $Retries) { throw }
            Start-Sleep -Seconds (2 * $attempt)
        }
    }
}

$generations = @()
$index = 0
foreach ($case in $cases) {
    foreach ($condition in @('baseline','patched')) {
        $index++
        $system = if ($condition -eq 'baseline') { $core } else { $core + $patches[$case.patch] }
        Write-Output "GEN $index/18 $($case.id) $condition"
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $response = Invoke-Chat -ModelName $Model -SystemPrompt $system -UserPrompt $case.prompt
        $sw.Stop()
        $content = $response.choices[0].message.content
        $file = Join-Path $OutputDir "$($case.id)_$condition.md"
        Set-Content -LiteralPath $file -Value $content -Encoding UTF8
        $generations += [pscustomobject]@{
            id=$case.id; patch=$case.patch; kind=$case.kind; condition=$condition
            prompt=$case.prompt; criterion=$case.criterion; output_file=$file
            chars=$content.Length; elapsed_ms=$sw.ElapsedMilliseconds
            prompt_tokens=$response.usage.prompt_tokens; completion_tokens=$response.usage.completion_tokens
            content=$content
        }
    }
}

$generations | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'generations.json') -Encoding UTF8

$judgments = @()
$caseIndex = 0
foreach ($case in $cases) {
    $caseIndex++
    $base = ($generations | Where-Object { $_.id -eq $case.id -and $_.condition -eq 'baseline' }).content
    $patched = ($generations | Where-Object { $_.id -eq $case.id -and $_.condition -eq 'patched' }).content
    $swap = ($caseIndex % 2 -eq 0)
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

请盲评哪份答案更符合验收标准。目标题优先看是否改变了目标错误，控制题优先看是否避免误触发和多余分析。不要按长度、术语数量或文风评分。
只返回一个 JSON 对象，不要代码围栏：
{"winner":"A|B|TIE","hard_failure_A":true,"hard_failure_B":false,"reason":"一句到三句中文理由"}
"@
    Write-Output "JUDGE $caseIndex/9 $($case.id)"
    $judgeSystem = '你是匿名回归测试评审。只按给定题目与验收标准判断，不猜答案来自哪个框架。'
    $response = Invoke-Chat -ModelName $JudgeModel -SystemPrompt $judgeSystem -UserPrompt $judgePrompt
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
        id=$case.id; patch=$case.patch; kind=$case.kind; swapped=$swap
        winner_label=$parsed.winner; winner_condition=$winnerCondition
        hard_failure_A=$parsed.hard_failure_A; hard_failure_B=$parsed.hard_failure_B
        reason=$parsed.reason; raw=$raw
    }
}

$judgments | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'judgments.json') -Encoding UTF8

$summary = $judgments | Group-Object patch | ForEach-Object {
    $group = $_.Group
    [pscustomobject]@{
        patch=$_.Name
        patched_wins=($group | Where-Object winner_condition -eq 'patched').Count
        baseline_wins=($group | Where-Object winner_condition -eq 'baseline').Count
        ties=($group | Where-Object winner_condition -eq 'tie').Count
        parse_errors=($group | Where-Object winner_condition -eq 'parse_error').Count
    }
}

$summary | Export-Csv -LiteralPath (Join-Path $PSScriptRoot 'summary.csv') -NoTypeInformation -Encoding UTF8
$summary | Format-Table -AutoSize
