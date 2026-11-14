# <PROJECT> — agent instructions

<!--
The per-project binding rules file, filled at init and named per the target repo's convention.
Keep it short and binding. It must not name any harness or runtime — this file is read by
whatever agent works the repo.
-->

## Project

<one paragraph: what this project is, what it is being upgraded from and to (stacks/runtime),
and where the work clone lives>

## Document map

| Need | File |
|---|---|
| Parity census (capabilities + inputs & contracts) | `notes/parity-census.md` |
| Design of record (what/why) | `notes/design.md` |
| Implementation plan (how, incl. declared diff footprint) | `notes/plan.md` |
| Audit / smoke / review / verify / walkthrough / close records | `notes/records/` |
| Harness config (roles, gates, checks) | `omh.config.yaml` |

## Hard rules (binding)

1. <Footprint law: "the clone may change only what the plan's declared diff footprint allows —
   anything else is reverted, re-audited, escalated">
2. <Census law: "every capability and input the original has is a census row with a disposition
   and a proof method — unknown is not a disposition">
3. <Parity law: "keep all existing features and functions as much as possible; dead-in-source
   stays dead and recorded; resurrecting one is new work, decided separately">
4. Design + census → plan → plan review → build; never commit red; one upgrade per clone/branch.
5. Commit per task, conventional messages scoped to the run.
6. Label non-obvious claims Verified or Inferred.

## Current state

- <phase status lines, updated at every gate>

## Next action

- <the single next thing, updated at every close>
