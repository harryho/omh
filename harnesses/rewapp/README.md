# rewapp — the app-rewrite harness

First member of the **omh** harness family ("oh my harness"). A runtime-neutral rewrite harness:
the process, roles, templates, and checks a rewrite needs — desktop→web, desktop→mobile, or a
stack swap — extracted from a rewrite that worked (the fxpa-rs project ran M0–M3 under this
process: built, independently reviewed, closed).

Five accountable roles instead of one agent improvising: **A** writes spec + plan, **B** builds
(asking A, never guessing), **C** reviews the spec+plan before any code exists, **D** reviews
the built code after, **E** tests independently from the spec alone. C, D, E never share B's
model — the config validator refuses a setup where they would.

```
        ┌────────┐  spec/plan   ┌────────┐
        │  A     │ ───────────► │  C     │ review before build
        │ author │              │ check  │
        └───┬────┘              └────────┘
      plan │ ▲ clarifications (recorded, binding)
        ▼  │
        ┌──┴───┐  code+gates   ┌────────┐  spec-only tests
        │  B   │ ────────────► │  D ∥ E │ independent review + test
        │builds│               └────┬───┘
        └──────┘                    ▼ close: evidence walk, digest → human
```

The human sets gates — default is fully autonomous, with six hard escalations that always stop
for a person (blocking decision, persistent FAIL, estimate drift, unexplained tree, invented
parity, major deviation).

## Quickstart

1. **Init** — an agent runs `init/INIT.md` in the target repo: a short questionnaire (project,
   source contract, stack, preset, gates, verification) scaffolds `omh.config.yaml`, the vendored
   playbook, and the notes tree.
2. **Run role A** on milestone M0 — spec from the source inventory.
3. **Watch the gates** — approve what your gate config asks you to; everything else runs.

## Documents

| Need | File |
|---|---|
| The pipeline: phases, gates, escalations | `HARNESS.md` |
| Role contracts A–E + human | `ROLES.md` |
| Binding rules: two-layer law, never-invent, evidence | `RULES.md` (family root; vendored flat) |
| Model presets, pair schema, validator | `MODELS.md` |
| Templates: spec, plan, reviews, test report, close, inventory, config | `templates/` |
| Adoption questionnaire | `init/INIT.md` |
| Launching roles on a specific runtime | `adapters/` |
| Skill wrapper + shared validator (family root; vendored flat) | `skill/`, `tools/` |
| Worked example (WPF → web, with an honest FAIL) | `examples/ledgerlite/` |

## Model presets

Three presets (max-diversity / balanced / budget), each overridable per role; see `MODELS.md`.
The invariant in all of them: C, D, E never share B's model.

## Out of scope for v0.1

Upgrades of already-scaffolded projects · a compiled CLI · adapters for other specific runtimes ·
live orchestration of rewrites · portfolio dashboards. (Full list with reasons: the founding
spec, §6.)

## Provenance

Extracted from the fxpa-rust rewrite's process docs — two-layer spec/plan law, phase gates with
entry/exit criteria, independent review on a different model with anti-anchoring read order,
evidence-or-it-didn't-happen verdicts — which carried three milestones from spec to close
(31 Oct – 7 Nov 2026), including one round-1 review FAIL that caught a real defect.
