# UPG-1 — close note

| | |
|---|---|
| **Run** | UPG-1 — StockPlot .NET 10 in-place upgrade |
| **Design** | `design-upg-1.md` → status **Shipped** 2026-11-21 |
| **Census** | `parity-census-upg-1.md` |
| **Plan** | `plan-upg-1-excerpt.md` |
| **Reviews** | R pass 1: `review-r1-plan-upg-1.md` · R pass 2: `review-r2-diff-upg-1.md` · V: `verify-report-upg-1.md` |
| **Audit / smoke** | footprint audit: `footprint-audit-upg-1.md` · smoke + probes: `smoke-evidence-upg-1.md` · walkthrough session: 2026-11-21, by the human |
| **Closed** | 2026-11-21 |

## 1. Verdict summary

| Stage | Role · model | Verdict | Evidence |
|---|---|---|---|
| Plan | A · glm-5.3 | written, rev 2 after R pass 1 FAIL | `plan-upg-1-excerpt.md` |
| Plan review (P3.5) | R · kimi-k2.7-code | round 1 **FAIL** → round 2 **PASS** (same file, dated sections) | `review-r1-plan-upg-1.md` |
| Build | B · glm-5.3-flash | complete, 3 commits | `f8a2c01` |
| Footprint audit (P5a) | machine | MATCH | `footprint-audit-upg-1.md` |
| Smoke + probes (P5b) | B · glm-5.3-flash | all PASS | `smoke-evidence-upg-1.md` |
| Diff review (P6) | R · kimi-k2.7-code | PASS-WITH-DEVIATIONS (1 minor, logged) | `review-r2-diff-upg-1.md` |
| Independent verify (P6) | V · MiniMax-M3.1-Flash | PASS (blind) | `verify-report-upg-1.md` |

Route record: V launched on `mimo` · mimo-v2.6-flash; failed twice; substitute
`minimax-anthropic` · MiniMax-M3.1-Flash fired per the route-churn policy and is stamped in the
verify report.

## Parity table

| Census row | Capability / input | Verdict | Evidence |
|---|---|---|---|
| C-1 | Open Ticker loads data file | PASS | probe C-1 (smoke) + launch check |
| C-2 | SMA 20 overlay computes | PASS | ProbeMath `RetCode=Success elements=112 PROBE PASS` (V re-ran) |
| C-3 | Chart renders candles + overlays | PASS | walkthrough W1 |
| C-4 | Exit confirmation dialog | PASS | observation citation `MainForm.cs:64`, live-confirmed in smoke |
| C-5 | Status-bar clock | PASS at close | walkthrough W2 — post-ship regression traced in Addendum 1 |
| C-6 | Export CSV | PASS | walkthrough W3 |
| C-7 | Backtest menu item | preserved-dead-in-source | observation citation `MainForm.cs:977`; demonstrated W4 |
| K-1 | `data\` ticker tree | carried | audit input-contract check + `test -d publish/data/acme/local` |
| K-2 | `MathFin.dll` side-car | carried | audit input-contract check + `test -f publish/MathFin.dll` |

No blank rows.

## Deviations — final state

| ID | Deviation | Accepted by | Date |
|---|---|---|---|
| D1 | `.gitignore` pattern wider than the residue list (`logs/`) | R (minor, pass 2) | 2026-11-20 |
| D2 | `SkinKit` skinning stripped — login dialog default look | human (declared drop at `spec`) | 2026-11-20 |

## Addenda (post-ship)

### Addendum 1: status-bar clock froze on a non-default locale machine (2026-11-22)

Report: after ship, on a machine whose CSV-export settings file carries a locale format
override, the status-bar clock stopped advancing. Root cause (cited): the UI timer tick shares
its handler with the export formatter; under .NET 10 the tick loop exits when the formatter
throws on that locale's format string. Resolution: safe-default rule applied — a small declared
milestone through the same roles and gates moved the clock onto its own dispatcher timer
(restoring the original's behaviour, not "improving" it); footprint for the one-file change
declared and audited.

**Census trace:** C-5 (walkthrough row). **E7 did not fire:** the capability was in the census;
what failed was a proof's reachability across locales, not a missing row — the fix is a parity
repair under an existing row, and the register records the lesson (walkthrough rows gain a
"vary the locale" step in the pack template). Had no row covered the clock, E7 would have fired
and the census would have grown the row before any fix.
