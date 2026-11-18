# ROLES — who owns what, and what each role may never do

Four agent roles plus an orchestrator and a human. Every document names its author in the
header (role · provider · model · date) — accountability is per document, not per project.
Role letters are modernize's composition of the family role types: A planner, B builder,
R reviewer, V verifier. The gates are lighter than upgrade's because modernize changes no
behaviour — but the control path is not lighter: R and V share no model with B or each other.

| Role | Type | Owns | Deliverable | Authority | Hard prohibitions |
|---|---|---|---|---|---|
| **A — Planner** | planner | the tranche note (scope, pins, metrics, acceptance criteria); the ledgers' editorial standard; binding answers to B's questions | tranche note; ledger updates spec | answers all tranche-note questions (recorded, binding) | no code; no pin planned without a proof it can judge; no finding disposed without a reason; no scope beyond the direction gate's decision |
| **B — Builder** | builder | building the pins, gates, benchmarks, probe fixtures; drafting ledger updates; committing tranche state | commits + green verify command + drafted ledger rows | none over scope | no silent divergence; no scope widening (E6 is a hard stop); never commits red; no inline fixes to findings (E1); no guessing |
| **R — Reviewer** | reviewer | two passes: tranche-note review (M3), diff review (M6) — one model across both by design | review reports + verdicts | blocks build on pass-1 FAIL; blocks close on pass-2 FAIL; self-accepts only minor deviations (logged) | never anchors on the note before an own checklist; no "looks right" verdicts |
| **V — Verifier** | verifier | blind re-execution of the verify command and the metric commands; per-acceptance-criteria walk | verify report | blocks close on failure | reads only the acceptance criteria + the command block — never B's evidence, R's verdicts, or the ledgers' narrative |
| Orchestrator | (lead session) | launches fresh roles, enforces gates, relays escalations, records gate outcomes | gate records | none over content | authors nothing analytical |
| Human | — | direction gate (by law); tranche-note and close gates by default; every ratchet rise; finding triage | decisions | final | — |

## A — Planner

- **Inputs:** the M0 state summary, the direction gate's decision, the ledgers as they stand.
- **Outputs:** the tranche note — which rungs, which files, every pin planned with its proof
  method, every metric to be recorded, the acceptance criteria, the declared scope (the exact
  paths B may touch) — and recorded answers to every clarification B raises.
- **Reads first:** the ledgers — a pin that duplicates an existing one, or contradicts a
  recorded finding, is a defect before the build starts.
- **Never:** plans a fix inside a pinning tranche; leaves a planned metric without the command
  that records it; leaves scope vague enough to need B's judgement.

## B — Builder

- **Inputs:** the approved tranche note, task by task. Nothing else authorizes code.
- **Outputs:** green pins/gates/benchmarks on the tranche branch, drafted ledger rows for A's
  review, and **committed state before reporting done** — an uncommitted tranche is not done.
- **Never:** fixes a finding inline (E1 — ask, record, defer); widens scope by a single file
  (E6); adds a dependency or a test-framework switch without an A answer; edits a ratchet
  count upward without a human acceptance (E4).
- **Owes the traps ledger:** every mechanism gotcha that cost B time goes into the traps
  ledger the same day, while the fix is fresh. A trap paid twice is B's defect.

## R — Reviewer (two passes, one model)

- **Pass 1 (M3)** judges the tranche note against its own checklist derived first from
  HARNESS and the ledgers — pin coverage, metric commands, scope exactness, acceptance
  criteria a non-author can judge. Verdict: PASS / FAIL back to M2.
- **Pass 2 (M6)** judges the diff against the note: only declared scope, every planned pin
  present, every ledger row traceable to a pin, no inline fixes smuggled in.
- One model across both passes by design — the same reviewer sees promise and delivery.

## V — Verifier (blind)

- **Intake:** the acceptance criteria and the verify/metric command block — nothing else.
- **Method:** re-run each command, compare every number against the acceptance criteria,
  walk each criterion to an observation. Modernize's verify is cheap and strong: the whole
  baseline is machine-checkable by construction, so blindness costs nothing and catches
  narrative drift completely.
- **Never:** reads the ledgers' prose, B's evidence, or R's verdicts. A mismatch (E5) is
  reported as found — V does not chase causes.

## Orchestrator (lead session)

Launches fresh roles on their declared intake, enforces the gate config, relays escalations,
keeps the M0 state summary current, and records gate outcomes. Authors nothing analytical.

## Human

The direction gate is human by law. By default: tranche note and tranche close. Always:
ratchet rises (dated acceptance in the ratchet file) and finding triage (E1). The human also
decides when the loop ends — the day an upgrade begins, modernize hands over.

## Intake — the only context a role launches with

Every role launches fresh: no inherited conversation, no other role's reasoning. Reading
outside the intake is a defect; launch prompts carry paths and protocol, never conclusions.

| Role | Intake | Read order |
|---|---|---|
| A | the M0 state summary, the ledgers as they stand, the direction decision | ledgers first — know what is already pinned — then the direction decision |
| B | the approved tranche note, task by task | note tasks in listed order; ask A on divergence — never guess |
| R pass 1 | HARNESS (ladder + contract), the ledgers, then the tranche note | derive your own checklist from HARNESS + ledgers first, then read the note |
| R pass 2 | the tranche note, the branch diff | note, own pass-1 checklist, then the diff — never B's evidence or V's report |
| V | the acceptance criteria + the command block — nothing else | criteria first, then the command block; re-run each command yourself |
| Orchestrator | launches, gates, records; authors nothing analytical | — |

## Independence matrix

What the config validator enforces for modernize (run it after any role change):

| Check | Result |
|---|---|
| R model == B model (declared pair `R-B`) | **error** — launch refused |
| V model == B model (declared pair `V-B`) | **error** — launch refused |
| V model == R model (declared pair `V-R`) | **error** — launch refused |
| Zero or multiple builders, no control role, unknown type | **error** |
| Undeclared same-model or same-provider pairs involving control roles | warning — logged, launch proceeds |

Modernize changes no behaviour, so a shared model on the *build* path (A and B) is an accepted
family default; on the *control* path it never is. The budget preset exists for exactly that
trade.

## Clarification protocol (B → A)

One row per question in the tranche note's Clarifications appendix:

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|

## Parallel R pass 2 ∥ V

R pass 2 and V run in parallel on independent intakes: R reads the note and the diff; V reads
the criteria and the commands. Neither sees the other; the orchestrator resolves a split
verdict by FAILing the tranche back to M4 — a tie is a FAIL.
