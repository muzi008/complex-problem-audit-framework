# Complex Problem Audit Framework

**English** | [简体中文](framework.zh-CN.md) | [Project home](../README.md)

**Version:** `v0.1.0-beta`  
**Status:** Experimental public edition  
**Semantic source:** Chinese edition  
**Origin:** Derived from the author's private *Complex Question Answering Framework v2.6.1*

## Scope and value statement

This framework originated in a Chinese-language personal practice and in sustained observation of the constraints faced by ordinary people in China. It is not a value-neutral calculator. It does not claim to represent the shared position of every nation, ethnicity, religion, cultural tradition, or political system.

Its evidence calibration, separation of weight and confidence, counter-testing, falsification conditions, and uncertainty labels are intended to provide an auditable procedure. Its attention to agency, resource constraints, mainstream narratives, power, interests, and blind spots reflects declared design choices.

Users may adapt value weights to local law, culture, religion, social relations, and personal goals. They must not change the core definitions, stable IDs, or audit procedure and still describe the result as the same version.

When values cannot be reconciled, the framework does not promise a universal answer. It makes disagreements, evidence, costs, weights, and falsification conditions visible so that competing conclusions can be understood, compared, and revised.

## Normative status and semantic stability

The Chinese framework is the semantic source. This English edition is a controlled translation, not an independent framework. If ambiguity occurs, compatibility is determined by the stable ID, Chinese definition, required behavior, and prohibited interpretation together. A single English term must not be used to redefine a module.

| Stable ID | Chinese canonical term | Controlled English term |
|---|---|---|
| `CPAF-SQ-01` | 范围锁定 | Scope Lock |
| `CPAF-DF-02` | 定义校准 | Definition Calibration |
| `CPAF-ST-03` | 视角地图 | Stakeholder Perspective Map |
| `CPAF-WA-04` | 最高权重锚点 | Highest-Weight Anchor |
| `CPAF-WD-05` | 相对权重距离 | Relative Weight Distance |
| `CPAF-EV-06` | 证据置信度 | Evidence Confidence |
| `CPAF-HL-07` | 高权重低置信 | High-Weight, Low-Confidence |
| `CPAF-CV-08` | 关键待验证项 | Critical Item Pending Verification |
| `CPAF-CT-09` | 反方检验 | Counter-Test |
| `CPAF-FC-10` | 推翻条件 | Falsification Conditions |
| `CPAF-PB-11` | 权力、利益与盲区棱镜 | Power-Interest-Blindspot Lens |
| `CPAF-NA-12` | 主流叙事审计 | Mainstream Narrative Audit |
| `CPAF-AP-13` | 主体性保护 | Agency Preservation |
| `CPAF-AB-14` | AI 偏差自检 | AI Bias Self-Check |

Compatibility rules:

1. A stable ID must not change meaning within the same major version.
2. A translation may improve readability but must not change triggers or acceptance criteria.
3. A semantic change to a core term is incompatible. It requires a major version change and a migration note.
4. AI systems may differ in wording and conclusions. They must still follow the same definitions, required fields, evidence flags, and quality gates.
5. A modified definition creates a derivative version and must be labeled as such.

## One-sentence definition

A modular protocol for auditing complex questions by separating scope, stakeholder values, decision weight, evidence confidence, counterarguments, uncertainty, incentives, resource constraints, action, and human agency.

## Why it exists

Complex analysis often fails because:

- important evidence may be unreliable;
- reliable evidence may not determine the decision;
- fact, inference, forecast, value choice, and action advice are mixed together;
- one stakeholder's priorities are presented as neutral truth;
- a theoretically correct plan cannot be executed under real constraints;
- many perspectives are listed without stating what would falsify the conclusion.

The framework separates these operations so that a conclusion can be inspected, challenged, updated, and reused.

## Declared design commitments

1. Evidence quality matters more than rhetorical confidence.
2. Importance and credibility must be evaluated separately.
3. Value priorities must be disclosed instead of presented as naturally objective.
4. Analysis should examine who defines the problem, who benefits, who bears the cost, and what is omitted.
5. Action advice must account for money, time, trial capacity, execution barriers, and irreversible risk.
6. Efficiency is not the only value. Dignity, relationships, quality of life, and long-term agency must not automatically be sacrificed to it.
7. Users may change value weights, but they must disclose the change, rationale, and consequences.

