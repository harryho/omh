# Baseline report — <project>

<!--
The standing record: what the code does (behaviour pins) and what the numbers are. A owns it
editorially; V re-runs every command blind at M6. A number without its scope, command and
provenance is a rumour with a decimal point.
-->

| | |
|---|---|
| **Role** | A · `<provider>` · `<model>` · <date> |
| **Ledger location** | <notes/baseline/> |
| **Verify command** | <the one primary gate command> — budget <duration> |

## Scope rules

What counts as the application's own code for every number below — each exclusion carries its
reason. The mechanism lives in the stack policy; this section records the project's decisions
within it.

| Included | Excluded | Reason |
|---|---|---|
| <paths counted> | <generated / vendored / third-party paths> | <why the exclusion is honest> |
|  | <paths outside today's pins> | <a number describes what is pinned, nothing more> |

## Behaviour pins

| Pin | What it proves | Reproduce command |
|---|---|---|
| PIN-<id> | <the behaviour, one sentence> | <exact command> |

## Recorded metrics

| Metric | Value | Date | Reproduce command | Machine/dataset provenance |
|---|---|---|---|---|
| <metric> | <value> | <date> | <exact command> | <machine, dataset size and shape, warm/cold> |

## Empty slots

A slot this stack cannot fill yet — each with a reason and a compensating check. Never silent.

| Slot | Reason | Compensating check |
|---|---|---|
| <rung or capability> | <why nothing is recorded> | <what guards the gap, or "none needed this tranche — recorded deliberately"> |
