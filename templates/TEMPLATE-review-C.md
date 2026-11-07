# REVIEW-C-M<N> — spec + plan review (pre-build)

<!--
Written by the spec reviewer, before any code exists. Read order is the whole point:
spec → derive Annex A → only then the plan. Never the reverse.
One file per review round; re-reviews get a new dated file; old reports are never edited.
-->

| | |
|---|---|
| **Milestone** | M<N> — <name> |
| **Spec** | `notes/specs/SPEC-M<N>-*.md` (status at review: <…>) |
| **Plan** | `notes/specs/plans/M<N>-plan.md` (if written) |
| **Reviewer** | <role> · <provider> · <model> — must differ from builder B |
| **Implementer** | <provider> · <model> (B, for reference) |
| **Date** | <date> |
| **Verdict** | **PASS** / **PASS-WITH-DEVIATIONS** / **FAIL** |

## Annex A — my checklist, derived before reading the plan

<Written from the spec alone: for each AC, what observable evidence would prove it; for each
story, which FR covers it. Kept verbatim as the review's anchor — this section is the
anti-anchoring record and must exist before the plan is opened.>

| AC | Evidence it requires (my derivation) |
|---|---|
| AC-1 | |
| AC-2 | |

## 1. Spec findings

| # | Severity | Where | Finding | Fix |
|---|---|---|---|---|
| S1 | blocker / major / minor / spec-defect | § | | |

Checks: every FR has ≥1 AC; the decisive AC is marked; every machine AC names its gate; no
decision left Blocking; every story tagged `← id` or `NEW`; out-of-scope items carry reasons.

## 2. Plan findings (if a plan exists)

| # | Severity | Where | Finding | Fix |
|---|---|---|---|---|
| P1 | | | | |

Checks: every AC has a task that proves it; no step contradicts the spec; the test story is real
(unit / functional / coverage / manual); scope the inventory never authorized.

## 3. Verdict reasoning

<What convinced me; what a FAIL would need fixed. Deviations listed for human acceptance if
PASS-WITH-DEVIATIONS.>

> **Independence statement:** I read the spec first and derived Annex A before opening the plan.
> This checklist, not the plan's claims, is the standard I judged against.
