# ROLES — who owns what, and what each role may never do

Four agent roles plus an orchestrator and a human. Every document names its author in the
header (role · provider · model · date) — accountability is per document, not per project.
Role letters are insitu's own composition of the family role types: A planner, B builder,
R reviewer, V verifier.

| Role | Type | Owns | Deliverable | Authority | Hard prohibitions |
|---|---|---|---|---|---|
| **A — Planner** | planner | design of record, parity census, plan + footprint; sole design interpreter | design, census, plan | answers all census/plan questions (recorded, binding) | no code; no invented census or spike evidence; no footprint entry without a parity reason |
| **B — Builder** | builder | task-by-task execution, probes, smoke evidence | commits + green audit/probes | none over scope | no silent divergence; no footprint widening (E5); never commits red; no guessing |
| **R — Reviewer** | reviewer | two passes: plan review (P3.5), diff review (P6) — one model across both by design | review reports + verdicts | blocks build on pass-1 FAIL; blocks close on pass-2 FAIL; self-accepts only minor deviations (logged) | never anchors on the plan before an own checklist; no "looks right" verdicts |
| **V — Verifier** | verifier | blind re-execution of the plan's commands | verify report + per-AC walk | blocks close on failure | reads only the AC list + commands — never B's evidence, R's verdicts, or the audit |
| Orchestrator | (lead session) | launches fresh roles, enforces gates, relays escalations, assembles the close note | gate records, close pack | none over content | authors nothing analytical |
| Human | — | direction, spec, close gates; the walkthrough session; escalations | decisions, recorded walkthrough | final | — |

## A — Planner

- **Inputs:** the spike evidence, the original source tree, open decisions.
- **Outputs:** the design of record (what/why), the parity census (every capability and input,
  each with a disposition and a proof method), the plan (how, once the census is approved), and
  recorded answers to every clarification B raises.
- **Reads first:** the original source — a census row that does not trace to it is invented,
  and invention is the defect this role exists to prevent.
- **Never:** leaves a census row without disposition + proof method; writes a footprint entry
  without a parity reason; leaves a blocking decision unanswered while the plan claims ready.

## B — Builder

- **Inputs:** the approved plan, task by task. Nothing else authorizes code.
- **Outputs:** one commit per task in the clone on the branch, probe and smoke evidence with
  observed output.
- **On ambiguity or divergence:** stop, ask A (question and answer land in the plan's
  Clarifications appendix), then proceed. Asking is always in scope; guessing never is.
- **Never:** widens the footprint ("while I'm here…" is E5), absorbs a plan error into code,
  commits red, or edits the census or design to match what was built.

## R — Reviewer (two passes, one model)

- **Pass 1 (P3.5, pre-build):** reads the design + census first, derives an own evidence
  checklist, only then reads the plan. Runs the **mapping audit**: every `probe` census row
  maps to a plan command, every contract row to a carrying mechanism, every `walkthrough` row
  to a pack step. **FAIL blocks build.**
- **Pass 2 (P6, post-build):** reviews the clone diff against design + plan + footprint, with
  `file:line` citations; re-runs the audit commands personally — green output is never taken on
  faith. **FAIL blocks close.**
- One model across both passes is deliberate: checklist continuity. The validator treats R as
  one reviewer role, so no same-model warning is even possible against itself.
- Verdicts: PASS · PASS-WITH-DEVIATIONS · FAIL. Re-reviews land in a new dated section or file;
  an old verdict is never edited.

## V — Verifier (blind)

- **Reads:** the AC list and the plan's command block. Nothing else — not B's evidence, not
  R's verdicts, not the footprint audit, not the census.
- **Does:** re-runs every command (machine gates + the full probe set), records observed
  output, walks every AC to a verdict.
- **Why blind:** V is the only role that can say "the shipped artifact works" without having
  been told by the roles that built it what "works" is supposed to look like.
- **Model:** must differ from B's (validator error) and from R's (declared pair, validator
  error).

## Orchestrator (lead session)

- **Does:** launches the four roles fresh (per the adapter), enforces gates, relays escalations
  with evidence attached, assembles the close note from role-produced artifacts, stamps route
  substitutions.
- **Never:** authors any analytical content — no review, no verdict, no test evidence, no
  census row. The close note is assembly, not authorship.

## Human

- Owns the `direction` gate (human by law), the `spec` and `close` gates (human by default),
  and every escalation.
- Runs **one structured walkthrough session** at close from the walkthrough pack — the only
  human verification the loop requires; everything else is machine-proven before it.

## Independence matrix

What the config validator enforces (run it after any role change):

| Check | Result |
|---|---|
| R model == B model | **error** — launch refused |
| V model == B model | **error** — launch refused |
| V model == R model (declared pair `V-R`) | **error** — launch refused |
| Zero or multiple builders, no control role, unknown type | **error** |
| Same model on a pair with no builder in it | warning — logged, launch proceeds |
| Same provider on any pair involving a control role | warning — logged, launch proceeds |

## Clarification protocol (B → A)

One row per question in the plan's Clarifications appendix:

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|

## Parallel R pass 2 ∥ V

After probes are green, R (pass 2) and V launch at the same time, from the same fresh state.
They must not see each other's output before either finishes. Both verdicts block close
independently — R passing cannot rescue a V failure, or the reverse.
