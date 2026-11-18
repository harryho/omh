# MODELS — role assignment, presets, and the independence validator

Roles are assigned models at init and stamped on every document the role produces. The point
of the table below is not which specific model is "best"; it is fresh intake per role plus
modernize's declared three-vendor law — R and V share no model with B or each other (declared
pairs, validator errors) — so no builder ever grades its own homework and no single reviewer
owns both verdicts. Roles are configured as `{ provider, model }` pairs. A bare model name is
rejected at validation: the same model id can exist on multiple routes with different cost,
context or modality — the pair is the unambiguous identifier.

## Presets

Three presets ship with modernize. They reuse the family route pool catalog-checked on
13 Nov 2026 and the same shape as upgrade's presets; max-diversity is the FXPA baseline run's
shape as actually deployed (17–18 Nov 2026). Every role is overridable after choosing a preset.

| Preset | A planner | B builder | R review (two passes) | V verify (blind) |
|---|---|---|---|---|
| **max-diversity** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `kimi` · kimi-k2.7-code | `minimax-anthropic` · MiniMax-M3.1-Flash |
| **balanced** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-pro | `kimi` · kimi-k2.7-code |
| **budget** | `zai-anthropic` · glm-5.3-flash | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-flash | `minimax-anthropic` · MiniMax-M3.1-Flash |

Preset logic: **max-diversity** — four distinct models, three vendors across B, R, V; the
right shape for a codebase people depend on. **balanced** — strong planner, cheap build,
three vendors across B, R, V. **budget** — cheapest defensible set that still keeps R and V
off B's model and off each other; A shares B's model, which is on the build path, not the
control path. Because modernize changes no behaviour, budget is defensible more often than
for upgrades — the ledgers catch narrative drift even when the models are cheap.

## Pair schema

- Roles are configured as `{ provider, model }` pairs. A bare model name is rejected at
  validation: the same model id can exist on multiple routes with different cost, context or
  modality — the pair is the unambiguous identifier.
- Config lines are exactly `A: { provider: <p>, model: <m>, type: <t> }` — one per role; that
  shape is what the validator parses. `type:` is optional on family default letters (A planner,
  B builder, C/D reviewer, E verifier) and required on any other letter; the vocabulary is
  `planner | builder | reviewer | verifier`. Role letters are harness-composed; an optional
  `independence: <X-Y>[, <X-Y>…]` line declares hard pairs — modernize declares
  `independence: R-B, V-B, V-R` in every preset.

## Validator contract

`tools/validate-config.sh <config>` — schema v3 (an `omh: v2` header reads as legacy
letter-default roles) — dependency-free; run it after any role change:

| Check | Result |
|---|---|
| `omh: v2`/`omh: v3` header or `harness: <id>` missing/malformed | **error**, exit 1 |
| Missing/malformed role line, empty provider or model | **error**, exit 1 |
| Type missing on a non-default letter, or an unknown type | **error**, exit 1 |
| Zero builders, or more than one builder-typed role | **error**, exit 1 |
| No control role (reviewer/verifier) declared | **error**, exit 1 |
| Declared pair with equal models on both ends, or unknown letters | **error**, exit 1 |
| Reviewer/verifier shares the builder's model | **warning** — needs the human's recorded consent |
| Same provider on a control-path pair | **warning** — logged, launch proceeds |

Route availability is deliberately **not** checked here — routes churn (see the family root
`MODELS.md` route-churn law); init confirms each pair out loud instead, and a harness run
confirms at every role launch.
