# UPG-1 — footprint audit (P5a, machine)

| | |
|---|---|
| **Run by** | orchestrator (mechanical runner) |
| **Date** | 2026-11-20 |
| **Clone** | `upgrade/`, branch `dotnet10`, base `2c41f77` |

## Audit commands

| # | Command | Expected | Observed | Verdict |
|---|---|---|---|---|
| A1 | `git status --porcelain` | empty | empty | MATCH |
| A2 | `git diff --name-only 2c41f77..dotnet10` | `StockPlot.csproj`, `LoginDialog.designer.cs`, `ProbeMath/ProbeMath.csproj`, `ProbeMath/Program.cs`, `.gitignore` | exactly that set | MATCH |
| A3 | `git diff 2c41f77..dotnet10 --numstat` | csproj ≈60 insertions; designer `0 4`; new files additive only | csproj `61 213`; designer `0 4`; `6 0`, `24 0`, `3 0` | MATCH |
| A4 | compile-list equality vs base | 61 files, identical except none | 61, identical | MATCH |
| A5 | `git diff 2c41f77..dotnet10 -- '*.cs' ':!LoginDialog.designer.cs'` | no output | no output | MATCH |

## Input-contract check

| Census row | Required at runtime as | Check command | Observed | Verdict |
|---|---|---|---|---|
| K-1 | `data\` under publish output | `test -d publish/data/acme/local` | exit 0 | PASS |
| K-2 | `MathFin.dll` in publish output | `test -f publish/MathFin.dll` | exit 0 | PASS |

## Verdict

**MATCH** — clone state equals the declared footprint, and every input-contract row is present
in the publish output.
