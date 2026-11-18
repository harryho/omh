# modernize — the standing baseline harness

Third member of the **omh** harness family ("oh my harness"). A runtime-neutral improvement
process for the long stretch **between** upgrades: the phases, roles, templates, and checks a
codebase needs to become steadily safer to change — an existing app kept on its current
runtime while its engineering floor is raised rung by rung, until the next upgrade consumes
the result. Extracted from a baseline run that worked (the FXPA public repo, 17–18 Nov 2026:
golden masters against an independent oracle, scoped coverage, recorded benchmarks, ratchet
gates, and a traps ledger that started as mid-run scar tissue).

The contract is the **baseline**: a recorded, machine-checkable statement of what the code
does and what the numbers are, that every later change has to defend. Four ledgers carry it —
the **baseline report** (behaviour and metrics, each with the command that reproduces it),
the **findings ledger** (every quirk: pinned where, fix deferred why), the **ratchet file**
(counts that may fall and never rise; metrics that move only with a dated human acceptance),
and the **traps ledger** (mechanism gotchas, so run two never rediscovers run one). Quirks are
pinned, not fixed — a fix is a human decision that gets its own tranche.

The same four accountable roles as upgrade, with lighter gates because modernize changes no
behaviour: **A** writes the tranche note (scope, pins planned, metrics to record) and owns the
ledgers; **B** builds the pins, gates, and benchmarks in a branch; **R** reviews twice — the
tranche note before build, the diff after, one model across both passes; **V** verifies blind,
re-running the one verify command with nothing but the acceptance criteria and the command
block. R and V share no model with B or each other — modernize declares the three-vendor law
as hard pairs, and the config validator refuses a setup where they would not hold.

```
        ┌──────────── human gates: direction, tranche close ──────────────┐
        │                                                                  │
 M0 ─► M1 ─► M2 ─► M3 ─► M4 ─► M5 ─► M6a R pass2 ─┬─► M7 ─► (M1 again)     │
 state  dir   tranche  R pass1  build  record    M6b V verify ┘  tranche  │
 check  (human  note    review   (B)   +audit   (blind, parallel) close   │
        by law)  (A)    of note          machine        (human)          │
        ◄── FAIL returns one stage; scope drift is a hard stop, never absorbed ─┘
```

Upgrade is bounded — it ships once and closes. Modernize is continuous — there is no close,
only tranche closes over ledgers that accrue. The process ends the day an upgrade begins:
the baseline report feeds the parity census, the ratchets become the upgrade's regression
gates, and the traps ledger tells the upgrade roles what this stack bites with.

## Quickstart

1. **Init** — an agent runs `init/INIT.md` in the target repo: a short questionnaire (runtime,
   stack policy, what exists already — verify command, coverage tool, oracle candidates —
   work location, preset, gates) scaffolds `omh.config.yaml`, the vendored playbook, and the
   ledgers from the templates.
2. **Pick the first tranche** from the ladder — usually L0 (a green verify command) plus one
   content rung; direction is a human gate.
3. **Run role A** on the tranche note — `HARNESS.md` M1–M2. Watch the gates; approve what
   your gate config asks you to.

## Documents

| Need | File |
|---|---|
| The pipeline: the ladder, tranche stages, gates, escalations, provenance | `HARNESS.md` |
| Role contracts A/B/R/V + orchestrator + human | `ROLES.md` |
| Binding rules: two-layer law, never-invent, evidence | `RULES.md` (family root; vendored flat) |
| Model presets, pair schema, validator | `MODELS.md` |
| Templates: tranche note, baseline report, findings, ratchet, traps, reviews, verify, close | `templates/` |
| Stack policies: the mechanism per technology family (.NET, Java, Kotlin, Rust) | `stacks/` |
| Adoption questionnaire | `init/INIT.md` |
| Launching roles on a specific runtime | `adapters/` |
| Worked example (fictional Java Swing desktop app, tranche 1: L0 + L1 + L2 + L7, with an honest review FAIL) | `examples/stockpad/` |

## Stack policies — why the harness is not .NET-specific

The core names the *slots* a technology stack must fill and never the mechanism that fills
them. The mechanism lives in a **stack policy** — one document per technology family filling
the same nine slots: build and verify command · test framework and layout · coverage scope
rules · independent oracle strategy · static gates and ratchets · measurement and benchmarks ·
UI and render probes · slow-suite isolation · modernize hazards.

`stacks/dotnet.md` ships today, written directly from the FXPA run; `stacks/java.md`,
`stacks/kotlin.md` and `stacks/rust.md` ship as working skeletons. The contract is in
`stacks/README.md`, and a new stack is one file. The project selects one with `stack.policy:`
in `omh.config.yaml`, asked at init.

## Model presets

Three presets (max-diversity / balanced / budget), each overridable per role; see `MODELS.md`.
Modernize changes no behaviour, so the budget preset is defensible more often than for
upgrades — but the three-vendor law on the control path (R and V off B's model and off each
other) is a hard pair set in every preset, and every role launches fresh on its declared
intake.
