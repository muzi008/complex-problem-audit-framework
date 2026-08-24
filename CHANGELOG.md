# Changelog

## [1.1.0] - 2026-08-24

Behavioral minor release using the v3.1.1 Final specification.

### Added

- Conditional observer-bias audit for high self-relevance, preferred conclusions, major sunk costs, public commitments, and hard-to-reverse actions.
- Symmetric evidence-threshold check, one-sided search check, and explicit model-lowering observations.
- Four rule-admission gates: semantic coverage, trigger coverage, behavioral effectiveness, and positive net benefit.
- Baseline SHA-256 requirements for candidates, diffs, and formal upgrades.
- Public v1.1 targeted evaluation report and auditable case, answer, and blind-judgment files.

### Changed

- Canonical Chinese specification updated from v3.0.1 Final to v3.1.1 Final.
- Runtime prompts updated to CORE-3.1.1 and ADAPTIVE-3.1.1.
- Claim-transition and outcome-mechanism checks remain evaluation cases because targeted screening found no independent runtime benefit over CORE.
- First-stage evaluation counts are stated precisely as nine questions, 18 answers, and nine blind pairs.

### Evidence boundary

- The observer patch scored three wins, three ties, and zero baseline wins on target comparisons across two stages; all three control comparisons tied.
- A separate exact-runtime release gate produced three v1.1 wins, one v1.0.1 win, and two ties on observer target comparisons; all three observer controls tied and no hard failures occurred.
- The single baseline-winning pair is retained publicly. The release rule was revised after this mixed result to judge aggregate repetitions, repeated same-class regressions, control pollution, and hard failures rather than treating one pairwise loss as an automatic veto.
- Results remain small-scale internal evidence under fixed model and prompt conditions, not independent cross-model validation.

## [1.0.1] - 2026-08-14

License-only patch. Framework behavior and the v3.0.1 Final specification are unchanged.

### Changed

- Replaced the all-rights-reserved notice with Creative Commons Attribution 4.0 International.
- Permitted copying, use, modification, redistribution, and commercial use under the attribution terms.
- Added a notice covering recommended attribution, change marking, official-project identity, generated outputs, and the warranty boundary.
- Updated public version references from v1.0.0 to v1.0.1.

## [1.0.0] - 2026-08-14

First formal public release.

### Added

- Canonical v3.0.1 Final Chinese specification.
- Compact CORE and conditional Adaptive runtime extracts.
- Layered architecture: SPEC, CORE, Router, Plugins, Tools, Free Search, and Evals.
- Observable-increment requirement and card-deletion test.
- Explicit stop rules, failure closure, tool evidence duties, and privacy boundary.
- Public blind-evaluation report with configuration limits.
- Migration guide from the public preview.

### Changed

- CORE now owns the default answer path.
- Plugin count has no lower bound; zero plugins is valid.
- Conclusion-strength labels are produced after evidence review and hidden by default.
- Internal route logs, plugin names, K/Q/E/M/F, and uncalibrated confidence percentages are hidden by default.
- Router evaluation now prioritizes answer outcome and added cost over exact agreement with a human plugin set.

### Preserved

- The original public preview remains in Git history and under tag v0.1.0-beta.

## [0.1.0-beta] - 2026-07-17

Public preview derived from the private v2.6.1 framework. It introduced the broad audit sequence, stable module vocabulary, Chinese and English documents, and reusable prompts.

