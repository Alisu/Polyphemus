#!/usr/bin/env bash
# One test run many times, each alone in a fresh process, optionally beside CPU load, to make a
# rare failure show itself (#31): how often it fails, the distinct failures, and the log of each
# failing run, kept in $WORK/repeat/. Runs from the images as they are: prepare them first
# (PREPARE_ONLY=1 bin/tdd.sh). In CI, the Repeat workflow; on the shared box, keep LOAD at 0.
#
#   WORK=<setup> bin/repeat-test.sh LinuxProcessMemoryTest testTheRunningProcessOfAStoppedImageShowsItsStack 40
#   LOAD=2 WORK=<setup> bin/repeat-test.sh WatcherInjectionTest '' 20     (the whole class, 20 times)
set -uo pipefail
class="${1:?a test class}"; test="${2:-}"; times="${3:-30}"; load="${LOAD:-0}"
HERE="$(cd "$(dirname "$0")" && pwd)"
out="$WORK/repeat"
rm -rf "$out"; mkdir -p "$out"
if [ "$load" -gt 0 ] && command -v stress-ng >/dev/null; then
  stress-ng --cpu "$load" --timeout 0 >/dev/null 2>&1 &
  stressing=$!
  trap 'kill $stressing 2>/dev/null' EXIT
  echo "== beside $load CPU worker(s) of stress-ng"
fi
failed=0
for (( i = 1; i <= times; i++ )); do
  args=(-c "$class"); [ -n "$test" ] && args+=(-t "$test")
  run=$(WORK="$WORK" SKIP_PREPARE=1 FRESH_RETRY=no "$HERE/tdd.sh" -j 1 "${args[@]}" 2>&1)
  if grep -aq "totals: .* 0 failures, 0 errors, 0 broken" <<<"$run"; then
    echo "run $i: green"
  else
    failed=$(( failed + 1 ))
    cp "$WORK/.class-logs/$class.log" "$out/run-$i.log" 2>/dev/null
    first=$(grep -aE '^    (FAIL|ERROR)|^RES [A-Za-z0-9_]+ (BROKEN|TIMEOUT)' <<<"$run" | head -1 | cut -c1-300)
    echo "run $i: RED $first"
    echo "$first" >> "$out/failures.txt"
  fi
done
echo "== $failed of $times runs failed: $class${test:+>>$test}"
if [ -s "$out/failures.txt" ]; then
  echo "== the failures, by what they said (up to its first bracket):"
  sed -E 's/ \[in .*//' "$out/failures.txt" | sort | uniq -c | sort -rn
fi
exit 0
