#!/usr/bin/env bash
# check.sh — upgrade harness gates (v0.1.0).
# Run from repo root. Family-level structure is gated by tools/check-family.sh.
set -u
cd "$(dirname "$0")/../.." || exit 1   # repo root
R=harnesses/upgrade
fail=0
say() { printf '%s\n' "$*"; }
bad() { say "FAIL $*"; fail=1; }

# --- AC-3: deliverables exist ---
for p in \
  "$R/HARNESS.md" "$R/ROLES.md" "$R/README.md" "$R/MODELS.md" "$R/VERSION" \
  "$R/templates/TEMPLATE-design.md" "$R/templates/TEMPLATE-parity-census.md" \
  "$R/templates/TEMPLATE-plan.md" "$R/templates/TEMPLATE-footprint-audit.md" \
  "$R/templates/TEMPLATE-smoke-evidence.md" "$R/templates/TEMPLATE-review-R1.md" \
  "$R/templates/TEMPLATE-review-R2.md" "$R/templates/TEMPLATE-verify-report.md" \
  "$R/templates/TEMPLATE-walkthrough-pack.md" "$R/templates/TEMPLATE-close-note.md" \
  "$R/templates/TEMPLATE-project-rules.md" "$R/templates/omh.config.yaml" \
  "$R/init/INIT.md" "$R/adapters/DSH.md" \
  "$R/examples/stockplot/omh.config.yaml" \
  "$R/examples/stockplot/design-upg-1.md" \
  "$R/examples/stockplot/parity-census-upg-1.md" \
  "$R/examples/stockplot/plan-upg-1-excerpt.md" \
  "$R/examples/stockplot/review-r1-plan-upg-1.md" \
  "$R/examples/stockplot/footprint-audit-upg-1.md" \
  "$R/examples/stockplot/smoke-evidence-upg-1.md" \
  "$R/examples/stockplot/review-r2-diff-upg-1.md" \
  "$R/examples/stockplot/verify-report-upg-1.md" \
  "$R/examples/stockplot/walkthrough-pack-upg-1.md" \
  "$R/examples/stockplot/close-upg-1.md"; do
  [ -f "$p" ] || bad "ac3: missing $p"
done
grep -q "v0.1.0" "$R/VERSION" || bad "ac3: upgrade VERSION is not v0.1.0"

# --- AC-4: law markers ---
grep -qF 'Roles are configured as `{ provider, model }` pairs. A bare model name is rejected at' "$R/MODELS.md" \
  || bad "ac4: D5 law line missing from upgrade MODELS.md"
grep -q 'human by law' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing 'human by law' (direction gate)"
grep -q 'E7' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing E7 (parity gap outside the census)"
grep -q 'safe-default rule' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing the safe-default rule"
grep -q '## Declared diff footprint' "$R/templates/TEMPLATE-plan.md" || bad "ac4: plan template missing footprint section"
grep -q '### Input-carrying entries' "$R/templates/TEMPLATE-plan.md" || bad "ac4: plan template missing input-carrying entries"
grep -q '| Census row | Proof command |' "$R/templates/TEMPLATE-plan.md" || bad "ac4: plan template missing probe mapping table"
grep -q '## Capability rows' "$R/templates/TEMPLATE-parity-census.md" || bad "ac4: census template missing capability rows"
grep -q '## Inputs & contracts' "$R/templates/TEMPLATE-parity-census.md" || bad "ac4: census template missing inputs & contracts"
grep -q 'Proof method' "$R/templates/TEMPLATE-parity-census.md" || bad "ac4: census template missing proof method column"
grep -q 'dead-in-source' "$R/templates/TEMPLATE-parity-census.md" || bad "ac4: census template missing dead-in-source disposition"
grep -q 'Blind-protocol statement' "$R/templates/TEMPLATE-verify-report.md" || bad "ac4: verify template missing blind-protocol statement"
grep -q 'Probe table' "$R/templates/TEMPLATE-smoke-evidence.md" || bad "ac4: smoke template missing probe table"
grep -q 'mapping audit' "$R/templates/TEMPLATE-review-R1.md" || bad "ac4: R1 template missing mapping audit"
grep -q 'expected observation' "$R/templates/TEMPLATE-walkthrough-pack.md" || bad "ac4: walkthrough template missing expected observations"
grep -q '## Parity table' "$R/templates/TEMPLATE-close-note.md" || bad "ac4: close template missing parity table"
grep -q 'machine-half' "$R/templates/TEMPLATE-design.md" && grep -q 'human-half' "$R/templates/TEMPLATE-design.md" \
  || bad "ac4: design template missing machine-half/human-half split"
