# DSH adapter — launching modernize roles on this runtime

How the four modernize roles map onto this runtime's mechanics. Everything else in
`harnesses/modernize/` is runtime-neutral; this file is the only place runtime vocabulary
appears.

## Roles → mechanics

| Role | DSH mechanic | Fresh context? | Prompt carries |
|---|---|---|---|
| Orchestrator | the lead session itself (you) | — | the loop: launch roles, enforce gates, keep the M0 state summary, record gate outcomes; authors nothing analytical |
| A · Planner | a fresh dedicated teammate for the M1–M2 span — fresh context, never forked from the orchestrator's conversation | yes | HARNESS phases M1–M2, the tranche-note template, the ledger templates; the repo path + the direction decision |
| B · Builder | a fresh agent per tranche (never a durable context-inheriting builder) | per tranche (state = tranche note + prior commits) | the approved note's tasks only; never the ledgers' narrative |
| R · Reviewer | fresh subagent with model override, launched twice | both passes fresh | pass 1: HARNESS + ledgers + tranche note; pass 2: tranche note + branch diff; never B's evidence or V's report |
| V · Verifier | fresh subagent with model override, launched in parallel with R pass 2 | yes | **the acceptance criteria and the command block — nothing else** |
| Human gates | `ask_user_question` / pause | — | the gate's artifact (tranche note, close record) and the specific decision |

Route overrides use the runtime's model selection (provider + model per agent), reading the
pairs from `omh.config.yaml`.

## Launch-prompt neutrality

A launch prompt tells an agent its role and inputs — never which runtime is launching it. The
prompt must not mention DSH, teammates, or harness machinery; the artifact speaks for itself.

Bad: "You are R, a subagent spawned by the DSH team lead to review this tranche note."
Good: "Review the attached tranche note against the ladder and ledger contracts in
`harnesses/modernize/HARNESS.md`. Derive your own checklist before reading the note. Verdict:
PASS, or FAIL with the specific defects."

## Builder hand-off (M4 → M5)

B reports done only after committing: the orchestrator runs `git status` — an uncommitted
tranche is returned to B, not audited. The commit message names the tranche and the rungs; the
ledgers' drafted rows travel in the same commit as the pins they describe.