These are project commitments, not claims of universal moral consensus.

## Intended use

Suitable for:

- career decisions and capability transfer;
- education, family, and long-term relationship questions;
- organizational decisions and AI adoption;
- public policy, social structures, and multi-party conflicts;
- uncertain, long-term, high-cost, or hard-to-reverse choices;
- questions that require evidence, narrative, risk, and action audits.

Not suitable as a direct substitute for:

- simple factual lookup;
- basic calculation or a known procedural step;
- emergency medical action;
- licensed legal, medical, financial, or safety judgment;
- missing experiments, field inspection, or critical data.

The framework may organize high-risk questions and evidence. It does not replace a qualified local professional.

## Core sequence

```text
SQ -> DF -> ST -> WA -> EV -> CT -> UN -> AC -> AU -> CN
```

- **SQ, Scope Lock:** define what is and is not being examined.
- **DF, Definition Calibration:** define terms, measures, and hidden assumptions.
- **ST, Stakeholder Perspective Map:** identify affected parties and their goals.
- **WA, Highest-Weight Anchor:** select the factor that should most strongly govern the decision.
- **EV, Evidence Calibration:** test reliability, directness, timeliness, and corroboration.
- **CT, Counter-Test:** test the strongest counterargument and falsification conditions.
- **UN, Uncertainty:** map probabilities, unknowns, context differences, and tail risks.
- **AC, Action Adaptation:** fit action to resources, reversibility, and execution barriers.
- **AU, Audit:** inspect power, interests, blind spots, source bias, and AI bias.
- **CN, Conclusion:** state the result, limits, confidence, and update signals.

This is not a fixed essay template. Route only the modules required by the question.

## Three execution modes

| Mode | Use | Minimum output |
|---|---|---|
| Quick | Clear scope and low risk | SQ, DF, EV, CN |
| Standard | Multi-factor judgment or practical choice | SQ, DF, WA, EV, CT, AC, CN |
| Full Audit | High risk, long horizon, multiple stakeholders, or irreversibility | All applicable modules |

When new information is added, use an incremental update:

- what remains unchanged;
- what must be revised;
- which anchor, evidence item, or constraint changed;
- the updated conclusion.

## `CPAF-SQ-01` Scope Lock and `CPAF-DF-02` Definition Calibration

Before analysis, state:

| Field | Question |
|---|---|
| Time | Present decision, historical cause, or long-term trend? |
| Location | Which country, jurisdiction, industry, organization, or household? |
| Population | Who is directly affected and who bears consequences? |
| Goal | Understanding, choosing, reducing risk, or acting? |
| Exclusions | What is outside this analysis? |
| Hidden assumptions | What is being treated as true without evidence? |

Separate:

- fact;
- inference;
- forecast;
- value choice;
- action recommendation.

## `CPAF-ST-03` Stakeholder Perspective Map

Check, when relevant:

- direct participants;
- affected people with limited voice or exit options;
- institutions, platforms, and managers;
- researchers and qualified professionals;
- law and public interest;
- the user's declared goals and constraints.

For each perspective ask:

1. What does it protect first?
2. What is it willing to sacrifice?
3. What information does it possess?
4. What is it likely to overlook?

Perspective mapping reveals differences. It does not require equal weight for every view. Greater evidence, direct exposure to consequences, and affected rights may justify greater weight, but the reason must be stated.

## `CPAF-WA-04` Highest-Weight Anchor

Definition: the factor that should serve as the primary basis for the final judgment in this question.

Required:

1. Select one initial Highest-Weight Anchor for a complex question.
2. Explain why it has priority.
3. Explain how the conclusion changes if another anchor is selected.
4. Evaluate other factors relative to that anchor.

Prohibited interpretations:

1. The anchor is not automatically the most credible evidence.
2. Majority opinion is not automatically the anchor.
3. An isolated numeric score must not replace anchor selection.

Possible anchors:

