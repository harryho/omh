# MOD-<n> — diff review (R pass 2)

<!--
Authored by R at M6, in parallel with V. Reads the approved note, then the branch diff — never
B's evidence or V's report. One model across both passes by design: the same reviewer saw the
promise and now sees the delivery.
-->

| | |
|---|---|
| **Role** | R · `<provider>` · `<model>` · <date> |
| **Note** | <link — the approved revision> |
| **Diff** | <branch + range> |

## Scope audit

Only the declared scope touched — anything else is E6, a hard stop:

| Declared file | Touched | Match |
|---|---|---|
| <path> | yes/no | OK |

<Extra files found in the diff: none — or itemized, each with a minor/major judgement.>

## Pin and ledger checks

| Check | Verdict |
|---|---|
| Every planned pin present and green | OK / DEFECT |
| Every ledger row traceable to a pin | OK / DEFECT |
| No inline finding fixes smuggled in (E1) | OK / DEFECT |
| Ratchet counts untouched — or a dated acceptance exists | OK / DEFECT |

## Deviations

<Minor deviations R self-accepts are logged here with the reason; anything major or blocker is
a numbered defect, not a deviation.>

## Verdict

**PASS / FAIL** — <one line. FAIL blocks close.>
