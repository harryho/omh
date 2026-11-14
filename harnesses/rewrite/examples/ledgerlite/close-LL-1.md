# CLOSE-LL-1 — ledger core + manual entry + categories

| | |
|---|---|
| **Milestone** | LL-1 |
| **Spec** | `SPEC-LL-1-ledger-and-entries.md` → **Shipped** 2 Nov 2026 |
| **Plan** | `plans/LL-1-plan-excerpt.md` |
| **Reviews** | C: `review-C-SPEC-LL-1.md` · D r1: `review-D-LL-1-r1.md` **FAIL** · D r2: `review-D-LL-1-r2.md` PASS-WITH-DEVIATIONS · E: `test-report-E-LL-1.md` PASS |
| **Closed** | 2 Nov 2026 (fictional) |

## 1. AC walk

| AC | Criterion (short) | Evidence | Result |
|---|---|---|---|
| AC-1 | balance invariant + immutability | `ledger.test.ts` (2) + E property test | pass |
| AC-2 | submit + reject-and-persist-nothing | `EntryForm.test.tsx` (2) + E store-count test | pass |
| AC-3 | rename/re-parent keep entries | `categories.test.ts` + E root-reparent test | pass |
| AC-4 | figures + human label, both render paths | `summary.test.ts`, `print-summary.test.tsx` (added by F2 fix) | pass |

## 2. Deviations — final state

| ID | Deviation | Accepted by | Date |
|---|---|---|---|
| D1 (r2) | whole-dollar summary figures | Harry | 2 Nov |

## 3. Inventory update

No disposition changed. Assignment change recorded: **LLD-5 stays `port`, moves to LL-2's scope**
(was a candidate row in LL-1's §2; orphaned, caught by D r1 F1).

## 4. Digest (for the human)

- LL-1 shipped: ledger, manual entry, two-level categories, month summary. 63 tests green.
- Round-1 review **FAILed** on an orphaned story (recurring entries in §2, no FR/AC, excluded in
  §6) — a spec self-contradiction C's round missed. Fixed by a recorded strike; moved to LL-2.
- The round is the lesson: every existing AC was green while a story silently had nothing. E
  passed *correctly* — it tests the criteria that exist; only the traceability walk found the
  gap. This is why D and E are two roles, not two of the same role.
- One minor deviation accepted (whole dollars). Nothing unverified; no manual ACs.

## 5. Next milestone

**LL-2 — recurring entries + budgets** (inventory rows LLD-5, LLD-6); story 4 moves there
verbatim as its first user story.