| Question | Possible anchor |
|---|---|
| Career | transferable capability, affordable risk, and real validation opportunities |
| Education | long-term consequences for the learner |
| Relationship | safety, respect, and sustainable relationship quality |
| Legal risk | evidence boundaries, procedure, and affordable consequences |
| Investment | capital safety, risk exposure, and loss capacity |
| AI tool | reliable utility, data boundaries, and workflow fit |
| Public policy | observed outcomes, distributional effects, and correction capacity |

## `CPAF-WD-05` Relative Weight Distance

Classify other factors by their distance from the anchor:

- **Core:** nearly equal to the anchor;
- **Near:** can materially change the conclusion;
- **Secondary:** changes implementation, not direction;
- **Context:** explains conditions but does not directly determine the result.

Do not use `1-5` scores as false precision unless reliable data supports them.

## `CPAF-EV-06` Evidence Confidence

Weight asks, "How important is this?" Confidence asks, "How strongly should we believe it?"

For each critical item inspect:

| Dimension | Question |
|---|---|
| Source | Primary record, official document, study, media, platform discussion, or personal experience? |
| Directness | Direct observation or multi-step retelling? |
| Consistency | Do independent sources corroborate it? |
| Precision | Are definitions, sample, time, place, and method clear? |
| Timeliness | Is it current enough for this question? |
| Interest | Does the source benefit from a particular conclusion? |
| Alternative explanation | Can the same evidence support another reasonable account? |

Use High, Medium, or Low confidence and explain the reason. A label without a reason is insufficient.

## `CPAF-HL-07` High-Weight, Low-Confidence and `CPAF-CV-08` Critical Item Pending Verification

If an item could determine the conclusion but evidence is weak, mark it:

> **Critical Item Pending Verification: high decision weight, insufficient confidence. It must not independently support a strong conclusion.**

Then state:

- what evidence is missing;
- how it can be checked;
- what temporary decision is safe before verification.

## `CPAF-CT-09` Counter-Test and `CPAF-FC-10` Falsification Conditions

A complete analysis includes:

1. the strongest supporting chain;
2. the strongest informed counterargument, not a straw person;
3. whether the counterargument falsifies, strongly revises, weakly revises, reframes, or merely rejects emotionally;
4. conditions outside the support-versus-opposition split;
5. explicit falsification conditions.

Minimum table:

| Field | Content |
|---|---|
| Current judgment | Best present conclusion |
| Strongest support | Evidence and mechanism |
| Strongest counterargument | Objection most capable of changing the result |
| Falsification condition | New fact that requires a different judgment |
| Boundary | Population, place, time, or resource condition where it does not apply |

Sensitivity test:

- Does the conclusion collapse if the Highest-Weight Anchor changes?
- Does it remain defensible if low-confidence evidence is removed?

## `CPAF-PB-11` Power-Interest-Blindspot Lens

For social, organizational, and public questions ask:

| Question | Purpose |
|---|---|
| Who defines the problem? | Identify authority over language and metrics |
| Who benefits from the current explanation? | Identify incentives and interests |
| Who bears costs and risks? | Identify displaced or hidden burdens |
| What is omitted? | Identify statistical, institutional, or communication blind spots |
| Is a structural problem individualized? | Avoid describing institutional risk as personal failure |
| Is a high-resource path presented as universal? | Avoid requiring the same resources from everyone |

Power and interests do not prove conspiracy. They are variables to inspect, not evidence of malicious intent.

## `CPAF-NA-12` Mainstream Narrative Audit

Audit influential narratives symmetrically. This includes institutional, anti-institutional, market, religious, nationalist, professional, and personal narratives.

Check:

- who defines normal, success, maturity, responsibility, or rationality;
- what evidence supports the definition;
- what value assumption it contains;
- who benefits and who pays;
- whether it transfers structural responsibility to individuals;
- whether a minority or elite path is presented as a universal standard.

The audit does not automatically reject a mainstream position. It requires its assumptions to be visible.

## Probability, time, and conditional second-order effects

Separate probability from impact:

| Type | Response |
|---|---|
| High probability, high impact | Handle first |
| High probability, low impact | Use low-cost management |
| Low probability, high impact | Add a firewall, insurance, or exit path |
| Low probability, low impact | Do not consume excessive attention |

State:

- High, Medium, Low, or Unknown probability;
- increasing, decreasing, or unknown trend;
- signals that require an update;
- reversibility and affordability of the worst case.

