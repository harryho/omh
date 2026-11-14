# StockPlot .NET 10 upgrade — design of record (UPG-1)

| | |
|---|---|
| **Date** | 2026-11-20 |
| **Author** | A · `zai-anthropic` · glm-5.3 · 2026-11-20 |
| **Status** | Approved at the `spec` gate 2026-11-20 (human) |
| **Original** | StockPlot — WinForms charting desktop app, .NET Framework 4.8; 88 tracked `.cs`, compile list 61 |
| **Work location** | clone at `upgrade/`, branch `dotnet10`; original repo untouched |
| **Parity census** | `notes/parity-census.md` (approved with this design) |

## 1. Objective

Move StockPlot from .NET Framework 4.8 to .NET 10 (`net10.0-windows`) with behaviour preserved:
same menus, same charts, same data tree, same dialogs. No feature work, no modernization, no
architecture change — the only intended user-visible difference is the runtime.

## Decision history

- 2026-11-20. Direction: upgrade in place (spike proved it compiles and launches; rewrite
  rejected — the app must stay itself). Confirmed by human at the `direction` gate.
- 2026-11-20. Desktop runtime flavor only (`net10.0-windows`); no cross-platform target.
- 2026-11-20. `SkinKit` skinning stripped (4 designer lines, library isFramework-only); the
  login dialog reverts to default WinForms look — declared drop, census K-row absent, C-row
  unaffected.

## Spike evidence (all Verified 2026-11-20, scratch clone `../spike/`)

1. Project converts with `dotnet upgrade-assistant` + hand edits: builds clean under
   `net10.0-windows` — `dotnet build`: Build succeeded.
2. App launches and shows the main window — title `StockPlot` (PowerShell process check).
3. Compile set is stable: 61 sources compile before and after (list-equality check).
4. `MathFin.dll` (managed IL side-car) loads from output on .NET 10 — no native binding.
5. `data\<TICK>\local\<TICK>.day` is read at startup via `DataFeed.ResolvePath`
   (`MainForm.cs:118`) — **runtime risk carried into AC-3**: the tree must ship.

## Where the work lives

Clone: `upgrade/` (fresh clone of the original at `2c41f77`), branch `dotnet10`. The original
repo stays untouched and read-only for the whole run. Evidence and records live under
`notes/records/`; build and publish output under ignored paths only.

## Work breakdown

1. Convert project file to SDK-style, `net10.0-windows` (replaces `StockPlot.csproj`).
2. Strip `SkinKit` wiring (edit `LoginDialog.designer.cs`, −4 lines).
3. Carry the data tree: csproj `Content` include → copy to output directory (K-1).
4. Carry `MathFin.dll`: csproj `Reference` with `CopyLocal` (K-2).
5. Add `ProbeMath` console project (C-2 probe) + `.gitignore` for build/publish output.
6. Build, publish, machine audit, smoke + probes, reviews, blind verify, walkthrough, close.

## Acceptance criteria

- **AC-1** Solution builds clean on .NET 10 with the compile list equal to the original's 61.
  — machine-half: `dotnet build upgrade/StockPlot.sln -c Release` → Build succeeded;
  compile-list diff empty.
- **AC-2** SMA-20 computation matches the original's math library. — machine-half:
  `ProbeMath` over `samples/acme.day` → `RetCode=Success elements=112 PROBE PASS`.
- **AC-3** The publish output carries every input the app reads at startup. — machine-half:
  `test -d publish/data/acme/local && test -f publish/MathFin.dll`.
- **AC-4** The four interactive capabilities (open ticker, overlay render, status-bar clock,
  CSV export) behave as censused, including the exit confirmation dialog. — human-half:
  walkthrough pack W1–W4 + observation citations.
- **AC-5** Every deviation from byte-identity is recorded and accepted — none silent.

## Out of scope

Feature work; modernization; resurrecting the dead Backtest menu (C-7, dead-in-source — stays
dead and recorded); CI; automated tests where none exist. Each is a possible follow-up run.

## Roles and routes

| Role | Context | Provider · Model | Produces |
|---|---|---|---|
| Orchestrator | lead | lead session | gate records, escalations, close-note assembly; authors nothing analytical |
| A · Planner | fresh agent | `zai-anthropic` · glm-5.3 | design, census, plan |
| B · Builder | fresh agent | `zai-anthropic` · glm-5.3-flash | commits in `upgrade/`, smoke + probe evidence |
| R · Reviewer | fresh agent, two passes | `kimi` · kimi-k2.7-code | plan-review verdict, diff-review verdict |
| V · Verifier | fresh agent | `minimax-anthropic` · MiniMax-M3.1-Flash | blind verify report (AC list + commands only) |

Independence: R and V each differ from B (validator error); V differs from R (declared pair).
