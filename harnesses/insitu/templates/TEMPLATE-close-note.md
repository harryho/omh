# <RUN> — close note

<!--
Assembled by the orchestrator at P7 from role-produced artifacts — assembly, not authorship.
The parity table is the census, walked to verdicts. Blank rows are forbidden; "unknown" is not
a verdict.
-->

| | |
|---|---|
| **Run** | <RUN> — <name> |
| **Design** | <link> → status **Shipped** <date> |
| **Census** | <link> |
| **Plan** | <link> |
| **Reviews** | R pass 1: <file> · R pass 2: <file> · V: <file> |
| **Audit / smoke** | footprint audit: <file> · smoke + probes: <file> · walkthrough session: <date, by whom> |
| **Closed** | <date> |

## 1. Verdict summary

| Stage | Role · model | Verdict | Evidence |
|---|---|---|---|
| Plan | A · <model> | written, rev per fix round | <link> |
| Plan review (P3.5) | R · <model> | <verdict> | <link> |
| Build | B · <model> | <verdict> | <commits> |
| Footprint audit (P5a) | machine | MATCH | <link> |
| Smoke + probes (P5b) | B · <model> | <verdict> | <link> |
| Diff review (P6) | R · <model> | <verdict> | <link> |
| Independent verify (P6) | V · <model> | <verdict> | <link> |

Route record: <any substitution, per policy — what failed, what fired, who stamped it.>

## Parity table

Every census row → verdict → evidence. No blank rows.

| Census row | Capability / input | Verdict | Evidence |
|---|---|---|---|
| C-1 |  | PASS / preserved-dead-in-source / declared-drop | <probe / walkthrough step / citation> |
| K-1 |  | carried / dropped (+ reason) | <audit row> |

## 3. Deviations — final state

| ID | Deviation | Accepted by | Date |
|---|---|---|---|

## 4. Addenda (post-ship)

Each addendum: report → root cause (cited) → resolution → **census row trace** — the row the
gap escaped from, or an explicit E7 record if no row covered it (then the census grows the row
and the register records the lesson).

### Addendum 1: <finding>

<Report. Root cause. Resolution. Census trace. Safe-default rule applied, or escalated as new
functionality — which, and why.>

## 5. Digest (for the human)

≤10 lines: what shipped, what proved it, what is unverified, what is next.

## 6. Human decisions (recorded)

<Close approval, walkthrough session date, any safe-default/new-functionality call.>
