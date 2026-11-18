# <PROJECT> — agent instructions

<!--
The per-project binding rules file, filled at init and named per the target repo's convention.
Keep it short and binding. It must not name any harness or runtime — this file is read by
whatever agent works the repo.
-->

## Project

<one paragraph: what this project is, its runtime and build, and where the baseline ledgers
live>

## Document map

| Need | File |
|---|---|
| Baseline report (behaviour pins + recorded metrics) | `notes/baseline/baseline-report.md` |
| Findings ledger | `notes/baseline/findings-ledger.md` |
| Ratchet file | `notes/baseline/ratchet.md` |
| Traps ledger | `notes/baseline/traps-ledger.md` |
| Tranche notes, reviews, verify reports, closes | `notes/tranches/` |
| Harness config (roles, gates, checks) | `omh.config.yaml` |

## Hard rules (binding)

1. <Verify law: "the verify command is the primary gate — a tranche that leaves it red, or
   slower than its recorded budget, is not done">
2. <Pin law: "a quirk is pinned the day it is met; the fix is a separate, human-opened
   decision — never an inline change">
3. <Scope law: "a tranche changes only the files its note declares — one file more is a hard
   stop, not a negotiation">
4. <Ratchet law: "a count may fall freely; a rise needs a dated acceptance in the ratchet
   file">
5. Commit per task, conventional messages scoped to the tranche; never commit red.
6. Label non-obvious claims Verified or Inferred.

## Current state

- <tranche status lines, updated at every gate>

## Next action

- <the single next thing, updated at every close>
