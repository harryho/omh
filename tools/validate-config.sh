#!/usr/bin/env bash
# validate-config.sh — omh config validator (schema v3). POSIX bash, no deps.
# Config shape parsed (one line per role, exactly as harnesses/*/templates/omh.config.yaml):
#   <LETTER>: { provider: <p>, model: <m>[, type: <t>] }
# v3 (reads `omh: v2` headers as legacy letter-default configs):
#   - roles are harness-composed letters; optional type: planner|builder|reviewer|verifier
#   - missing type falls back to family letter defaults (A planner, B builder,
#     C/D reviewer, E verifier); any other letter without a type is an error
# Errors (exit 1): schema/harness/role problems; unknown or missing type; zero or
#   multiple builders; no control role; a reviewer/verifier sharing the builder's
#   model; an `independence:` pair with equal models or unknown letters.
# Warnings (stdout, exit 0): same model on a pair with no builder in it; same
#   provider on any pair involving a control role. Availability is NOT checked here
#   (root MODELS.md route-churn).
set -u
f="${1:?usage: validate-config.sh <config-file>}"
[ -f "$f" ] || { echo "ERROR: no such file: $f"; exit 1; }

grep -Eq "^omh: v[23][[:space:]]*$" "$f" || { echo "ERROR: missing 'omh: v2' or 'omh: v3' header line"; exit 1; }
harness=$(grep -E "^harness: " "$f" | head -1 | sed -E 's/#.*$//' | sed -E 's/^harness:[[:space:]]*//' | tr -d '[:space:]')
if ! printf '%s' "$harness" | grep -Eq "^[a-z][a-z0-9-]*$"; then
  echo "ERROR: missing or malformed 'harness: <kebab-id>' line (got: '${harness}')"; exit 1
fi

declare -A P M T
order=()
default_for() {
  case "$1" in
    A) echo planner ;;  B) echo builder ;;  C|D) echo reviewer ;;  E) echo verifier ;;
    *) echo "" ;;
  esac
}

# Parse role lines: any letter, optional type.
while IFS= read -r line; do
  letter=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*([A-Za-z][A-Za-z0-9]*):[[:space:]]*\{.*/\1/')
  body=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*[A-Za-z][A-Za-z0-9]*:[[:space:]]*\{(.*)\}.*/\1/')
  [ -z "$letter" ] && continue
  p=$(printf '%s' "$body" | sed -E 's/.*provider:[[:space:]]*([^,}]+).*/\1/' | tr -d ' ')
  m=$(printf '%s' "$body" | sed -E 's/.*model:[[:space:]]*([^,}]+).*/\1/' | tr -d ' ')
  t=""
  if printf '%s' "$body" | grep -Eq '(^|[,[:space:]])type:'; then
    t=$(printf '%s' "$body" | sed -E 's/.*type:[[:space:]]*([^,}]+).*/\1/' | tr -d ' ')
  fi
  if [ -z "$t" ]; then
    t=$(default_for "$letter")
    [ -z "$t" ] && { echo "ERROR: role $letter: missing type (add 'type: planner|builder|reviewer|verifier', or use a family default letter A-E)"; exit 1; }
  fi
  case "$t" in planner|builder|reviewer|verifier) ;; *) echo "ERROR: role $letter: unknown type '$t'"; exit 1 ;; esac
  [ -z "$p" ] && { echo "ERROR: role $letter: provider empty"; exit 1; }
  [ -z "$m" ] && { echo "ERROR: role $letter: model empty"; exit 1; }
  P[$letter]=$p; M[$letter]=$m; T[$letter]=$t
  order+=("$letter")
done < <(grep -E "^[[:space:]]*[A-Za-z][A-Za-z0-9]*:[[:space:]]*\{" "$f")

[ ${#order[@]} -eq 0 ] && { echo "ERROR: no role lines found"; exit 1; }

builders=0; controls=0; B=""
for r in "${order[@]}"; do
  [ "${T[$r]}" = builder ] && { builders=$((builders+1)); B=$r; }
  case "${T[$r]}" in reviewer|verifier) controls=$((controls+1)) ;; esac
done
[ $builders -eq 0 ] && { echo "ERROR: no builder-typed role declared (exactly one is required)"; exit 1; }
[ $builders -gt 1 ] && { echo "ERROR: multiple builder-typed roles declared (${builders})"; exit 1; }
[ $controls -eq 0 ] && { echo "ERROR: no control role (reviewer/verifier) declared"; exit 1; }

rc=0
for r in "${order[@]}"; do
  case "${T[$r]}" in reviewer|verifier)
    if [ "${M[$r]}" = "${M[$B]}" ]; then echo "ERROR: independence: $r (${T[$r]}) model == builder $B model (${M[$B]})"; rc=1; fi
  ;; esac
done

# Declared extra hard pairs: independence: X-Y, Y-Z, ...
indepline=$(grep -E "^independence:" "$f" | head -1 | sed -E 's/#.*$//' | sed -E 's/^independence:[[:space:]]*//' | tr -d ' ')
if [ -n "$indepline" ]; then
  IFS=',' read -ra pairs <<< "$indepline"
  for pair in "${pairs[@]}"; do
    [ -z "$pair" ] && continue
    x=${pair%%-*}; y=${pair#*-}
    [ -z "${M[$x]:-}" ] && { echo "ERROR: independence: pair '$pair' names unknown role '$x'"; rc=1; continue; }
    [ -z "${M[$y]:-}" ] && { echo "ERROR: independence: pair '$pair' names unknown role '$y'"; rc=1; continue; }
    [ "${M[$x]}" = "${M[$y]}" ] && { echo "ERROR: independence: pair '$pair' models equal (${M[$x]})"; rc=1; }
  done
fi

# Warnings over all pairs.
n=${#order[@]}
for ((i=0; i<n; i++)); do
  for ((j=i+1; j<n; j++)); do
    x=${order[$i]}; y=${order[$j]}
    if [ "${M[$x]}" = "${M[$y]}" ] && [ "${T[$x]}" != builder ] && [ "${T[$y]}" != builder ]; then
      echo "WARNING: same model $x/$y: ${M[$x]}"
    fi
    if [ "${P[$x]}" = "${P[$y]}" ]; then
      case "${T[$x]}${T[$y]}" in
        *reviewer*|*verifier*) echo "WARNING: same provider $x/$y: ${P[$x]}" ;;
      esac
    fi
  done
done

[ $rc -eq 0 ] && echo "OK: harness '$harness' — independence constraints satisfied"
exit $rc
