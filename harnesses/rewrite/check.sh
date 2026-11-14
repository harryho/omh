#!/usr/bin/env bash
# check.sh — rewrite harness gates (v0.1.1).
# Run from repo root. Family-level structure is gated by tools/check-family.sh.
set -u
cd "$(dirname "$0")/../.." || exit 1   # repo root
R=harnesses/rewrite
fail=0
say() { printf '%s\n' "$*"; }
bad() { say "FAIL $*"; fail=1; }

# --- AC-1: rewrite deliverables exist ---
for p in \
  "$R/HARNESS.md" "$R/ROLES.md" "$R/README.md" "$R/MODELS.md" "$R/VERSION" \
  "$R/templates/TEMPLATE-spec.md" "$R/templates/TEMPLATE-plan.md" \
  "$R/templates/TEMPLATE-review-C.md" "$R/templates/TEMPLATE-review-D.md" \
  "$R/templates/TEMPLATE-test-report.md" "$R/templates/TEMPLATE-close.md" \
  "$R/templates/TEMPLATE-source-inventory.md" "$R/templates/TEMPLATE-project-rules.md" \
  "$R/templates/omh.config.yaml" \
  "$R/init/INIT.md" "$R/adapters/DSH.md" \
  "$R/examples/ledgerlite/source-inventory.md" \
  "$R/examples/ledgerlite/SPEC-LL-1-ledger-and-entries.md" \
  "$R/examples/ledgerlite/plans/LL-1-plan-excerpt.md" \
  "$R/examples/ledgerlite/review-C-SPEC-LL-1.md" \
  "$R/examples/ledgerlite/review-D-LL-1-r1.md" \
  "$R/examples/ledgerlite/review-D-LL-1-r2.md" \
  "$R/examples/ledgerlite/test-report-E-LL-1.md" \
  "$R/examples/ledgerlite/close-LL-1.md"; do
  [ -f "$p" ] || bad "ac1: missing $p"
done
grep -q "v0.1.1" "$R/VERSION" || bad "ac1: rewrite VERSION is not v0.1.1"

# --- AC-3: two-layer law markers in templates ---
grep -q "no file paths" "$R/templates/TEMPLATE-spec.md" || bad "ac3: TEMPLATE-spec.md missing 'no file paths'"
grep -q "no code" "$R/templates/TEMPLATE-spec.md" || bad "ac3: TEMPLATE-spec.md missing 'no code'"
grep -q "Test story" "$R/templates/TEMPLATE-plan.md" || bad "ac3: TEMPLATE-plan.md missing test story"
grep -q "Clarifications" "$R/templates/TEMPLATE-plan.md" || bad "ac3: TEMPLATE-plan.md missing Clarifications"

# --- AC-4: preset rows byte-equal to rewrite's self-contained MODELS.md ---
grep -qF '| **max-diversity** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `minimax-anthropic` · MiniMax-M3[1m] | `kimi` · kimi-k2.7-code | `minimax-anthropic` · MiniMax-M3.1-Flash |' "$R/MODELS.md" \
  || bad "ac4: max-diversity row drifts"
grep -qF '| **balanced** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-pro | `minimax-anthropic` · MiniMax-M3[1m] | `minimax-anthropic` · MiniMax-M3.1-Flash |' "$R/MODELS.md" \
  || bad "ac4: balanced row drifts"
grep -qF '| **budget** | `zai-anthropic` · glm-5.3-flash | `zai-anthropic` · glm-5.3-flash | `minimax-anthropic` · MiniMax-M3.1-Flash | `mimo` · mimo-v2.6-flash | `minimax-anthropic` · MiniMax-M3.1-Flash |' "$R/MODELS.md" \
  || bad "ac4: budget row drifts"

# --- AC-4b: config template is schema v2 with harness id ---
grep -q "^omh: v2" "$R/templates/omh.config.yaml" || bad "ac4b: config template not omh: v2"
grep -q "^harness: rewrite" "$R/templates/omh.config.yaml" || bad "ac4b: config template missing harness: rewrite"
grep -q "^harness_version:" "$R/templates/omh.config.yaml" || bad "ac4b: config template missing the harness_version pin"
grep -q "^vendoring:" "$R/templates/omh.config.yaml" || bad "ac4b: config template missing the vendoring mode"
grep -q "Vendoring mode" "$R/init/INIT.md" || bad "ac4b: INIT.md missing the vendoring-mode question"

# --- AC-5: runtime-neutral vocabulary in rewrite docs (its own adapters/ excluded) ---
hits=$(grep -rnE "DSH|teammate|create_goal|workflow" \
  "$R/HARNESS.md" "$R/ROLES.md" "$R/README.md" "$R/MODELS.md" "$R/templates" "$R/init" "$R/examples" 2>/dev/null)
[ -n "$hits" ] && { say "FAIL ac5: runtime terms outside rewrite adapters:"; say "$hits"; fail=1; }

# --- AC-3b: no stale references to the pre-move layout inside rewrite ---
hits=$(grep -rnE "check-omh0|notes/specs/plans/INDEX" "$R" --include="*.md" --include="*.yaml" 2>/dev/null)
[ -n "$hits" ] && { say "FAIL ac3b: stale pre-move references inside rewrite:"; say "$hits"; fail=1; }

if [ $fail -eq 0 ]; then say "OK: rewrite check green"; fi
exit $fail
