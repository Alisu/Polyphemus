#!/usr/bin/env bash
# The gate (docs/editions.md). Each edition has a setup directory with its own image, timings and
# polyphemus.env, run with WORK set to it.
#
#   bin/gate.sh              every edition: before a push, and before tagging an edition
#   bin/gate.sh 13           the edition being worked on: before a commit
#   bin/gate.sh 10 13        ...and Pharo 10 as well, when the change touches shared code
#   bin/gate.sh --commit 13 10   before a commit: the fast tier, and the slow classes the
#                            change reaches, as the image finds its senders (bin/select-tests.st,
#                            TestImpact); a change to a core class
#                            (bin/core-classes) is pushed and waits for CI before anything is
#                            built on it
#   bin/gate.sh --commit --classes "ATest BTest" 13 10
#                            the fast tier and those classes, named rather than looked for: when
#                            the selection comes out wide (a core class, a common selector)
#   bin/gate.sh --status     each edition's last green commit, against HEAD
#   JOBS=5 bin/gate.sh 13    JOBS_10=1 for one edition only (Pharo 10 runs short of memory, #110)
#
# The editions' tests run side by side, each on its own setup.
#
# A commit gate should stay under about ten minutes (Beck's ten-minute build; the most common
# "maximum acceptable" CI build time in Hilton et al., FSE 2017). Every run is logged, with its
# time and the CPU's peak temperature, in $ROOT/gate-history.log.
set -uo pipefail
ROOT="${ROOT:-$HOME/polyphemus}"
JOBS="${JOBS:-6}"
REPO="$ROOT/Polyphemus"
HISTORY="$ROOT/gate-history.log"

setup_of() {  # 10 or pharo10 -> its setup directory
  local n="${1#pharo}"
  if [ "$n" = 10 ]; then echo "$ROOT"; else echo "$ROOT/pharo$n"; fi
}

. "$(dirname "$0")/timings.sh"

jobs_of() {  # the jobs an edition runs: JOBS_<n>, or JOBS
  local var="JOBS_${1#pharo}"
  echo "${!var:-$JOBS}"
}

ALL=(10)
for dir in "$ROOT"/pharo[0-9]*; do
  [ -f "$dir/dev.image" ] && ALL+=("${dir##*/pharo}")
done

head_commit=$(git -C "$REPO" rev-parse --short HEAD)
dirty=$(git -C "$REPO" status --porcelain --untracked-files=no | grep -q . && echo "+changes" || echo "")

if [ "${1:-}" = "--status" ]; then
  for n in "${ALL[@]}"; do
    last=$(cat "$(setup_of "$n")/.last-green" 2>/dev/null || echo "never")
    echo "Pharo $n: last green $last (HEAD $head_commit$dirty)"
  done
  exit 0
fi

COMMIT_GATE=
NAMED_CLASSES=
if [ "${1:-}" = --commit ]; then
  COMMIT_GATE=yes; shift
  if [ "${1:-}" = --classes ]; then NAMED_CLASSES="$2"; shift 2; fi
  CHANGES=$(mktemp)
  SELECTION=$("$REPO/bin/commit-selection.sh")
  grep '^CHANGE ' <<<"$SELECTION" | cut -c8- > "$CHANGES"
  CORE_CHANGED=$(grep '^CORE ' <<<"$SELECTION" | awk '{print $2}' | tr '\n' ' ')
