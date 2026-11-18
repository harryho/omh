#!/usr/bin/env bash
# check.sh — modernize harness gates (v0.1.0).
# Run from repo root. Family-level structure is gated by tools/check-family.sh.
set -u
cd "$(dirname "$0")/../.." || exit 1   # repo root
R=harnesses/modernize
fail=0
say() { printf '%s\n' "$*"; }
bad() { say "FAIL $*"; fail=1; }

# --- AC-3: deliverables exist ---
for p in \
  "$R/HARNESS.md" "$R/ROLES.md" "$R/README.md" "$R/MODELS.md" "$R/VERSION" \
  "$R/templates/TEMPLATE-tranche-note.md" "$R/templates/TEMPLATE-baseline-report.md" \
  "$R/templates/TEMPLATE-findings-ledger.md" "$R/templates/TEMPLATE-ratchet.md" \
  "$R/templates/TEMPLATE-traps-ledger.md" "$R/templates/TEMPLATE-review-R1.md" \
  "$R/templates/TEMPLATE-review-R2.md" "$R/templates/TEMPLATE-verify-report.md" \
  "$R/templates/TEMPLATE-tranche-close.md" "$R/templates/TEMPLATE-project-rules.md" \
  "$R/templates/omh.config.yaml" \
  "$R/init/INIT.md" "$R/adapters/DSH.md" \
  "$R/stacks/README.md" "$R/stacks/dotnet.md" "$R/stacks/java.md" \
  "$R/stacks/kotlin.md" "$R/stacks/rust.md" \
  "$R/examples/stockpad/omh.config.yaml" \
  "$R/examples/stockpad/tranche-note-mod-1.md" \
  "$R/examples/stockpad/review-r1-plan-mod-1.md" \
  "$R/examples/stockpad/baseline-report-mod-1.md" \
  "$R/examples/stockpad/findings-ledger-mod-1.md" \
  "$R/examples/stockpad/ratchet-mod-1.md" \
  "$R/examples/stockpad/traps-ledger-mod-1.md" \
  "$R/examples/stockpad/review-r2-diff-mod-1.md" \
  "$R/examples/stockpad/verify-report-mod-1.md" \
  "$R/examples/stockpad/tranche-close-mod-1.md"; do
  [ -f "$p" ] || bad "ac3: missing $p"
done
grep -q "v0.1.0" "$R/VERSION" || bad "ac3: modernize VERSION is not v0.1.0"

# --- AC-4: law markers ---
grep -qF 'Roles are configured as `{ provider, model }` pairs. A bare model name is rejected at' "$R/MODELS.md" \
  || bad "ac4: D5 law line missing from modernize MODELS.md"
grep -q 'human by law' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing 'human by law' (direction gate)"
grep -q 'baseline contract' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing the baseline contract"
grep -q 'E5' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing E5 (verify mismatch)"
grep -q 'E6' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing E6 (scope drift hard stop)"
grep -q 'Pin quirks, don' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing the pin-don't-fix discipline"
grep -q '## Handoff to upgrade' "$R/HARNESS.md" || bad "ac4: HARNESS.md missing the upgrade handoff"
grep -q '## Declared scope' "$R/templates/TEMPLATE-tranche-note.md" || bad "ac4: tranche-note template missing declared scope"
grep -q '## Pins planned' "$R/templates/TEMPLATE-tranche-note.md" || bad "ac4: tranche-note template missing pins planned"
grep -q '## Acceptance criteria' "$R/templates/TEMPLATE-tranche-note.md" || bad "ac4: tranche-note template missing acceptance criteria"
grep -q 'Scope rules' "$R/templates/TEMPLATE-baseline-report.md" || bad "ac4: baseline-report template missing scope rules"
grep -q 'Reproduce' "$R/templates/TEMPLATE-baseline-report.md" || bad "ac4: baseline-report template missing reproduce column"
grep -q 'Pinning test' "$R/templates/TEMPLATE-findings-ledger.md" || bad "ac4: findings template missing pinning test column"
grep -q 'Deferred' "$R/templates/TEMPLATE-findings-ledger.md" || bad "ac4: findings template missing deferred disposition"
grep -q 'Down is free' "$R/templates/TEMPLATE-ratchet.md" || bad "ac4: ratchet template missing the down-is-free rule"
grep -q 'dated acceptance' "$R/templates/TEMPLATE-ratchet.md" || bad "ac4: ratchet template missing the dated-acceptance rule"
grep -q 'Discovered' "$R/templates/TEMPLATE-traps-ledger.md" || bad "ac4: traps template missing discovered column"
grep -q 'pin audit' "$R/templates/TEMPLATE-review-R1.md" || bad "ac4: R1 template missing pin audit"
grep -q 'declared scope' "$R/templates/TEMPLATE-review-R2.md" || bad "ac4: R2 template missing declared-scope check"
grep -q 'Blind-protocol statement' "$R/templates/TEMPLATE-verify-report.md" || bad "ac4: verify template missing blind-protocol statement"
grep -q '## Baseline table' "$R/templates/TEMPLATE-tranche-close.md" || bad "ac4: close template missing baseline table"

