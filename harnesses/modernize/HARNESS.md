# HARNESS — the standing loop a codebase runs between upgrades

Modernize is continuous. Upgrade is bounded — it has a P0-to-P8 arc and ships once. Rewrite is
bounded — it ends when the replacement reaches parity. Modernize has no close at the process
level: it is a loop of **tranches**, each individually bounded and closed, over state that
accrues in the repository. The loop ends only when an upgrade (or a rewrite) begins — and its
whole purpose is to make that day safe.

## The baseline contract

Everything modernize produces is state the next change must defend. Four ledgers carry it;
all four live in the repository (default `notes/baseline/`, set at init) and are committed
with each tranche.

| Ledger | What it holds | What makes it honest |
|---|---|---|
| **Baseline report** | What the code does (behaviour pins) and what the numbers are (coverage, benchmarks, counts, durations), each row with the command that reproduces it | Every number is *recorded*, not asserted — V re-runs the commands and compares |
| **Findings ledger** | Every quirk or suspected bug met while pinning: what it does, where it is pinned, whether the fix is deferred and why | A finding without a pinning test is incomplete; "is this a bug?" is the human's call, never B's |
| **Ratchet file** | Count ratchets (a number that may fall and never rise) and recorded metrics (a number that moves only with a dated human acceptance) | A rise needs a dated acceptance in the file itself — the ratchet remembers who moved the floor and when |
| **Traps ledger** | Mechanism and environment gotchas this stack bites with, discovered by fire | Written when discovered, while the scar is fresh; run two never rediscovers run one |

Three disciplines hold the contract:

- **Pin quirks, don't fix.** A characterization test is the deliverable; the fix is a separate
  decision. This keeps modernize behaviour-preserving by construction and keeps the history
  honest — the quirk was there, and now everyone can see it.
- **Record scope with every number.** A coverage number without its exclusion scope, or a
  benchmark without its machine and data size, is not a baseline — it is a rumour with a
  decimal point.
- **One fast primary gate.** Exactly one command (the verify command) is the gate every
  tranche must keep green. Anything slow, flaky, or environmental lives in a slow suite
  outside it — never inside, never silently.

## The ladder — the menu of tranches

The rungs are ordered not by dependency but by cost of regret: rung L0 is the cheapest thing
that makes every later tranche verifiable. A tranche usually takes one or two rungs. Every
rung names *slots*, never mechanisms — the stack policy fills them.

| Rung | What it pins | Slots filled |
|---|---|---|
| **L0 — the verify command** | One command: builds green, runs the suite, fits its recorded duration budget | 1, 2 |
| **L1 — oracle pins** | The core logic against an independent oracle (golden masters, reference implementation, hand-computed vectors) — never against itself | 2, 4 |
| **L2 — data pipeline pins** | Input/output formats round-trip; fixtures carry content hashes; save/load is pinned even when (especially when) it misbehaves | 2, 4, 9 |
| **L3 — geometry pins** | Coordinate mapping, scale/pan composition, render maths — round-trips and known points | 2, 7 |
| **L4 — threading pins** | Thread affinity assumptions, single-threaded contracts, what must never cross a thread | 2, 9 |
| **L5 — UI smoke** | The real UI launches in-process, renders with bundled data, and is asserted non-blank — no OS-level input, no fragile accessibility hooks | 7, 8 |
| **L6 — measurement baselines** | Hot paths benchmarked; the numbers land in the baseline report with machine and dataset provenance | 6 |
| **L7 — static gates** | Count ratchets (legacy smells that may fall, never rise), deterministic builds, and — if the project needs it — a privacy gate over names that must never appear | 5 |

## Phases — entry and exit

| Phase | Name | Owner | Entry | Exit |
|---|---|---|---|---|
| M0 | State check | Orchestrator | a new tranche is proposed | ledger state known: what is pinned, what the numbers are, what the verify command is today |
| M1 | Direction | Human (gate) | M0 summary on the table | a tranche is chosen: which rungs, which findings (if any) get triaged, what is explicitly out of scope |
| M2 | Tranche note | A | direction given | the note names scope (files, ledgers touched), every pin planned, every metric to be recorded, and acceptance criteria a non-author can judge |
| M3 | R pass 1 | R (gate) | tranche note exists | the plan is approved or FAILed back to M2 |
| M4 | Build | B | approved note | pins, gates, benchmarks built in the tranche branch; ledger updates drafted; **state committed before reporting done** |
| M5 | Record + audit | machine | B reports done | metrics recorded in the baseline report; a scope audit confirms B touched only the declared files |
| M6 | R pass 2 ∥ V verify | R and V (parallel) | M5 clean | R judges the diff; V re-runs the verify command and the metric commands blind and compares every number |
| M7 | Tranche close | Human (gate) | M6 green on both | branch merges, ledgers commit, ratchet file updated; the loop returns to M0 |

A FAIL at any stage returns one stage — M6 to M4, M3 to M2 — never to zero. Scope drift found
at M5 is not a FAIL-and-continue: it is a hard stop.

## Gates

