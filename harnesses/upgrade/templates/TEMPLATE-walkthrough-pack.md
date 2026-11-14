# <RUN> — walkthrough pack (the one human session, at close)

<!--
Executed by the human at P7, once, in order. Every `walkthrough` census row is proven here;
results land in the close note's parity table. Preconditions come from the smoke evidence.
-->

| | |
|---|---|
| **Prepared by** | orchestrator (steps) + A (expected observations) |
| **Date of session** | <filled when run> |
| **Executed by** | <the human> |
| **Build under test** | <exact build/ship path> |

## Preconditions (from P5b — must already be green)

<Launch works; probes green; audit MATCH; shipped contents carry the K-rows.>

## Steps

### W1 — C-<n>: <capability>

1. <exact action>
2. **Expected observation:** <what must be seen — specific enough to check>

Result: <PASS / FAIL / notes>

### W2 — C-<n>: <capability>

1. <exact action>
2. **Expected observation:** <…>

Result: <…>

<Lesson from run UPG-1 (see the upgrade example): where a capability depends on locale, settings
or environment, repeat its step once under a varied setting (e.g. a non-default locale) — a
walkthrough that passed one way can still regress another.>

<Repeat per walkthrough row. Also demonstrate any `dead-in-source` rows worth showing the
human (e.g. the menu item that no-ops in the original and must still no-op), so "preserved
faithfully" is seen, not just cited.>

## Results table (feeds the close note's parity table)

| Step | Census row | Result | Notes |
|---|---|---|---|