grep -q '## Decision history' "$R/templates/TEMPLATE-design.md" || bad "ac4: design template missing decision history"
grep -q 'Input-contract check' "$R/templates/TEMPLATE-footprint-audit.md" || bad "ac4: audit template missing input-contract check"

# --- AC-4b: config template is schema v3 with harness id, gates, independence ---
grep -q '^omh: v3' "$R/templates/omh.config.yaml" || bad "ac4b: config template not omh: v3"
grep -q '^harness: upgrade' "$R/templates/omh.config.yaml" || bad "ac4b: config template missing harness: upgrade"
grep -q '^independence: R-B, V-B, V-R' "$R/templates/omh.config.yaml" || bad "ac4b: config template missing declared independence"
grep -q '# direction is human by law — not settable here' "$R/templates/omh.config.yaml" || bad "ac4b: config template missing direction-by-law comment"
grep -q '^  spec: human' "$R/templates/omh.config.yaml" || bad "ac4b: config template spec gate not human"
grep -q '^  close: human' "$R/templates/omh.config.yaml" || bad "ac4b: config template close gate not human"

# --- AC-4c: the config template validates (validator end-to-end) ---
vout=$(bash tools/validate-config.sh "$R/templates/omh.config.yaml" 2>&1)
[ $? -eq 0 ] || { say "FAIL ac4c: config template fails validation:"; say "$vout"; fail=1; }
printf '%s' "$vout" | grep -q '^WARNING:' && { say "FAIL ac4c: config template validates with warnings:"; say "$vout"; fail=1; }

# --- AC-4d: preset rows byte-equal to upgrade MODELS.md ---
grep -qF '| **max-diversity** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `kimi` · kimi-k2.7-code | `minimax-anthropic` · MiniMax-M3.1-Flash |' "$R/MODELS.md" \
  || bad "ac4d: max-diversity row drifts"
grep -qF '| **balanced** | `zai-anthropic` · glm-5.3 | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-pro | `kimi` · kimi-k2.7-code |' "$R/MODELS.md" \
  || bad "ac4d: balanced row drifts"
grep -qF '| **budget** | `zai-anthropic` · glm-5.3-flash | `zai-anthropic` · glm-5.3-flash | `mimo` · mimo-v2.6-flash | `minimax-anthropic` · MiniMax-M3.1-Flash |' "$R/MODELS.md" \
  || bad "ac4d: budget row drifts"

# --- AC-5: example purity — no real-world strings from the source run ---
hits=$(grep -rniE "fxpa|gbpusd|ta-lib|irisskin|2ec9f28" "$R/examples/stockplot" 2>/dev/null)
[ -n "$hits" ] && { say "FAIL ac5: real-world strings leaked into the fictional example:"; say "$hits"; fail=1; }

# --- AC-5b: census markers present in the example ---
grep -q 'dead-in-source' "$R/examples/stockplot/parity-census-upg-1.md" || bad "ac5b: example census missing a dead-in-source row"
grep -q '## Parity table' "$R/examples/stockplot/close-upg-1.md" || bad "ac5b: example close missing parity table"
grep -q 'E7' "$R/examples/stockplot/close-upg-1.md" || bad "ac5b: example close missing the census-lesson (E7) record"

# --- AC-neutrality: runtime-neutral vocabulary (adapters/ excluded) ---
hits=$(grep -rnE "DSH|teammate|create_goal|workflow" \
  "$R/HARNESS.md" "$R/ROLES.md" "$R/README.md" "$R/MODELS.md" "$R/templates" "$R/init" "$R/examples" 2>/dev/null)
[ -n "$hits" ] && { say "FAIL neutrality: runtime terms outside upgrade adapters:"; say "$hits"; fail=1; }

if [ $fail -eq 0 ]; then say "OK: upgrade check green"; fi
exit $fail
