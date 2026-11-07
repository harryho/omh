#!/usr/bin/env bash
# validate-config.sh — omh config validator (schema v1). POSIX bash, no deps.
# Config shape parsed (one line per role, exactly as templates/omh.config.yaml):
#   A: { provider: <p>, model: <m> }
# Errors (exit 1): malformed/missing role line; C/D/E model == B model (FR-4).
# Warnings (stderr, exit 0): same-model pair off the B axis; same provider on any
# pair involving C, D or E. Availability is NOT checked here (catalog churn is
# operator-side; see MODELS.md route-churn policy).
set -u
f="${1:?usage: validate-config.sh <config-file>}"
[ -f "$f" ] || { echo "ERROR: no such file: $f"; exit 1; }

declare -A P M
for r in A B C D E; do
  line=$(grep -E "^[[:space:]]*${r}:[[:space:]]*\{" "$f" | head -1)
  if [ -z "$line" ]; then
    echo "ERROR: role $r missing (need one line: ${r}: { provider: X, model: Y })"; exit 1
  fi
  p=$(sed -E 's/.*provider:[[:space:]]*([^,}]+).*/\1/' <<<"$line" | tr -d ' ')
  m=$(sed -E 's/.*model:[[:space:]]*([^,}]+).*/\1/' <<<"$line" | tr -d ' ')
  [ -z "$p" ] && { echo "ERROR: role $r: provider empty"; exit 1; }
  [ -z "$m" ] && { echo "ERROR: role $r: model empty"; exit 1; }
  P[$r]=$p; M[$r]=$m
done

rc=0
for r in C D E; do
  if [ "${M[$r]}" = "${M[B]}" ]; then
    echo "ERROR: independence: $r model == B model (${M[B]})"; rc=1
  fi
done

for pair in A:C A:D A:E C:D C:E D:E; do
  r1=${pair%%:*}; r2=${pair##*:}
  [ "${M[$r1]}" = "${M[$r2]}" ] && echo "WARNING: same model $r1/$r2: ${M[$r1]}"
done
for pair in B:C B:D B:E A:C A:D A:E C:D C:E D:E; do
  r1=${pair%%:*}; r2=${pair##*:}
  [ "${P[$r1]}" = "${P[$r2]}" ] && echo "WARNING: same provider $r1/$r2: ${P[$r1]}"
done

[ $rc -eq 0 ] && echo "OK: independence constraints satisfied"
exit $rc
