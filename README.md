# omh — oh my harness

omh runs agents through a spec-driven rewrite loop: settle **what and why** in a spec, review it
on a different model, settle **how** in a plan, build it, then review and test it again on models
that never saw the build. The point is independence — the reviewer and the tester never run the
builder's model, so nobody grades their own homework.

One harness is one way of running that loop. The family shares only the laws that must never
differ between loops.

## Start here

1. **Pick a harness** from the table below — `rewrite` and `upgrade` today.
2. **Open its README** — [`harnesses/rewrite/README.md`](harnesses/rewrite/README.md) or
   [`harnesses/upgrade/README.md`](harnesses/upgrade/README.md) — for the
   loop and who does what.
3. **Adopt it in a target repo:** an agent runs the harness's `init/INIT.md`
   ([rewrite](harnesses/rewrite/init/INIT.md) ·
   [upgrade](harnesses/upgrade/init/INIT.md)), answers a short
   questionnaire, and scaffolds `omh.config.yaml`, the notes tree, and a flat vendored copy at
   `omh/`. The copy is committed or gitignored (`vendoring: commit | ignore`, default
   **ignore**) — either way the version pin stays committed, so the record of which process
   ran survives. The copy is committed or gitignored (`vendoring: commit | ignore`, default
   **ignore**) — either way the version pin stays committed, so the record of which process
   ran survives.
4. **Read the shared law** before the first milestone: [`RULES.md`](RULES.md) and
   [`MODELS.md`](MODELS.md).

## Harnesses

| harness | purpose | maturity | entry |
|---|---|---|---|
| **rewrite** | rewrite an existing app to a new target — desktop→web, desktop→mobile, stack swap | v0.1.1 — shipped | [`harnesses/rewrite/README.md`](harnesses/rewrite/README.md) |
| **upgrade** | upgrade an existing app or system in place to a newer LTS/runtime — behaviour-preserving, diff footprinted, parity censused | v0.1.0 — scaffold | [`harnesses/upgrade/README.md`](harnesses/upgrade/README.md) |

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
| Understand the rewrite loop | [`harnesses/rewrite/HARNESS.md`](harnesses/rewrite/HARNESS.md) |
| Understand the upgrade loop | [`harnesses/upgrade/HARNESS.md`](harnesses/upgrade/HARNESS.md) |
| Pick the right stack mechanism for an upgrade | [`harnesses/upgrade/stacks/`](harnesses/upgrade/stacks/) |
| Know what each role may and may not do | [`harnesses/rewrite/ROLES.md`](harnesses/rewrite/ROLES.md) · [`harnesses/upgrade/ROLES.md`](harnesses/upgrade/ROLES.md) |
| Scaffold a new project | [`harnesses/rewrite/init/INIT.md`](harnesses/rewrite/init/INIT.md) · [`harnesses/upgrade/init/INIT.md`](harnesses/upgrade/init/INIT.md) |
| Validate a config | [`tools/validate-config.sh`](tools/validate-config.sh) |
| Run the roles on a specific agent runtime | [`harnesses/rewrite/adapters/`](harnesses/rewrite/adapters/) · [`harnesses/upgrade/adapters/`](harnesses/upgrade/adapters/) |
| See a worked example end to end | [`harnesses/rewrite/examples/ledgerlite/`](harnesses/rewrite/examples/ledgerlite/) · [`harnesses/upgrade/examples/stockplot/`](harnesses/upgrade/examples/stockplot/) |

## Shared law (every harness repeats it verbatim in its own MODELS.md)

| Law | File |
|---|---|
| Binding rules: two-layer spec/plan, never-invent, evidence labels, commits, clarifications, independence | [`RULES.md`](RULES.md) |
| Model pair schema + validator contract + route-churn policy | [`MODELS.md`](MODELS.md) |
| Config validator (schema v3) + family checks | `tools/` |
| Thin skill router for runtime catalogs | [`skill/SKILL.md`](skill/SKILL.md) |

## For maintainers

**Adding a harness.** Add a directory — nothing else changes: `harnesses/<id>/` holding
`HARNESS.md` (the loop), `ROLES.md` (contracts), `MODELS.md` (shared law verbatim + its preset
tables), `templates/`, `init/INIT.md`, `adapters/`, `examples/`, `check.sh`, `VERSION`,
`README.md`. Register it in the harnesses table; `tools/check-family.sh` enforces completeness and
root purity (root docs define no role contracts or loop phases — they may reference the
role-letter convention the validator enforces).
