# MOD-1 — diff review (R pass 2)

<!--
Authored by R at M6, in parallel with V. Reads the approved note, then the branch diff — never
B's evidence or V's report. One model across both passes by design.
-->

| | |
|---|---|
| **Role** | R · `mimo` · mimo-v2.6-pro · 2026-11-18 |
| **Note** | `notes/tranches/tranche-note-mod-1.md` — rev 2, approved 2026-11-17 |
| **Diff** | branch `tranche/mod-1` vs `main` |

## Scope audit

Only the declared scope touched — anything else is E6, a hard stop.

| Declared file | Touched | Match |
|---|---|---|
| pom.xml | yes — coverage plugin and test config | OK |
| src/main/java/com/stockpad/pricing/NavCalculator.java | no production diff | OK |
| src/main/java/com/stockpad/pricing/CsvImporter.java | no production diff | OK |
| src/main/java/com/stockpad/pricing/ConsoleReport.java | untouched | OK |
| src/test/java/com/stockpad/pricing/NavCalculatorGoldenTest.java | new | OK |
| src/test/java/com/stockpad/pricing/CsvImportRoundTripTest.java | new | OK |
| src/test/java/com/stockpad/pricing/SmellCountGateTest.java | new | OK |
| src/test/resources/golden/nav-personal.properties | new | OK |
| src/test/resources/golden/nav-joint.properties | new | OK |
| src/test/resources/golden/nav-halves.properties | new | OK |
| src/test/resources/fixtures/holdings-dup.csv | new | OK |
| src/test/resources/fixtures/holdings-clean.csv | new | OK |

Extra files found in the diff: one — `src/test/java/com/stockpad/pricing/support/TextTableProbe.java`,
a test helper used by PIN-1's assertion output. It sits inside the declared test tree and
carries no production behaviour; the note under-listed it. Judged minor (see Deviations).

## Pin and ledger checks

| Check | Verdict |
|---|---|
| Every planned pin present and green | OK — PIN-1, PIN-2, GATE-1, GATE-2 all in the diff and green |
| Every ledger row traceable to a pin | OK — findings F-1, F-2, F-3 each cite a pinning test present in the diff |
| No inline finding fixes smuggled in (E1) | OK — CsvImporter shows no production diff |
| Ratchet counts untouched, or a dated acceptance exists | OK — first floors only; no rises, no acceptances |

## Deviations

| Deviation | Judgement |
|---|---|
| TextTableProbe.java — test helper inside the declared test tree, not itemized in the note | Minor — self-accepted and logged here; next tranche's note itemizes helpers too |

## Verdict

**PASS** — the delivery matches the promise; close may proceed.
