# MODELS — role assignment, presets, and the independence validator

Roles are assigned models at init and stamped on every document the role produces. The point of
the table below is not which specific model is "best"; it is that the control roles — R and V —
never share B's model, and never each other's, so no builder ever grades its own homework and
no single reviewer owns both verdicts.

## Presets

Three presets ship with insitu (max-diversity is the FXPA run's shape as actually deployed,
14 Nov 2026; balanced and budget are built from routes the family catalog-checked on
13 Nov 2026). Every role is overridable after choosing a preset.

| Preset | A planner | B builder | R review (two passes) | V verify (blind) |
|---|---|---|---|---|
| **max-diversity** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `kimi` · kimi-k2.7-code | `minimax-anthropic` · MiniMax-M3.1-Flash |
| **balanced** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-pro | `kimi` · kimi-k2.7-code |
| **budget** | `zai-anthropic` · glm-5.3-flash | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-flash | `minimax-anthropic` · MiniMax-M3.1-Flash |

Preset logic: **max-diversity** — the FXPA shape; four distinct models, three vendors across
B, R, V, for upgrades of apps people depend on. **balanced** — strong planner, cheap build,
three vendors across B, R, V. **budget** — cheapest defensible set that still keeps R and V off
B's model and off each other (A shares B's model; that pair is on the build path, not the
control path).

## Pair schema

- Roles are configured as `{ provider, model }` pairs. A bare model name is rejected at
  validation: the same model id can exist on multiple routes with different cost, context or
  modality — the pair is the unambiguous identifier.
- Config lines are exactly `A: { provider: <p>, model: <m>, type: <t> }` — one per role; that
  shape is what the validator parses. `type:` is optional on family default letters (A planner,
  B builder, C/D reviewer, E verifier) and required on any other letter; the vocabulary is
  `planner | builder | reviewer | verifier`. Role letters are harness-composed; an optional
  `independence: <X-Y>[, <X-Y>…]` line adds hard pairs beyond the builder rule.

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
| Reviewer/verifier model == builder model | **error**, exit 1 — fix before launch |
| `independence:` pair names unknown letters, or its pair's models equal | **error**, exit 1 |
| Same model on a pair with no builder in it | warning — logged, proceeds |
| Same provider on any pair involving a control role | warning — logged, proceeds |

insitu configs declare `independence: R-B, V-B, V-R` — the FXPA three-vendor law as hard pairs.
Warnings exist to be read: a project that accepts a warning records it in the decisions
register.

## Route churn

Catalogs change; presets are config data, not code. The validator deliberately does **not** check
route availability — that is the launch layer's job, at launch time. If a preset route is
unavailable, the launch layer reports which pair failed, and init offers the alternate pool:
`kimi` · kimi-k3 / kimi-k2.7-code, `zai-anthropic` · glm-5.3 / glm-5.3-flash,
`minimax-anthropic` · MiniMax-M3[1m] / MiniMax-M3.1-Flash, `mimo` · mimo-v2.6-flash /
mimo-v2.6-pro, `deepseek-anthropic` · deepseek-flash[1m] / deepseek-v4-pro, `opencode` routes
(`deepseek-v4-pro`, `deepseek-v4.1-flash`, `glm-5.3`, `glm-5.3-flash`, `kimi-k2.7-code`,
`kimi-k3`, `minimax-m3`, …). Any substitution must still satisfy the validator's independence
errors.

Precedent: in the FXPA run the V route (`minimax-anthropic` · MiniMax-M3.1-Flash) failed to
launch twice; the substitute `deepseek-anthropic` · deepseek-v4-pro fired per this policy and
is stamped in the run's verify report. Independence held — the substitute differed from B and R
in both model and vendor.

## Choosing a preset

- Behaviour-preserving upgrade of an app people depend on → **max-diversity**.
- Solo, fast-moving, low-stakes → **balanced**.
- Batch runs, cost-bound → **budget**.
- Override any role after picking a preset; re-run the validator; record accepted warnings.
