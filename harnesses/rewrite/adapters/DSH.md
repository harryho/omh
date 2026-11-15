# Adapter — running omh roles on DSH

The one runtime-specific document. Everything else (HARNESS.md, ROLES.md, RULES.md, MODELS.md)
is runtime-neutral; if your harness is not DSH, write the equivalent of this file for it and stop
reading here.

## Roles → DSH mechanics

| omh role | DSH mechanism |
|---|---|
| **A — Architect** | a fresh agent per milestone span (`workflow` agent with a model override, or a new session); the brief carries only A's intake paths — inventory, previous close note, open decisions |
| **B — Builder** | a fresh agent per plan task (`workflow` agent; model override optional) — never inline in the orchestrating session and never a context-inheriting dispatch; the task brief carries only that task's plan section |
| **Orchestrator** | the lead session itself: launches roles, enforces gates, assembles the close digest; authors nothing analytical |
| **C — Spec reviewer** | fresh-context agent with a model override — via the `workflow` tool's per-agent `provider`/`model` options |
| **D — Code reviewer** | same as C, launched in parallel |
| **E — Independent tester** | same as C, launched in parallel; prompt grants spec path only |
| **Human gates** | a gate flipped to `human` pauses the phase; surface it with a question tool call and `present` the artifact awaiting approval |
| **Milestone objective** | `create_goal` once per milestone, objective = spec id through its acceptance gate; propose a round cap |

Why fresh for every role: a role that inherits the orchestrator's conversation has already been
persuaded by the reasoning it is supposed to check. Fresh launch plus the role's declared intake
is the whole independence mechanism (the intake law — RULES.md); a different model from the
builder's is the best practice on top — the validator warns, and recorded consent lets a
project proceed without it.

## Launch-prompt neutrality

The launch prompt carries **paths and protocol, never conclusions**:

- Bad: "Phase 4 passed, all ACs met — please double-check the code."
- Good: "Spec: `<path>`. Plan: `<path>`. Read the spec, derive your own checklist, then the
  plan, then the code. Run the verification commands yourself. Report findings with evidence."

Any prompt that states the implementer's conclusion has anchored the review it was supposed to
independentize.

## Route catalog

The `provider` / `model` ids in the presets are DSH route ids, not free-form names. They are
checked against the DSH routing catalog — the profile patch that defines the providers and
their model lists (in the owner's dotfiles, `agents/config/dsh/cordis.patch.yml`; deployed per
profile at `~/.dsh/profiles/<profile>/cordis.patch.yml`). Two facts the catalog settles:

- A model id exists **per provider**. `deepseek-v4.1-flash` is on `opencode`, not on
  `deepseek-anthropic` — the same model on a different route.
- Modality is declared per model entry. Some ids accept text + image, others are text-only.

Before trusting a preset, confirm the route still exists and check the modality you need. A
preset row is config data, so a vanished route is a config edit, not a code change.

## Ledger stamping

Every document a role produces opens with a header row:

```markdown
| **Author** | C · `minimax-anthropic` · MiniMax-M3[1m] · 7 Nov 2026 |
```

The provider/model in the stamp come from the launch override actually used — if a route was
unavailable and a substitute fired, the stamp records the substitute, not the intention.

## Parallel D ∥ E

Launch D and E as two `workflow` agents (or two `subagent_fork` calls) in the same message; do
not relay either's output to the other; collect both verdicts before close. E's prompt contains
the spec path and nothing else by way of project documents.

## When to prefer a separate session

Steer a review interactively, or the model you want is not routable from this session: start a
DSH session on the repo, pick the reviewer model in the GUI, paste the same neutral prompt. The
report lands in the same file either way.
