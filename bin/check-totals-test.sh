#!/usr/bin/env bash
# Tests of bin/check-totals.sh, on suite logs written here. No Pharo.
#
#   bin/check-totals-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d)

log() {   # log CLASSES TESTS SKIPPED: a suite log of that many classes, each of TESTS/CLASSES tests
  local c=$1 t=$2 s=$3 i
  for i in $(seq 1 "$c"); do
    if [ "$i" = 1 ] && [ "$s" -gt 0 ]; then echo "RES Class$i $((t / c)) run 0 failures 0 errors $s skipped (2s)"
    else echo "RES Class$i $((t / c)) run 0 failures 0 errors (2s)"; fi
  done
  echo "== totals: $t run, 0 failures, 0 errors, 0 broken, 0 flaky, $s skipped =="
}

log 10 100 0 > "$dir/whole.log"
out=$("$HERE/check-totals.sh" "$dir/whole.log" 10 100 2>&1); code=$?
check "a suite that ran what it should passes" "[ $code = 0 ] && ! grep -q '!!' <<<\"\$out\""

log 9 90 0 > "$dir/few.log"
out=$("$HERE/check-totals.sh" "$dir/few.log" 10 50 2>&1); code=$?
check "fewer classes than asked fails, saying how many" "[ $code = 1 ] && grep -q '^!! 9 classes answered, fewer than 10' <<<\"\$out\""

log 10 100 60 > "$dir/skips.log"
out=$("$HERE/check-totals.sh" "$dir/skips.log" 10 50 2>&1); code=$?
check "skipped tests are not tests run" "[ $code = 1 ] && grep -q '^!! 40 tests ran (100 run, 60 skipped), fewer than 50' <<<\"\$out\""

printf 'RES Class1 5 run 0 failures 0 errors (2s)\nRES Class1 1 run 0 failures 0 errors (2s)\n' > "$dir/retried.log"
echo "== totals: 5 run, 0 failures, 0 errors, 0 broken, 1 flaky, 0 skipped ==" >> "$dir/retried.log"
out=$("$HERE/check-totals.sh" "$dir/retried.log" 2 1 2>&1); code=$?
check "a class run again for a retry counts once" "[ $code = 1 ] && grep -q '^!! 1 classes answered' <<<\"\$out\""

echo "nothing to run" > "$dir/none.log"
out=$("$HERE/check-totals.sh" "$dir/none.log" 1 1 2>&1); code=$?
check "a log without totals fails" "[ $code = 1 ] && grep -q '^!! no totals' <<<\"\$out\""

rm -rf "$dir"
echo "== check-totals-test: $failures failing"
[ "$failures" = 0 ]
