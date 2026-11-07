# REVIEW-D-M<N> — code review (post-build)

<!--
Written by the code reviewer after machine gates are green. Runs in parallel with the
independent tester; neither sees the other's output before finishing. Re-reviews get a new
dated file; old reports are never edited.
-->

| | |
|---|---|
| **Milestone** | M<N> — <name> |
| **Spec** | `notes/specs/SPEC-M<N>-*.md` |
| **Plan** | `notes/specs/plans/M<N>-plan.md` |
| **Reviewer** | <role> · <provider> · <model> — **must differ from builder B's model** |
| **Builder** | <provider> · <model> |
| **Reviewed range** | `<from>..<to>` |
| **Date** | <date> |
| **Verdict** | **PASS** / **PASS-WITH-DEVIATIONS** / **FAIL** |

## 1. What I ran

Every verification command, executed personally — not quoted from the plan:

| Command | Observed result |
|---|---|
| | |

## 2. FR / AC coverage

One row per FR and per AC; no collapsing.

| Requirement | Demands | Evidence (`file:line` / test name) | Status |
|---|---|---|---|
| FR-1 | | | MET / PARTIAL / MISSING |
| AC-1 | | | MET / PARTIAL / MISSING / UNTESTABLE |

**Decisive AC:** <which> — <verdict>.

## 3. Traceability chain

| Story | → FR | → AC | → test/site | Intact? |
|---|---|---|---|---|
| 1 | FR-1 | AC-1 | `<test or file:line>` | yes / **broken — why** |

The dangerous case is not a failing AC (that is loud); it is a passing AC that no longer
describes its story, or an orphaned story.

## 4. Findings

| # | Severity | Finding | Evidence | Suggested fix |
|---|---|---|---|---|
| F1 | blocker / major / minor / spec-defect | | | |

Include: tests written to pass rather than to prove; implementation decisions the spec never
authorized; never-invent violations (behaviour claimed as port, absent from the inventory).

## 5. Deviations

| ID | Deviation | Severity | Disposition |
|---|---|---|---|
| D1 | | minor | self-accepted + logged / **escalated (major/blocker → human)** |

## 6. Verdict reasoning

<What convinced me; what would flip the verdict.>

> **Independence statement:** I ran the commands myself; every verdict above cites evidence. No
> verdict rests on the builder's summary or on green CI I did not observe.
