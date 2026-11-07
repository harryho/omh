#!/usr/bin/env bash
# check-omh0.sh — static machine gates for omh v0.1 (AC-1, AC-3, AC-4, AC-5).
# Run from repo root. AC-2 (init dry-run) is evidenced separately at close.
set -u
fail=0
say() { printf '%s\n' "$*"; }
bad() { say "FAIL $*"; fail=1; }

# --- AC-1: required files exist ---
for p in \
  README.md HARNESS.md ROLES.md RULES.md MODELS.md omh/VERSION \
  templates/TEMPLATE-spec.md templates/TEMPLATE-plan.md \
  templates/TEMPLATE-review-C.md templates/TEMPLATE-review-D.md \
  templates/TEMPLATE-test-report.md templates/TEMPLATE-close.md \
  templates/TEMPLATE-source-inventory.md templates/TEMPLATE-project-rules.md \
  templates/omh.config.yaml \
  init/INIT.md adapters/DSH.md skill/SKILL.md \
  examples/ledgerlite/source-inventory.md \
  examples/ledgerlite/SPEC-LL-1-ledger-and-entries.md \
  examples/ledgerlite/plans/LL-1-plan-excerpt.md \
  examples/ledgerlite/review-C-SPEC-LL-1.md \
  examples/ledgerlite/review-D-LL-1-r1.md \
  examples/ledgerlite/review-D-LL-1-r2.md \
  examples/ledgerlite/test-report-E-LL-1.md \
  examples/ledgerlite/close-LL-1.md \
  tools/validate-config.sh tools/check-omh0.sh \
  notes/specs/plans/INDEX.md; do
  [ -f "$p" ] || bad "ac1: missing $p"
done

# --- AC-3: two-layer law markers in templates ---
grep -q "no file paths" templates/TEMPLATE-spec.md \
  || bad "ac3: TEMPLATE-spec.md missing 'no file paths' rule"
grep -q "no code" templates/TEMPLATE-spec.md \
  || bad "ac3: TEMPLATE-spec.md missing 'no code' rule"
grep -q "Test story" templates/TEMPLATE-plan.md \
  || bad "ac3: TEMPLATE-plan.md missing test story"
grep -q "Clarifications" templates/TEMPLATE-plan.md \
  || bad "ac3: TEMPLATE-plan.md missing Clarifications appendix"

# --- AC-4: MODELS.md preset rows match SPEC FR-9 verbatim ---
grep -qF '| **max-diversity** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `deepseek-anthropic` · deepseek-flash[1m] | `minimax-anthropic` · MiniMax-M3[1m] | `minimax-anthropic` · MiniMax-M3.1-Flash |' MODELS.md \
  || bad "ac4: max-diversity row drifts from SPEC FR-9"
grep -qF '| **balanced** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `zai-anthropic` · glm-5.3 | `minimax-anthropic` · MiniMax-M3[1m] | `minimax-anthropic` · MiniMax-M3.1-Flash |' MODELS.md \
  || bad "ac4: balanced row drifts from SPEC FR-9"
grep -qF '| **budget** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `minimax-anthropic` · MiniMax-M3.1-Flash | `mimo` · mimo-v2.6-flash | `minimax-anthropic` · MiniMax-M3.1-Flash |' MODELS.md \
  || bad "ac4: budget row drifts from SPEC FR-9"

# --- AC-5: agnostic core — harness terms only under adapters/ and skill/ ---
hits=$(grep -rnE "DSH|teammate|create_goal|workflow" \
  README.md HARNESS.md ROLES.md RULES.md MODELS.md templates init examples 2>/dev/null)
[ -n "$hits" ] && { say "FAIL ac5: harness-specific terms outside adapters/skill:"; say "$hits"; fail=1; }

if [ $fail -eq 0 ]; then say "OK: check-omh0 all static gates green"; fi
exit $fail
