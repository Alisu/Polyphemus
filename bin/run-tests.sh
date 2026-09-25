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
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

collect() {
  timeout 120 ./pharo "$IMAGE" st "$HERE/collect-tests.st" 2>/dev/null | noise
}
all_classes() { grep '^CLASS ' <<<"$COLLECTED" | awk '{print $2}' | sort -u; }

is_slow() {
  local c="$1" t
  t=$(awk -v c="$c" '$1==c {print $2}' "$TIMINGS" 2>/dev/null | tail -1)
  [ -n "$t" ] && [ "$t" -ge "$SLOW_THRESHOLD" ]
}

longest_first() {
  awk -v timings="$TIMINGS" 'BEGIN { while ((getline line < timings) > 0) { split(line, f, " "); t[f[1]] = f[2] } }
    { print ($1 in t ? t[$1] : 999999), $1 }' | sort -k1,1nr | awk '{print $2}'
}

run_class() {
  local c="$1" script out rc start el
  script="/tmp/polyphemus-run-$c.st"
  if [ -n "${ONLY_TEST:-}" ]; then
    cat > "$script" <<INNER
| r |
[ r := ($c selector: #$ONLY_TEST) run.
  ('RES $c ', r runCount printString, ' run ', r failureCount printString, ' failures ', r errorCount printString, ' errors') traceCr.
  r failures do: [ :t |
    ('    FAIL  $c>>', t selector, ' -- ',
      ([ t runCase. 'passed when it was run again, so it is a flake' ]
        on: TestFailure do: [ :e | e messageText ifNil: [ 'no message' ] ])) traceCr ].
  r errors   do: [ :t |
    ('    ERROR $c>>', t selector, ' -- ',
      ([ t runCase. 'passed when it was run again, so it is a flake' ]
        on: Error do: [ :e | e class name, ' ', e messageText asString ])) traceCr ] ]
  on: Error, Warning
  do: [ :e | ('RES $c BROKEN ', e class name, ' ', e messageText asString) traceCr ].
Smalltalk exitSuccess
INNER
  else
    cat > "$script" <<INNER
| r |
[ r := $c buildSuite run.
  ('RES $c ', r runCount printString, ' run ', r failureCount printString, ' failures ', r errorCount printString, ' errors') traceCr.
  r failures do: [ :t |
    ('    FAIL  $c>>', t selector, ' -- ',
      ([ t runCase. 'passed when it was run again, so it is a flake' ]
        on: TestFailure do: [ :e | e messageText ifNil: [ 'no message' ] ])) traceCr ].
  r errors   do: [ :t |
    ('    ERROR $c>>', t selector, ' -- ',
      ([ t runCase. 'passed when it was run again, so it is a flake' ]
        on: Error do: [ :e | e class name, ' ', e messageText asString ])) traceCr ] ]
  on: Error, Warning
  do: [ :e | ('RES $c BROKEN ', e class name, ' ', e messageText asString) traceCr ].
Smalltalk exitSuccess
INNER
  fi
  start=$(date +%s)
  # rc must be timeout's own status: $? after a pipeline is grep's, which hid every timeout (#14).
  # A flat limit makes the slow classes report TIMEOUT whenever the machine is busy, which is a
  # red suite that means nothing. Give each class what it took last time, three times over (#31).
  local limit known
  known=$(awk -v c="$c" '$1==c {print $2}' "$TIMINGS" 2>/dev/null | tail -1)
  limit="$TMO"
  if [ -n "$known" ] && [ "$known" -gt 0 ] 2>/dev/null; then
    limit=$(( known * 3 ))
    [ "$limit" -lt "$TMO" ] && limit="$TMO"
  fi
  out=$(timeout "$limit" ./pharo "$IMAGE" st "$script" 2>/dev/null | noise | grep -E '^RES |^    (FAIL|ERROR)'; exit ${PIPESTATUS[0]})
  rc=$?
  el=$(( $(date +%s) - start ))
  rm -f "$script"
  if [ $rc -eq 124 ]; then
    echo "RES $c TIMEOUT ${limit}s"
  elif ! grep -q "^RES $c " <<< "$out"; then
    # The image died, or printed nothing: a class that did not report is broken, not absent.
    echo "RES $c BROKEN no result (exit $rc)"
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
  # Classes that launch images of their own run one after another, in a lane beside the rest:
  # two 59 MB targets starting at once is what made their tests flaky (#31).
  local lane=() pool=() c pool_jobs="$JOBS"
  for c in "${classes[@]}"; do
    if grep -qx "$c" <<<"$LANE"; then lane+=("$c"); else pool+=("$c"); fi
  done
  [ ${#lane[@]} -gt 0 ] && [ ${#pool[@]} -gt 0 ] && [ "$JOBS" -gt 1 ] && pool_jobs=$((JOBS - 1))
  echo "== $label: ${#classes[@]} classes, $JOBS at a time; ${#lane[@]} launching images, one after another =="
  local start; start=$(date +%s)
  if [ ${#lane[@]} -gt 0 ]; then
    ( for c in "${lane[@]}"; do run_class "$c"; done ) | tee -a "$RESULTS" &
  fi
  # Slowest first, by the last recorded time; a class never timed is unknown, so it goes first
  # too. Run by name, a heavy class could start last and alone set the end of the run.
  if [ ${#pool[@]} -gt 0 ]; then
    printf '%s\n' "${pool[@]}" | longest_first \
      | xargs -P "$pool_jobs" -I{} bash -c 'run_class "$@"' _ {} | tee -a "$RESULTS"
  fi
  wait
  echo "== $label done in $(( $(date +%s) - start ))s =="
}

# One suite at a time. Two runs on this box fight each other for memory -- three test
# classes load a 59 MB image apiece -- and the loser looks like a flaky test rather than
# an overloaded machine. So a new run stops the one still going.
#
# Only when a previous *runner* is alive: `pkill -x pharo` would otherwise take out an
# interactive Pharo someone is sitting in front of. -x matches the name exactly, never
# the ssh command line that asked for it.
LOCK="$WORK/.test-runner.pid"
if [ -f "$LOCK" ]; then
  PREV=$(cat "$LOCK" 2>/dev/null || true)
  if [ -n "${PREV:-}" ] && [ "$PREV" != "$$" ] && kill -0 "$PREV" 2>/dev/null; then
    echo "== stopping the run already going (pid $PREV) =="
    kill -TERM "$PREV" 2>/dev/null || true
    pkill -x pharo 2>/dev/null || true
    sleep 2
    pkill -9 -x pharo 2>/dev/null || true
  fi
fi
echo $$ > "$LOCK"
trap 'rm -f "$LOCK"' EXIT

: > "$RESULTS"; : > "$TIMINGS.new"

# Which classes exist, and which launch images: asked of the image once. A single class needs
# neither, so the tightest loop does not pay for starting Pharo to ask.
COLLECTED=; LANE=
if [ ${#SELECTED[@]} -ne 1 ]; then
  COLLECTED=$(collect)
  LANE=$(grep '^LANE ' <<<"$COLLECTED" | awk '{print $2}')
fi

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
