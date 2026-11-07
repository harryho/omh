# omh — oh my harness

A family of named agent harnesses. Each member is one way of running agents through a
spec-driven loop; the family shares the laws that must never differ between loops, and nothing
else. A project picks its harness by name — `harness: <id>` in `omh.config.yaml` — and the
skill router loads exactly that one.

## Harnesses

| harness | purpose | maturity | entry |
|---|---|---|---|
| **rewapp** | rewrite an existing app to a new target — desktop→web, desktop→mobile, stack swap | v0.1.1 — shipped | `harnesses/rewapp/README.md` |

## Shared law (every harness repeats it verbatim in its own MODELS.md)

| Law | File |
|---|---|
| Binding rules: two-layer spec/plan, never-invent, evidence labels, commits, clarifications, independence | `RULES.md` |
| Model pair schema + validator contract + route-churn policy | `MODELS.md` |
| Config validator (schema v2) + family checks | `tools/` |
| Thin skill router for runtime catalogs | `skill/SKILL.md` |

## Quickstart (adopting a harness)

1. An agent runs the chosen harness's `init/INIT.md` questionnaire in the target repo.
2. It scaffolds `omh.config.yaml` (`omh: v2` + `harness: <id>` + roles + gates), the notes tree,
   and a **flat** vendored copy at `omh/` — no family nesting ever appears in an adopting repo.
3. The project runs on the vendored copy; the shared validator is its model gate.

## Adding a harness

Add a directory — nothing else changes: `harnesses/<id>/` holding `HARNESS.md` (the loop),
`ROLES.md` (contracts), `MODELS.md` (shared law verbatim + its preset tables), `templates/`,
`init/INIT.md`, `adapters/`, `examples/`, `check.sh`, `VERSION`, `README.md`. Register it in the
table above; `tools/check-family.sh` enforces completeness and root purity (root docs define no
role contracts or loop phases — they may reference the role-letter convention the validator
enforces).

## Provenance

The family's first member, rewapp, was extracted from the fxpa-rust rewrite's process —
two-layer spec/plan law, phase gates, independent review on a different model, evidence-based
verdicts — which carried three milestones from spec to close (31 Oct – 7 Nov 2026).
