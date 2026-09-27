#!/usr/bin/env bash
# The gate: the whole suite of every edition set up on this box (docs/editions.md). Each setup is
# a directory with its own image, timings and polyphemus.env, run with WORK set to it.
# One after another: side by side, three suites put 18 images on 4 fast cores and took 35 min,
# against about 25 in turn (2026-09-27), and starved a cold dump build past its budget.
#
#   bin/gate.sh              every setup in turn, 6 jobs each
#   JOBS=5 bin/gate.sh
set -uo pipefail
ROOT="${ROOT:-$HOME/polyphemus}"
JOBS="${JOBS:-6}"
SETUPS=("$ROOT")
for extra in pharo11 pharo12 pharo13; do
  [ -d "$ROOT/$extra" ] && [ -f "$ROOT/$extra/dev.image" ] && SETUPS+=("$ROOT/$extra")
done

start=$(date +%s)
for setup in "${SETUPS[@]}"; do
  began=$(date +%s)
  ( cd "$setup" && WORK="$setup" "$setup/Polyphemus/bin/tdd.sh" --all -j "$JOBS" > "$setup/.gate.log" 2>&1 )
  echo "$(( $(date +%s) - began ))" > "$setup/.gate.seconds"
done

status=0
for setup in "${SETUPS[@]}"; do
  echo "== $setup ($(cat "$setup/.gate.seconds")s)"
  grep -aE "^== totals|^    (FAIL|ERROR)|BROKEN|TIMEOUT|never ran" "$setup/.gate.log"
  grep -qaE "^    (FAIL|ERROR)|BROKEN|TIMEOUT|never ran" "$setup/.gate.log" && status=1
done
echo "== gate done in $(( $(date +%s) - start ))s"
exit $status
