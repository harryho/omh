# MODELS — role assignment, presets, and the independence validator

Roles are assigned models at init and stamped on every document the role produces. The point
of the table below is not which specific model is "best"; it is fresh intake per role plus
modernize's declared three-vendor law — R and V share no model with B or each other (declared
pairs, validator errors) — so no builder ever grades its own homework and no single reviewer
owns both verdicts.

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
| Reviewer/verifier model == builder model | warning — best practice is a different model, ideally a different vendor; proceed on recorded consent |
| `independence:` pair names unknown letters, or its pair's models equal | **error**, exit 1 |
| Same model on a pair with no builder in it | warning — logged, proceeds |
| Same provider on any pair involving a control role | warning — logged, proceeds |

modernize configs declare `independence: R-B, V-B, V-R` — the three-vendor law as hard pairs,
so the reviewer's and verifier's models must differ from the builder's and from each other;
that case is an error, not a consent. Warnings exist to be read: a project that accepts a
warning records it in the decisions register.

## Route churn

Catalogs change; presets are config data, not code. The validator deliberately does **not** check
route availability — that is the launch layer's job, at launch time. If a preset route is
unavailable, the launch layer reports which pair failed, and init offers the alternate pool:
`kimi` · kimi-k3 / kimi-k2.7-code, `zai-anthropic` · glm-5.3 / glm-5.3-flash,
`minimax-anthropic` · MiniMax-M3[1m] / MiniMax-M3.1-Flash, `mimo` · mimo-v2.6-flash /
mimo-v2.6-pro, `deepseek-anthropic` · deepseek-flash[1m] / deepseek-v4-pro, `opencode` routes
(`deepseek-v4-pro`, `deepseek-v4.1-flash`, `glm-5.3`, `glm-5.3-flash`, `kimi-k2.7-code`,
`kimi-k3`, `minimax-m3`, …). Any substitution must still satisfy the validator's errors —
declared `independence:` pairs always hold; a substitution landing a control role on the
builder's model or vendor is a warning that needs recorded consent.

## Choosing a preset

- A codebase people depend on, with a real UI → **max-diversity**.
- Steady tranches, moderate risk → **balanced**.
- Cheap, frequent tranches on the build path → **budget** (defensible more often here than for
  upgrades: modernize changes no behaviour, and the ledgers catch narrative drift even when the
  models are cheap).
- Override any role after picking a preset; re-run the validator; record accepted warnings.
