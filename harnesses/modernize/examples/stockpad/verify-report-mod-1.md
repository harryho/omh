# MOD-1 — independent verification report

<!--
Authored by V at M6, launched in parallel with R pass 2. Fresh context, blind: V reads the
acceptance criteria and the command block — nothing else.
-->

| | |
|---|---|
| **Role** | V · `kimi` · kimi-k2.7-code · 2026-11-18 |
| **Machine** | repo clone at `tranche/mod-1`; JDK 17; warm build |

## Blind-protocol statement

**Inputs read:** the acceptance criteria of tranche MOD-1 (rev 2) and the command block they
name — nothing else.
**Not read (per instruction):** the builder's evidence, the reviewer's verdicts, the four
ledgers' prose.

Each command was re-run by V, verbatim; every number compared against the criterion.

## Results

| Criterion | Command re-run | Expected | Observed | Match |
|---|---|---|---|---|
| AC-1 verify green, ≥ 42 tests, within the 10 s budget | `time ./mvnw -q test` | green; ≥ 42 tests; ≤ 10 s | green; 42 tests; **8.1 s** | yes — within the budget the note states; the recorded number is 8.2 s and the observation sits 0.1 s under it (near-miss to the recorded value, matched — see Mismatches) |
| AC-2 PIN-1 fails on an edited golden | edit golden/nav-halves.properties by +0.01, re-run PIN-1, revert | red, naming the edited fixture | red, naming the fixture row | yes |
| AC-3 PIN-2 asserts first-wins duplicates by name | `./mvnw -q test -Dtest=CsvImportRoundTripTest` | green; the duplicate case named in output | green; the case named | yes |
| AC-4 coverage recorded with scope rules and command | `./mvnw -q verify -Pcoverage` | a scoped number reproducible from the command | pricing rows sum to 31.4 % line | yes |
| AC-5 gate counts printed, floors match | the count commands recorded in the ratchet file | 12 and 2 on this tree | 12 and 2 | yes |
| AC-6 findings pinned, none fixed | diff the pinned production files against `main` | no production diffs | none | yes |

## Mismatches

None fired — no E5 this tranche. The AC-1 observation sits 0.1 s from the recorded number; the
criterion binds to the 10 s budget, so it is recorded as observed-and-matched rather than a
mismatch.

## Verify verdict

**PASS** — every criterion walked to an observation; close may proceed.
