# Baseline report — stockpad

<!--
The standing record, created by MOD-1 and maintained every tranche. A owns it editorially;
V re-runs every command blind at M6. Every number carries its scope, its command and its
provenance — a number without them is a rumour with a decimal point.
-->

| | |
|---|---|
| **Role** | A · `zai-anthropic` · glm-5.3 · 2026-11-18 |
| **Ledger location** | notes/baseline/ |
| **Verify command** | `./mvnw -q test` — budget 10 s |

## Scope rules

What counts as the application's own code for every number below — each exclusion carries its
reason. The mechanism is the stack policy's; these are the project's decisions within it.

| Included | Excluded | Reason |
|---|---|---|
| src/main/java/com/stockpad/pricing/** | src/main/java/com/stockpad/** outside the pricing package | MOD-1 pinned the pricing floor only — the number describes what is pinned, nothing more |
|  | generated sources (the target tree, annotation-processor output) | not hand-written logic; regenerates every build |
|  | the Swing window classes | the UI layer is unpinned this tranche (L5 deferred) |
|  | test code itself | the number measures the library, not the tests |

## Behaviour pins

| Pin | What it proves | Reproduce command |
|---|---|---|
| PIN-1 | portfolio NAV equals three hand-computed golden files (2-decimal cent arithmetic) | `./mvnw -q test -Dtest=NavCalculatorGoldenTest` |
| PIN-2 | CSV import round-trips a clean holdings file; duplicate tickers keep the FIRST row — quirk pinned, not fixed | `./mvnw -q test -Dtest=CsvImportRoundTripTest` |

## Recorded metrics

| Metric | Value | Date | Reproduce command | Machine/dataset provenance |
|---|---|---|---|---|
| Line coverage, pricing package (scoped per the rules above) | 31.4 % | 2026-11-18 | `./mvnw -q verify -Pcoverage` → coverage CSV, pricing rows | dev laptop, Linux x64; fixtures: 3 golden NAV files + 2 CSV fixtures; warm build |
| Verify duration (build + full test suite) | 8.2 s (42 tests) | 2026-11-18 | `time ./mvnw -q test` | same machine, warm; budget 10 s |

## Empty slots

| Slot | Reason | Compensating check |
|---|---|---|
| Benchmarks (L6) | no benchmark module exists yet; adding one is build configuration beyond MOD-1's scope — proposed as its own tranche | none needed this tranche — recorded deliberately; the gap is visible, not silent |
| UI and render probes (L5) | deferred with the direction decision; the headful-environment constraint is recorded in the traps ledger first | the human launches the app at close as an informal check |
