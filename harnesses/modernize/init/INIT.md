# INIT — adopting modernize in a target repository

Run this procedure from the target repo's root. Any capable agent with file + shell access can
execute it. Ask one question at a time; record every answer.

**Hard rule:** never proceed past step 6 while the validator reports an error, or while any
role's model is unconfirmed. Warnings may proceed — but each accepted warning is written into
the init log with who accepted it.

## 1. Project name

Ask: "What is this project called?" → `<name>`; used in `omh.config.yaml` and doc headers.

## 2. Runtime and stack policy

Ask: "What is the app today — runtime, UI toolkit, build system?" → free text, e.g.
"Java 17 desktop app (Swing, Maven)". Modernize has no `stack.to` — it runs on what is, until
the next upgrade moves it. Goes to config `stack.runtime`.

Then: "Which stack policy applies?" → the technology family. Shipped policies are listed in
`stacks/README.md` (`dotnet`, `java`, `kotlin`, `rust`); a project may point at its own policy
document instead. Goes to config `stack.policy`.

The policy is what tells the roles how this stack verifies, what counts as its own code, what
it can use as an oracle, and what bites while baselining — settled up front, not improvised
mid-tranche.

## 3. Baseline state (the M0 inventory)

Walk this checklist, record each answer — the M0 state summary of tranche 1 is built from it:

1. "Is there a command that builds and runs tests today?" → the candidate verify command; if
   none, L0 is the first tranche.
2. "Which test framework, and where do tests live?"
3. "Is there a coverage mechanism? What does it count as the app's own code today?" → if the
   scope is unscoped, slot 3 of the stack policy becomes a tranche-1 task.
4. "What could serve as an independent oracle for the core logic?" → reference
   implementations, proven libraries, hand-computed vectors; if none, E2 applies.
5. "Is there a benchmark/measurement tool?" 
6. "Can the UI be launched in-process with bundled data?" → if only with OS-level input or
   accessibility hooks, note it — slot 7 needs a real answer before L5.
7. "What is deliberately slow or flaky-prone today?" → slow-suite candidates.

## 4. Work location

Ask three things, record all: (a) where the ledgers live (default `notes/baseline/`); (b) the
branch policy — one branch per tranche off the main branch, main always green on the verify
command; (c) that this repo is the working repo — modernize works in place; no original/clone
split, unlike upgrade.

## 5. Roles — preset, then overrides

Show the preset table from MODELS.md plus the alternate pool. Ask: "Which preset —
max-diversity, balanced, budget?" (Modernize changes no behaviour; budget is defensible more
often than for upgrades, but the three-vendor law on the control path holds in every preset.)

Then loop: "Override any role?" — for each yes: role letter + `{provider, model}` pair (bare
model names are not accepted; MODELS.md explains why). modernize's letters are A planner /
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

**Same-model or same-vendor consent.** Declared pairs (`R-B, V-B, V-R`) cannot be accepted
away — the validator refuses them. If any warning names a shared model or provider on the
control path, ask it explicitly: "`<pair>` shares `<model/provider>` — the recommendation is a
different model, ideally a different vendor. Accept and record, or change the pair?" Only an
explicit acceptance proceeds; record it in the init log (pair, who accepted, date).

## 7. Gates

`direction` is human by law — not settable. `ratchet_rise` is human always — not settable.
Ask: "Which of the remaining gates pause for you?" → defaults are `tranche_note: human` and
`close: human`; every other gate runs machine or role side. Goes to config `gates:`.

## 8. First tranche proposal

From the step-3 answers, propose tranche 1 to the human: usually L0 plus the one content rung
the step-3 gaps demand (unscoped coverage → slot 3 work; no verify command → L0 alone). The
human may reorder, split, or defer — the ladder is a menu, not a sequence. Record the decision
as tranche 1's direction; the M1 gate of tranche 1 is satisfied by this init conversation.

## 9. Scaffold

Write, from the templates: `omh.config.yaml` (values as recorded); the four ledgers
(`baseline-report.md`, `findings-ledger.md`, `ratchet.md`, `traps-ledger.md`) with their
header blocks filled and the step-3 answers as first rows where they fit; the project rules
stub if the repo has none. Vendor the playbook per the `vendoring:` setting (default: ignore —
the harness runs from its checkout; `commit` copies `omh/` into the repo, pinned to the
version in `harnesses/modernize/VERSION`).

## 10. Init log

Append to `notes/baseline/init-log.md`: date, every answer, every validator run with its
result, every warning with its recorded acceptance, the confirmed roles table, the tranche-1
direction. The init log is the provenance of the whole engagement — first row of the baseline
report links to it.