The **direction gate is human by law** — no config may set it to auto: what gets pinned, and
which findings get triaged, is a judgement about the project's future, not a mechanical step.
Human by default: the tranche note (M2 gate) and the tranche close (M7). Human always: a
ratchet rise — the ratchet file records the acceptance, the accepter, and the date. Everything
else runs machine or role gates; the config sets which human gates pause, direction excepted.

## Escalations (E1–E7)

| Id | Fires when | Effect |
|---|---|---|
| E1 | A finding looks like a bug worth fixing now | triage is human: pin it and defer (default), or open a fix tranche — never fix inline |
| E2 | No independent oracle exists for a capability | the capability is recorded in the findings ledger as unpinned, with the reason; never invent an oracle |
| E3 | A metric cannot be recorded on this stack (no coverage tool, no profiler) | the baseline report carries an explicit empty slot with reason and a compensating check |
| E4 | A change would raise a ratchet count | build blocked; B asks A to amend the plan, or the human accepts the rise with a dated entry |
| E5 | V's numbers do not match the recorded baseline | FAIL back to M4; the mismatch and its cause are written into the traps ledger |
| E6 | B touched files outside the declared scope | hard stop; the tranche is unwound to the declared scope and re-verified |
| E7 | A probe is flaky (fails without a code cause) | the probe moves to the slow suite with a tracking entry; the primary gate never absorbs flake |

## Findings discipline

Every quirk gets a row in the findings ledger the day it is met: what happens, where it is
pinned (test name, fixture), and a disposition — `deferred` (the default, with a reason) or
`fix-tranche` (a human opened one). The never-invent rule applies at full strength: a claim
that something is a bug traces to the pinning test, not to a feeling. At close-of-tranche the
ledger row count is itself a ratchet candidate — findings may be resolved (fix shipped), but
they may not silently vanish.

## Ratchet discipline

A ratchet is a number chosen because its rise means rot: legacy smell counts, wildcard
versions, console writes in library code, names that must never appear. Two rules only:

1. **Down is free.** The count may fall at any time — that is the point.
2. **Up is a decision.** A rise requires a dated acceptance in the ratchet file: who, why, and
   what compensates. Without the entry, the build is red.

Recorded metrics (coverage, benchmark numbers) are not ratchets until the human promotes them:
a floor set too early is false comfort. The baseline report records them from L6 onward; the
ratchet file lists a metric only when the human says the number may never quietly drop.

## Stack policies — the seam that keeps this harness generic

The harness core is stack-neutral: it names slots, never mechanisms. A **stack policy** is one
document that fills every slot for one technology family; the project declares which applies
(`stack.policy:` in `omh.config.yaml`). The nine slots:

| # | Section | The question it answers |
|---|---|---|
| 1 | Build and verify command | What is the one primary gate command, and how fast should it stay? |
| 2 | Test framework and layout | Where do tests live, how are they named, what runs on every tranche? |
| 3 | Coverage scope rules | What counts as the application's own code, and which mechanism enforces that scope? |
| 4 | Independent oracle strategy | What does this stack compare core logic *against* — never against itself? |
| 5 | Static gates and ratchets | Which smells are countable here, and what mechanism asserts the counts? |
| 6 | Measurement and benchmarks | Which tool times hot paths, and how is machine/dataset provenance recorded? |
| 7 | UI and render probes | How does a desktop UI get launched and asserted without OS input or accessibility hooks? |
| 8 | Slow-suite isolation | What is deliberately slow or flaky-prone, where does it live, and what runs it? |
| 9 | Modernize hazards | What bites when you baseline this stack — the traps this family keeps rediscovering? |

A mechanism named in `HARNESS.md`, a role contract, or a template is a defect; it belongs in a
policy. A policy is data, not law — it changes without a decisions-register entry. A project
may ship its own policy by pointing `stack.policy` at a document that follows this contract.

## Handoff to upgrade

The loop exits when an upgrade begins, and it exits *paid up*:

- the **baseline report** seeds the upgrade's parity census — every behaviour pin is a census
  row with a proof command already written;
- the **ratchet file** becomes the upgrade's regression gate set — the upgrade must leave the
  numbers where modernize left them;
- the **findings ledger** hands upgrade its known-quirk map — parity claims about deferred
  defects are already traceable;
- the **traps ledger** goes to the upgrade's stack-policy hazards slot — the scars travel.

## Provenance

Extracted from the FXPA public-repo baseline run of 17–18 Nov 2026: one verify command green
at 65 tests in ~0.3 s; golden masters for 16 catalogue functions plus 5 ported indicators
against an independent Python oracle at 1e-6 tolerance; a 3,300-bar fixture pinned by SHA-256;
interval aggregation, coordinate mapping, and thread affinity characterized; a 3-test UI smoke
suite held out of the primary gate with in-process launch and pixel probes; 6 benchmarks
recorded; 4 static gates (two count ratchets, deterministic versions, an opt-in privacy gate);
scoped coverage of 9.52% over 9,932 lines of the application's own code. The findings and
traps ledgers of that run — a save format that cannot read its own exports, an interval
off-by-one on rollover, coverage-exclusion pattern rules, a benchmark harness with a
case-sensitive project-name lookup — are the reason this document exists.
