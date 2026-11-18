# MOD-<n> — independent verification report

<!--
Authored by V at M6, launched in parallel with R pass 2. Fresh context, blind: V reads the
acceptance criteria and the command block — nothing else.
-->

| | |
|---|---|
| **Role** | V · `<provider>` · `<model>` · <date> |
| **Machine** | <paths, tool versions> |

## Blind-protocol statement

**Inputs read:** the acceptance criteria and the command block — nothing else.
**Not read (per instruction):** the builder's evidence, the reviewer's verdicts, the ledgers'
prose.

Each command was re-run by V, verbatim; every number compared against the criterion.

## Results

| Criterion | Command re-run | Expected | Observed | Match |
|---|---|---|---|---|
| AC-<n> <short> | <exact command> | <what the criterion promises> | <what V saw> | yes/no |

## Mismatches

<A mismatch is E5: reported as found — the criterion, the command, the observed output.
Cause-chasing is not V's job; the mismatch and its cause land in the traps ledger when the
tranche returns to M4. An observation near a recorded number is judged against the criterion's
stated budget or tolerance, and documented either way.>

## Verify verdict

**PASS / FAIL** — <one line. FAIL blocks close; the failure names the criterion, the command
and the observed output.>
