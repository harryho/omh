# INIT — adopting omh in a target repository

Run this procedure from the target repo's root (an empty directory is fine). Any capable agent
with file + shell access can execute it. Ask one question at a time; record every answer.

**Hard rule:** never proceed past step 5 while the validator reports an error, or while any
role's model is unconfirmed. Warnings may proceed — but each accepted warning is written into
the init log with who accepted it.

## 1. Project name

Ask: "What is this project called?" → `<name>`; used in `omh.config.yaml` and doc headers.

## 2. Source contract

Ask: "What defines correct behaviour today?"
`legacy-app` (an old app is being rewritten) · `existing-tests` (a passing suite is the contract)
· `api-spec` (an interface spec is the contract) · `greenfield` (nothing yet).

Then: "Where does the source live?" → a path, repo, suite, or doc. This is the inventory source.
For `greenfield`, the inventory will list *intended* capabilities instead (same table, same law).

## 3. Stack

Ask: "Rewriting from what, to what?" → free text, e.g. "WPF .NET 4.8 desktop" → "React +
TypeScript web". Goes to config `stack.from` / `stack.to`.

## 4. Roles — preset, then overrides

Show the preset table from MODELS.md plus the alternate pool. Ask: "Which preset —
max-diversity (parity-critical), balanced (solo, fast), budget (batch, cost-bound)?"

Then loop: "Override any role?" — for each yes: role + `{provider, model}` pair (bare model
names are not accepted; MODELS.md explains why). After **every** change run:

```bash
bash omh/tools/validate-config.sh omh.config.yaml
```

An `ERROR:` line blocks: fix the pair or pick a different role before continuing. A `WARNING:`
line proceeds only after the human says accepted — record it.

## 5. Confirm the model for every role

Before any further action, present the resolved assignment and get the human to confirm each
role's model explicitly. The model choice is theirs to approve — not the agent's default to
assume:

| Role | Provider | Model | From |
|---|---|---|---|
| A — architect | | | preset / override |
| B — builder | | | preset / override |
| C — spec review | | | preset / override |
| D — code review | | | preset / override |
| E — independent test | | | preset / override |

Ask: "Confirm the model for each role — accept all, or change any?" Accept only on an explicit
confirmation of the table (or per-row confirmations). Any change goes back to step 4 for that
role, re-runs the validator, and returns here. Do not write the config, do not scaffold, do not
move on to gates until every row is confirmed. Record each confirmation (role, pair, who
confirmed, date) in the init log.

## 6. Gates

Ask: "Fully autonomous, or does any gate pause for you?" Default: all `auto`
(`spec · plan · deviations · close`). List the four; flip named ones to `human`.
Parity-critical projects should at least human-gate `spec` and `plan`.

## 7. Verification commands

Ask: "Which commands must be green at every milestone's verify phase?" → a list, or "defer to
the M0 plan" (config gets a commented stub the M0 plan fills).

## 8. Scaffold

Create in the target repo:

- `notes/specs/` and `notes/specs/plans/` — empty, with the plan template copied in.
- `notes/source-inventory.md` — from `templates/TEMPLATE-source-inventory.md`; for a rewrite,
  populate it from the source now (role A's first job if deferred — but say which).
- `omh.config.yaml` — from `templates/omh.config.yaml`, every answer filled in.
- The project rules file — from `templates/TEMPLATE-project-rules.md`, named per the target
  repo's convention (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, …).
- Vendored playbook at `omh/` — **flat, no family nesting**. Copy from this harness directory:
  `HARNESS.md`, `ROLES.md`, `MODELS.md`, `templates/`, `init/`, `adapters/`; plus from the
  family root: `RULES.md`, `tools/validate-config.sh` (with `tools/fixtures/`), `skill/SKILL.md`;
  and write `omh/VERSION` with this harness's version stamp verbatim. The maintainer-side checks
  are not vendored — the validator is the project's gate. The vendored copy is what the project
  runs on — it must not reference files outside the repo.
- **Vendoring mode** — ask: "Should the vendored playbook be committed or ignored?"
  → `vendoring: ignore` (default) or `vendoring: commit` in `omh.config.yaml`. Record the
  harness version in `harness_version:` in the same file — it is the **committed** pin, and it
  must equal the contents of `omh/VERSION`.
  - **`ignore`** → write `/omh/` into the target repo's `.gitignore` (create the file if absent),
    and add a hard rule to the project rules file: *"The omh playbook is not in git — vendor
    `omh/` at the pinned `harness_version` before the first phase of a milestone."* A fresh
    clone cannot run the loop until it is vendored.
  - **`commit`** → vendor as usual and commit `omh/`; a fresh clone then works immediately and
    the project's history records which process version ran.
  Either way the vendored copy records its source — the omh repo, the harness id, and the
  version — so the exact copy can be restored.
## 9. Init log

Write `notes/omh-init-log.md`: every question, answer, role-model confirmation, validator
result, and accepted warning, with dates. This log is the provenance of every later "who chose which model" question.

## 10. Hand off

Print the config summary (roles table, gates, verification list) and the next action:

> **Run role A on milestone M0** — write `notes/specs/SPEC-M0-*.md` from the inventory, per the
> vendored `HARNESS.md` phase P1.
