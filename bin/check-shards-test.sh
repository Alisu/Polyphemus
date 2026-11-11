#!/usr/bin/env bash
# Tests of bin/check-shards.sh, on shards' suite logs written here. No Pharo.
#
#   bin/check-shards-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d)

shard() {   # shard K N WHOLE FIRST LAST SKIPPED: a log of shard K of N, classes FIRST to LAST, ten tests each
  local k=$1 n=$2 whole=$3 first=$4 last=$5 s=$6 i count=0
  echo "== shard $k/$n: $((last - first + 1)) of $whole classes =="
  for i in $(seq "$first" "$last"); do echo "RES Class$i 10 run 0 failures 0 errors (2s)"; count=$((count + 10)); done
  echo "== totals: $count run, 0 failures, 0 errors, 0 broken, 1 flaky, $s skipped =="
}

mkdir "$dir/whole"; shard 1 2 10 1 4 0 > "$dir/whole/a.log"; shard 2 2 10 5 10 5 > "$dir/whole/b.log"
out=$("$HERE/check-shards.sh" "$dir/whole" 10 90 2>&1); code=$?
check "two shards that ran the suite between them pass" "[ $code = 0 ] && ! grep -q '!!' <<<\"\$out\""
check "their totals are said as one" "grep -q '^== totals: 100 run, 0 failures, 0 errors, 0 broken, 2 flaky, 5 skipped ==' <<<\"\$out\""
check "and how much ran" "grep -q '^== 10 classes answered in 2 shards, 95 tests ran (5 skipped)' <<<\"\$out\""

mkdir "$dir/lost"; shard 1 2 10 1 4 0 > "$dir/lost/a.log"
out=$("$HERE/check-shards.sh" "$dir/lost" 4 10 2>&1); code=$?
check "a shard whose log is missing fails, saying which" "[ $code = 1 ] && grep -q '^!! no log of shard 2/2' <<<\"\$out\""

mkdir "$dir/hole"; shard 1 2 10 1 4 0 > "$dir/hole/a.log"; shard 2 2 10 5 9 0 > "$dir/hole/b.log"
out=$("$HERE/check-shards.sh" "$dir/hole" 5 10 2>&1); code=$?
check "a class no shard answered for fails" "[ $code = 1 ] && grep -q '^!! 9 classes answered, the suite has 10' <<<\"\$out\""

mkdir "$dir/twice"; shard 1 2 10 1 5 0 > "$dir/twice/a.log"; shard 2 2 10 5 10 0 > "$dir/twice/b.log"
out=$("$HERE/check-shards.sh" "$dir/twice" 5 10 2>&1); code=$?
check "a class two shards ran fails, naming it" "[ $code = 1 ] && grep -q '^!! in more than one shard: Class5' <<<\"\$out\""

mkdir "$dir/apart"; shard 1 2 10 1 4 0 > "$dir/apart/a.log"; shard 2 2 12 5 10 0 > "$dir/apart/b.log"
out=$("$HERE/check-shards.sh" "$dir/apart" 5 10 2>&1); code=$?
check "shards that do not agree on the suite fail" "[ $code = 1 ] && grep -q '^!! the shards do not agree' <<<\"\$out\""

mkdir "$dir/few"; shard 1 2 10 1 4 0 > "$dir/few/a.log"; shard 2 2 10 5 10 60 > "$dir/few/b.log"
out=$("$HERE/check-shards.sh" "$dir/few" 10 90 2>&1); code=$?
check "skipped tests are not tests run, over the shards" "[ $code = 1 ] && grep -q '^!! 40 tests ran (100 run, 60 skipped), fewer than 90' <<<\"\$out\""
out=$("$HERE/check-shards.sh" "$dir/whole" 12 90 2>&1); code=$?
check "fewer classes than the job is known to run fails" "[ $code = 1 ] && grep -q '^!! 10 classes answered, fewer than 12' <<<\"\$out\""

mkdir "$dir/again"; { shard 1 2 10 1 4 0; echo "RES Class2 10 run 0 failures 0 errors (2s)"; } > "$dir/again/a.log"; shard 2 2 10 5 10 0 > "$dir/again/b.log"
out=$("$HERE/check-shards.sh" "$dir/again" 10 90 2>&1); code=$?
check "a class run again for a retry counts once" "[ $code = 0 ]"

mkdir "$dir/cut"; shard 1 2 10 1 4 0 | grep -v totals > "$dir/cut/a.log"; shard 2 2 10 5 10 0 > "$dir/cut/b.log"
out=$("$HERE/check-shards.sh" "$dir/cut" 10 90 2>&1); code=$?
check "a shard that did not end fails" "[ $code = 1 ] && grep -q '^!! no totals in shard 1/2' <<<\"\$out\""

mkdir "$dir/none"
out=$("$HERE/check-shards.sh" "$dir/none" 1 1 2>&1); code=$?
check "no log at all fails" "[ $code = 1 ] && grep -q '^!! no shard' <<<\"\$out\""
rm -rf "$dir"

echo "== check-shards-test: $failures failing"
exit $(( failures > 0 ))
