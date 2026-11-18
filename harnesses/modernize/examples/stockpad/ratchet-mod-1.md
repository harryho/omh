# Ratchet file — stockpad

<!--
A ratchet is a number chosen because its rise means rot. Two rules only, and they are binding:
-->

1. **Down is free.** The count may fall at any time — that is the point.
2. **Up is a decision.** A rise requires a dated acceptance in this file — who accepted, why,
   and what compensates. Without the entry, the build stays red (E4).

| | |
|---|---|
| **Role** | A · `zai-anthropic` · glm-5.3 · 2026-11-18 |

| Ratchet | What it counts | Floor (may not rise above) | First recorded | Acceptances (date · who · why) |
|---|---|---|---|---|
| console prints, pricing package | print and write calls under src/main/java/com/stockpad/pricing | ≤ 12 | 2026-11-18 (12) | none yet |
| library System-exit calls | exit calls in src/main/java, library packages (window classes excepted) | ≤ 2 | 2026-11-18 (2) | none yet |

## Metric promotion

Recorded metrics are not ratchets until a human promotes them — a floor set too early is false
comfort. The MOD-1 coverage number (31.4 %) and the verify duration (8.2 s) stay recorded in
the baseline report only; neither is promoted this tranche. A promotion is a human decision,
named and dated, recorded in this section and carried in the acceptances column like any rise.
