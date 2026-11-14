# UPG-1 — walkthrough pack (the one human session, at close)

| | |
|---|---|
| **Prepared by** | orchestrator (steps) + A (expected observations) |
| **Date of session** | 2026-11-21 (filled when run) |
| **Executed by** | the human |
| **Build under test** | `publish/` (published 2026-11-20, HEAD `f8a2c01`) |

## Preconditions (from P5b — all green)

Launch works; probes green; audit MATCH; publish carries `data\` (K-1) and `MathFin.dll` (K-2).

## Steps

### W1 — C-3: chart renders candles + overlays

1. Open ticker `acme` via File → Open Ticker; drag the price panel taller; resize the window.
2. **Expected observation:** candles redraw on every resize; SMA-20 line follows the candles;
   no ghosting or blank panel.

Result: PASS

### W2 — C-5: status-bar clock updates

1. Watch the status bar for ~30 seconds with a ticker open.
2. **Expected observation:** the clock advances every second, matching the system clock.

Result: PASS *(see close-note Addendum 1 — post-ship regression on another locale, traced to
this row)*

### W3 — C-6: Export CSV writes the file

1. Tools → Export CSV with ticker `acme` open.
2. **Expected observation:** `data/acme/acme.csv` exists next to the data tree; opens with the
   same column header row as the original's format.

Result: PASS

### W4 — C-7 preserved-dead demonstration (faithful brokenness)

1. Tools → Backtest.
2. **Expected observation:** menu item does nothing — same as the original (unfinished path in
   the 2009 source, `MainForm.cs:977`). Preserved, not resurrected.

Result: PASS (no-op confirmed)

*C-4 (exit dialog) was confirmed live during the P5b smoke close procedure; its proof method is
observation, not walkthrough.*

## Results table (feeds the close note's parity table)

| Step | Census row | Result | Notes |
|---|---|---|---|
| W1 | C-3 | PASS | |
| W2 | C-5 | PASS | addendum traced post-ship |
| W3 | C-6 | PASS | |
| W4 | C-7 | PASS | dead-in-source preserved |
