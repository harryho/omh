# HARNESS — the pipeline an upgrade runs through, from spike to shipped

One upgrade per run. A phase starts only when the previous phase's exit criterion is true.
Roles: A planner, B builder, R reviewer (two passes, one model), V verifier (blind). The
orchestrator launches roles and enforces gates; it authors nothing analytical.

```
        ┌────────────── human gates: direction, spec, close ────────────────────────────┐
        │                                                                                │
 P0 ─► P1 ─► P2 ─► P3 ─► P3.5 ─► P4 ─► P5a ─► P5b ─► P6a R pass2 ─┬─► P7 ─► P8 ─┼─► (next)
 state  spike  design+  plan+   R pass1  build  footprint smoke  P6b V verify ┘  close  post- │
 check  +dir   census   footpt  review   (B)    audit   probes  (parallel)      (human) ship │
        ◄── FAIL returns one phase; footprint violation is a hard stop, never absorbed ───┘
```

## Phases — entry and exit

| Phase | Entry | What happens | Exit |
|---|---|---|---|
| **P0 — state check** | an upgrade request | target repo at rest: clean tree or explained; **baseline census** recorded (tracked-file counts, source/compile counts, base commit) and spike/scratch locations declared; unexplained state stops everything (E4) | census recorded |
| **P1 — spike + direction** | census recorded | throwaway conversion spike in a scratch clone proves the upgrade compiles and launches; evidence labelled Verified/Inferred; **human decides: upgrade in place / hand off to `rewapp` (rewrite) / stop** | spike evidence + direction recorded (`direction` gate) |
| **P2 — design + parity census (A)** | direction = upgrade | design of record: objective, decision history, spike evidence, work location (clone + branch policy; original untouched), work breakdown, acceptance criteria with **machine-half / human-half split**, out of scope, role routes — plus the **parity census**: one row per capability of the original, plus its inputs & contracts (see the census template) | design + census approved (`spec` gate, human by default) |
| **P3 — plan + footprint (A)** | design + census approved | plan: ledger header, goal/architecture/constraints, the **declared diff footprint** incl. a carrying mechanism per input-contract row, tasks with AC-proof steps, commands, estimates, escalations table, verification section = machine gates + one probe command per census `probe` row + smoke steps + the V protocol | plan drafted |
| **P3.5 — R pass 1** | plan drafted | reviewer reads design + census first, derives an own checklist, only then the plan; runs the **mapping audit**: every `probe` row → a plan command, every contract row → a carrying mechanism, every `walkthrough` row → a pack step; verdict PASS / PASS-WITH-DEVIATIONS / FAIL; FAIL blocks build; re-reviews in new dated files | verdict recorded, no blocking findings |
| **P4 — build (B)** | approved plan | task-by-task in the clone on the branch; never commit red; tree-state guards at declared checkpoints; divergence stops for a clarification (binding, logged); estimate drift >1.5× is E3 | every task committed; guards green |
| **P5a — footprint audit** | build complete | **machine audit**, not a model call: clone diff vs the declared footprint — exact changed-file set, per-file numstat expectations, census equality, compile-list equality; publish/build output checked against the input-contract rows (outputs **and** required inputs present); anything else is E5 | audit MATCH recorded |
| **P5b — smoke + probes** | audit MATCH | B executes launch, log, and every census `probe` command; observed output recorded per row; FAIL returns to B | probe table green |
| **P6 — R pass 2 ∥ V verify** | probes green | parallel, fresh, mutually blind: R reviews the clone diff against design + plan with `file:line` citations; V receives *only* the AC list and the plan's commands (which include the probe set) and re-runs everything itself | both verdicts recorded |
| **P7 — close** | both verdicts in | the **parity table**: every census row → verdict → evidence, no blank rows (machine verdicts come from P5b/P6; `walkthrough` rows are executed by the human in one structured session from the **walkthrough pack**); deviations resolved, none silent; close note assembled by the orchestrator from role-produced artifacts | close note committed; **Shipped** |
| **P8 — post-ship** | shipped | gaps found after ship: the **safe-default rule** — a gap with a parity-preserving safe default is fixed autonomously as a small milestone through the same roles and gates (no option questionnaire); only *new-functionality* proposals escalate; each addendum names the census row it escaped from, or E7 fires and the census gains the missing row | addendum resolved or queued; census lesson recorded |

