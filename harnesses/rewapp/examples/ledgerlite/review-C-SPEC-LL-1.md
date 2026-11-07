# REVIEW-C-LL-1 — spec + plan review (pre-build)

| | |
|---|---|
| **Milestone** | LL-1 — ledger core + manual entry + categories |
| **Spec** | `SPEC-LL-1-ledger-and-entries.md` (status at review: Draft) |
| **Plan** | `plans/LL-1-plan-excerpt.md` (P2.5 pass, 26 Oct) |
| **Reviewer** | C · `minimax-anthropic` · MiniMax-M3[1m] |
| **Implementer** | B — `zai-anthropic` · glm-5.3-flash (scheduled) |
| **Date** | 26 Oct 2026 (fictional) |
| **Verdict** | **PASS** (after S1 fixed in place) |

## Annex A — my checklist, derived before reading the plan

| AC | Evidence it requires (my derivation) |
|---|---|
| AC-1 | a test that folds asymmetric in/out flows and asserts per-account balance; a compile- or run-time proof that stored entries reject mutation |
| AC-2 | a happy-path submit test AND a rejection test where nothing persists |
| AC-3 | rename and re-parent each keep every entry attached; explicit no-orphans assertion |
| AC-4 | hand-computed figures for a fixture month; a label test forbidding ISO form |

## 1. Spec findings

| # | Severity | Where | Finding | Fix |
|---|---|---|---|---|
| S1 | spec-defect | §4 AC-4 | "labelled in human month form" was untestable as written — two renderings could both claim it | Rewritten to the contrast form: `"Nov 2026" style, never "2026-11"` — applied in place before the plan was written |

Checks: FRs 1–4 each carry ≥1 AC ✓ decisive AC marked (AC-2) ✓ machine gates named ✓ D1 answered in place ✓ stories tagged ✓ scope reasons present ✓.

## 2. Plan findings

| # | Severity | Where | Finding | Fix |
|---|---|---|---|---|
| P1 | minor | Task 1 test | Mutation test used `toThrowTypeError` — strict mode makes frozen-write a TypeError, but the assertion should name it | Changed to `expect(() => …).toThrow(TypeError)` |

Test story present and real (three unit families + build gate + explicit no-manual) ✓ plan steps contradict nothing in the spec ✓ no unauthorized scope ✓.

## 3. Verdict reasoning

The spec's four FRs are testable and each AC names a gate; S1 was the one untestable wording and
it is fixed in place. The plan's Task 1–2 prove AC-1 and AC-2; Tasks 3–6 (omitted here) carried
AC-3/AC-4. Nothing blocks build.

> **Independence statement:** I read the spec first and derived Annex A before opening the plan.
> This checklist, not the plan's claims, is the standard I judged against.
