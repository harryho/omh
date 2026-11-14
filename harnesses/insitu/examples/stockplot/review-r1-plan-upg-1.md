# UPG-1 — plan review (R pass 1)

| | |
|---|---|
| **Role** | R · `kimi` · kimi-k2.7-code · 2026-11-20 |
| **Governing design** | `notes/design-upg-1.md` |
| **Governing census** | `notes/parity-census-upg-1.md` |
| **Plan reviewed** | `notes/plan-upg-1-excerpt.md` (draft of 2026-11-20) |

## Review method

Read order was anti-anchoring: design first, then census (all 9 rows), derived my own
checklist below — only then opened the plan draft.

## Checklist (derived before reading the plan)

1. Every `probe` row has a command. 2. Every `walkthrough` row maps to a pack step. 3. Every
`observation` row is cited in the census itself. 4. Every K-row has a carrying entry. 5.
Footprint covers every file the tasks touch. 6. Untouched categories are checkable (list
equality / zero diff). 7. AC split machine-half/human-half matches proof methods. 8. Compile
equality is in the audit commands.

## Mapping audit

| Census row | Required proof | Found in plan (draft) | Verdict |
|---|---|---|---|
| C-1 (probe) | a command in verification | present (ProbeMath + launch) | OK |
| C-2 (probe) | a command in verification | present (ProbeMath) | OK |
| C-3 (walkthrough) | a step in the pack | present (W1) | OK |
| C-4 (observation) | a citation | present (`MainForm.cs:64`) | OK |
| C-5 (walkthrough) | a step in the pack | present (W2) | OK |
| C-6 (walkthrough) | a step in the pack | present (W3) | OK |
| C-7 (observation) | a citation | present (`MainForm.cs:977`) | OK |
| **K-1 (contract)** | **a carrying entry in the footprint** | **absent — the data tree appears in no footprint section** | **MISSING** |
| **K-2 (contract)** | a carrying entry + a contents check in the mapping table | carrying entry absent; mapping table row absent | **MISSING** |

## Findings

### F1: K-1 has no carrying entry — the ticker data tree would not ship

The census says the app reads `data\<TICK>\local\<TICK>.day` at startup
(`MainForm.cs:118`). The draft csproj rewrite (Task T1) converts the project but declares
no `Content` include; the publish audit would then check for a directory nothing copies.
This is exactly the class of gap the census exists for. **Blocking.**

### F2: mapping table lacks the K-2 row

`MathFin.dll` gets a `Reference` in the draft but the verification mapping table checks no
contents row for it. Minor — fix with F1.

## Deviations

None.

## Verdict

**FAIL** — returned to A 2026-11-20. Build blocked until the K-rows carry.

---

## Re-review (round 2 — dated section, original verdict above is untouched)

| | |
|---|---|
| **Role** | R · `kimi` · kimi-k2.7-code · 2026-11-20 |

A revised the plan: csproj now declares the K-1 `Content` include and the K-2 `Reference`
(input-carrying entries present in the footprint), and the mapping table gained K-1/K-2
contents checks. Re-ran the mapping audit row by row: 9/9 OK. Checklist items 4 and 8 now
green. F1 and F2 resolved; no new findings.

**Verdict: PASS** — build unblocked 2026-11-20.
