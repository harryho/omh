# SPEC-LL-1 — the ledger and its entries live on the web

| | |
|---|---|
| **Milestone** | LL-1 — ledger core + manual entry + categories |
| **Plan reference** | `plans/LL-1-plan-excerpt.md` (excerpt) |
| **Author** | A · `zai-anthropic` · glm-5.3 · 25 Oct 2026 |
| **Status** | **Shipped** 2 Nov 2026 (fictional dates) |
| **Depends on** | nothing (first milestone) |

## 1. Why this milestone exists

The double-entry ledger is the spine: every later capability reads it. Shipping it first with
categories and manual entry proves the new stack can hold the old app's core honestly, and
unblocks reports, import, and budgets. Skipping it means building everything on an unverified
foundation.

## 2. User stories

1. As a saver, I want my ledger to balance every time I open it, so that I can trust every
   number the app shows. `← LLD-1`
2. As a saver, I want to record an expense or income in under ten seconds with a category, so
   that month-end needs no cleanup. `← LLD-2` `← LLD-3`
3. As a saver, I want a two-level category tree I can rename and re-parent without losing
   entries, so that my history stays intact as my scheme evolves. `← LLD-4`
4. ~~As a saver, I want my monthly standing orders entered automatically, so that I never re-type
   rent.~~ `← LLD-5` — **struck by the D-r1 fix (F1): this story was orphaned (no FR/AC) and
   contradicted §6; it moves to LL-2 verbatim.** Stories below renumbered? No — numbering kept;
   the register records the removal, history is not rewritten.

## 3. Functional requirements

**FR-1 — The ledger balances.** After any sequence of entries, total debits equal total credits
per account; a stored entry is immutable (edits are new rows).

**FR-2 — Fast entry.** An expense or income entry needs date, amount, direction, account, and one
category; the form submits in one action and rejects invalid input inline.

**FR-3 — Living category tree.** Categories form exactly two levels; renaming or re-parenting a
category never loses, duplicates, or reassigns an entry.

**FR-4 — Month summary.** For any month, the app shows opening balance, total in, total out, and
closing balance, labelled in human month form.

> **FR-1 is the point of this milestone.** Trust in every later number depends on the balance
> invariant; nothing else survives without it.

## 4. Acceptance criteria

**AC-1** *(FR-1, machine: `npm test -- ledger`)*
> **Given** any ledger with n entries **When** balances are computed **Then** debits equal
> credits per account, and mutation of a stored entry is rejected.

**AC-2** *(FR-2, machine: `npm test -- entries`)* — *the one that proves the work*
> **Given** the entry form **When** valid expense or income data is submitted **Then** the entry
> persists and appears in the account feed; invalid submissions are rejected with a field-level
> message and nothing persists.

**AC-3** *(FR-3, machine: `npm test -- categories`)*
> **Given** a two-level tree with entries attached **When** a category is renamed or re-parented
> **Then** every entry keeps its category reference and the tree has no orphans.

**AC-4** *(FR-4, machine: `npm test -- summary`)*
> **Given** a month with known flows **When** the summary opens **Then** the four figures match
> hand-computed values and the month is labelled "Nov 2026" style, never "2026-11".

## 5. Decisions required

| ID | Decision | Owner | Blocking? |
|---|---|---|---|
| **D1** | ~~Store dates UTC or local?~~ ✅ **UTC always; render in the user's zone — Verified 25 Oct 2026 against `Ledger.Core/LedgerDate.cs` (old app already UTC-internal).** | — | — |

## 6. Out of scope

- Recurring entries (LLD-5) — *next milestone (LL-2); needs the entry core to exist first.*
- Budgets, import, export, dashboard — *inventory order; each has its own milestone.*
- Multi-currency (LLD-19) — *deferred at the inventory; unchanged.*

## 7. Assumptions

1. One account set (checking, savings, cash) in v1 — from the old app's fixed three.
2. The web build replaces, not accompanies, the desktop app for pilot users.

## 8. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Date handling drifts to local time | month summaries wrong at boundaries | FR-1/AC-4 boundary tests; D1 recorded |
| Tree re-parent loses entries | silent data corruption — worst class | AC-3 property-style tests before UI polish |

## 9. Evidence and references

- **Verified** 25 Oct 2026 — capability tags trace to `source-inventory.md` rows LLD-1..4; UTC
  claim vs `Ledger.Core/LedgerDate.cs` (fictional source).
- **Inferred** — "under ten seconds" entry speed is from pilot-user complaint themes, not timed
  data; kept because the form's field count is the testable part.

## 10. Implementation notes

The balance invariant owns FR-1: exactly one module computes balances; the UI never recomputes.
The plan holds paths and code.
