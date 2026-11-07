# SPEC-M<N> — <outcome in plain words, not the mechanism>

<!--
Two binding comments, keep both:
1. This spec holds WHAT and WHY — no file paths, no code. A decision-encoding type or
   state-machine shape is the only exception, trimmed to the decision-rich part.
2. Every AC names its proof: a machine gate it can name, or a manual verifier who can be asked.
Title by outcome ("M1 loads a year of history in one second"), not by artifact ("data layer").
Delete sections that do not apply, except §3–§5.
-->

| | |
|---|---|
| **Milestone** | M<N> — <name> |
| **Plan reference** | `plans/M<N>-plan.md` (written after this spec reaches Ready) |
| **Author** | <role> · <provider> · <model> · <date> |
| **Status** | **Draft** / **Ready to build** / **Blocked — on D<n>** |
| **Depends on** | <milestones or decisions that must land first> |

## 1. Why this milestone exists

≤3 sentences: what capability this unlocks, what it unblocks, what later failure it prevents.
Not the mechanism — that is the plan's job.

## 2. User stories

Numbered. Actor + capability + benefit; a story without a benefit is a task in disguise.
Tag each with the inventory row it replaces (`← LLD-4`) or mark it `NEW` — the tag is the
never-invent audit trail.

1. As a <actor>, I want <capability>, so that <benefit>. `← <inventory-id>`
2. As a …, so that …. `NEW`

## 3. Functional requirements

`FR-n`, bold lead-in, testable, judgeable by a non-developer. Mark the decisive one.

**FR-1 — <lead-in>.** <what must be true>

> **FR-<k> is the point of this milestone.** <why — stops it being traded away when time runs short>

## 4. Acceptance criteria

Each ties to an FR. Given/When/Then. Mark the one that proves the work.

**AC-1** *(FR-1, machine: `<gate name>`)*
> **Given** <state> **When** <action> **Then** <observable outcome>

**AC-2** *(FR-<k>, machine: `<gate>`)* — *the one that proves the work*
> **Given** … **When** … **Then** …

**AC-n** *(FR-n, manual: <who verifies>)* — <plain sentence>

## 5. Decisions required

| ID | Decision | Owner | Blocking? |
|---|---|---|---|
| **D1** | <question, with a recommendation> | <owner> | Yes / No |
| **D2** | ~~<answered question>~~ ✅ **<answer> — <date>** | — | — |

Answers are recorded in place (strike through, answer, date) so the reasoning survives. A spec
cannot be Ready while any decision is Blocking: Yes.

## 6. Out of scope

- <exclusion> — *with a reason; an unexplained exclusion reads as an oversight.*

## 7. Assumptions

Numbered; taken as true without confirming; each cheap to correct if wrong.

## 8. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| | | |

## 9. Evidence and references

- **Verified** <date> — <source: inventory row, source repo path, external doc, spike result>
- **Inferred** — <what it is inferred from>

## 10. Implementation notes

Pointer to the plan only, plus decisions that constrain it (e.g. "exactly one owner of X; the
plan must not introduce a second"). No file lists, no code.
