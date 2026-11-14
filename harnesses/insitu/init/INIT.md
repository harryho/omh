# INIT — adopting insitu in a target repository

Run this procedure from the target repo's root. Any capable agent with file + shell access can
execute it. Ask one question at a time; record every answer.

**Hard rule:** never proceed past step 6 while the validator reports an error, or while any
role's model is unconfirmed. Warnings may proceed — but each accepted warning is written into
the init log with who accepted it.

## 1. Project name

Ask: "What is this project called?" → `<name>`; used in `omh.config.yaml` and doc headers.

## 2. Target and stacks

Ask: "What is being upgraded, from what to what?" → the app/system name, current stack, target
LTS/runtime; free text, e.g. "WinForms .NET Framework 4.8 desktop" → ".NET 10
(`net10.0-windows`)". Goes to config `stack.from` / `stack.to`.

## 3. Source contract + inventory location

Ask: "Where does the original live?" → the original repo path + base commit. This is the census
source: role A traces every capability and input row to it. The original stays untouched; the
upgrade happens in a clone (step 4).

## 4. Work location

Ask three things, record all: (a) where the clone lives; (b) the upgrade branch name (one
branch, one upgrade); (c) confirmation that the original repo is read-only for this run.

## 5. Roles — preset, then overrides

Show the preset table from MODELS.md plus the alternate pool. Ask: "Which preset —
max-diversity (parity-critical), balanced (solo, fast), budget (batch, cost-bound)?"

Then loop: "Override any role?" — for each yes: role letter + `{provider, model}` pair (bare
model names are not accepted; MODELS.md explains why). insitu's letters are A planner /
B builder / R reviewer / V verifier, already typed in the config template. After **every**
change run:

```bash
bash omh/tools/validate-config.sh omh.config.yaml
```

An `ERROR:` line blocks: fix the pair or pick a different role before continuing. A `WARNING:`
line proceeds only if the human explicitly accepts it — record who and why in the init log.

## 6. Confirm the model for every role

Print the current roles table — role letter, pair, model — and ask the human to confirm each
row out loud. No config write, no scaffold, no further step until every row is confirmed.
Record each confirmation (role, pair, who confirmed, date) in the init log.

## 7. Gates

`direction` is human by law — not settable. Ask: "Which of the remaining gates pause for you?"
Defaults: `spec: human`, `close: human`, `plan/footprint/smoke: auto`. Flip any settable gate;
record each flip with a dated decisions-register entry.

## 8. Verification commands

Ask: "Which commands must be green before anything ships?" → a list, or "defer to the plan".
Note out loud: the parity census adds one probe command per `probe` capability row at plan
time — those land in the same `verification:` block. If the census is not written yet, defer
to the plan and say so.

## 9. Scaffold

Create in the target repo:

- `notes/` — with `notes/parity-census.md` from `templates/TEMPLATE-parity-census.md`
  (populate = role A's P2 job if deferred — but say which), plus `notes/records/` empty.
- `notes/design.md` and `notes/plan.md` — from their templates, headers filled.
- `omh.config.yaml` — from `templates/omh.config.yaml`, every answer filled in.
- The project rules file — from `templates/TEMPLATE-project-rules.md`, named per the target
  repo's convention (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, …).
- Vendored playbook at `omh/` — **flat, no family nesting**. Copy from this harness directory:
  `HARNESS.md`, `ROLES.md`, `MODELS.md`, `templates/`, `init/`, `adapters/`; plus from the
  family root: `RULES.md`, `tools/validate-config.sh` (with `tools/fixtures/`), `skill/SKILL.md`;
  and write `omh/VERSION` with this harness's version stamp verbatim. The maintainer-side checks
  are not vendored — the validator is the project's gate. The vendored copy is what the project
  runs on — it must not reference files outside the repo.

## 10. Init log + hand off

Write `notes/omh-init-log.md`: every question, answer, role-model confirmation, validator
result, accepted warning, gate flips — with dates. Then print the config summary (roles table,
gates, verification list) and the next action:

**Run role A on the spike and design of record — `HARNESS.md` P1–P2 (spike → direction →
design + parity census).**
