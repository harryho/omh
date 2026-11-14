# <RUN> — smoke + probe evidence (P5b)

<!--
Authored by B after the footprint audit is MATCH. No scripted GUI input anywhere: evidence is
process/window checks, app logs, console probes, file listings. GUI-only capability rows are
walkthrough rows — they are proven in the pack, not here.
-->

| | |
|---|---|
| **Role** | B · `<provider>` · `<model>` · <date> |
| **Plan (binding)** | <plan link, smoke section> |
| **Clone** | <path>, branch `<branch>` |

## 0. Preconditions

<Branch, HEAD, porcelain empty, base commit — observed, not assumed.>

## 1. Launch smoke

<Launch command → process alive + window/title evidence → log tail check → close procedure
(matching the app's real exit behaviour — see the census observation rows).>

## 2. Probe table

One row per census `probe` row — the commands come from the plan's mapping table:

| Census row | Command | Expected | Observed | Verdict |
|---|---|---|---|---|
| C-<n> | <command> | <exact output> | <observed> | PASS/FAIL |

## 3. Ship smoke (if the upgrade ships an artifact)

<Ship → contents listing → launch of the shipped artifact → expected title.>

## 4. Tree-state guard

`git status --porcelain` → empty. Build/ship/log output landed only under ignored paths.
Any dirtied tracked file: explain or escalate (E4).

**Verdict:** <all rows PASS, or FAIL per row with the census row named — FAIL returns to B.>
