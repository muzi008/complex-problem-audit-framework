# Complex Problem Audit Framework Prompt

**English** | [简体中文](cpaf.zh-CN.md) | [Full framework](../docs/framework.en.md)

**Compatible version:** `CPAF v0.1.0-beta`

Copy the prompt below and replace the final three fields.

```text
Use the Complex Problem Audit Framework, CPAF v0.1.0-beta, to analyze the question below.

Semantic rules:
1. Interpret every core module through its stable CPAF ID and normative definition, not through an improvised everyday meaning.
2. Do not reveal hidden chain-of-thought. Provide an auditable reasoning summary that identifies evidence, key assumptions, the decision anchor, counterarguments, falsification conditions, and action rationale.
3. Select Quick, Standard, or Full Audit according to complexity. Do not mechanically output every module.
4. If you change a core definition or trigger, label the result as a derivative. Do not claim full conformance with the original version.

Execution requirements:
1. [CPAF-SQ-01] Lock the scope. State inclusions, exclusions, time, location, affected population, and goal.
2. [CPAF-DF-02] Calibrate terms and hidden assumptions. Separate facts, inferences, forecasts, value choices, and action recommendations.
3. [CPAF-ST-03] Map direct participants, affected parties, and their value priorities. Do not present one stakeholder's goal as neutral truth.
4. [CPAF-WA-04] Select the Highest-Weight Anchor. Explain why it has priority and how another anchor would change the conclusion.
5. [CPAF-WD-05] Classify other factors as Core, Near, Secondary, or Context relative to the anchor.
6. [CPAF-EV-06] Separate importance from evidence confidence. Explain source, directness, consistency, precision, timeliness, interests, and alternative explanations.
7. [CPAF-HL-07/CPAF-CV-08] Mark high-weight, low-confidence information as a Critical Item Pending Verification. It must not independently support a strong conclusion.
8. [CPAF-CT-09] Give the strongest support and the strongest informed counterargument. Do not use a straw person.
9. [CPAF-FC-10] State falsification conditions and boundaries. Test whether the conclusion survives removal of low-confidence evidence.
10. [CPAF-PB-11] When relevant, inspect who defines the problem, who benefits, who bears the cost, and what is omitted. Interests alone are not proof of conspiracy.
11. [CPAF-NA-12] Audit institutional, anti-institutional, market, religious, nationalist, professional, and personal narratives symmetrically. Do not assume that one side is inherently correct.
12. When relevant, analyze probability, impact, time scale, and conditional second-order effects. Do not present distant consequences as inevitable.
13. Adapt action to time, money, trial cost, reversibility, resource constraints, impact on others, and execution barriers.
14. [CPAF-AP-13] Separate real limits from remaining room for action. Do not reduce Agency Preservation to motivational language.
15. [CPAF-AB-14] Briefly state the most relevant AI biases that may affect the answer.
16. End with the current conclusion, boundary, confidence level, uncertainty, update signals, and a one-sentence summary.

Value and cultural statement:
This framework originated in a Chinese-language context and in observation of the constraints faced by ordinary people in China. It does not claim to represent every nation, ethnicity, religion, or cultural tradition. Use the questioner's declared legal, cultural, religious, relational, and value constraints. If values cannot be unified, expose the disagreement and its costs instead of inventing a global consensus.

My question:
[Write the question here]

My goal:
[Understand, choose, reduce risk, or act]

Known constraints:
[Jurisdiction, time, budget, law, culture, religion, family duties, risk tolerance, and other limits]
```

