#!/usr/bin/env bash
# Polyphemus test runner: tiered, parallel, selective.
#
#   ./run-tests.sh                 fast tier, then slow tier only if fast is green
#   ./run-tests.sh --fast          fast tier only
#   ./run-tests.sh --slow          slow tier only
#   ./run-tests.sh -c Foo -c Bar   just these classes (the TDD loop)
#   ./run-tests.sh -c Foo -t testBar   just one test (the tightest loop)
#   ./run-tests.sh -j 10           parallelism (default 6)
#   IMAGE=dev.image ./run-tests.sh run against another image
#
# One Pharo process per class: the image is single threaded, the box is not.
# Each run records per-class seconds in .test-timings, which decides the tiers.
set -uo pipefail

WORK="${WORK:-$HOME/polyphemus}"
IMAGE="${IMAGE:-warm.image}"
JOBS="${JOBS:-6}"
TMO="${TMO:-400}"
SLOW_THRESHOLD="${SLOW_THRESHOLD:-8}"
cd "$WORK"
TIMINGS="$WORK/.test-timings"
RESULTS="$WORK/.test-results"

MODE=tiered
SELECTED=()
ONLY_TEST=
while [ $# -gt 0 ]; do
  case "$1" in
    --fast) MODE=fast ;;
    --slow) MODE=slow ;;
    --all)  MODE=all ;;
    -c)     shift; SELECTED+=("$1") ;;
    -t)     shift; ONLY_TEST="$1" ;;
    -j)     shift; JOBS="$1" ;;
    *) echo "unknown option: $1"; exit 2 ;;
  esac
  shift
done

noise() { tr -d '\033' | grep -vE 'Simd|addMapped|extensionBytecode|CleanBlockChecker|^\[' ; }
export -f noise

all_classes() {
  timeout 120 ./pharo "$IMAGE" st collect-tests.st 2>/dev/null | noise \
    | grep '^CLASS ' | awk '{print $2}' | sort -u
}

is_slow() {
  local c="$1" t
  t=$(awk -v c="$c" '$1==c {print $2}' "$TIMINGS" 2>/dev/null | tail -1)
  [ -n "$t" ] && [ "$t" -ge "$SLOW_THRESHOLD" ]
}

run_class() {
  local c="$1" script out rc start el
  script="/tmp/polyphemus-run-$c.st"
  if [ -n "${ONLY_TEST:-}" ]; then
    cat > "$script" <<INNER
| r |
[ r := ($c selector: #$ONLY_TEST) run.
  ('RES $c ', r runCount printString, ' run ', r failureCount printString, ' failures ', r errorCount printString, ' errors') traceCr.
  r failures do: [ :t | ('    FAIL  $c>>', t selector) traceCr ].
  r errors   do: [ :t | ('    ERROR $c>>', t selector) traceCr ] ]
  on: Error, Warning
  do: [ :e | ('RES $c BROKEN ', e class name, ' ', e messageText asString) traceCr ].
Smalltalk exitSuccess
INNER
  else
    cat > "$script" <<INNER
| r |
[ r := $c buildSuite run.
  ('RES $c ', r runCount printString, ' run ', r failureCount printString, ' failures ', r errorCount printString, ' errors') traceCr.
  r failures do: [ :t | ('    FAIL  $c>>', t selector) traceCr ].
  r errors   do: [ :t | ('    ERROR $c>>', t selector) traceCr ] ]
  on: Error, Warning
  do: [ :e | ('RES $c BROKEN ', e class name, ' ', e messageText asString) traceCr ].
Smalltalk exitSuccess
INNER
  fi
  start=$(date +%s)
  out=$(timeout "$TMO" ./pharo "$IMAGE" st "$script" 2>/dev/null | noise | grep -E '^RES |^    (FAIL|ERROR)')
  rc=$?
  el=$(( $(date +%s) - start ))
  rm -f "$script"
  if [ $rc -eq 124 ]; then
    echo "RES $c TIMEOUT ${TMO}s"
  else
    echo "$out" | sed "1s/\$/ (${el}s)/"
    [ -z "${ONLY_TEST:-}" ] && echo "$c $el" >> "$TIMINGS.new"
  fi
}
export -f run_class
export WORK IMAGE TMO TIMINGS ONLY_TEST

run_set() {
  local label="$1"; shift
  local classes=("$@")
  [ ${#classes[@]} -eq 0 ] && { echo "== $label: nothing to run =="; return 0; }
  echo "== $label: ${#classes[@]} classes, $JOBS at a time =="
  local start; start=$(date +%s)
  printf '%s\n' "${classes[@]}" | xargs -P "$JOBS" -I{} bash -c 'run_class "$@"' _ {} | tee -a "$RESULTS"
  echo "== $label done in $(( $(date +%s) - start ))s =="
}

: > "$RESULTS"; : > "$TIMINGS.new"

if [ ${#SELECTED[@]} -gt 0 ]; then
  run_set "selected" "${SELECTED[@]}"
else
  mapfile -t ALL < <(all_classes)
  FAST=(); SLOW=()
  for c in "${ALL[@]}"; do
    if is_slow "$c"; then SLOW+=("$c"); else FAST+=("$c"); fi
  done
  case "$MODE" in
    fast) run_set "fast tier" ${FAST[@]+"${FAST[@]}"} ;;
    slow) run_set "slow tier" ${SLOW[@]+"${SLOW[@]}"} ;;
    all)  run_set "all" ${ALL[@]+"${ALL[@]}"} ;;
    tiered)
      run_set "fast tier" ${FAST[@]+"${FAST[@]}"}
      if grep -qE 'FAIL|ERROR|BROKEN|TIMEOUT' "$RESULTS"; then
        echo "== fast tier is red: stopping before the slow tier =="
      else
        run_set "slow tier" ${SLOW[@]+"${SLOW[@]}"}
      fi ;;
  esac
fi

if [ -s "$TIMINGS.new" ]; then
  cat "$TIMINGS" "$TIMINGS.new" 2>/dev/null \
    | awk '{t[$1]=$2} END {for (c in t) print c, t[c]}' | sort > "$TIMINGS.tmp"
  mv "$TIMINGS.tmp" "$TIMINGS"
fi
rm -f "$TIMINGS.new"

awk '/^RES /{ if ($3=="TIMEOUT"||$3=="BROKEN") b++; else {r+=$3; f+=$5; e+=$7} }
     END { printf "== totals: %d run, %d failures, %d errors, %d broken ==\n", r, f, e, b }' "$RESULTS"
if grep -qE 'FAIL|ERROR|BROKEN|TIMEOUT' "$RESULTS"; then exit 1; else exit 0; fi
