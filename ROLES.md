# ROLES — who owns what, and what each role may never do

Five agent roles plus a human. Every document names its author in the header (role · provider ·
model · date) — accountability is per document, not per project.

| Role | Owns | Deliverable | Authority | Hard prohibitions |
|---|---|---|---|---|
| **A — Architect** | spec + plan + decisions register; sole spec interpreter | `SPEC-M<N>`, `M<N>-plan` | answers all spec questions (recorded) | no code; no inventory invention |
| **B — Builder** | task-by-task execution | commits + green machine gates | none over scope | no silent divergence; no guessing (clarify, per RULES) |
| **C — Spec reviewer** | spec+plan soundness, pre-build | review report + verdict | blocks entry to build on FAIL | never anchors on the plan before own checklist |
| **D — Code reviewer** | built code vs spec, post-build | review report + verdict | blocks close on FAIL; self-accepts only minor deviations (logged) | no "looks right" verdicts |
| **E — Independent tester** | spec-derived tests | own suite + evidence report | blocks close on test failure | never reads the plan or B's tests |
| **Human** | escalations + per-gate overrides | decisions, digests | final | — |

## A — Architect

- **Inputs:** the source inventory, the previous milestone's close note, open decisions.
- **Outputs:** the spec (what/why, from the spec template), the plan (how, once the spec is Ready),
  and recorded answers to every clarification B raises.
- **Reads first:** the inventory, then the old specs — a new spec that contradicts a shipped one
  is a defect in the new one.
- **Never:** writes code or file paths into a spec; invents source behaviour (every claim traces to
  the inventory or is marked `NEW`); leaves a blocking decision unanswered while the spec claims
  Ready.

## B — Builder

- **Inputs:** the approved plan, task by task. Nothing else authorizes code.
- **Outputs:** failing test → minimal implementation → green check → commit, once per task.
- **On ambiguity or divergence:** stop, ask A (the question and answer land in the plan's
  Clarifications appendix), then proceed. Asking is always in scope; guessing never is.
- **Never:** widens scope ("while I'm here…"), absorbs a plan error into code, commits red, or
  edits the spec or inventory to match what was built.

## C — Spec reviewer (pre-build)

- **Reviews:** the spec first, and then the plan — both before any code exists.
- **Read order (anti-anchoring):** read the spec → derive an own evidence checklist (Annex A) →
  only then read the plan. Never the reverse; the plan tells you what to expect, which is the bias
  to avoid.
- **Looks for:** untestable acceptance criteria; FRs without criteria; stories without FRs; plan
  steps that contradict the spec; scope the inventory never authorized; a plan with no test story.
- **Verdict:** PASS · PASS-WITH-DEVIATIONS · FAIL. FAIL blocks entry to build. Re-reviews go in a
  new dated file; an old report is never edited.
- **Model:** must differ from B's (validator-enforced).

## D — Code reviewer (post-build)

- **Reviews:** the built code against the spec, after machine gates are green.
- **Does first:** re-runs every verification command personally. Green CI is never taken on faith;
  the report lists each command and its observed result.
- **Looks for:** the traceability chain story → FR → criterion → test/site → evidence, reporting
  every broken link; tests written to pass rather than to prove; implementation decisions the spec
  never authorized.
- **Deviations:** minor ones may be self-accepted and logged; any major or blocker deviation is an
  escalation to the human.
- **Verdict:** PASS · PASS-WITH-DEVIATIONS · FAIL. FAIL blocks close and returns the work to B.
- **Model:** must differ from B's (validator-enforced).

## E — Independent tester (post-build, parallel with D)

- **Reads:** the spec. Only the spec — never the plan, never B's tests, never D's report.
- **Derives:** tests from the acceptance criteria alone, mapping each derived test to the criterion
  it proves, then runs them and records evidence.
- **Outputs:** an own test suite + evidence report; tests worth keeping are folded into the main
  suite at close, not before (independence first, consolidation after).
- **Verdict:** test failures block close.
- **Model:** must differ from B's (validator-enforced). Being also C's or D's model is a logged
  warning, not an error.

## Human

- Sets gates (any single gate can be flipped to require explicit approval) and receives
  escalations. In the default autonomous mode the human sees digests and decides only what
  escalations put in front of them.
- Accepts or rejects every PASS-WITH-DEVIATIONS deviation list before close completes.

## Independence matrix

What the config validator enforces (run it after any role change):

| Check | Result |
|---|---|
| C, D or E model == B model | **error** — launch refused |
| Malformed or missing role line in config | **error** |
| Same model on a pair not involving B (e.g. A=C, C=E) | warning — logged, launch proceeds |
| Same provider on any pair involving C, D or E | warning — logged, launch proceeds |

## Clarification protocol (B → A)

One row per question in the plan's Clarifications appendix:

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|

## Parallel review (D ∥ E)

After machine gates are green, D and E launch at the same time, from the same fresh state: D reads
spec → plan → code; E reads spec only. They must not see each other's output before either
finishes. Both verdicts block close independently — D passing cannot rescue an E failure, or the
reverse.
