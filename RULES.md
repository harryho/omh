# RULES — binding rules for every omh project

One page. If a rule here conflicts with a project's own rules file, the project file wins for
that project — after being recorded in the decisions register, never silently.

## Two-layer law

- **Spec** = what and why. **No file paths, no code** — a decision-encoding type or state-machine
  shape is the only exception, trimmed to the decision-rich part. Stable: a refactor must not
  invalidate it.
- **Plan** = how. Exact files, complete content, test-first steps, commits. Allowed to churn.
- Never write implementation detail into a spec; never write business narrative into a plan.
- A spec layer that cannot be judged by a non-developer, or a plan layer a builder must guess
  from, is a defect in that layer.

## Source contract and the never-invent rule

- The **source inventory** is the scope contract: one row per source capability, each with a
  disposition — `port / NEW / drop / defer` — and a reason. A row without a reason is incomplete.
- **Never invent parity.** Any behaviour claimed to exist in the source must trace to the
  inventory or the source itself. If it is not there, it is `NEW` and must say so.
- Changing scope means editing the inventory, not silently drifting. The inventory is updated at
  close with what actually happened.
- A rewrite with no legacy source (greenfield) still has an inventory — of intended capabilities —
  so the same audit trail exists from day one.

## Evidence labelling

- Every non-obvious claim is labelled **Verified** (date + source: inventory row, source repo
  path, external doc, spike result) or **Inferred** (what it is inferred from).
- A spike settles it; a guess does not. "Probably fine" is Inferred at best.
- Reviewers and testers cite evidence for every verdict: a test name, a command output, or a
  `file:line`. "Looks right" is not a verdict.

## Commits and history

- Commit per task. Conventional messages scoped to the milestone (`feat(m1): …`, `docs(m0): …`).
- One branch until a remote exists. Commits are the record of what happened and when.
- Never commit red: a task's checks pass before its commit lands.

## Clarifications law

- The executing role asks the authoring role when a plan step is ambiguous or reality diverges
  from the plan. (Each harness names its roles; rewapp's are B asks A.)
- The authoring role answers; the answer is **binding** and is recorded in the plan's
  Clarifications appendix: question, answer, date, sections affected.
- Asking is always in scope. Guessing is never in scope. An executor who guesses where a
  question was owed has taken authority the role does not grant.
- Reality diverging from the plan is normal; the divergence is recorded, not absorbed.

## Independence law

- Reviewers C and D, and tester E, each run a **different model** from builder B. This is
  validator-enforced; the launch layer must refuse a config that violates it.
- An exception requires a dated decisions-register entry naming who accepted it and why.
- Same-model or same-provider pairs elsewhere on the review/test path are flagged warnings, not
  errors — the ledger records them so a human can weigh them.
- Every produced document header records the role, provider and model that wrote it.

## Changing a decision

- The decisions register (spec §5) is the contract. Decisions are answered **in place** — strike
  through the question, record the answer and the date — so the reasoning survives.
- Never pick a different default silently. If a decision's answer no longer holds, open a new row,
  don't overwrite history.
