# MOD-1 — tranche note (pricing floor: verify command, NAV goldens, CSV round-trip, count gates)

<!--
Authored by A at M2 from the direction gate's decision of 2026-11-17. This file is revision 2:
amended the same day after R pass 1 FAILed the draft — the two command-less metric rows were
dropped and the scope was itemized to exact files (see review-r1-plan-mod-1.md).
-->

| | |
|---|---|
| **Role** | A · `zai-anthropic` · glm-5.3 · 2026-11-17 (rev 2) |
| **Tranche** | MOD-1 — first rung of the ladder: make the tree verifiable |
| **Rungs** | L0 (verify command) + L1 (NAV oracle pins) + L2 (CSV round-trip) + L7 (count gates) |
| **Direction decision** | 2026-11-17, Harry H. — pin the pricing floor first; the UI and the benchmarks are explicitly out of scope; no finding gets fixed this tranche |
| **Ledgers as they stand** | empty at M0 — MOD-1 creates all four under notes/baseline/ |

**Goal:** the pricing package is pinned against hand-computed goldens and a round-tripped
import format, the verify command is the one green gate under a duration budget, and the first
two count ratchets exist — behaviour unchanged, branch `tranche/mod-1`.

## Declared scope

The exact paths B may touch — anything else is E6: hard stop, unwind, re-verify.

| Path | Why it is in scope |
|---|---|
| pom.xml | coverage plugin and test config behind the verify command |
| src/main/java/com/stockpad/pricing/NavCalculator.java | PIN-1's subject — no production diff expected; edits only if a pin proves drift |
| src/main/java/com/stockpad/pricing/CsvImporter.java | PIN-2's subject — no production diff expected |
| src/main/java/com/stockpad/pricing/ConsoleReport.java | GATE-1 counts its console prints |
| src/test/java/com/stockpad/pricing/NavCalculatorGoldenTest.java | PIN-1 |
| src/test/java/com/stockpad/pricing/CsvImportRoundTripTest.java | PIN-2 |
| src/test/java/com/stockpad/pricing/SmellCountGateTest.java | GATE-1 + GATE-2 |
| src/test/resources/golden/nav-personal.properties | PIN-1 hand-computed fixture |
| src/test/resources/golden/nav-joint.properties | PIN-1 hand-computed fixture |
| src/test/resources/golden/nav-halves.properties | PIN-1 rounding-edge fixture |
| src/test/resources/fixtures/holdings-dup.csv | PIN-2 duplicate-ticker quirk fixture |
| src/test/resources/fixtures/holdings-clean.csv | PIN-2 round-trip fixture |

**Explicitly untouched:** everything under src/main/java/com/stockpad/ outside the pricing
package; the Swing window classes; the build scripts. These must show zero diff.

## Pins planned

| Pin | What it proves | Proof method or command | Rung |
|---|---|---|---|
| PIN-1 | portfolio NAV equals three hand-computed golden files (2-decimal cent arithmetic) | `./mvnw -q test -Dtest=NavCalculatorGoldenTest` | L1 |
| PIN-2 | CSV import round-trips a clean holdings file, and duplicate tickers keep the FIRST row — quirk pinned, not fixed | `./mvnw -q test -Dtest=CsvImportRoundTripTest` | L2 |
| GATE-1 | console prints in the pricing package are counted — first floor 12 | the count command recorded in the ratchet file, asserted green by SmellCountGateTest | L7 |
| GATE-2 | library System-exit calls are counted — first floor 2 | the same mechanism, second counter | L7 |

No independent oracle exists for the import module's date parsing beyond the round-trip itself
— recorded as unpinned (E2), see the findings ledger.

## Metrics to record

| Metric | Command that records it | Where it lands |
|---|---|---|
| Line coverage, pricing package only, exclusions per the baseline report's scope rules | `./mvnw -q verify -Pcoverage` → coverage CSV, rows of the pricing package | baseline report, Recorded metrics |
| Verify duration (build + full test suite) | `time ./mvnw -q test` — budget 10 s | baseline report + the config budget |

(Branch coverage and a benchmark table were drafted in rev 1 without the commands that record
them — dropped at R pass 1; they return in a later tranche with mechanisms chosen.)

## Acceptance criteria

Each criterion judgeable by a non-author from an observation, not an opinion.

1. `./mvnw -q test` runs green with 42 or more tests and finishes within the 10 s budget.
2. PIN-1 fails if any golden fixture value is edited by 0.01 or more (demonstrated once on the
   tranche branch, then reverted).
3. PIN-2 passes and asserts by name that a duplicate ticker keeps the FIRST occurrence.
4. The baseline report records the scoped coverage number with its scope rules and the exact
   command that produced it.
5. GATE-1 and GATE-2 print their counts on this tree, and the ratchet file's floors match them.
6. Every finding met during the tranche is a findings-ledger row with a pinning test — zero
   findings fixed in MOD-1.

## Appendix — Clarifications (B → A)

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|
| 1 | May I add a test-only dependency for golden-file assertions? | No new dependencies in MOD-1 — hand-rolled assertions in the test tree; the pom change stays confined to coverage and test config | 2026-11-17 | Declared scope (pom.xml) |
| 2 | The CSV fixture's date column mixes two calendar formats — normalize in the importer, or pin as-is? | Pin as-is and open a finding; normalizing is human triage (E1), never an inline fix | 2026-11-18 | Pins planned (PIN-2), findings ledger |