# --- AC-4e: stack policies fill all nine slots ---
for pol in "$R"/stacks/dotnet.md "$R"/stacks/java.md "$R"/stacks/kotlin.md "$R"/stacks/rust.md; do
  id=$(basename "$pol" .md)
  for slot in "## 1. Build and verify command" "## 2. Test framework and layout" \
              "## 3. Coverage scope rules" "## 4. Independent oracle strategy" \
              "## 5. Static gates and ratchets" "## 6. Measurement and benchmarks" \
              "## 7. UI and render probes" "## 8. Slow-suite isolation" \
              "## 9. Modernize hazards"; do
    grep -qF "$slot" "$pol" || bad "ac4e: policy '$id' missing slot '$slot'"
  done
done
# the config template's policy must exist under stacks/
pol=$(grep -E '^  policy: ' "$R/templates/omh.config.yaml" | head -1 | sed -E 's/.*policy:[[:space:]]*([^#[:space:]]+).*/\1/')
[ -f "$R/stacks/$pol.md" ] || bad "ac4e: config template names policy '$pol' but stacks/$pol.md is missing"
grep -q 'stack.policy\|  policy: ' "$R/templates/omh.config.yaml" || bad "ac4e: config template missing stack.policy selector"
grep -q 'independence: R-B, V-B, V-R' "$R/templates/omh.config.yaml" || bad "ac4e: config template missing the three-vendor law"

# --- AC-5: example purity — no real-world strings from the source run ---
hits=$(grep -rniE "fxpa|gbpusd|ta-lib|irisskin|2ec9f28|coverlet|xunit|winforms|benchmarkdotnet|dotnet|c#" "$R/examples/stockpad" 2>/dev/null)
[ -n "$hits" ] && { say "FAIL ac5: real-world strings leaked into the fictional example:"; say "$hits"; fail=1; }

# --- AC-5b: ledger markers present in the example ---
grep -q 'Pinning test' "$R/examples/stockpad/findings-ledger-mod-1.md" || bad "ac5b: example findings ledger missing pinning test column"
grep -q 'Deferred' "$R/examples/stockpad/findings-ledger-mod-1.md" || bad "ac5b: example findings ledger missing a deferred row"
grep -q '## Baseline table' "$R/examples/stockpad/tranche-close-mod-1.md" || bad "ac5b: example close missing baseline table"
grep -q 'Blind-protocol statement' "$R/examples/stockpad/verify-report-mod-1.md" || bad "ac5b: example verify report missing blind-protocol statement"
grep -q 'FAIL' "$R/examples/stockpad/review-r1-plan-mod-1.md" || bad "ac5b: example R1 review missing its honest FAIL"

# --- AC-neutrality: runtime-neutral vocabulary (adapters/ excluded) ---
hits=$(grep -rnE "DSH|teammate|create_goal|workflow" \
  "$R/HARNESS.md" "$R/ROLES.md" "$R/README.md" "$R/MODELS.md" "$R/templates" "$R/init" \
  "$R/examples" "$R/stacks" 2>/dev/null)
[ -n "$hits" ] && { say "FAIL neutrality: runtime terms outside modernize adapters:"; say "$hits"; fail=1; }

if [ $fail -eq 0 ]; then say "OK: modernize check green"; fi
exit $fail
