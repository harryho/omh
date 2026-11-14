# <App/system> <target> upgrade — design of record

| | |
|---|---|
| **Date** | <date> |
| **Author** | A · `<provider>` · `<model>` · <date> |
| **Status** | Draft → approved at the `spec` gate <date> |
| **Original** | <repo/app, stack, scale> |
| **Work location** | <clone path + branch; original untouched> |
| **Parity census** | <census doc link> (rides with this design through the gate) |

## 1. Objective

<What moves to what, behaviour preserved. No feature work, no modernization, no architecture
change — the only intended user-visible difference is the runtime itself, plus recorded
deviations.>

## Decision history

- <date.> <decision, answered in place; supersessions named and kept>

## 3. Spike evidence (all Verified <date>, <scratch location>)

The numbered facts that make this a known-size job — each with its command or citation:

1. <fact — command/citation>
2. <fact>
3. <runtime risk carried into the acceptance criteria, if any>

## 4. Where the work lives

<Clone + branch policy; the original repo stays untouched; where evidence and scratch live and
what stays ignored.>

## 5. Work breakdown

1. <step>
2. <step>
…

## 6. Acceptance criteria

Each AC is marked **machine-half** (command-provable, lands in the verification section) or
**human-half** (lands in the walkthrough pack) — or both halves where a capability needs each.

- **AC-1** <criterion> — machine-half: <command/expectation>
- **AC-2** <criterion> — machine-half + human-half: <split>
- **AC-3** <criterion — deviations recorded, none silent>

## 7. Out of scope

<Feature work, modernization, resurrection of dead-in-source capabilities, CI, automated tests
where none exist — each named as a possible follow-up, not silently dropped.>

## 8. Roles and routes

| Role | Context | Provider · Model | Produces |
|---|---|---|---|
| Orchestrator | lead | <session runtime> | gate records, escalations, close-note assembly; authors nothing analytical |
| A · Planner | fresh agent | <pair> | design, census, plan |
| B · Builder | fresh agent | <pair> | commits in the clone, smoke + probe evidence |
| R · Reviewer | fresh agent, two passes | <pair> | plan-review verdict (P3.5), diff-review verdict (P6) |
| V · Verifier | fresh agent | <pair> | blind verify report: AC list + commands only |

Independence: R and V each differ from B (validator error); V differs from R (declared pair).
