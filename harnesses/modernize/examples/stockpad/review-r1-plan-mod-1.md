# MOD-1 — tranche-note review (R pass 1)

<!--
Authored by R at M3, before any build. Read order was anti-anchoring: HARNESS (ladder +
baseline contract) and the ledgers first — empty at M0 — then the checklist below, then the
note draft. One model across both passes by design.
-->

| | |
|---|---|
| **Role** | R · `mimo` · mimo-v2.6-pro · 2026-11-17 |
| **Note reviewed** | `notes/tranches/tranche-note-mod-1.md` — draft rev 1 |
| **Ledgers read first** | notes/baseline/ — empty; MOD-1 creates all four |

## Review method

Read HARNESS (the ladder and the baseline contract), confirmed the ledgers are empty (no
duplicate-pin risk, no prior findings), derived the checklist — only then opened the draft.

## Checklist (derived before reading the note)

1. Every planned pin has a proof method or command A can judge. 2. Pins cover their claimed
rungs and duplicate no ledger row. 3. Every metric row carries the command that records it.
4. Scope is exact files — a directory is not a scope; the M5 audit must be judgeable against
it. 5. Acceptance criteria judgeable by a non-author. 6. Out-of-scope explicit.

## Pin audit

| Pin | Proof method present | Rung covered | Duplicates a ledger row? | Verdict |
|---|---|---|---|---|
| PIN-1 | yes — golden-test command | L1 | n/a (empty ledger) | OK |
| PIN-2 | yes — round-trip test command | L2 | n/a | OK |
| GATE-1 | yes — count command + gate test | L7 | n/a | OK |
| GATE-2 | yes — second counter, same mechanism | L7 | n/a | OK |

The pin audit passes: every planned pin has a proof, covers its rung, duplicates nothing.

## Checks

| Check | Verdict |
|---|---|
| Metric rows carry recording commands | **DEFECT — 2 of 4 rows command-less** |
| Scope is exact files | **DEFECT — two whole directories declared** |
| Acceptance criteria judgeable by a non-author | OK |
| Out-of-scope explicit | OK |

## Findings

### D1: two metrics have no command that records them

The metrics table lists branch coverage and a total test count without the command that
records either. HARNESS: a number without its command is a rumour; ROLES: A never leaves a
planned metric without its recording command. **Blocking.**

### D2: scope declares directories, not files

The pricing package directory and the whole test tree are declared wholesale. The E6 hard stop
is unenforceable against a directory — the M5 audit needs the exact file set to be judgeable.
**Blocking.**

## Verdict

**FAIL** — returned to A 2026-11-17. Build blocked until D1 and D2 are amended.

---

## Re-review — 2026-11-17 (same model across both passes)

A amended the note to rev 2 the same day: the two command-less metric rows are dropped (branch
coverage and the benchmark table return in a later tranche with mechanisms chosen — recorded in
the note's metrics section), and the scope is itemized to the exact file set, including the
three golden fixtures and the two CSV fixtures.

Re-checked against the same checklist: D1 resolved — every remaining metric row carries its
command; D2 resolved — the audit can now diff the exact file set. The pin audit is unchanged
and still passes. Acceptance criteria and the out-of-scope rows are unchanged and still OK.

**Verdict: PASS** — build authorized on rev 2, 2026-11-17.