## Gates

Per-run approval checkpoints, each `auto` (roles gate each other; the human sees the digest) or
`human` (the phase pauses for explicit approval). Six gates; one of them is not settable:

| Gate | Pauses… | Default |
|---|---|---|
| `direction` | after P1 — parity upgrade vs rewrite (`rewapp`) vs stop | **human by law** (not settable in config) |
| `spec` | after P2, before the plan is written | **human** (flippable to auto with a dated register entry) |
| `plan` | after P3.5, before build | auto |
| `footprint` | after P5a — accepts the audit MATCH | auto (the audit itself is machine; violations hard-stop regardless) |
| `smoke` | after P5b | auto (FAIL returns to B) |
| `close` | at P7, before Shipped | **human** (flippable only with a dated register entry) |

## Escalations (E1–E7)

Hard stops. Each one pauses the run for a human decision regardless of gate settings; removing
one from the config requires a dated decisions-register entry.

- **E1 — blocking decision with no safe default.** A needed change outside the footprint; a
  compile-list mismatch; anything where grinding on would be guessing with authority.
- **E2 — FAIL persisting after one fix round.** A review, probe or smoke FAIL that survived one
  fix + re-check round is systemic, not local.
- **E3 — estimate drift >1.5× plan.** The plan no longer describes reality — re-scope rather
  than grind.
- **E4 — unexplained tree state.** Base-commit drift, baseline-census drift, or a non-empty
  status nobody can explain; no build happens on a tree nobody can explain.
- **E5 — change outside the declared footprint.** Hard stop: **revert first, re-audit, then
  escalate.** Never absorbed, never committed.
- **E6 — major-or-blocker deviation.** R may self-accept only minor deviations; anything major
  or blocking goes to the human with the evidence.
- **E7 — parity gap outside the census.** Behaviour found missing or changed that no census row
  covers: the census was incomplete. Fix via the safe-default rule where one exists, add the
  missing row, record the lesson in the register.

Route churn (a role's model route fails to launch) is family MODELS law, not an insitu
escalation; the substitute is stamped in the affected document.

## Provenance — the FXPA run this was extracted from

The FXPA desktop upgrade (.NET Framework → .NET 10, run 14 Nov 2026) proved the machinery and
named the gaps. Mapping: its gates G1/G2/G3/G4 → `spec`-adjacent reviews, `footprint`, `smoke`,
`close`; its escalations X1–X4 → E1–E4; X5 → E5; its deviation gate → E6.

What the precursor run missed, and what this harness adds:

| Lesson (from the run's close pack) | Class | insitu answer |
|---|---|---|
| "Can't load candle data" post-ship: byte-identical code, broken shipped feature — the publish carried none of the data tree the app reads at startup | features live in **inputs** | inputs & contracts rows (census) + carrying entries (footprint) + publish-contents check (P5a) |
| "Do indicators work?" post-ship: compute probed fine; the UI path silently no-ops — unknown until asked | features live in **runtime wiring** | capability rows with a proof method each; probes run before anything ships (P5b) |
| Dead menu handlers and an unfinished path in the 2008 source, recorded only after investigation | the original's own **incompleteness** | `dead-in-source` disposition — recorded, preserved, never silently resurrected |
| Smoke expected "closed gracefully"; the original shows a modal exit dialog — an unverified parity assumption inside the plan itself | unverified **parity claims** | `observation` rows pin such behaviour with cited source at census time, before the plan is written |

The expensive human interventions in the precursor run were all the human serving as the
parity-verification instrument after ship. The census converts those into pre-ship machine
evidence plus one structured walkthrough session at close.
