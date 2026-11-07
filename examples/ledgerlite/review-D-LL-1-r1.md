# REVIEW-D-LL-1 — code review round 1 (post-build)

| | |
|---|---|
| **Milestone** | LL-1 |
| **Spec** | `SPEC-LL-1-ledger-and-entries.md` |
| **Plan** | `plans/LL-1-plan-excerpt.md` |
| **Reviewer** | D · `minimax-anthropic` · MiniMax-M3.1-Flash |
| **Builder** | B · `zai-anthropic` · glm-5.3-flash |
| **Reviewed range** | `a1f00c2..e4b77d9` (12 commits) |
| **Date** | 1 Nov 2026 (fictional) |
| **Verdict** | **FAIL** |

## 1. What I ran

| Command | Observed result |
|---|---|
| `npm test` | 61 passed — green, observed myself |
| `npm run build` | clean |
| `npm run coverage` | 88% lines `src/domain/`, 71% `src/ui/` |

## 2. FR / AC coverage

| Requirement | Demands | Evidence | Status |
|---|---|---|---|
| FR-1 / AC-1 | balance invariant + immutability | `src/domain/ledger.test.ts::debits_equal_credits`, `::stored_entries_are_immutable` | MET |
| FR-2 / AC-2 | submit + inline rejection | `src/ui/EntryForm.test.tsx` (both paths) | MET |
| FR-3 / AC-3 | rename/re-parent keep entries | `src/domain/categories.test.ts::reparent_keeps_entries` | MET |
| FR-4 / AC-4 | summary figures + human label | `src/domain/summary.test.ts::label_is_human_form` (main view) | **PARTIAL** — see F2 |

**Decisive AC:** AC-2 — MET. The build works; that is not where this review lands.

## 3. Traceability chain

| Story | → FR | → AC | → test/site | Intact? |
|---|---|---|---|---|
| 1 | FR-1 | AC-1 | `ledger.test.ts` | yes |
| 2 | FR-2 | AC-2 | `EntryForm.test.tsx` | yes |
| 3 | FR-4? no — FR-3 | AC-3 | `categories.test.ts` | yes |
| **4 (recurring)** | **none** | **none** | **none** | **broken — orphaned story; see F1** |

## 4. Findings

| # | Severity | Finding | Evidence | Suggested fix |
|---|---|---|---|---|
| F1 | **blocker** | Story 4 (recurring entries, `← LLD-5`) is orphaned: no FR, no AC, no task — while §6 excludes LLD-5 as "next milestone". The spec both includes and excludes the same capability; nothing in the build implements it, and no gate could ever have caught it because there is no criterion to fail. This is the silent-orphan case the traceability walk exists for. | spec §2 row 4 vs §6 bullet 1; plan Tasks 1–6 contain no recurring work; `grep -r recurr src/` → no matches | Strike story 4 from §2 (recorded in place, moved verbatim to the LL-2 spec); re-review |
| F2 | minor | AC-4's human-form label holds in the main summary but the print/export render path emits `2026-11` | `src/ui/PrintSummary.tsx:41` uses raw `entry.date.slice(0,7)` | Route through the same formatter the main view uses; add the contrast test there |

## 5. Deviations

None offered — FAIL.

## 6. Verdict reasoning

Every machine gate is green and every *existing* AC is met, which is precisely the danger: the
failure is a story nothing covers, and green tests cannot express it. F1 is a spec defect the
C review round missed; fixing it is cheap now and invisible later. FAIL until §2/§6 are
reconciled and F2's second render path uses the shared formatter.

> **Independence statement:** I ran the commands myself; every verdict cites evidence. No verdict
> rests on the builder's summary or on green CI I did not observe.
