# <RUN> Upgrade — Implementation Plan

> **Approval:** <date + approver — no build before this line is filled>

| | |
|---|---|
| **Role** | A · `<provider>` · `<model>` · <date> |
| **Governing design** | <design of record link> (binding) |
| **Governing census** | <parity census link> — every probe/contract row below cites a C-/K- id |
| **Inputs read** | <design, census, spike tree, source repo @ base commit> |
| **Est. effort** | <estimate> · **Touched areas:** <list> |
| **Verification this plan leaves green** | <commands> |

**Goal:** <one sentence: what moves from which stack to which target, behaviour preserved,
diff footprinted, in which clone and branch.>

**Architecture:** <2–3 sentences: the mechanism of the upgrade — what is replaced, what is
stripped, what is carried, and why the rest stays byte-identical.>

**Tech stack:** <target SDK/runtime, package swaps, tooling paths.>

## Global constraints

<One line each, verbatim from the design — every task implicitly includes them: target
framework, tool invocation paths, clone/branch policy, original-repo immutability, never commit
red, conventional commits, footprint violations are E5 hard stops, no feature work, no
modernization.>

## Declared diff footprint

The complete set of changes allowed in the clone between the recorded base commit and the final
state of the branch. Anything else in the clone is E5: hard stop, revert, re-audit.

### Replaced files

| File | Change | Expected line delta |
|---|---|---|
| <path> | <full replacement; content source> | ≤ <n> insertions / ≤ <n> deletions |

### Edited files

| File | Change | Expected line delta |
|---|---|---|
| <path> | <exact edit: lines/deletions> | <numstat> |

### New files

| File | Content (exact) | Purpose |
|---|---|---|
| <path> | <exact content> | <why> |

### Explicitly untouched

<Categories and named files that must show zero diff — the byte-identity claim the audit
checks.>

### Part-rewrites and reverts

| File | Behaviour preserved or restored | Why a part-rewrite/revert is needed |
|---|---|---|

(Section may be empty — but an upgrade that needs one and does not declare it is E5 when it
happens.)

### Untracked residue

<Build/publish/log output paths; covered by ignore rules; never `git add`-ed.>

### Input-carrying entries

One per census K-row — the mechanism that puts the input where the app reads it:

| Census row | Input | Carrying mechanism |
|---|---|---|
| K-1 | <input> | <csproj Content include / publish layout / copy step> |

### Machine-audit commands

The exact commands P5a runs, with expected outputs inline (status empty; changed-file set;
per-file numstat; census/compile-list equality; publish contents vs K-rows):

```bash
<command>   # expected: <exact output>
```

## Build tasks

### Task <T1>: <name>

**Files:** <none | created/modified>
**AC proof:** <which AC / census rows this supports>

- [ ] **Step <n>.1:** <action>

```bash
<exact command>
```
Expected: <exact output>. On mismatch: <X-code>.

<Repeat per task. Every step carries its complete content.>

## Verification

Machine gates (P5a) and smoke + probes (P5b) run exactly these. The mapping audit (R pass 1)
checks the table against the census row-by-row:

| Census row | Proof command |
|---|---|
| C-<n> | <command> |
| K-<n> | <publish/contents check> |

Smoke steps: <launch, window/title evidence, log check, census re-check — each with expected
output. No scripted GUI input; walkthrough rows are the pack's, not the smoke's.>

**V protocol:** V receives only the AC list and the commands above — never B's evidence, never
R's verdicts, never the audit. V re-runs everything and walks every AC.

## Escalations

| Code | Trigger | Action |
|---|---|---|
| E1 | blocking decision, no safe default | stop; report failing command, verbatim error, options |
| E2 | FAIL after one fix round | second attempt forbidden; escalate with both logs |
| E3 | estimate drift > 1.5× | report at task boundary; re-scope decision |
| E4 | unexplained tree state / census drift | stop; dump status/diff; no restore without explanation |
| E5 | change outside the declared footprint | hard stop: revert, re-audit, escalate |
| E6 | major-or-blocker deviation | escalate with evidence |
| E7 | parity gap outside the census | safe-default fix if one exists; add the census row; register entry |

## Appendix — Clarifications (B → A)

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|
| 1 | | | | |
