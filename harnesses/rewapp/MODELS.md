# MODELS — role assignment, presets, and the independence validator

Roles are assigned models at init and stamped on every document the role produces. The point of
the table below is not which specific model is "best"; it is that C, D and E never share B's
model, so no builder ever grades its own homework.

## Presets

Three presets ship with omh (owner-confirmed 7 Nov 2026; rows amended 13 Nov 2026). Every
provider/model pair below was checked against the runtime's routing catalog on 13 Nov 2026.
Override any single role after choosing a preset.

| Preset | A architect | B builder | C spec-review | D code-review | E tester |
|---|---|---|---|---|---|
| **max-diversity** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `minimax-anthropic` · MiniMax-M3[1m] | `kimi` · kimi-k2.7-code | `minimax-anthropic` · MiniMax-M3.1-Flash |
| **balanced** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-pro | `minimax-anthropic` · MiniMax-M3[1m] | `minimax-anthropic` · MiniMax-M3.1-Flash |
| **budget** | `zai-anthropic` · glm-5.3-flash | `zai-anthropic` · glm-5.3-flash | `minimax-anthropic` · MiniMax-M3.1-Flash | `mimo` · mimo-v2.6-flash | `minimax-anthropic` · MiniMax-M3.1-Flash |

Preset logic: **max-diversity** — five distinct models, maximum independence, for parity-critical
rewrites. **balanced** — strong architect + spec reviewer on the same capable model (A=C, a logged
warning), cheap build, independent code review and test. **budget** — cheapest defensible set
that still keeps C, D, E off B's model (C=E share MiniMax-M3.1-Flash, a logged warning).

## Pair schema

- Roles are configured as `{ provider, model }` pairs. A bare model name is rejected at
  validation: the same model id can exist on multiple routes with different cost, context or
  modality — the pair is the unambiguous identifier.
- Config lines are exactly `A: { provider: <p>, model: <m> }` — one per role; that shape is what
  the validator parses.

## Validator contract

`tools/validate-config.sh <config>` — dependency-free; run it after any role change:

| Check | Result |
|---|---|
| C, D or E model == B model | **error**, exit 1 — fix before launch |
| Missing/malformed role line, empty provider or model | **error**, exit 1 |
| Same model on a pair not involving B (A=C, C=E, …) | warning — logged, proceeds |
| Same provider on any pair involving C, D or E | warning — logged, proceeds |

Warnings exist to be read: a project that accepts a warning records it in the decisions register.

## Alias resolution

Shorthand names used during design, resolved 7 Nov 2026 — recorded here so old notes stay
readable:

| Alias | Resolves to |
|---|---|
| glm-flash | `zai-anthropic` · glm-5.3-flash |
| minimax | `minimax-anthropic` · MiniMax-M3[1m] |
| minimax-flash, minimax-m3.1-flash | `minimax-anthropic` · MiniMax-M3.1-Flash |
| mimo-flash | `mimo` · mimo-v2.6-flash |
| mimo-pro | `mimo` · mimo-v2.6-pro |
| kimi-code | `kimi` · kimi-k2.7-code |
| deepseek-v4.1-flash | `deepseek-anthropic` · deepseek-flash[1m] (official route; `opencode` · deepseek-v4.1-flash is the same model on another route) |

## Modalities

Verified against the runtime's routing catalog, 13 Nov 2026:

| Model | Input |
|---|---|
| `zai-anthropic` · glm-5.3 | text only |
| `zai-anthropic` · glm-5.3-flash | text + image |
| `minimax-anthropic` · MiniMax-M3[1m] | text + image |
| `minimax-anthropic` · MiniMax-M3.1-Flash | text + image |
| `kimi` · kimi-k2.7-code | text + image |
| `kimi` · kimi-k3 | text + image |
| `mimo` · mimo-v2.6-pro | text only |
| `mimo` · mimo-v2.6-flash | text only |
| `deepseek-anthropic` · deepseek-flash[1m] | text only |
| `deepseek-anthropic` · deepseek-v4-pro | text only |

- Consequence: in **max-diversity** and **balanced**, D and E can perform bounded vision
  spot-checks on screenshot evidence natively. In **budget**, only E can — D runs on
  `mimo-v2.6-flash`, which is text-only.
- Bounded means: resolve the named visual criteria only, never escalate into a full re-review —
  a full re-review by the same agent would defeat the independence the phase exists to create.

## Route churn

Catalogs change; presets are config data, not code. The validator deliberately does **not** check
route availability — that is the launch layer's job, at launch time. If a preset route is
unavailable, the launch layer reports which pair failed, and init offers the alternate pool:
`kimi` · kimi-k3 / kimi-k2.7-code, `zai-anthropic` · glm-5.3 / glm-5.3-flash,
`minimax-anthropic` · MiniMax-M3[1m] / MiniMax-M3.1-Flash, `mimo` · mimo-v2.6-flash /
mimo-v2.6-pro, `deepseek-anthropic` · deepseek-flash[1m] / deepseek-v4-pro, `opencode` routes
(`deepseek-v4-pro`, `deepseek-v4.1-flash`, `glm-5.3`, `glm-5.3-flash`, `kimi-k2.7-code`,
`kimi-k3`, `minimax-m3`, …). Any substitution must still satisfy the validator (C/D/E ≠ B).

## Choosing a preset

- Parity-critical rewrite (an old app that must not lose behaviour) → **max-diversity**.
- Solo, fast-moving → **balanced**.
- Batch runs, low stakes, cost-bound → **budget**.
- Override any role after picking a preset; re-run the validator; record accepted warnings.
