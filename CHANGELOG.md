# Changelog

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

