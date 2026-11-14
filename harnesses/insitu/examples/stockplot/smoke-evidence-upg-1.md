# UPG-1 — smoke + probe evidence (P5b)

| | |
|---|---|
| **Role** | B · `zai-anthropic` · glm-5.3-flash · 2026-11-20 |
| **Plan (binding)** | `notes/plan-upg-1-excerpt.md`, verification section |
| **Clone** | `upgrade/`, branch `dotnet10` |

## 0. Preconditions

Branch `dotnet10`, HEAD `f8a2c01`, `git status --porcelain` → empty (observed).

## 1. Launch smoke

Launched `publish/StockPlot.exe` → process alive; PowerShell:
`(Get-Process StockPlot).MainWindowTitle` → `StockPlot`. Log tail (`logs/app.log`): no
exceptions, startup completed with ticker tree resolved (2 tickers found). Close procedure:
exit dialog appeared (C-4 citation confirmed live); declined → app stayed open; accepted →
clean exit, no orphan process.

## 2. Probe table

| Census row | Command | Expected | Observed | Verdict |
|---|---|---|---|---|
| C-1 | launch + title (load path exercised) | `StockPlot` | `StockPlot` | PASS |
| C-2 | `dotnet run --project upgrade/ProbeMath -c Release -- samples/acme.day` | `RetCode=Success elements=112 PROBE PASS` | `RetCode=Success elements=112 PROBE PASS` | PASS |

## 3. Publish smoke

`dotnet publish … -o publish` → exit 0; `publish/data/acme/local/acme.day` present (K-1);
`publish/MathFin.dll` present (K-2); published exe launches with title `StockPlot`.

## 4. Tree-state guard

`git status --porcelain` → empty. Build/publish/log output landed only under ignored paths.

**Verdict:** all rows PASS — proceed to P6.
