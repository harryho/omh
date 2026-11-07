---
name: omh
description: Run the omh rewrite pipeline — start a rewrite, scaffold omh into a repo, or continue a milestone under the omh harness. Use when the user says "start a rewrite", "scaffold omh", "run the omh pipeline", or asks how the A/B/C/D/E roles proceed.
---

# omh — router

This skill routes; it carries no process content (all process lives in the repo's vendored
playbook — if you find process detail here, it has drifted; delete it).

1. Look for `omh.config.yaml` in the repo root.
2. **Absent** → the repo has not adopted omh. Run the vendored-or-upstream `init/INIT.md`
   procedure (questionnaire → config → scaffold → "run role A on M0").
3. **Present** → read `omh/VERSION` (the vendored snapshot), then load, from the vendored copy:
   - `HARNESS.md` — phases, gates, escalations (where are we in the loop?)
   - `ROLES.md` — role contracts (who does what, prohibitions)
   - `adapters/DSH.md` — how to launch each role in this runtime
   Then act as the phase's role per config (`roles:`, `gates:`), stamping every produced
   document with role · provider · model · date.

Install: copy this file to the user's skills directory (e.g. `~/.agents/skills/omh/SKILL.md`),
from the omh repo. The repo, not this file, is the source of truth.
