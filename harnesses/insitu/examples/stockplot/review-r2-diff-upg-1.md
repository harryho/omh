# UPG-1 — diff review (R pass 2)

| | |
|---|---|
| **Role** | R · `kimi` · kimi-k2.7-code · 2026-11-20 — pass 2 (same model as pass 1 by design) |
| **Governing design** | `notes/design-upg-1.md` |
| **Census** | `notes/parity-census-upg-1.md` |
| **Plan** | `notes/plan-upg-1-excerpt.md` |
| **Work clone** | `upgrade/`, branch `dotnet10`, base `2c41f77` |

## Scope and method

Read: design, census, plan (approved revision), `git log dotnet10 --not main`, full branch
diff, all five touched files, re-ran the audit commands personally. Deliberately not read:
V's report (parallel, blind), B's smoke evidence.

## Checks

1. Diff = declared footprint — file set exact (5), numstat as declared, 3 commits
   (`feat(upg1): sdk-style csproj with carrying entries`, `chore(upg1): strip skinkit`,
   `test(upg1): probemath probe + gitignore`).
2. Untouched categories byte-identical — `*.cs` diff empty except designer (verified myself).
3. Input-carrying entries present in publish output — re-ran `test -d publish/data/acme/local`
   and `test -f publish/MathFin.dll`: both exit 0.
4. Compile-list equality — 61 sources before and after.
5. No behaviour change beyond declared edits — the designer strip removes only `SkinKit`
   wiring; no other source moved.
6. No build output committed — `.gitignore` covers it; porcelain empty.

## Deviations and observations

- Observation: the csproj diff is 61/213 vs the plan's "≈60" — within the declared approximation;
  noted, not a deviation.
- Deviation (minor, self-accepted and logged): `.gitignore` also ignores `logs/` though the plan's
  residue section names it under publish output — same policy, wider pattern.

## Verdict

**PASS-WITH-DEVIATIONS** — one logged minor deviation; blocks nothing.
