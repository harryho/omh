#!/usr/bin/env bash
# check-family.sh — family-level gates for the omh harness family.
# Run from repo root. Per-harness content is gated by each harness's own check.sh.
set -u
cd "$(dirname "$0")/.." || exit 1
fail=0
say() { printf '%s\n' "$*"; }
bad() { say "FAIL $*"; fail=1; }

# --- family structure ---
[ -f README.md ] || bad "family: README.md (index) missing"
[ -f RULES.md ] || bad "family: shared RULES.md missing"
[ -f MODELS.md ] || bad "family: shared MODELS.md (law) missing"
[ -f VERSION ] || bad "family: root VERSION missing"
[ -f skill/SKILL.md ] || bad "family: skill router missing"
[ -f tools/validate-config.sh ] || bad "family: shared validator missing"

# every harness dir is complete and listed in the index
for d in harnesses/*/; do
  id=$(basename "$d")
  for f in HARNESS.md VERSION check.sh MODELS.md README.md; do
    [ -f "$d$f" ] || bad "family: harnesses/$id missing $f"
  done
  grep -q "$id" README.md || bad "family: index README does not list harness '$id'"
done
[ -d harnesses/rewapp ] || bad "family: harnesses/rewapp missing"

# --- root purity: no role contracts, pipeline phases, or escalations in root law docs ---
hits=$(grep -rnE "Architect|Builder|Independent tester|P1\.5|P4\.5|escalation" \
  README.md RULES.md MODELS.md AGENTS.md 2>/dev/null)
[ -n "$hits" ] && { say "FAIL family: role-contract/pipeline content leaked into root docs:"; say "$hits"; fail=1; }

# --- forbidden runtime terms in root docs (same rule as v0.1 AC-5, family scope) ---
hits=$(grep -rnE "DSH|teammate|create_goal|workflow" README.md RULES.md MODELS.md AGENTS.md 2>/dev/null)
[ -n "$hits" ] && { say "FAIL family: harness-runtime terms in root docs:"; say "$hits"; fail=1; }

# --- D5 law guard: the binding pair-schema line appears verbatim in root and every harness MODELS.md ---
for f in MODELS.md harnesses/*/MODELS.md; do
  grep -qF 'Roles are configured as `{ provider, model }` pairs. A bare model name is rejected at' "$f" \
    || bad "family: D5 law line missing or drifted in $f"
done

if [ $fail -eq 0 ]; then say "OK: check-family green"; fi
exit $fail
