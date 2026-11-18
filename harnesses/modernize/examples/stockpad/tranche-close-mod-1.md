# MOD-1 — tranche close

<!--
Assembled by the orchestrator at M7 from role-produced artifacts — assembly, not authorship.
The human close gate approves this record; the loop then returns to M0.
-->

| | |
|---|---|
| **Role** | Orchestrator · `zai-anthropic` · glm-5.3 · 2026-11-18 (assembly) |
| **Tranche** | MOD-1 — pricing floor (L0 + L1 + L2 + L7) |
| **Note** | rev 2 · R pass 1: FAIL, then PASS on amendment · R pass 2: PASS · V: PASS |
| **Branch** | `tranche/mod-1` merged to `main` at 4f1c7a2 |

## Baseline table

Before → after for every recorded metric and ratchet. No blank rows.

| Metric / ratchet | Before MOD-1 | After MOD-1 |
|---|---|---|
| Line coverage (scoped, pricing package) | n/a — first recording | 31.4 % |
| Verify duration | n/a — first recording | 8.2 s (42 tests), budget 10 s |
| Console prints, pricing package | uncounted | 12 — floor set at ≤ 12 |
| Library System-exit calls | uncounted | 2 — floor set at ≤ 2 |
| Findings ledger rows | 0 | 3 — all pinned, all deferred |
| Ratchet acceptances | — | 0 |

## Commits

- `b91d0c4` mod-1: verify command green — coverage plugin and test config
- `c207e9d` mod-1: PIN-1 NAV golden pins (3 hand-computed fixtures)
- `dd84e10` mod-1: PIN-2 CSV round-trip, duplicate-ticker quirk pinned
- `ea95f33` mod-1: GATE-1/GATE-2 count gates and first ratchet floors
- `4f1c7a2` mod-1: ledgers — baseline report, findings, ratchet, traps

## Escalations fired

| Id | When | Outcome |
|---|---|---|
| E1 | 2026-11-18 — the two-calendar-formats finding needed triage | human: pin and defer (F-2); a fix tranche stays proposed, not opened |
| E3 | 2026-11-18 — benchmarks unrecordable this tranche (no module yet) | explicit empty slot in the baseline report; L6 proposed as its own tranche |

## Human close decision

Closed by Harry H., 2026-11-18. Decisions at close: F-2's fix tranche stays proposed, not
opened; no metric promoted to a ratchet; next tranche direction proposed — L6 (benchmarks in a
dedicated module), with L3 geometry pins first if the chart work lands sooner.
