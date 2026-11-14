# <RUN> — independent verification report

<!--
Authored by V at P6, launched in parallel with R pass 2. Fresh context. Blind.
-->

| | |
|---|---|
| **Role** | V · `<provider>` · `<model>` (route actually used — record any substitution) · <date> |
| **Machine** | <paths, tool versions> |

## Blind-protocol statement

**Inputs read:** the acceptance criteria list and the command block below — nothing else.
**Not read (per instruction):** the builder's evidence, the reviewer's reports, the footprint
audit, the parity census, the design narrative.

Each command was re-run by V, verbatim. Observed output is recorded; one pass/fail per command.

## Re-run record

| # | Command | Expected | Observed | Verdict |
|---|---|---|---|---|
| V1 | <build> | <criterion> |  | PASS/FAIL |
| V2 | <diff/footprint checks> |  |  |  |
| V3 | <ship + contents (inputs included)> |  |  |  |
| V4 | <probe commands — the full census probe set> |  |  |  |
| V5 | <launch> |  |  |  |

## Per-AC walk

| AC | Criterion (short) | Evidence (command + observed) | Verdict |
|---|---|---|---|
| AC-1 |  |  | PASS/FAIL |

## Tree-state guard (final)

<status after all re-runs: clean; branch; HEAD; no orphan processes.>

## Verify verdict

**PASS / FAIL** — <one line. FAIL blocks close; the failure names the command and the observed
output.>
