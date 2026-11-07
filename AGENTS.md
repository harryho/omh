# omh — agent instructions

**omh ("oh my harness")** — a generic, agent-agnostic rewrite harness extracted from the fxpa-rs
process. This repo dogfoods itself: its process docs are the product.

Keep this file short and binding. Depth lives in the documents below — read the one you need.

## Document map

| Need | File |
|---|---|
| What omh is, adoption quickstart | `README.md` (OMH-0 deliverable) |
| Founding design: roles, pipeline, gates, presets, decisions D1–D12 | [notes/specs/SPEC-OMH-0-harness-design.md](notes/specs/SPEC-OMH-0-harness-design.md) |
| Pipeline phases, entry/exit, escalations | `HARNESS.md` (OMH-0 deliverable) |
| Role contracts A–E + human | `ROLES.md` (OMH-0 deliverable) |
| Generic hard rules (two-layer, never-invent, evidence labels) | `RULES.md` (OMH-0 deliverable) |
| Model presets, independence constraints, validator | `MODELS.md` (OMH-0 deliverable) |

## Hard rules (binding)

1. **Two-layer law applies to omh's own docs.** Design/what-why in `notes/specs/SPEC-*.md`; exact
   files, contents and steps in `notes/specs/plans/*-plan.md`. Never mix.
2. **Spec → plan → Harry approval → build.** No product file beyond the founding spec exists until
   the OMH-0 plan is approved. One milestone per goal.
3. **The decisions register (SPEC-OMH-0 §5, D1–D12) is the contract.** Changing one means editing
   the register with a date — never silently picking a different default.
4. **Independence constraint** (validator-enforced, no exceptions without a dated register entry):
   roles C, D, E must each run a model different from B's.
5. **Commit per task**, conventional commits scoped to the milestone (`docs(omh0): …`,
   `feat(omh0): …`). `main` is the only branch until a remote exists.
6. **Label non-obvious claims** verified or inferred. A reference to the fxpa-rs origin of a rule
   accompanies the inlined rule; it never replaces it.

## Current state

- **OMH-0 CLOSED (7 Nov 2026)** — omh v0.1 shipped; spec **Shipped**; close note
  `notes/specs/plans/OMH-0-close.md`. Machine ACs 1–5 evidenced; AC-6/AC-7 are Harry's manual
  readings (open handoff).
- The playbook is live: HARNESS/ROLES/RULES/MODELS, nine templates, init questionnaire, DSH
  adapter, skill wrapper, LedgerLite worked example (includes an honest round-1 FAIL).
- Next action: **OMH-1 — first real adoption** — run the full loop (C and E included) on a
  second real repo; spec written at pipeline P1 entry. `omh upgrade` stays deferred.
