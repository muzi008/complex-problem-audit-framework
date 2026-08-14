# CPAF v1.0.0 English Reference Overview

The canonical specification is the Chinese document [framework.zh-CN.md](framework.zh-CN.md), internally frozen as Complex Question Answering Framework v3.0.1 Final. This English file is a reference overview, not a controlled line-by-line translation.

## 1. Purpose

CPAF governs how a complex answer is framed, evidenced, challenged, limited, and turned into action. It addresses two opposite failures:

- omission of decisive evidence, alternatives, values, risks, or execution constraints;
- accumulation of internal control material that increases length without changing the judgment.

Its default presumption is H0: CORE is sufficient. Any plugin, tool call, or free-search pass bears the burden of showing an observable marginal benefit.

## 2. Six layers

| Layer | Role | Default runtime status |
|---|---|---|
| SPEC | Definitions, rules, boundaries, methods, and tests | Not loaded for ordinary questions |
| CORE | Compact default reasoning discipline | Always active |
| ROUTER / ADAPTIVE | Detects and repairs explicit CORE gaps | Conditional |
| PLUGINS | Supplies one differentiating method output | Conditional and minimal |
| TOOLS + FREE SEARCH | Obtains external evidence or searches beyond the current model set | Evidence-triggered |
| EVALS | Quality gates, ablation, regression, and version governance | Internal |

Capability, availability, and activation are different. A method may exist in the specification without entering the current working context.

## 3. CORE contract

CORE requires an answer to:

1. represent the real question before solving it;
2. account for what the user already knows;
3. add a real variable, mechanism, scale, prediction, or decision implication rather than repeat the prompt;
4. separate fact, inference, hypothesis, value, and action;
5. use a serious competing explanation when it can change the judgment;
6. match conclusion strength to evidence;
7. use tools when external evidence can change the answer;
8. adapt action to resources, risk, reversibility, execution barriers, and agency;
9. stop when further work has no marginal decision value.

## 4. Adaptive entry rule

Adaptive is not a parallel large prompt. It starts only when the CORE draft lacks at least one of:

- critical external evidence;
- a decisive variable;
- a genuine competing model;
- a discriminating test;
- an action-changing boundary.

The Router generates candidates, not mandatory modules. Plugin count has no lower bound.

Each candidate must state one observable addition. Accepted additions are new evidence, a new variable, a new competing model, a new discriminating test, or a new action boundary. If removing a card would not remove one of these outputs, the card is deleted.

## 5. Plugin index

| ID | Method |
|---|---|
| P1 | Concepts and definitions |
| P2 | Evidence and sources |
| P3 | Causal inference |
| P4 | System dynamics |
| P5 | Multi-agent games and incentives |
| P6 | Probability, statistics, and uncertainty |
| P7 | Time, space, and scenarios |
| P8 | Values, power, interests, and narratives |
| P9 | Decisions and actions |
| P10 | Execution barriers and behavior design |
| P11 | Law, ethics, and high-risk boundaries |
| P12 | Relationships and behavioral sequences |
| P13 | Science and technology |
| P14 | Expression and reusable artifacts |

An apparent match does not activate a plugin. The observable-increment and deletion tests still apply.

## 6. Tool and evidence contract

The framework decides whether evidence is needed; the environment decides which tools exist.

External evidence is normally required when a decisive claim is current, specialized, high-risk, explicitly requested for verification, or otherwise carries an evidence duty. A complete tool loop is:

claim -> evidence duty -> source/tool -> result -> updated judgment -> citation or boundary

Searching that merely decorates a prior conclusion does not satisfy the contract.

## 7. Competition, counterfactuals, and predictions

A competitor must differ in mechanism, not just wording. The answer should identify evidence that distinguishes the leading models. Counterfactuals and unique predictions are used when they can test the mechanism or change the decision.

Null models and low-probability, high-impact models are conditional:

- include a null model when it could defeat a causal attribution;
- include a low-probability, high-impact model when it changes the safe action.

## 8. Output rules

The user normally sees the answer, evidence, boundary, and next action. The following remain internal unless an audit is requested:

- K/Q/E/M/F readiness fields;
- plugin and Router logs;
- card-deletion traces;
- conclusion-strength labels;
- uncalibrated confidence percentages;
- execution receipts.

Auditability means the answer can be checked. It does not require exposing the full control process.

## 9. Stopping and failure closure

Stop expansion when:

- a new plugin would not change the conclusion, evidence need, or action ranking;
- leading models imply the same safe action;
- available evidence supports only a bounded judgment and more prose repeats that uncertainty;
- the user asked a simple definition or operation and already has an executable answer.

When tools fail or evidence is unavailable, state what is known, what remains unresolved, why it matters, how the conclusion is limited, and the next best verification action.

## 10. Evaluation

Evaluation starts with hard failures and anonymous pairwise review, not a single composite score. Relevant dimensions include question representation, factual correctness, novelty relative to the user, mechanism, model discrimination, evidence quality, decision value, expression cost, stopping behavior, tool closure, and Adaptive's added outcome relative to CORE.

The 2026-08-13 screening found that CORE preserved the same broad quality tier at about 64% of the visible character count of v2 FULL. It did not establish that CPAF beats a bare model or that Adaptive, tools, and free search each have independent benefits. See the [public report](../reports/v1.0-blind-evaluation.zh-CN.md).

## 11. Conformance

An implementation may claim CPAF v1.0.0 compatibility when:

- CORE owns the default path;
- Adaptive is entered only for a named gap;
- zero plugins is valid and retained plugins pass the increment and deletion tests;
- external evidence updates the judgment;
- internal controls stay hidden by default;
- analysis stops at zero marginal decision value;
- high-risk answers preserve verification and responsibility boundaries.

The Chinese specification controls when this overview is incomplete or ambiguous.

