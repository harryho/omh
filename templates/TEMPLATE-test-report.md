# TEST-E-M<N> — independent test report

<!--
Written by the independent tester after machine gates are green, in parallel with the code
review. Sources read: the spec ONLY. Never the plan, never the builder's tests, never the
reviewer's report — independence is the entire value of this role.
-->

| | |
|---|---|
| **Milestone** | M<N> — <name> |
| **Spec (only source read)** | `notes/specs/SPEC-M<N>-*.md` |
| **Tester** | <role> · <provider> · <model> — **must differ from builder B's model** |
| **Builder** | <provider> · <model> |
| **Date** | <date> |
| **Verdict** | **PASS** / **FAIL** (test failures block close) |

> **Sources-read statement:** I derived every test below from the spec's acceptance criteria
> alone. I did not open the plan, the builder's tests, or any review document.

## 1. Derived tests

Each test names the AC it proves and why it proves *that* AC and not something adjacent:

| Test | AC | Why it proves it |
|---|---|---|
| `<test name / command>` | AC-1 | |

## 2. Results

| Test | Command | Observed output | Pass/fail |
|---|---|---|---|

## 3. Folded-back suggestions

Tests worth adopting into the main suite at close (with why), for the builder to fold in after
this report — not before:

| Test | Why worth keeping |
|---|---|

## 4. Verdict

<One paragraph: what passed, what failed, what a failure means for close.>

> **Statement:** every result above is output I observed myself from commands I ran myself.
