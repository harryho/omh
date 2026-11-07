# <PROJECT> — agent instructions

<!--
The per-project binding rules file, filled at init and named per the target repo's convention.
Keep it short and binding. It must not name any harness or runtime — this file is read by
whatever agent works the repo.
-->

## Project

<one paragraph: what this project is, what is being rewritten into what, target platforms>

## Document map

| Need | File |
|---|---|
| Scope contract (capabilities + dispositions) | `notes/source-inventory.md` |
| Milestone specs (what/why) | `notes/specs/SPEC-M<N>-*.md` |
| Implementation plans (how) | `notes/specs/plans/M<N>-plan.md` |
| Review + test reports | `notes/reviews/` |
| Harness config (roles, gates, checks) | `omh.config.yaml` |

## Hard rules (binding)

1. <Rule from the source contract — e.g. "never invent parity: behaviour claims trace to the
   inventory or are marked NEW">
2. <Architecture rules that bind every milestone — e.g. layering, single-owner rules>
3. <Verification-first rules — e.g. "reference outputs frozen before implementation code">
4. Spec → plan → approval gate → build; one milestone per objective.
5. Commit per task, conventional messages scoped to the milestone.
6. Label non-obvious claims Verified or Inferred.

## Current state

- <milestone status lines, updated at every close>

## Next action

- <the single next thing, updated at every close>
