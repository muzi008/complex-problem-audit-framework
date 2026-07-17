# Complex Problem Audit Framework

**English** | [简体中文](README.zh-CN.md)

> A value-aware, context-sensitive framework for auditing complex questions through scope, evidence, decision weights, counterarguments, uncertainty, incentives, constraints, and human agency.

**Version:** `v0.1.0-beta`  
**Status:** Experimental  
**Format:** Model-agnostic protocol for humans, AI systems, and human-AI collaboration

## Why this project exists

Complex answers often fail for reasons that more information cannot fix:

- important evidence may be unreliable;
- reliable evidence may not determine the decision;
- facts, inferences, forecasts, and values may be mixed together;
- one stakeholder's priorities may be presented as neutral truth;
- an ideal recommendation may be impossible under real constraints;
- an answer may list many perspectives without stating what would falsify its conclusion.

This framework separates those tasks so that a conclusion can be inspected, challenged, updated, and reused.

## Core idea

```text
SQ -> DF -> ST -> WA -> EV -> CT -> UN -> AC -> AU -> CN
```

1. Lock the scope and calibrate definitions.
2. Map stakeholders and their value priorities.
3. Select the Highest-Weight Anchor.
4. Separate importance from evidence confidence.
5. test the strongest counterargument and falsification conditions.
6. map uncertainty, risk, incentives, and blind spots.
7. adapt action to resources, reversibility, and execution barriers.
8. state the conclusion, limits, confidence, and update signals.

The sequence is dynamically routed. A simple question should not trigger a full audit.

## Start here

- [Full framework in English](docs/framework.en.md)
- [完整中文框架](docs/framework.zh-CN.md)
- [English AI prompt](prompts/cpaf.en.md)
- [中文 AI 提示词](prompts/cpaf.zh-CN.md)

## Scope and value statement

The framework originated in a Chinese-language personal practice shaped by the constraints faced by ordinary people in China. It is not culturally neutral and does not claim to represent every nation, ethnicity, religion, political system, or moral tradition.

Its evidence and falsification procedures are intended to be auditable. Its attention to agency, resource constraints, dominant narratives, power, interests, and blind spots reflects declared design choices.

Users may adapt value weights to their legal, cultural, religious, and personal contexts. They should not change the definitions, stable IDs, or audit rules and still describe the result as the same version.

## Semantic stability

The Chinese framework is the semantic source. The English edition is a controlled translation, not a separate framework. Stable `CPAF-*` module IDs, definitions, required behavior, and prohibited interpretations govern compatibility across languages and AI systems.

Different models may use different wording or reach different conclusions. Conformance means that they use the same concepts, required fields, evidence flags, and quality gates. It does not mean that every answer must be identical.

## Limitations

- The Beta is based on long-term personal practice and human-AI collaboration, not large-scale controlled trials.
- It improves auditability but cannot guarantee a correct conclusion.
- It cannot replace missing evidence, field research, experiments, professional judgment, or the affected person's final decision.
- High-risk medical, legal, financial, and safety decisions require qualified local professionals.

## License status

No open-source license has been selected for this Beta. Public visibility does not grant permission to copy, modify, or redistribute the work. All rights are reserved until a `LICENSE` file states otherwise.

## Origin

This public Beta is derived from the author's private *Complex Question Answering Framework v2.6.1*. The private source remains separate and unchanged.
