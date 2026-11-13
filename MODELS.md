# MODELS — shared model law for the omh harness family

The law every harness's `MODELS.md` repeats verbatim, plus the shared validator contract. Each
harness appends its own preset tables to its self-contained copy (see `harnesses/<id>/MODELS.md`).

## Pair schema

- Roles are configured as `{ provider, model }` pairs. A bare model name is rejected at
  validation: the same model id can exist on multiple routes with different cost, context or
  modality — the pair is the unambiguous identifier.
- Config lines are exactly `A: { provider: <p>, model: <m> }` — one per role; that shape is what
  the validator parses.

## Validator contract

`tools/validate-config.sh <config>` — schema v2 — dependency-free; run it after any role change:

| Check | Result |
|---|---|
| `omh: v2` header or `harness: <id>` missing/malformed | **error**, exit 1 |
| C, D or E model == B model | **error**, exit 1 — fix before launch |
| Missing/malformed role line, empty provider or model | **error**, exit 1 |
| Same model on a pair not involving B (A=C, C=E, …) | warning — logged, proceeds |
| Same provider on any pair involving C, D or E | warning — logged, proceeds |

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
