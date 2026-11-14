# M<N> — Implementation Plan

> **Approval:** <date + approver — no build before this line is filled>

**Spec:** <spec link> · **Est. effort:** <estimate> · **Touched areas:** <list>
**Verification this plan leaves green:** <commands>

> **For the builder role:** execute task by task. Steps use checkbox (`- [ ]`) syntax. Never
> guess where a question was owed — see the Clarifications appendix.

## Global constraints

<The project rules + inventory dispositions that bind this build, one line each, copied verbatim
from where they bind. Every task's requirements implicitly include this section.>

## Test story

Mandatory. A plan with no test story is not a plan (the unit / functional / coverage / manual
layers, what each proves, and which commands CI or the operator actually runs):

| Layer | What it proves | Where |
|---|---|---|
| **Unit** | <modules + first real test names; smoke-only allowed only if the milestone ships no logic — say so in one sentence> | |
| **Functional** | <the automated gates, commands actually run> | |
| **Coverage** | <tooling, baseline policy, threshold on/off> | |
| **Manual** | <every manual verification, listed as manual — never implied> | |

### Task 1: <name>

**Files:**
- Create: `exact/path`
- Modify: `exact/path`

**Interfaces:**
- Consumes: <exact signatures from earlier tasks>
- Produces: <exact names/types later tasks rely on>

- [ ] **Step 1:** <failing test, complete content>

```<lang>
<complete test code>
```

- [ ] **Step 2:** Run `<exact command>` — expected: FAIL with <reason>.
- [ ] **Step 3:** <minimal implementation, complete content>

```<lang>
<complete implementation code>
```

- [ ] **Step 4:** Run `<exact command>` — expected: PASS.
- [ ] **Step 5:** Commit — `<conventional message scoped to the milestone>`

<Repeat per task. Every step carries its complete content — "add appropriate handling" is a
plan failure, not a step.>

## Appendix — Clarifications (B → A)

| # | Question (B) | Answer (A — binding) | Date | Sections affected |
|---|---|---|---|---|
| 1 | | | | |
