# PARITY-CENSUS-UPG-1 — every capability the original has, and what proves it survives

| | |
|---|---|
| **Role** | A · `zai-anthropic` · glm-5.3 · 2026-11-20 |
| **Original** | StockPlot @ `2c41f77` (WinForms, .NET Framework 4.8) |
| **Target** | .NET Framework 4.8 → .NET 10 (`net10.0-windows`) |
| **Status** | Approved at the `spec` gate 2026-11-20 |

## Capability rows

One row per user-facing capability of the *original* — traced to its source.

| id | Capability | Evidence (`file:line` / wiring) | Disposition | Proof method |
|---|---|---|---|---|
| C-1 | File → Open Ticker loads `data\<TICK>\local\<TICK>.day` into the chart | `MainForm.cs:118` (`DataFeed.ResolvePath`), `MainForm.cs:142` (load) | carry | probe |
| C-2 | Chart → SMA 20 overlay computes from loaded series | `Indicators.cs:57` calls `MathFin.Sma` | carry | probe |
| C-3 | Chart renders candles + overlays on resize | `ChartPanel.cs:203` (`OnPaint`) | carry | walkthrough |
| C-4 | Exit confirmation dialog on window close | `MainForm.cs:64` (`OnFormClosing` → modal Yes/No) | carry | observation |
| C-5 | Status-bar clock updates every second | `MainForm.cs:305` (UI timer tick) | carry | walkthrough |
| C-6 | Tools → Export CSV writes `<TICK>.csv` next to the data file | `Export.cs:31` | carry | walkthrough |
| C-7 | Tools → Backtest menu item | `MainForm.cs:977` handler early-returns (unfinished in the 2009 source) | **dead-in-source** | observation |

Row notes: C-7 is preserved as-is — the menu item no-ops in the original and must still no-op;
resurrecting it is NEW work, a separate decision. C-4 is pinned by citation: the dialog is real
behaviour, byte-identical source keeps it.

## Inputs & contracts

Everything the app consumes at runtime — byte-identical code with a missing input still ships a
broken feature.

| id | Input the app consumes | Evidence (where it is read) | Must exist at runtime as | Carried by (footprint entry) |
|---|---|---|---|---|
| K-1 | `data\<TICK>\local\<TICK>.day` ticker tree (loaded at startup) | `DataFeed.ResolvePath`, `MainForm.cs:118` | `data\` under the publish output | csproj `Content` include → copy to output directory |
| K-2 | `MathFin.dll` managed IL side-car | `Indicators.cs:57` (P/Invoke-free managed call) | `MathFin.dll` in the publish output | csproj `Reference` with `CopyLocal=true` |
