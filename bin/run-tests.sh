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
. "$HERE/portable.sh"
cd "$WORK"
# What this host's setup says about its targets (POLYPHEMUS_TARGET_VM, POLYPHEMUS_CORE): see
# docs/editions.md. Absent, targets run on the host's own VM and the dump is next to its image.
[ -f "$WORK/polyphemus.env" ] && { set -a; . "$WORK/polyphemus.env"; set +a; }
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

noise() { tr -d '\033' | grep -avE 'Simd|addMapped|extensionBytecode|CleanBlockChecker|^\[' ; }
export -f noise

collect() {
  timeout 120 ./pharo "$IMAGE" --no-default-preferences st "$HERE/collect-tests.st" 2>/dev/null | noise
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
  script="/tmp/polyphemus-run-$(basename "$WORK")-$c.st"   # one per host setup (#50)
  if [ -n "${ONLY_TEST:-}" ]; then
    cat > "$script" <<INNER
| run ascii |
"A line holding a wide character is a WideString, which traceCr writes four bytes a character:
 the runner then sees binary, not the line. Anything past ASCII prints as a question mark
 (written by its code: this text goes through a heredoc, where a dollar sign is the shell's)."
ascii := [ :text | String streamContents: [ :s | text do: [ :ch | s nextPut: (ch asInteger < 128 ifTrue: [ ch ] ifFalse: [ Character value: 63 ]) ] ] ].
[ run := (PolyphemusTestRun of: (TestSuite new addTest: ($c selector: #$ONLY_TEST); yourself)) run.
  '' traceCr. "a line of its own: the simulator leaves its output unfinished (#51)"
  ('RES $c ', run runCount printString, ' run ', run failureCount printString, ' failures ', run errorCount printString, ' errors', (run skippedCount > 0 ifTrue: [ ' ', run skippedCount printString, ' skipped' ] ifFalse: [ '' ])) traceCr.
  "What each problem signalled the first time, then what it did when run again (#31)."
  run problems do: [ :each | | again |
    again := run againOf: each key selector.
    (ascii value: (((run isFailure: each value) ifTrue: [ '    FAIL  ' ] ifFalse: [ '    ERROR ' ]), '$c>>', each key selector, ' -- ',
      (run describe: each value),
      (again = #passed
        ifTrue: [ ' (passed when run again in the same image: a flake, or state its first run left, #31)' ]
        ifFalse: [ ' (again: ', (run describe: again), ')' ]))) traceCr ] ]
  on: Error, Warning
  do: [ :e | (ascii value: 'RES $c BROKEN ', e class name, ' ', e messageText asString) traceCr ].
Smalltalk exitSuccess
INNER
  else
    cat > "$script" <<INNER
| run ascii |
"A line holding a wide character is a WideString, which traceCr writes four bytes a character:
 the runner then sees binary, not the line. Anything past ASCII prints as a question mark
 (written by its code: this text goes through a heredoc, where a dollar sign is the shell's)."
ascii := [ :text | String streamContents: [ :s | text do: [ :ch | s nextPut: (ch asInteger < 128 ifTrue: [ ch ] ifFalse: [ Character value: 63 ]) ] ] ].
[ run := (PolyphemusTestRun of: $c buildSuite) run.
  '' traceCr. "a line of its own: the simulator leaves its output unfinished (#51)"
  ('RES $c ', run runCount printString, ' run ', run failureCount printString, ' failures ', run errorCount printString, ' errors', (run skippedCount > 0 ifTrue: [ ' ', run skippedCount printString, ' skipped' ] ifFalse: [ '' ])) traceCr.
  "What each problem signalled the first time, then what it did when run again (#31)."
  run problems do: [ :each | | again |
    again := run againOf: each key selector.
    (ascii value: (((run isFailure: each value) ifTrue: [ '    FAIL  ' ] ifFalse: [ '    ERROR ' ]), '$c>>', each key selector, ' -- ',
      (run describe: each value),
      (again = #passed
        ifTrue: [ ' (passed when run again in the same image: a flake, or state its first run left, #31)' ]
        ifFalse: [ ' (again: ', (run describe: again), ')' ]))) traceCr ] ]
  on: Error, Warning
  do: [ :e | (ascii value: 'RES $c BROKEN ', e class name, ' ', e messageText asString) traceCr ].
Smalltalk exitSuccess
INNER
  fi
  start=$(date +%s)
  # rc must be timeout's own status: $? after a pipeline is grep's, which hid every timeout (#14).
  # A flat limit makes the slow classes report TIMEOUT whenever the machine is busy, which is a
  # red suite that means nothing. Give each class what it took last time, three times over (#31),
  # and at least what its tests may take, each its own limit: a class never timed is not cut off.
  local limit known allowed
  known=$(awk -v c="$c" '$1==c {print $2}' "$TIMINGS" 2>/dev/null | tail -1)
  allowed=$(awk -v c="$c" '$1=="LIMIT" && $2==c {print $3}' "$LIMITS" 2>/dev/null | tail -1)
  limit="$TMO"
  [ -n "$allowed" ] && [ "$allowed" -gt "$limit" ] 2>/dev/null && limit="$allowed"
  if [ -n "$known" ] && [ "$known" -gt 0 ] 2>/dev/null && [ $(( known * 3 )) -gt "$limit" ]; then
    limit=$(( known * 3 ))
  fi
  # The whole output, stderr too, stays in .class-logs: a class that dies says why there (#31).
  mkdir -p "$WORK/.class-logs"
  local log="$WORK/.class-logs/$c.log"
  out=$(timeout "$limit" ./pharo "$IMAGE" --no-default-preferences st "$script" 2>&1 | tee "$log" | noise | grep -aE '^RES |^    (FAIL|ERROR|NOTE)'; exit ${PIPESTATUS[0]})
  rc=$?
  # VM 9 may refuse to start when mmap offers its heap below the image's base (#31): the class's
  # own image, like a live target, gets one more start, and says so.
  if [ $rc -ne 124 ] && ! grep -a -q "^RES $c " <<< "$out" && grep -a -q 'cannot find a good memory address' "$log"; then
    out=$(timeout "$limit" ./pharo "$IMAGE" --no-default-preferences st "$script" 2>&1 | tee "$log" | noise | grep -aE '^RES |^    (FAIL|ERROR|NOTE)'; exit ${PIPESTATUS[0]})
    rc=$?
    out="$out"$'\n''    NOTE its image did not start (VM 9 found no memory at its base, #31) and was started again'
  fi
  el=$(( $(date +%s) - start ))
  rm -f "$script"
  if [ $rc -eq 124 ]; then
    echo "RES $c TIMEOUT ${limit}s"
  elif ! grep -a -q "^RES $c " <<< "$out"; then
    # The image died, or printed nothing: a class that did not report is broken, not absent.
    echo "RES $c BROKEN no result (exit $rc)"
    tail -n 5 "$log" | tr -d '\033' | sed 's/^/    | /'
  else
    # NOTE lines (a target started again, #31) come after the class's result line.
    grep -a -v '^    NOTE' <<< "$out" | sed "1s/\$/ (${el}s)/"
    grep -a '^    NOTE' <<< "$out" || true
    # Only a class that passed says what it costs: a failing one can hang for its whole budget.
    [ -z "${ONLY_TEST:-}" ] && grep -a -q " 0 failures 0 errors" <<< "$out" && echo "$c $el" >> "$TIMINGS.new"
  fi
}
export -f run_class
export WORK IMAGE TMO TIMINGS ONLY_TEST

run_set() {
  local label="$1"; shift
  local classes=("$@")
  [ ${#classes[@]} -eq 0 ] && { echo "== $label: nothing to run =="; return 0; }
  # With SERIAL_LANES=n, classes that launch images of their own run in n lanes beside the rest,
  # one after another in each (#31). None by default.
  local lanes="${SERIAL_LANES:-0}" lane=() pool=() c pool_jobs="$JOBS"
  for c in "${classes[@]}"; do
    if grep -qx "$c" <<<"$LANE"; then lane+=("$c"); else pool+=("$c"); fi
  done
  [ ${#lane[@]} -lt "$lanes" ] && lanes=${#lane[@]}
  # No lanes: those classes run in the pool like any other (#45).
  if [ "$lanes" -eq 0 ]; then pool+=(${lane[@]+"${lane[@]}"}); lane=(); fi
  [ ${#pool[@]} -gt 0 ] && [ "$JOBS" -gt "$lanes" ] && pool_jobs=$((JOBS - lanes))
  echo "== $label: ${#classes[@]} classes, $JOBS at a time; ${#lane[@]} launching images, in $lanes lane(s) =="
  local start; start=$(date +%s)
  # Each lane class, longest first, goes to the lane with the least recorded time so far.
  if [ ${#lane[@]} -gt 0 ]; then
    local assigned; assigned=$(printf '%s\n' "${lane[@]}" | longest_first | awk -v n="$lanes" -v timings="$TIMINGS" '
      BEGIN { while ((getline line < timings) > 0) { split(line, f, " "); t[f[1]] = f[2] } }
      { best = 0; for (i = 1; i < n; i++) if (load[i] < load[best]) best = i
        load[best] += ($1 in t ? t[$1] : 60); print best, $1 }')
    local i
    for (( i = 0; i < lanes; i++ )); do
      ( for c in $(awk -v i="$i" '$1 == i { print $2 }' <<<"$assigned"); do run_class "$c"; done ) \
        | tee -a "$RESULTS" &
    done
  fi
  # Slowest first, by the last recorded time; a class never timed is unknown, so it goes first
  # too. Run by name, a heavy class could start last and alone set the end of the run.
  if [ ${#pool[@]} -gt 0 ]; then
    printf '%s\n' "${pool[@]}" | longest_first \
      | xargs -P "$pool_jobs" -I{} bash -c 'run_class "$@"' _ {} | tee -a "$RESULTS"
  fi
  wait
  # Every class given must have said something: one that never ran is broken, not green (#45).
  for c in "${classes[@]}"; do
    grep -a -q "^RES $c " "$RESULTS" || echo "RES $c BROKEN never ran" | tee -a "$RESULTS"
  done
  retry_fresh
  echo "== $label done in $(( $(date +%s) - start ))s =="
}

# A failure run again alone, in a fresh process: one that passes there is a flake, said apart
# (FLAKY) and not counted as a failure, so that red means a failure that stays (#31). A retry in
# the same image proves nothing: what its first run left can make it pass (docs/mistakes.md).
# Ten failures or more are a regression, not flakes, and are not retried. FRESH_RETRY=no: none.
RETRY_LIMIT=10
red() { grep -a -qE '^RES [A-Za-z0-9_]+ (TIMEOUT|BROKEN)|^    (FAIL |ERROR) ' "$RESULTS"; }
not_retried() {  # BSD grep (macOS) is not trusted with an empty pattern file
  if [ -s "$RESULTS.retried" ]; then grep -vxF -f "$RESULTS.retried" || true; else cat; fi
}
retry_fresh() {
  [ "${FRESH_RETRY:-yes}" = no ] && return 0
  local failed classes kind c sel out
  failed=$(grep -a -E '^    (FAIL |ERROR) +[A-Za-z0-9_]+>>[A-Za-z0-9_:]+ ' "$RESULTS" \
    | sed -E 's/^    (FAIL|ERROR) +([A-Za-z0-9_]+)>>([A-Za-z0-9_:]+) .*/\1 \2 \3/' | not_retried)
  classes=$(grep -a -E '^RES [A-Za-z0-9_]+ (TIMEOUT|BROKEN)' "$RESULTS" | awk '{print $2}' | not_retried)
  [ -z "$failed$classes" ] && return 0
  if [ $(( $(grep -c . <<<"$failed") + $(grep -c . <<<"$classes") )) -ge "$RETRY_LIMIT" ]; then
    echo "== $RETRY_LIMIT failures or more: a regression, not retried =="
    return 0
  fi
  echo "== each failure again, alone, in a fresh process =="
  while read -r kind c sel; do
    [ -z "$kind" ] && continue
    echo "$kind $c $sel" >> "$RESULTS.retried"
    out=$(ONLY_TEST="$sel" run_class "$c" < /dev/null)
    grep -a -q "^RES $c 1 run 0 failures 0 errors" <<<"$out" || { echo "    still failing: $c>>$sel"; continue; }
    echo "    FLAKY $c>>$sel"
    awk -v k="$kind" -v c="$c" -v s="$sel" '
      !done && index($0, "    " (k == "FAIL" ? "FAIL  " : "ERROR ") c ">>" s " ") == 1 {
        sub(/^    (FAIL  |ERROR )/, "    FLAKY "); sub(" -- ", " -- failed, then passed alone in a fresh process; first: "); done = 1 }
      $1 == "RES" && $2 == c && $3 ~ /^[0-9]+$/ && !fixed { if (k == "FAIL") $5--; else $7--; fixed = 1 }
      { print }' "$RESULTS" > "$RESULTS.tmp" && mv "$RESULTS.tmp" "$RESULTS"
  done <<<"$failed"
  for c in $classes; do
    echo "$c" >> "$RESULTS.retried"
    out=$(run_class "$c" < /dev/null)
    grep -a -qE "^RES $c [0-9]+ run 0 failures 0 errors" <<<"$out" || { echo "    still failing: $c"; continue; }
    echo "    FLAKY $c"
    awk -v c="$c" -v fresh="$(grep -a "^RES $c " <<<"$out" | head -1)" '
      $1 == "RES" && $2 == c && ($3 == "TIMEOUT" || $3 == "BROKEN") && !done {
        print fresh; print "    FLAKY " c " -- " $3 " first, then passed in a fresh process"; done = 1; skip = 1; next }
      skip && /^    \| / { next }
      { skip = 0; print }' "$RESULTS" > "$RESULTS.tmp" && mv "$RESULTS.tmp" "$RESULTS"
  done
}

# One run per setup: two share its warm.image and scratch files. A run started where one is
# going refuses, since a gate may be running there in the background (bin/gate.sh); FORCE=1
# stops the other instead -- and `pkill -x pharo` stops every Pharo on the box, other setups'
# too. -x matches the name exactly, never the ssh command line that asked for it.
LOCK="$WORK/.test-runner.pid"
if [ -f "$LOCK" ]; then
  PREV=$(cat "$LOCK" 2>/dev/null || true)
  if [ -n "${PREV:-}" ] && [ "$PREV" != "$$" ] && kill -0 "$PREV" 2>/dev/null; then
    if [ -z "${FORCE:-}" ]; then
      echo "!! a run is already going in $WORK (pid $PREV), perhaps a gate: use another setup, wait, or FORCE=1"
      exit 3
    fi
    echo "== stopping the run already going (pid $PREV) =="
    kill -TERM "$PREV" 2>/dev/null || true
    pkill -x pharo 2>/dev/null || true; pkill -x Pharo 2>/dev/null || true   # Pharo: the VM on macOS
    sleep 2
    pkill -9 -x pharo 2>/dev/null || true; pkill -9 -x Pharo 2>/dev/null || true
  fi
fi
echo $$ > "$LOCK"
trap 'rm -f "$LOCK"' EXIT

: > "$RESULTS"; : > "$RESULTS.retried"; : > "$TIMINGS.new"

# Which classes exist, and which launch images: asked of the image once. A single class needs
# neither, so the tightest loop does not pay for starting Pharo to ask.
COLLECTED=; LANE=
LIMITS="$WORK/.test-limits"; export LIMITS
if [ ${#SELECTED[@]} -ne 1 ]; then
  COLLECTED=$(collect)
  LANE=$(grep '^LANE ' <<<"$COLLECTED" | awk '{print $2}')
elif ! grep -qs "^LIMIT ${SELECTED[0]} " "$LIMITS" &&
     ! awk -v c="${SELECTED[0]}" '$1==c {f=1} END {exit !f}' "$TIMINGS" 2>/dev/null; then
  COLLECTED=$(collect)   # a class never run here: asked once what it may take
fi
[ -n "$COLLECTED" ] && grep '^LIMIT ' <<<"$COLLECTED" > "$LIMITS"
# SERIAL_LANES=n runs the image-launching classes in n lanes of their own; by default there are
# none. Measured at -j 5 with the dump cache warm: no lanes 418 s, two 483 s, one 573 s, all
# green -- the lanes cost more than the flakes they were meant to prevent (#31).
[ "${SERIAL_LANE:-yes}" = no ] && LANE=

# Asked for classes this image does not hold (another host's, another edition's): said and
# skipped, not run as broken. Asked of the image only for two classes or more.
if [ ${#SELECTED[@]} -gt 1 ] && [ -n "$COLLECTED" ]; then
  HELD=(); for c in "${SELECTED[@]}"; do
    if all_classes | grep -qx "$c"; then HELD+=("$c"); else echo "== not in this image, skipped: $c"; fi
  done
  SELECTED=(${HELD[@]+"${HELD[@]}"})
fi
if [ ${#SELECTED[@]} -gt 0 ]; then
  run_set "selected" "${SELECTED[@]}"
else
  ALL=(); while IFS= read -r c; do ALL+=("$c"); done < <(all_classes)   # no mapfile in bash 3.2 (macOS)
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
      if red; then
        echo "== fast tier is red: stopping before the slow tier =="
      else
        run_set "slow tier" ${SLOW[@]+"${SLOW[@]}"}
      fi ;;
  esac
fi

if [ -s "$TIMINGS.new" ]; then
  cat "$TIMINGS" "$TIMINGS.new" 2>/dev/null \
    | awk '!($1 in t) || $2 > t[$1] {t[$1]=$2} END {for (c in t) print c, t[c]}' | sort > "$TIMINGS.tmp"   # worst, not last (#54)
  mv "$TIMINGS.tmp" "$TIMINGS"
fi
rm -f "$TIMINGS.new"

awk '/^RES /{ if ($3=="TIMEOUT"||$3=="BROKEN") b++; else {r+=$3; f+=$5; e+=$7} } /^    FLAKY /{ k++ }
     END { printf "== totals: %d run, %d failures, %d errors, %d broken, %d flaky ==\n", r, f, e, b, k }' "$RESULTS"
rm -f "$RESULTS.retried"
if red; then exit 1; else exit 0; fi
