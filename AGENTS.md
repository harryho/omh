# omh — agent instructions

**omh ("oh my harness")** — a family of named agent harnesses; each member is one way of running
agents through a spec-driven loop. This repo dogfoods itself: its process docs are the product.

Keep this file short and binding. Depth lives in the documents below — read the one you need.

## Document map

| Need | File |
|---|---|
| Family index: which harnesses exist, adopting one, adding one | [README.md](README.md) |
| Shared law: binding rules (two-layer, never-invent, evidence) | [RULES.md](RULES.md) |
| Shared law: model pairs, validator contract | [MODELS.md](MODELS.md) |
| rewrite: pipeline, roles, templates, init, example | [harnesses/rewrite/README.md](harnesses/rewrite/README.md) |
| Config validator + family checks | [tools/validate-config.sh](tools/validate-config.sh) |
| Skill router | [skill/SKILL.md](skill/SKILL.md) |
| A worked spec → plan → review → test → close set | [harnesses/rewrite/examples/ledgerlite/](harnesses/rewrite/examples/ledgerlite/) |

## Hard rules (binding)

1. **Two-layer law.** Design/what-why lives in a spec; exact files, contents and steps live in a
   plan. Never mix. In a project running omh those are `notes/specs/SPEC-*.md` and
   `notes/specs/plans/*-plan.md`.
2. **Spec → plan → human approval → build.** One milestone per objective.
3. **Decisions are contracts.** A decision that changes is edited in place with a date — never
   silently replaced by a different default. Preset rows live in each harness's `MODELS.md`.
4. **Independence constraint** (validator-enforced, no exceptions without a dated register entry):
   the review/test roles must each run a model different from the build role's.
5. **Commit per task**, conventional commits scoped to the milestone. `main` is the only branch
   until a remote exists.
6. **Label non-obvious claims** verified or inferred; the critical fact is inlined, references
   accompany it.
7. **Root purity:** root docs define no role contracts or loop phases; harness-specific content
   lives under `harnesses/<id>/` (enforced by `tools/check-family.sh`).

Internal working notes live in `notes/` and are git-ignored — they are not part of the shipped
harness.

## If you are here to adopt omh

Start at [README.md](README.md) → pick a harness → run its `init/INIT.md` in the target repo.