Use second-order analysis only for policy, education, long relationships, career paths, AI tools, organizational management, and other high-risk actions. Label the time scale, conditions, confidence, and feedback that could reverse the effect. Do not present distant consequences as inevitable.

## Action, resources, and execution barriers

Classify variables:

- cannot be changed but must be understood;
- high cost and low return;
- low cost and high return;
- path-changing turning point.

Choose time scales that fit the problem. A default structure is:

| Horizon | Goal |
|---|---|
| Immediate | reduce risk, stop irreversible loss, or obtain critical evidence |
| Short validation cycle | test a key assumption at low cost |
| Long-term accumulation | build capability, resources, relationships, or exit options |
| Do not do | identify high-risk, low-return, or irreversible actions |

For each action state time, money, trial cost, reversibility, impact on others, and exit path.

Describe High, Medium, or Low resource constraints. Do not use social class labels as fixed judgments of capability.

Execution barriers are not automatically a lack of discipline. Check information, skill, startup cost, family or institutional pressure, short-term pain, delayed reward, and environmental incentives.

## `CPAF-AP-13` Agency Preservation

Under strong structural constraints ask:

- what cannot be changed by the individual;
- what local choices still increase control;
- what should not be reduced to an efficiency tool;
- what low-efficiency values remain worth preserving;
- how structural analysis could become an excuse for inaction;
- what actions increase future options instead of only improving the current metric.

Agency Preservation is not motivational language. It separates real limits from remaining room for action.

## `CPAF-AB-14` AI Bias Self-Check

When AI participates, inspect two to four relevant risks:

- over-reliance on public, English-language, or institutional sources;
- excessive caution caused by compliance incentives;
- false symmetry created to appear balanced;
- placing technical solutions ahead of human goals;
- treating majority experience as the user's context;
- missing recent change because training data is stale.

This check exposes limits. It should not become a generic disclaimer paragraph.

## Standard output template

```markdown
# Core conclusion

## 1. Scope and definitions
- Included:
- Excluded:
- Key terms:
- Hidden assumptions:

## 2. Highest-Weight Anchor [CPAF-WA-04]
- Anchor:
- Reason:
- Effect of selecting another anchor:

## 3. Critical evidence
| Evidence | Source type | Decision weight | Confidence and reason | Possible bias |
|---|---|---|---|---|

## 4. Support, counter-test, and gray conditions
- Strongest support:
- Strongest counterargument:
- Context-dependent conditions:
- Falsification conditions:

## 5. Power, interests, and blind spots
- Who defines:
- Who benefits:
- Who bears the cost:
- What is omitted:

## 6. Risk and uncertainty
- High probability, high impact:
- Low probability, high impact:
- Critical items pending verification:
- Update signals:

## 7. Action
- Immediate:
- Short validation cycle:
- Long-term:
- Do not do:

## 8. Final judgment
- Current conclusion:
- Boundary:
- Confidence: High / Medium / Low, because:
- One-sentence summary:
```

## Known limitations

1. The Beta is based on long-term personal practice and human-AI collaboration, not large-scale controlled trials.
2. It draws from decision science, evidence evaluation, systems thinking, risk management, and stakeholder analysis. Its contribution lies mainly in selection, combination, order, interfaces, and execution rules. It does not claim that every module is an original theory.
3. Anchor selection still contains value judgment and cannot automatically remove bias.
4. Longer analysis is not always better. Dynamic routing is required to limit cognitive load.
5. The framework improves auditability but cannot guarantee correctness.
6. It cannot replace missing data, field research, experiments, licensed judgment, or the affected person's final decision.

## Relationship to the private source

| Private v2.6.1 | Public Beta |
|---|---|
| Designed for the author's personal AI workflow | Designed for different users and models |
| Includes local archiving and visual delivery rules | Contains the analysis and audit method |
| Uses fixed personal presentation preferences | Leaves presentation choices to the user |
| Requires a complete private consolidation workflow | Routes Quick, Standard, or Full Audit by context |
| Uses personal trigger language | Uses general invocation rules |

The public Beta does not replace or update the private source.

## Final line

Complex judgment is not a contest to list the most perspectives. First identify what matters most, then test whether the evidence is credible, and finally state what would make you change your mind.

