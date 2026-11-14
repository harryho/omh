# UPG-1 — Implementation Plan (excerpt)

> **Approval:** 2026-11-20, human at the `plan` gate (after R pass 1 round 2 PASS).

| | |
|---|---|
| **Role** | A · `zai-anthropic` · glm-5.3 · 2026-11-20 |
| **Governing design** | `notes/design-upg-1.md` (binding) |
| **Governing census** | `notes/parity-census-upg-1.md` — rows cited below |
| **Inputs read** | design, census, spike clone, original repo @ `2c41f77` |
| **Est. effort** | 1 day · **Touched areas:** project file, one designer file, two new helper projects |
| **Verification this plan leaves green** | build, ProbeMath, publish contents, launch title |

**Goal:** Move StockPlot to `net10.0-windows` in clone `upgrade/` on branch `dotnet10`,
behaviour preserved, every change inside the footprint below.

**Architecture:** SDK-style project replaces the csproj; the 61 compile sources stay
byte-identical except 4 stripped designer lines; the data tree and side-car DLL ride the new
project file into the publish output; a `ProbeMath` console project proves the math.

**Tech stack:** .NET 10 SDK, `net10.0-windows`, WinForms flavor.

## Global constraints

`net10.0-windows` only · `dotnet` CLI at repo root · work only in `upgrade/` on `dotnet10` ·
original repo read-only · never commit red · conventional commits · footprint violations are
E5 hard stops · no feature work, no modernization.

## Declared diff footprint

### Replaced files

| File | Change | Expected line delta |
|---|---|---|
| `StockPlot.csproj` | SDK-style rewrite: `net10.0-windows`, `UseWindowsForms`, K-1 `Content` include (`data\**` → output), K-2 `Reference` (`MathFin.dll`, CopyLocal) | ≈ 60 insertions / all deletions |

### Edited files

| File | Change | Expected line delta |
|---|---|---|
| `LoginDialog.designer.cs` | strip 4 `SkinKit` lines | `0 4` |

### New files

| File | Content (exact) | Purpose |
|---|---|---|
| `ProbeMath/ProbeMath.csproj` + `ProbeMath/Program.cs` | console app referencing `MathFin.dll`, prints SMA-20 verdict over a `.day` file | C-2 probe |
| `.gitignore` | `bin/`, `obj/`, `publish/`, `logs/` | untracked residue policy |

### Explicitly untouched

All compile sources except `LoginDialog.designer.cs` (61-file list equality); `data\`,
`samples\`, `MathFin.dll`, all `.resx`, all other designer files — zero diff.

### Part-rewrites and reverts

None declared. If build reveals one is needed, it is added here **before** the code changes
(E5 otherwise).

### Untracked residue

`upgrade/**/bin/`, `upgrade/**/obj/`, `publish/`, `logs/` — ignored, never `git add`-ed.

### Input-carrying entries

| Census row | Input | Carrying mechanism |
|---|---|---|
| K-1 | `data\` ticker tree | csproj `Content Include="data\**\*"` + `CopyToOutputDirectory=PreserveNewest` |
| K-2 | `MathFin.dll` | csproj `Reference Include="MathFin"` + `<Private>true</Private>` |

### Machine-audit commands

```bash
git -C upgrade status --porcelain                                   # expected: empty
git -C upgrade diff --name-only 2c41f77..dotnet10                   # expected: 5 files (below)
git -C upgrade diff 2c41f77..dotnet10 --numstat                     # csproj ~60/…; designer 0/4
git -C upgrade diff 2c41f77..dotnet10 -- '*.cs' ':!LoginDialog.designer.cs'   # expected: empty
dotnet publish upgrade/StockPlot -c Release -o publish -r win-x64 --self-contained false
test -d publish/data/acme/local && test -f publish/MathFin.dll      # expected: exit 0
```

## Build tasks

### Task T1: project conversion + carrying entries
**Files:** replaced `StockPlot.csproj`; new `.gitignore`
**AC proof:** AC-1, AC-3 (K-1, K-2)

- [ ] **Step 1.1:** write the SDK-style csproj with `UseWindowsForms`, the K-1 `Content`
      include and the K-2 `Reference`, then build:

```bash
dotnet build upgrade/StockPlot.sln -c Release
```
Expected: `Build succeeded. 0 Warning(s). 0 Error(s).` On mismatch: E1.

### Task T2: SkinKit strip · Task T3: ProbeMath probe · Task T4: publish contents check
*(elided in this excerpt — same shape: files, AC proof, steps, expected output)*

## Verification

Machine gates (P5a) and smoke + probes (P5b) run exactly these. The mapping audit (R pass 1)
checks the table against the census row-by-row:

| Census row | Proof command |
|---|---|
| C-1 | `dotnet run --project upgrade/ProbeMath -c Release -- samples/acme.day` + launch title check (load path exercised) |
| C-2 | `dotnet run --project upgrade/ProbeMath -c Release -- samples/acme.day` → `RetCode=Success elements=112 PROBE PASS` |
| K-1 | `test -d publish/data/acme/local` |
| K-2 | `test -f publish/MathFin.dll` |
| C-3, C-5, C-6 | walkthrough pack W1–W3 (human session at close) |
| C-4, C-7 | observation citations (census) |

Smoke steps: launch from `publish/` → process alive, title `StockPlot`; log tail has no
exceptions; close → C-4 dialog appears (manual confirm during walkthrough, not scripted).

**V protocol:** V receives only the AC list and the commands above — never B's evidence, never
R's verdicts, never the audit. V re-runs everything and walks every AC.

## Escalations

E1 blocking decision · E2 FAIL after one fix round · E3 estimate drift >1.5× · E4 unexplained
tree · E5 footprint violation (revert → re-audit → escalate) · E6 major/blocker deviation ·
E7 parity gap outside the census. All hard stops regardless of gate settings.

## Appendix — Clarifications (B → A)

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|
| 1 | `data\` paths are lowercase in the repo but `DataFeed` builds `data\<TICK>\local\` with the ticker's case — does the Content include need case-exact staging? | Keep repo casing as-is; Windows FS is case-insensitive and `ResolvePath` lowercases on lookup — no staging change. Verified against `MainForm.cs:118`. | 2026-11-20 | T1 (csproj), footprint untouched-list |
