#!/usr/bin/env bash
# The gate: the whole suite of every edition set up on this box, side by side (docs/editions.md).
# Each setup is a directory with its own image, timings and polyphemus.env, run with WORK set to
# it. Side by side they take about the longer of the two, not their sum.
#
#   bin/gate.sh              every setup, 4 jobs each
#   JOBS=5 bin/gate.sh
set -uo pipefail
ROOT="${ROOT:-$HOME/polyphemus}"
JOBS="${JOBS:-4}"
SETUPS=("$ROOT")
[ -d "$ROOT/pharo11" ] && SETUPS+=("$ROOT/pharo11")
[ -d "$ROOT/pharo12" ] && SETUPS+=("$ROOT/pharo12")

start=$(date +%s)
pids=()
for setup in "${SETUPS[@]}"; do
  ( cd "$setup" && WORK="$setup" "$setup/Polyphemus/bin/tdd.sh" --all -j "$JOBS" > "$setup/.gate.log" 2>&1 ) &
  pids+=($!)
done
# Our own children: never pgrep -f, which matches the waiting shell (docs/mistakes.md).
for pid in "${pids[@]}"; do wait "$pid"; done

status=0
for setup in "${SETUPS[@]}"; do
  echo "== $setup"
  grep -aE "^== all done|^== totals|^    (FAIL|ERROR)|BROKEN|TIMEOUT|never ran" "$setup/.gate.log"
  grep -qaE "^    (FAIL|ERROR)|BROKEN|TIMEOUT|never ran" "$setup/.gate.log" && status=1
done
echo "== gate done in $(( $(date +%s) - start ))s"
exit $status
