# <RUN> — diff review (R pass 2)

<!--
Authored by R at P6, after probes are green. Judges the committed work against the design and
the declared footprint. Re-runs the audit commands personally — green output is never taken on
faith. FAIL blocks close.
-->

| | |
|---|---|
| **Role** | R · `<provider>` · `<model>` · <date> — pass 2 (same model as pass 1 by design) |
| **Governing design** | <design link> |
| **Census** | <census link> |
| **Plan** | <plan link> |
| **Work clone** | <path>, branch `<branch>`, base `<base>` |

## Scope and method

<What was read: design, census, plan, git history, the full branch diff, touched files. What
was deliberately not read (V's report; optionally B's evidence file).>

## Checks

1. <diff = declared footprint — file set, numstat, commits>
2. <byte-identity of untouched categories>
3. <input-carrying entries actually present in the shipped output>
4. <built-unit list / census equality — per the stack policy>
5. <no behaviour change beyond the declared edits>
6. <no build output committed>

## Deviations and observations

- <Observation (not a deviation): …>
- <Deviation (minor, self-accepted and logged): … — anything major/blocker is E6.>

## Verdict

**PASS / PASS-WITH-DEVIATIONS / FAIL** — <one line. FAIL blocks close and returns the work to
B.>
