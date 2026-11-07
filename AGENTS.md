# omh — agent instructions

**omh ("oh my harness")** — a family of named agent harnesses; each member is one way of running
agents through a spec-driven loop. This repo dogfoods itself: its process docs are the product.

Keep this file short and binding. Depth lives in the documents below — read the one you need.

## Document map

| Need | File |
|---|---|
| Family index: which harnesses exist, adding one | [README.md](README.md) |
| Founding design (v0.1): roles, pipeline, gates, decisions D1–D12 | [notes/specs/SPEC-OMH-0-harness-design.md](notes/specs/SPEC-OMH-0-harness-design.md) |
| Family design (v0.1.1): harness family, flat vendoring | [notes/specs/SPEC-OMH-1-harness-family.md](notes/specs/SPEC-OMH-1-harness-family.md) |
| Shared law: binding rules (two-layer, never-invent, evidence) | [RULES.md](RULES.md) |
| Shared law: model pairs, validator contract | [MODELS.md](MODELS.md) |
| rewapp: pipeline, roles, templates, init, example | `harnesses/rewapp/` |
| Config validator + family checks | `tools/` |
| Skill router | `skill/SKILL.md` |
| Specs / plans / reviews / evidence | `notes/` |

## Hard rules (binding)

1. **Two-layer law applies to omh's own docs.** Design/what-why in `notes/specs/SPEC-*.md`; exact
   files, contents and steps in `notes/specs/plans/*-plan.md`. Never mix.
2. **Spec → plan → Harry approval → build.** One milestone per objective.
3. **The decisions registers (SPEC-OMH-0 §5 D1–D12; SPEC-OMH-1 §5) are contracts.** Changing one
   means editing the register with a date — never silently picking a different default.
4. **Independence constraint** (validator-enforced, no exceptions without a dated register entry):
   the review/test roles must each run a model different from the build role's.
5. **Commit per task**, conventional commits scoped to the milestone. `main` is the only branch
   until a remote exists.
6. **Label non-obvious claims** verified or inferred; the critical fact is inlined, references
   accompany it.
7. **Root purity:** root docs define no role contracts or loop phases; harness-specific content
   lives under `harnesses/<id>/` (enforced by `tools/check-family.sh`).

## Current state

- **OMH-0 CLOSED (7 Nov 2026)** — rewapp v0.1 shipped (spec Shipped; AC-6/AC-7 manual readings
  with Harry). Restructured into the family layout by OMH-1 → rewapp v0.1.1.
- **OMH-1 (harness family) — building 7 Nov 2026**: git mv done, schema v2 live, routers updated;
  dry-run evidence and close next.
- Next after close: **OMH-2 — first real adoption** (full loop incl. C and E on a second real
  repo). `omh upgrade`/re-sync stays deferred.
