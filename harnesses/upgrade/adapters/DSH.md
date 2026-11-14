# DSH adapter — launching upgrade roles on this runtime

How the four upgrade roles map onto this runtime's mechanics. Everything else in `harnesses/upgrade/`
is runtime-neutral; this file is the only place runtime vocabulary appears.

## Roles → mechanics

| Role | DSH mechanic | Fresh context? | Prompt carries |
|---|---|---|---|
| Orchestrator | the lead session itself (you) | — | the run: launch roles, enforce gates, assemble the close note; authors nothing analytical |
| A · Planner | dedicated teammate for the P1–P3 span (spike → design+census → plan) | yes | HARNESS phases P1–P3, templates, census contract; the original source repo path + base commit |
| B · Builder | fresh subagent per task batch, or one durable builder for small runs | per batch (state = plan + prior commits) | the approved plan tasks only; never the census or design narrative |
| R · Reviewer | fresh subagent with model override, launched twice | both passes fresh | pass 1: design + census + plan; pass 2: design + census + plan + branch diff; never B's evidence or V's report |
| V · Verifier | fresh subagent with model override, launched in parallel with R pass 2 | yes | **the AC list and the plan's command block — nothing else** |
| Human gates | `ask_user_question` / pause + `present` | — | the gate's artifact (design, close note) and the specific decision |

Route overrides use the runtime's model selection (provider + model per agent), reading the
pairs from `omh.config.yaml`.

## Launch-prompt neutrality

A launch prompt tells an agent its role and inputs — never which runtime is launching it. The
prompt must not mention DSH, teammates, or harness machinery; the artifact speaks for itself.

Bad: "You are R, a subagent spawned by the DSH team lead to review this plan."
Good: "You are role R (reviewer) in an upgrade upgrade run. Read the design of record and parity
census first, derive your own checklist, then review the plan at notes/plan.md."

## The V prompt is a protocol, not a summary

V's prompt is the acceptance-criteria list plus the plan's commands verbatim, plus this
instruction: "Re-run each command yourself; record observed output; walk every AC to a verdict.
You have been deliberately given nothing else — do not ask for more context; the blindness is
the method." Never attach B's evidence, R's verdicts, the audit, or the census.

## Parallel R pass 2 ∥ V

After probes are green, launch R (pass 2) and V in the same message as two independent
subagents. Never relay one's output to the other before both finish. Both verdicts block close
independently; the orchestrator records both, then pauses at the `close` gate.

## Route catalog

Available providers/models on this runtime (verify at launch; catalogs change):

| Provider | Models |
|---|---|
| `zai-anthropic` | glm-5.3, glm-5.3-flash |
| `kimi` | kimi-k3, kimi-k2.7-code |
| `minimax-anthropic` | MiniMax-M3[1m], MiniMax-M3.1-Flash |
| `mimo` | mimo-v2.6-flash, mimo-v2.6-pro |
| `deepseek-anthropic` | deepseek-flash[1m], deepseek-v4-pro |
| `opencode` | deepseek-v4-pro, deepseek-v4.1-flash, glm-5.3, glm-5.3-flash, kimi-k2.7-code, kimi-k3, minimax-m3, … |

## Ledger stamping

Every produced document header records role + provider + model + date:

```markdown
| **Author** | R · `kimi` · kimi-k2.7-code · 2026-11-14 |
```

The stamp names the model that actually produced the document — after any substitution, the
substitute's name goes in the stamp.

## Route churn

A route that fails to launch twice is dead for the run. Substitute from the catalog, satisfying
the validator's independence errors (never B's model, never each other's where declared), re-run
`validate-config.sh` on the updated config, and stamp the substitute everywhere it appears. The
close note's verdict summary records the substitution. Precedent: in the FXPA run the V route
failed twice and `deepseek-anthropic` · deepseek-v4-pro fired — stamped in that run's verify
report.
