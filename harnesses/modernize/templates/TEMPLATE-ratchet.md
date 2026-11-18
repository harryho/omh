# Ratchet file — <project>

<!--
A ratchet is a number chosen because its rise means rot: legacy smell counts, wildcard
versions, console writes in library code, names that must never appear. Two rules only, and
they are binding:
-->

1. **Down is free.** The count may fall at any time — that is the point.
2. **Up is a decision.** A rise requires a dated acceptance in this file — who accepted, why,
   and what compensates. Without the entry, the build stays red (E4).

| | |
|---|---|
| **Role** | A · `<provider>` · `<model>` · <date> |

| Ratchet | What it counts | Floor (may not rise above) | First recorded | Acceptances (date · who · why) |
|---|---|---|---|---|
| <name> | <the smell counted, and where> | ≤ <n> | <date> (<n>) | none yet |
| <name> |  | ≤ <n> |  | <date · who · why — and what compensates> |

## Metric promotion

Recorded metrics (coverage, benchmark numbers) are not ratchets until a human promotes them —
a floor set too early is false comfort. A baseline-report number becomes a row above only by a
human decision, named and dated, recorded here; the acceptance column carries it like any
rise. Until then the number lives in the baseline report, visible but not policed.
