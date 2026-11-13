#!/usr/bin/env bash
# Tests of bin/check-root.sh, on root-step logs written here. No Pharo.
#
#   bin/check-root-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d)
root() { "$HERE/check-root.sh" "$dir/root.log" "$1" > "$dir/out" 2>&1; echo $?; }

printf '%s\n' 'RES ATest 4 run 0 failures 0 errors (12s)' 'RES BTest 3 run 0 failures 0 errors 1 skipped (9s)' > "$dir/root.log"
check "classes that answered green pass" "[ \$(root 2) -eq 0 ] && [ ! -s $dir/out ]"
check "one class fewer than asked is red" "[ \$(root 3) -eq 1 ] && grep -q '!! 2 of 3 classes answered' $dir/out"

printf '%s\n' 'RES ATest TIMEOUT 1800s' > "$dir/root.log"
check "a class that timed out is red (#177)" "[ \$(root 1) -eq 1 ] && grep -q '!! ATest TIMEOUT' $dir/out"

printf '%s\n' 'RES ATest 1 run 0 failures 0 errors 1 skipped (1s)' > "$dir/root.log"
check "a class whose every test was skipped is red (#177)" "[ \$(root 1) -eq 1 ] && grep -q '!! ATest: every test skipped' $dir/out"

printf '%s\n' 'RES ATest BROKEN Error it broke' 'RES BTest 2 run 1 failures 0 errors (3s)' > "$dir/root.log"
check "a class that broke or failed is red" "[ \$(root 2) -eq 1 ] && grep -q '!! ATest BROKEN' $dir/out && grep -q '!! BTest 2 run 1 failures' $dir/out"

rm -rf "$dir"
echo "== check-root-test: $failures failing"
exit $(( failures > 0 ))