fi
EDITIONS=("$@")
[ ${#EDITIONS[@]} -eq 0 ] && EDITIONS=("${ALL[@]}")
for n in "${EDITIONS[@]}"; do
  [ -f "$(setup_of "$n")/dev.image" ] || { echo "no setup for Pharo ${n#pharo} at $(setup_of "$n")"; exit 2; }
done

# The gate holds its setups: bin/tdd.sh refuses them while it runs (#59's lesson: a second run
# on a setup overwrites the images the first is testing).
for n in "${EDITIONS[@]}"; do
  held=$(cat "$(setup_of "$n")/.gate.pid" 2>/dev/null || true)
  if [ -n "$held" ] && kill -0 "$held" 2>/dev/null; then
    echo "!! a gate (pid $held) already holds Pharo ${n#pharo}"; exit 3
  fi
done
for n in "${EDITIONS[@]}"; do echo $$ > "$(setup_of "$n")/.gate.pid"; done
# Removing the temperature's file stops its sampler, however the gate ends.
trap 'for n in "${EDITIONS[@]}"; do rm -f "$(setup_of "$n")/.gate.pid"; done; rm -f "${peak_file:-}" "${CHANGES:-}"' EXIT

# The CPU's peak temperature over the run: this box throttles near 110 C, which doubles a gate.
peak_file=$(mktemp)
echo 0 > "$peak_file"
( while [ -f "$peak_file" ]; do
    t=$(( $(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -n | tail -1) / 1000 ))
    [ -f "$peak_file" ] && [ "$t" -gt "$(cat "$peak_file" 2>/dev/null || echo 0)" ] && echo "$t" > "$peak_file"
    sleep 20
  done ) &

start=$(date +%s)
# Every edition's images first: once they hold the working copy, it can change again. Side by
# side: each compiles and builds on one core, and in turn they took 187 s of a 297 s gate.
preparing=()
for n in "${EDITIONS[@]}"; do
  setup=$(setup_of "$n")
  ( ( cd "$setup" && WORK="$setup" GATE_OWNED=1 PREPARE_ONLY=1 "$setup/Polyphemus/bin/tdd.sh" > "$setup/.gate.log" 2>&1 ) ||
    echo "RES prepare BROKEN: the working copy was not compiled into this edition" >> "$setup/.gate.log" ) &
  preparing+=($!)
done
wait "${preparing[@]}"   # these only: the temperature watch above runs until the end
# Which tests the changes reach, asked of the first edition's image once it holds them: the
# senders of what changed, followed up to the tests (bin/select-tests.st, TestImpact).
if [ -n "$NAMED_CLASSES" ]; then
  SELECTED_CLASSES="$NAMED_CLASSES"
  rm -f "$CHANGES"
  echo "== commit gate: the fast tier, and $NAMED_CLASSES (named)"
elif [ -n "$COMMIT_GATE" ]; then
  first=$(setup_of "${EDITIONS[0]}")
  SELECTION=$( cd "$first" && POLYPHEMUS_CHANGES="$CHANGES" timeout 300 ./pharo dev.image --no-default-preferences \
    st "$REPO/bin/select-tests.st" 2>/dev/null | tr -d '\033' | grep -aE '^(CLASS|WIDE) |^SELECTED$' )
  # No closing line: the image did not answer, and no class is not the same as none reached.
  grep -q '^SELECTED$' <<<"$SELECTION" || {
    echo "!! the test selection failed: the image did not say which tests the change reaches"; exit 4; }
  SELECTED_CLASSES=$(grep '^CLASS ' <<<"$SELECTION" | awk '{print $2}' | sort | tr '\n' ' ')
  WIDE_CHANGED=$(grep '^WIDE ' <<<"$SELECTION" | awk '{print $2}' | tr '\n' ' ')
  rm -f "$CHANGES"
  echo "== commit gate: the fast tier, and ${SELECTED_CLASSES:-no slow class}"
fi
echo "== working copy free after $(( $(date +%s) - start ))s: edit on, but run bin/tdd.sh only on setups not in this gate"
testing=()
for n in "${EDITIONS[@]}"; do
  setup=$(setup_of "$n")
  jobs=$(jobs_of "$n")
  grep -q "^RES prepare BROKEN" "$setup/.gate.log" && { echo 0 > "$setup/.gate.seconds"; continue; }
  ( began=$(date +%s)
    if [ -n "$COMMIT_GATE" ]; then
      ( cd "$setup" && WORK="$setup" GATE_OWNED=1 SKIP_PREPARE=1 "$setup/Polyphemus/bin/tdd.sh" --fast -j "$jobs" >> "$setup/.gate.log" 2>&1 )
      # Only the slow ones: the fast tier has run every other. A class never timed counts as slow;
      # a class named runs whatever its time.
      slow=()
      for c in $SELECTED_CLASSES; do
        t=$(best_time_of "$c" "$setup/.test-timings")
        { [ -n "$NAMED_CLASSES" ] || [ -z "$t" ] || [ "$t" -ge "${SLOW_THRESHOLD:-8}" ]; } && slow+=(-c "$c")
      done
      [ ${#slow[@]} -gt 0 ] && ( cd "$setup" && WORK="$setup" GATE_OWNED=1 SKIP_PREPARE=1 "$setup/Polyphemus/bin/tdd.sh" "${slow[@]}" -j "$jobs" >> "$setup/.gate.log" 2>&1 )
    else
      ( cd "$setup" && WORK="$setup" GATE_OWNED=1 SKIP_PREPARE=1 "$setup/Polyphemus/bin/tdd.sh" --all -j "$jobs" >> "$setup/.gate.log" 2>&1 )
    fi
    echo "$(( $(date +%s) - began ))" > "$setup/.gate.seconds" ) &
  testing+=($!)
done
[ ${#testing[@]} -gt 0 ] && wait "${testing[@]}"
peak=$(cat "$peak_file"); rm -f "$peak_file"

status=0
summary=""
for n in "${EDITIONS[@]}"; do
  setup=$(setup_of "${n#pharo}")
  echo "== Pharo ${n#pharo} ($(cat "$setup/.gate.seconds")s)"
  grep -aE "^== totals|^    (FAIL|ERROR|FLAKY)|BROKEN|TIMEOUT|never ran|^NO COMMENT|^LONG COMMENT" "$setup/.gate.log"
  # Red by the totals, which count a failure that passed alone in a fresh process as a flake,
  # not a failure (bin/run-tests.sh); the log above still shows its first run.
  # Every run's totals green, and at least one: a commit gate makes two runs, the fast tier and
  # the slow classes it selected.
  # A class without its comment compiles here, but a user's Metacello load fails on it; a method
  # comment over three lines breaks the working agreement (bin/long-comments.py).
  # A run of no test is no green: an image that did not start reads as 0 run, 0 failures.
  if ! grep -qa "^== totals" "$setup/.gate.log" || grep -qaE "^(NO|LONG) COMMENT" "$setup/.gate.log" ||
     grep -qa "^== totals: 0 run" "$setup/.gate.log" ||
     grep -a "^== totals" "$setup/.gate.log" | grep -qv " 0 failures, 0 errors, 0 broken"; then
    status=1; summary="$summary ${n#pharo}:red"
  else
    echo "$head_commit$dirty $(date +%F)" > "$setup/.last-green"; summary="$summary ${n#pharo}:green"
  fi
done
took=$(( $(date +%s) - start ))
echo "== gate done in ${took}s, CPU peak ${peak}C"
[ -n "$COMMIT_GATE" ] && [ -n "$CORE_CHANGED" ] &&
  echo "== core classes changed ($CORE_CHANGED): the whole suite tests them; push, and wait for CI before building on this"
[ -n "$COMMIT_GATE" ] && [ -n "${WIDE_CHANGED:-}" ] &&
  echo "== selectors many classes implement changed ($WIDE_CHANGED): not followed; push, and wait for CI before building on this"
echo "$(date '+%F %T') $head_commit$dirty${summary} ${took}s peak ${peak}C${COMMIT_GATE:+ commit}" >> "$HISTORY"
exit $status
