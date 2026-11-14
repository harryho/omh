# PARITY-CENSUS-<RUN> — every capability the original has, and what proves it survives

<!--
Authored by A at the design phase. R pass 1 audits row→proof mapping against the plan.
"Unknown" is not a disposition; a row without disposition + proof method is a census defect.
-->

| | |
|---|---|
| **Role** | A · `<provider>` · `<model>` · <date> |
| **Original** | <repo/app + base commit> |
| **Target** | <stack from → stack to> |
| **Status** | Draft → approved at the `spec` gate <date> |

## Capability rows

One row per user-facing capability of the *original* — menus, commands, operations, dialogs,
background jobs. Not a feature wishlist: a list of what the app **does today**, traced to its
source.

| id | Capability | Evidence (`file:line` / wiring) | Disposition | Proof method |
|---|---|---|---|---|
| C-1 | <what the user/system can do> | <trace to the original source> | carry | probe |
| C-2 |  |  | carry / dead-in-source / drop (+ reason) | walkthrough |
| C-3 |  |  |  | observation |

Row laws:

- `carry` — the capability must work after the upgrade; it needs a proof (probe or walkthrough).
- `dead-in-source` — broken or unfinished in the original; preserved as-is and said so.
  Resurrecting it is NEW work — a separate decision, never part of the upgrade.
- `drop` — a declared loss with a reason; a loss without a reason is silent, and silence is the
  only forbidden outcome.
- `probe` — scriptable without GUI automation (a console check, a file-format round-trip, a
  compute call). Probes become commands in the plan's verification section.
- `walkthrough` — needs hands and eyes; becomes a step in the walkthrough pack, executed in one
  human session at close.
- `observation` — behaviour pinned by byte-identical source plus a citation (e.g. a modal exit
  dialog). No run needed; the citation is the proof.

## Inputs & contracts

Everything the app consumes at runtime — the class of failure where byte-identical code still
produces a broken shipped feature because an input never made it into the shipped
output.

| id | Input the app consumes | Evidence (where it is read) | Must exist at runtime as | Carried by (footprint entry) |
|---|---|---|---|---|
| K-1 | <data tree / config file / side-car binary / endpoint> | <read site, `file:line`> | <runtime path/shape> | <resource manifest entry / install layout / copy step / embed directive> |

A contract row with no carrying mechanism blocks the plan (R pass 1, mapping audit). The
the shipped-output audit checks these rows against the output, not just the outputs themselves.
