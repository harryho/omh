# SOURCE INVENTORY — <project name>

<!--
The scope contract. One row per source capability. Changing scope means editing this table —
never silently drifting. Dispositions: port / NEW / drop / defer, each with a reason; a row
without a reason is incomplete. greenfield projects inventory intended capabilities the same way.
-->

| | |
|---|---|
| **Contract kind** | legacy-app / existing-tests / api-spec / greenfield |
| **Source** | <app name + version, repo path, test suite, or spec doc> |

## Capabilities

| id | capability | source ref | disposition | reason |
|---|---|---|---|---|
| <PREFIX>-1 | <one line, user-visible> | <path / doc § / test name> | port | |
| <PREFIX>-2 | | | NEW | <why it exists now; no old equivalent> |
| <PREFIX>-3 | | | drop | <why it may die> |
| <PREFIX>-4 | | | defer | <why it waits, and where it is tracked> |

## Counts

`<n> total — port <n> · NEW <n> · drop <n> · defer <n>` (updated at every close; the delta is
the scope-drift record).
