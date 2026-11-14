# UPG-1 — independent verification report

| | |
|---|---|
| **Role** | V · `minimax-anthropic` · MiniMax-M3.1-Flash · 2026-11-20 (route actually used — substitution recorded below) |
| **Machine** | paths `upgrade/`, `publish/`; .NET SDK 10.0.x; Windows x64 |

**Route record:** launched first on `mimo` · mimo-v2.6-flash (budget-pool selection); the route
failed to launch twice. Substitute `minimax-anthropic` · MiniMax-M3.1-Flash fired per the
route-churn policy, stamped here; independence held (differs from B and R in model and vendor).

## Blind-protocol statement

**Inputs read:** the acceptance criteria list and the command block below — nothing else.
**Not read (per instruction):** the builder's evidence, the reviewer's reports, the footprint
audit, the parity census, the design narrative.

Each command was re-run by V, verbatim. Observed output is recorded; one pass/fail per command.

## Re-run record

| # | Command | Expected | Observed | Verdict |
|---|---|---|---|---|
| V1 | `dotnet build upgrade/StockPlot.sln -c Release` | Build succeeded, 0 warnings | `Build succeeded. 0 Warning(s). 0 Error(s).` | PASS |
| V2 | `git -C upgrade status --porcelain` · name-only + numstat diffs | empty; 5 files; declared deltas | as expected | PASS |
| V3 | publish + `test -d publish/data/acme/local` + `test -f publish/MathFin.dll` | exit 0 / present / present | exit 0 / present / present | PASS |
| V4 | `dotnet run --project upgrade/ProbeMath -c Release -- samples/acme.day` | `RetCode=Success elements=112 PROBE PASS` | verbatim | PASS |
| V5 | launch; `(Get-Process StockPlot).MainWindowTitle` | `StockPlot` | `StockPlot` | PASS |

## Per-AC walk

| AC | Criterion (short) | Evidence (command + observed) | Verdict |
|---|---|---|---|
| AC-1 | builds clean, compile list equal | V1 + V2 (compile diff empty) | PASS |
| AC-2 | SMA math matches | V4 verbatim | PASS |
| AC-3 | inputs carried into publish | V3 both checks | PASS |
| AC-4 | interactive capabilities behave | V5 launch; interactive halves noted as the human session's scope | PASS (machine halves) |
| AC-5 | no silent deviation | V2: diff = 5 declared files | PASS |

## Tree-state guard (final)

`git status --porcelain` → empty; branch `dotnet10`; HEAD `f8a2c01`; no orphan processes.

## Verify verdict

**PASS** — every command re-run green; no evidence consulted beyond the protocol.
