# Complex Problem Audit Framework (CPAF)

**English** | [简体中文](README.zh-CN.md)

> An adaptive rule set for answering and auditing complex questions. A compact CORE answers first. Extra analysis is activated only when it can repair a named gap in evidence, variables, competing explanations, discriminating tests, or action boundaries.

- **Public release:** v1.0.1
- **Canonical specification:** Complex Question Answering Framework v3.0.1 Final
- **Release date:** 2026-08-14
- **Status:** Formal public release under CC BY 4.0; evidence remains limited

## The problem

Complex answers can fail by omission: weak evidence, mixed fact and value claims, no serious competing explanation, or advice that ignores risk and execution.

They can also fail by accumulation. Internal checklists, route logs, confidence percentages, and method names spill into the answer without changing the decision.

CPAF v1.0.1 starts from one presumption:

> CORE is sufficient until an additional step can state what would be lost without it.

Analysis stops when more work would not change the conclusion, evidence requirement, or action ranking.

## Start here

- [Canonical Chinese specification](docs/framework.zh-CN.md)
- [Chinese runtime prompt](prompts/cpaf.zh-CN.md)
- [English reference overview](docs/framework.en.md)
- [English runtime prompt](prompts/cpaf.en.md)
- [v1.0.0 blind evaluation report, Chinese](reports/v1.0-blind-evaluation.zh-CN.md)
- [Migration from the public preview](MIGRATION.md)
- [Changelog](CHANGELOG.md)
- [Copyright, attribution, and official-status notice](NOTICE.md)

## One canonical specification

Only [docs/framework.zh-CN.md](docs/framework.zh-CN.md) is authoritative.

CORE-3.0.1, ADAPTIVE-3.0.1, the Router, and Plugins are runtime layers inside that specification, not separate versions. Files under prompts/ are reproducible runtime extracts.

The 2,600-line specification is for reading, maintenance, audits, and evaluation. Ordinary questions should load the compact CORE first and enter Adaptive only after a concrete gap is found.

## What changed since v0.1.0-beta

The public preview, released on 2026-07-17, described a broad audit sequence. It remains available through Git history and its release tag.

v1.0.0 changes the runtime contract:

- CORE answers by default;
- Adaptive repairs named gaps rather than running in parallel;
- zero plugins is valid, and every plugin must promise an observable addition;
- tools and free search are activated by evidence duties;
- audit controls stay internal by default;
- card deletion, stopping, and graceful failure rules are explicit;
- evaluation and version governance are part of the specification.

This is an incompatible public major release. See [MIGRATION.md](MIGRATION.md).

## Evidence so far

An internal same-batch blind screening on 2026-08-13 produced 50 anonymous answers across 10 questions and five conditions. All 50 completed; answer failures and context-isolation failures were both zero.

| Condition | Mean visible characters | Relative to v2 FULL |
|---|---:|---:|
| Bare model | 2,076 | 71% |
| v2.7.2.1 FULL | 2,906 | 100% |
| v3 CORE | 1,852 | 64% |
| v3 CORE + human-selected cards | 1,976 | 68% |
| v3 Adaptive Router | 1,905 | 66% |

The blind review found no systematic quality loss matching the reduction in visible length. This does not establish superiority over a bare model, repeated-run stability, or an independent benefit from tools or free search. The model was declared in the UI as gpt-5.6-sol / high but could not be verified programmatically, and a runtime model-catalog change was reported. See the [Chinese report](reports/v1.0-blind-evaluation.zh-CN.md).

## Version mapping

| Name | Role |
|---|---|
| CPAF v0.1.0-beta | Preserved public preview |
| CPAF v1.0.0 | First formal public release, preserved with its original license record |
| CPAF v1.0.1 | Current public release; same framework behavior, now under CC BY 4.0 |
| Framework v3.0.1 Final | Canonical internal specification used by v1.0.1 |

## Limitations

- The framework can improve reasoning discipline and auditability; it cannot create missing evidence or guarantee a correct conclusion.
- Current evidence is a small internal screening with one generation per question-condition pair.
- Medical, legal, financial, and safety decisions still require qualified local professionals.
- The Chinese specification is canonical. The English document is a reference overview, not a controlled line-by-line translation.

## License

Except where otherwise noted, original content in this repository is licensed under [Creative Commons Attribution 4.0 International](LICENSE), copyright © 2026 muzi008.

Anyone may copy, use, adapt, redistribute, and use the material commercially. When sharing, users must credit the creator, identify the license, link to the original project, and indicate whether changes were made. Adapted projects must not imply that they are official CPAF releases or endorsed by the creator. See [NOTICE.md](NOTICE.md) for the recommended attribution, output scope, and warranty boundary.

## Feedback

Reproducible failure cases, counterexamples, and evaluation designs are welcome. A proposed rule should identify an observed failure and a regression test, not merely sound useful.
