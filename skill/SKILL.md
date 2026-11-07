---
name: omh
description: Run an omh-family harness — start a rewrite with rewapp, scaffold a harness into a repo, or continue a milestone. Use when the user says "start a rewrite", "scaffold omh", "run the omh pipeline", "use rewapp", or asks how a project's harness roles proceed.
---

# omh — router

This skill routes; it carries no process content (all process lives in the repo's vendored
playbook — if you find process detail here, it has drifted; delete it).

1. Look for `omh.config.yaml` in the repo root.
2. **Absent** → the repo has not adopted a harness. Show the family index (the omh repo's
   `README.md`); ask which harness; run that harness's vendored-or-upstream
   `harnesses/<id>/init/INIT.md` questionnaire.
3. **Present** → read its `harness:` field, then load — from the flat vendored copy (`omh/`) in
   an adopting repo, or `harnesses/<id>/` in the omh source repo:
   - `<harness>/HARNESS.md` — phases, gates, hard stops (where are we in the loop?)
   - `<harness>/ROLES.md` — role contracts (who does what, prohibitions)
   - `<harness>/adapters/` — how to launch each role in this runtime
   Then act as the phase's role per config (`roles:`, `gates:`), stamping every produced
   document with role · provider · model · date.

Install: copy this file to the user's skills directory (e.g. `~/.agents/skills/omh/SKILL.md`),
from the omh repo. The repo, not this file, is the source of truth.
