# upgrade — the in-place upgrade harness

Second member of the **omh** harness family ("oh my harness"). A runtime-neutral upgrade
process: the phases, roles, templates, and checks an in-place upgrade needs — an existing app
or system moved to a newer LTS/runtime with its behaviour kept — extracted from an upgrade that
worked (the FXPA desktop app, .NET Framework → .NET 10, ran a precursor of this loop on
14 Nov 2026: footprint-audited, independently reviewed, blind-verified, closed by the human).

The contract is parity: keep all existing features and functions as much as possible. Two
signed contracts carry it — the **declared diff footprint** (exactly what may change, machine-
audited) and the **parity census** (every capability and input the original has, each with a
proof). Part-rewrites and reverts are legitimate declared means; undeclared drift never is.

Four accountable roles instead of one agent improvising: **A** writes the design of record, the
parity census, and the plan; **B** builds in a clone on a branch (asking A, never guessing);
**R** reviews twice — the plan before build, the diff after — one model across both passes;
**V** verifies blind, re-running every command with nothing but the acceptance criteria and the
commands themselves. R and V never share B's model, and never each other's — the config
validator refuses a setup where they would.

```
        ┌────────────── human gates: direction, spec, close ────────────────────────────┐
        │                                                                                │
 P0 ─► P1 ─► P2 ─► P3 ─► P3.5 ─► P4 ─► P5a ─► P5b ─► P6a R pass2 ─┬─► P7 ─► P8 ─┼─► (next)
 state  spike  design+  plan+   R pass1  build  footprint smoke  P6b V verify ┘  close  post- │
 check  +dir   census   footpt  review   (B)    audit   probes  (parallel)      (human) ship │
        ◄── FAIL returns one phase; footprint violation is a hard stop, never absorbed ───┘
```

The human gates what matters: the **direction** call (upgrade in place vs hand off to `rewrite`
for a rewrite vs stop) is human by law; the design and the close are human by default. The
human also runs one structured walkthrough session at close — everything else is proven by
machines and roles before anything ships.

## Quickstart

1. **Init** — an agent runs `init/INIT.md` in the target repo: a short questionnaire (target,
   stacks, work location, preset, gates, verification) scaffolds `omh.config.yaml`, the vendored
   playbook, and the notes tree.
2. **Run role A** on the spike and design of record — `HARNESS.md` P1–P2, census included.
3. **Watch the gates** — approve what your gate config asks you to; everything else runs.

## Documents

| Need | File |
|---|---|
| The pipeline: phases, gates, escalations, provenance | `HARNESS.md` |
| Role contracts A/B/R/V + orchestrator + human | `ROLES.md` |
| Binding rules: two-layer law, never-invent, evidence | `RULES.md` (family root; vendored flat) |
| Model presets, pair schema, validator | `MODELS.md` |
| Templates: design, parity census, plan, audit, smoke, reviews, verify, walkthrough, close | `templates/` |
| Adoption questionnaire | `init/INIT.md` |
| Launching roles on a specific runtime | `adapters/` |
| Worked example (fictional WinForms 4.8 → .NET 10, with an honest review FAIL) | `examples/stockplot/` |

## Model presets

Three presets (max-diversity / balanced / budget), each overridable per role; see `MODELS.md`.
The invariant in all of them: R and V never share B's model, and never each other's
(`independence: R-B, V-B, V-R`).

## upgrade or rewrite?

Choose `rewrite` when the deliverable is a **new app on a new stack** — desktop→web, stack swap.
Choose `upgrade` when the app must **stay itself** — a newer runtime underneath, the same
features on top, every change footprinted and every capability censused before anything ships.

## Out of scope for v0.1

The first real upgrade run (this harness ships unrun, like onprem did) · adapters for runtimes
other than the one true adapter in `adapters/` · live orchestration of upgrades · automated GUI
probing (walkthrough rows stay human — bounded vision spot-checks on screenshots are allowed,
full UI automation is not).
