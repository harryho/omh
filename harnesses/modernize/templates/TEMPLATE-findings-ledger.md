# Findings ledger — <project>

<!--
One row per quirk, the day it is met. Dispositions: Deferred (the default — with a reason) or
fix-tranche (a human opened one). A resolved finding is annotated with its fix, never silently
removed. "Is this a bug?" is the human's call (E1) — B pins and asks, never fixes inline.
-->

| | |
|---|---|
| **Role** | A · `<provider>` · `<model>` · <date> |
| **Rows** | <n> — resolved <n>, deferred <n>, fix-tranche <n> |

| # | Finding (what happens) | Where met | Pinning test | Disposition | Why deferred | Date |
|---|---|---|---|---|---|---|
| F-1 | <the quirk, stated as observed behaviour> | <file / tranche> | <test name + fixture> | Deferred | <the reason the fix waits> | <date> |
| F-2 |  |  |  | fix-tranche — <link> |  |  |

A row without a pinning test is incomplete — the never-invent rule applies at full strength:
the claim traces to the test, not to a feeling. At close the row count is itself a ratchet
candidate: findings may be resolved, they may not vanish.
