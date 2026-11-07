# TEST-E-LL-1 — independent test report

| | |
|---|---|
| **Milestone** | LL-1 |
| **Spec (only source read)** | `SPEC-LL-1-ledger-and-entries.md` |
| **Tester** | E · `minimax-anthropic` · MiniMax-M3.1-Flash (⚠ same model as C — accepted warning, init log row 4) |
| **Builder** | B · `zai-anthropic` · glm-5.3-flash |
| **Date** | 1 Nov 2026 (fictional) |
| **Verdict** | **PASS** |

> **Sources-read statement:** I derived every test below from the spec's acceptance criteria
> alone. I did not open the plan, the builder's tests, or any review document.

## 1. Derived tests

| Test | AC | Why it proves it |
|---|---|---|
| `e-ac1-frozen-ledger-random-flows` (property: 200 random entry sequences) | AC-1 | The criterion says "after any sequence" — a property test samples sequences, not one fixture |
| `e-ac2-form-rejects-and-persists-nothing` | AC-2 | The criterion's second clause ("nothing persists") needs an explicit store-count assertion |
| `e-ac3-reparent-grandchildren-no-orphans` | AC-3 | Re-parenting the *root* of a subtree is the case a single-level fixture misses |
| `e-ac4-summary-year-boundary` | AC-4 | Dec/Jan flows around a year boundary stress the UTC decision (spec D1) hardest |

## 2. Results

| Test | Command | Observed output | Pass/fail |
|---|---|---|---|
| all four | `npm test -- e-` | `4 passed (4)` — run in the built tree, observed myself | pass |

## 3. Folded-back suggestions

| Test | Why worth keeping |
|---|---|
| `e-ac4-summary-year-boundary` | The builder's suite fixtures single months; the boundary is where a local-time regression would hide |

## 4. Verdict

All four criteria pass under tests I wrote from the spec alone. Note the limit of this method,
stated plainly: I test the ACs that exist; a story with no criterion is invisible to me by
construction. (Whether such a story existed here is the code reviewer's question, not mine.)

> **Statement:** every result above is output I observed myself from commands I ran myself.
