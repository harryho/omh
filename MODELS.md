# MODELS — shared model law for the omh harness family

The law every harness's `MODELS.md` repeats verbatim, plus the shared validator contract. Each
harness appends its own preset tables to its self-contained copy (see `harnesses/<id>/MODELS.md`).

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

Warnings exist to be read: a project that accepts a warning records it in the decisions register.

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
