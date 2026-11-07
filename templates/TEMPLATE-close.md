# CLOSE-M<N> — <milestone name>

<!--
Written at pipeline P5. The AC walk is the evidence pack: every pass cites where the evidence
lives. Manual ACs are listed with their verifier and date, or marked open — never assumed.
-->

| | |
|---|---|
| **Milestone** | M<N> — <name> |
| **Spec** | `notes/specs/SPEC-M<N>-*.md` → status **Shipped** <date> |
| **Plan** | `notes/specs/plans/M<N>-plan.md` |
| **Reviews** | C: <file> · D r1: <file> · D r2: <file, if re-review> · E: <file> |
| **Closed** | <date> |

## 1. AC walk

| AC | Criterion (short) | Evidence | Result |
|---|---|---|---|
| AC-1 | | <test name / command output / `file:line` / manual verifier + date> | pass / fail / **open — <who owes it>** |

## 2. Deviations — final state

| ID | Deviation | Accepted by | Date |
|---|---|---|---|

## 3. Inventory update

Rows whose disposition changed during the milestone (recorded, never silent):

| id | was | now | why |
|---|---|---|---|

## 4. Digest (for the human)

≤10 lines: what shipped, what proved it, what is unverified, what is next.

## 5. Next milestone

<name + the inventory rows it draws from>
