# Findings ledger — stockpad

<!--
One row per quirk, the day it is met. Dispositions: Deferred (the default — with a reason) or
fix-tranche (a human opened one). A resolved finding is annotated with its fix, never silently
removed. "Is this a bug?" is the human's call — B pins and asks, never fixes inline.
-->

| | |
|---|---|
| **Role** | A · `zai-anthropic` · glm-5.3 · 2026-11-18 |
| **Rows** | 3 — resolved 0, deferred 3, fix-tranche 0 |

| # | Finding (what happens) | Where met | Pinning test | Disposition | Why deferred | Date |
|---|---|---|---|---|---|---|
| F-1 | CSV import with duplicate ticker rows keeps the FIRST occurrence and silently drops the rest | CsvImporter, met while building PIN-2 | CsvImportRoundTripTest · fixtures/holdings-dup.csv | Deferred | behaviour users may already rely on; changing it is a product decision | 2026-11-18 |
| F-2 | date parsing silently accepts two calendar formats in the date column | CsvImporter, met while building PIN-2 (clarification #2) | CsvImportRoundTripTest · fixtures/holdings-dup.csv | Deferred — fix-tranche proposed | pinned first; normalizing alters imported results and needs human triage | 2026-11-18 |
| F-3 | NAV rounds half-up while the display rounds half-even — a one-cent mismatch on exact halves | NavCalculator vs ConsoleReport, met while building PIN-1 | NavCalculatorGoldenTest · golden/nav-halves.properties | Deferred | display-side fix candidates differ; a human decides which side is correct | 2026-11-18 |
