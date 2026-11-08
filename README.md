# omh — oh my harness

omh runs agents through a spec-driven rewrite loop: settle **what and why** in a spec, review it
on a different model, settle **how** in a plan, build it, then review and test it again on models
that never saw the build. The point is independence — the reviewer and the tester never run the
builder's model, so nobody grades their own homework.

One harness is one way of running that loop. The family shares only the laws that must never
differ between loops.

## Start here

1. **Pick a harness** from the table below — `rewapp` is the only one today.
2. **Open its README** — [`harnesses/rewapp/README.md`](harnesses/rewapp/README.md) — for the
   loop and who does what.
3. **Adopt it in a target repo:** an agent runs
   [`harnesses/rewapp/init/INIT.md`](harnesses/rewapp/init/INIT.md), answers a short
   questionnaire, and scaffolds `omh.config.yaml`, the notes tree, and a flat vendored copy at
   `omh/`.
4. **Read the shared law** before the first milestone: [`RULES.md`](RULES.md) and
   [`MODELS.md`](MODELS.md).

## Harnesses

| harness | purpose | maturity | entry |
|---|---|---|---|
| **rewapp** | rewrite an existing app to a new target — desktop→web, desktop→mobile, stack swap | v0.1.1 — shipped | [`harnesses/rewapp/README.md`](harnesses/rewapp/README.md) |

## Core idea (30 seconds)

- **Spec-driven.** What and why are settled in a spec before anything is built; how is settled in
  a plan; only then does building start. A plan a builder must guess from is a defect.
- **Model independence.** The review and test roles each run a **different model** from the
  builder's — validator-enforced, so a config that violates it will not launch.
- **Evidence.** Every non-obvious claim is labelled **Verified** or **Inferred** with its source;
  every verdict cites a test, a command output, or a `file:line`. "Looks right" is not a verdict.

## Where do I look?

| I want to… | Open |
|---|---|
| Know the binding rules | [`RULES.md`](RULES.md) |
| Configure models / understand independence | [`MODELS.md`](MODELS.md) |
| Understand the loop, gates and hard stops | [`harnesses/rewapp/HARNESS.md`](harnesses/rewapp/HARNESS.md) |
| Know what each role may and may not do | [`harnesses/rewapp/ROLES.md`](harnesses/rewapp/ROLES.md) |
| Scaffold a new project | [`harnesses/rewapp/init/INIT.md`](harnesses/rewapp/init/INIT.md) |
| Validate a config | [`tools/validate-config.sh`](tools/validate-config.sh) |
| Run the roles on a specific agent runtime | [`harnesses/rewapp/adapters/`](harnesses/rewapp/adapters/) |
| See a worked example end to end | [`harnesses/rewapp/examples/ledgerlite/`](harnesses/rewapp/examples/ledgerlite/) |

## Shared law (every harness repeats it verbatim in its own MODELS.md)

| Law | File |
|---|---|
| Binding rules: two-layer spec/plan, never-invent, evidence labels, commits, clarifications, independence | [`RULES.md`](RULES.md) |
| Model pair schema + validator contract + route-churn policy | [`MODELS.md`](MODELS.md) |
| Config validator (schema v2) + family checks | `tools/` |
| Thin skill router for runtime catalogs | [`skill/SKILL.md`](skill/SKILL.md) |

## For maintainers

**Adding a harness.** Add a directory — nothing else changes: `harnesses/<id>/` holding
`HARNESS.md` (the loop), `ROLES.md` (contracts), `MODELS.md` (shared law verbatim + its preset
tables), `templates/`, `init/INIT.md`, `adapters/`, `examples/`, `check.sh`, `VERSION`,
`README.md`. Register it in the harnesses table; `tools/check-family.sh` enforces completeness and
root purity (root docs define no role contracts or loop phases — they may reference the
role-letter convention the validator enforces).

**Provenance.** The family's first member, rewapp, was extracted from the fxpa-rust rewrite's
process — two-layer spec/plan law, phase gates, independent review on a different model,
evidence-based verdicts — which carried three milestones from spec to close (31 Oct – 7 Nov 2026).
