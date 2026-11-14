# <RUN> — footprint audit (P5a, machine)

<!--
Not a model call. The orchestrator (or any mechanical runner) executes the plan's declared
machine-audit commands and compares observed output to expected output. Judgement calls are
defects: the audit is deterministic.
-->

| | |
|---|---|
| **Run by** | <who/what executed the commands> |
| **Date** | <date> |
| **Clone** | <path>, branch `<branch>`, base `<base commit>` |

## Audit commands

| # | Command | Expected | Observed | Verdict |
|---|---|---|---|---|
| A1 | `git status --porcelain` | empty |  | MATCH/MISMATCH |
| A2 | `git diff --name-only <base>..<branch>` | exactly: <file set> |  |  |
| A3 | `git diff <base>..<branch> --numstat` | <per-file deltas> |  |  |
| A4 | <census/compiled-unit list equality> | identical / <count> |  |  |
| A5 | <byte-identity check for untouched categories> | no output |  |  |

## Input-contract check

Shipped output vs the census K-rows — inputs, not just outputs:

| Census row | Required at runtime as | Check command | Observed | Verdict |
|---|---|---|---|---|
| K-1 | <path/shape> | <test -e / listing> |  | PASS/FAIL |

## Verdict

**MATCH** — clone state equals the declared footprint, and every input-contract row is present
in the shipped output.

**VIOLATION** — anything else. Action per E5: revert the offending change first, re-run the
audit, then escalate with the audit attached. A violation is never absorbed and never committed.
