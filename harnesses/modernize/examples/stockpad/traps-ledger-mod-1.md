# Traps ledger — stockpad

<!--
Written while the scar is fresh — a trap paid twice is B's defect. Run two never rediscovers
run one. Each row names the stack-policy slot the lesson belongs to; the policy absorbs it,
and the row stays here as the project's memory of what it cost.
-->

| | |
|---|---|
| **Role** | B · `zai-anthropic` · glm-5.3-flash · 2026-11-18 |

| # | Trap (what bites) | Discovered | Workaround | Stack-policy slot |
|---|---|---|---|---|
| T-1 | coverage excludes configured as package globs silently match nothing — the scoped number stays fat | 2026-11-18 · MOD-1 | exclude by source-directory patterns in the plugin config, then re-read the coverage CSV rows to confirm the scope took | 3 — Coverage scope rules |
| T-2 | the benchmark tool refuses to run from the main application module — the measurement harness needs its own module | 2026-11-18 · MOD-1 (while costing out L6) | give benchmarks a dedicated module and keep the main module's verify command free of it | 6 — Measurement and benchmarks |
| T-3 | Swing rendering needs a headful environment — screenshot probes crash a headless CI runner | 2026-11-18 · MOD-1 (planning L5) | run UI probes under a virtual display (xvfb) on CI; locally they run headful | 7 — UI and render probes |
