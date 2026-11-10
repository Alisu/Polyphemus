#!/usr/bin/env bash
# Tests of bin/run-tests.sh, run against a stand-in for Pharo that reports one class green. A
# second or so, no Pharo.
#
#   bin/run-tests-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d)

# The stand-in answers what the runner's script asks for: the class named in its RES line.
cat > "$dir/pharo" <<'STUB'
#!/usr/bin/env bash
script="${@: -1}"
case "$script" in *collect-tests.st)
  for c in ${STUB_CLASSES:-}; do echo "CLASS $c"; done
  for c in ${STUB_LANES:-}; do echo "LANE $c"; done
  exit 0 ;; esac
class=$(grep -ao "RES [A-Za-z0-9]* '" "$script" | head -1 | awk '{print $2}')
[ -n "${STUB_SCRATCH:-}" ] && echo "SCRATCH $STUB_SCRATCH"
[ -n "${STUB_COLOUR:-}" ] && printf '\033[0m'   # a colour reset left by the VM's output, then the line
# A class whose image dies says nothing, its log ending mid-line (#51).
[ "$class" = "${STUB_SILENT:-}" ] && { printf 'a stack, then\033[0m'; exit 1; }
if [ -n "${STUB_SKIPPED:-}" ]; then echo "RES $class 3 run 0 failures 0 errors 2 skipped"
else echo "RES $class 1 run 0 failures 0 errors"; fi
STUB
chmod +x "$dir/pharo"

# The workers are fresh shells: every function they call must reach them.
out=$(WORK="$dir" "$HERE/run-tests.sh" -c FakeTest -j 1 2>&1)
check "a class run in the pool reports its result" "grep -q '^RES FakeTest 1 run 0 failures 0 errors' <<<\"\$out\""

# A class that dies leaves its targets running, its ensure: blocks never run (#164): the runner
# kills them, found by the class's spike directory in their command line, before its retry.
( exec -a "fakevm $dir/polyphemus-target-SilentTest/quiet.st" sleep 60 ) &
target=$!
sleep 0.3
out=$(WORK="$dir" STUB_SCRATCH="$dir" STUB_CLASSES="SilentTest" STUB_SILENT=SilentTest "$HERE/run-tests.sh" -c SilentTest -j 1 2>&1)
sleep 0.3
check "a dead class's targets are killed, and said" "! kill -0 $target 2>/dev/null && grep -q 'NOTE killed the targets it left running' <<<\"\$out\""
kill -9 $target 2>/dev/null
( exec -a "fakevm $dir/polyphemus-target-FakeTestTwo/quiet.st" sleep 60 ) &
other=$!
( exec -a "fakevm $dir/another-setup/polyphemus-target-SilentTest/quiet.st" sleep 60 ) &
elsewhere=$!
sleep 0.3
out=$(WORK="$dir" STUB_SCRATCH="$dir" STUB_CLASSES="SilentTest" STUB_SILENT=SilentTest "$HERE/run-tests.sh" -c SilentTest -j 1 2>&1)
check "another class's targets are left alone" "kill -0 $other 2>/dev/null"
check "another setup's run of the class is left alone" "kill -0 $elsewhere 2>/dev/null"
kill -9 $other $elsewhere 2>/dev/null

# A class the suite no longer has leaves the timings the lanes are balanced on (#164).
printf 'GoneTest 1883\nFakeTest 5\n' > "$dir/.test-timings"
out=$(STUB_CLASSES="FakeTest" WORK="$dir" "$HERE/run-tests.sh" --all -j 1 2>&1)
check "a full run drops the timings of classes no longer in the suite" "! grep -q GoneTest '$dir/.test-timings' && grep -q FakeTest '$dir/.test-timings'"
rm -f "$dir/.test-timings"

# Skipped tests are run tests that did not run: the totals say how many (#164).
out=$(STUB_SKIPPED=1 WORK="$dir" "$HERE/run-tests.sh" -c FakeTest -j 1 2>&1)
check "the totals count the tests skipped" "grep -q '^== totals: 3 run, 0 failures, 0 errors, 0 broken, 0 flaky, 2 skipped ==' <<<\"\$out\""
check "no class is broken by the runner itself" "! grep -q 'BROKEN' <<<\"\$out\""
out=$(WORK="$dir" STUB_COLOUR=1 "$HERE/run-tests.sh" -c FakeTest -j 1 2>&1)
check "a result behind a colour code still counts" "grep -q '^RES FakeTest 1 run' <<<\"\$out\" && ! grep -q 'BROKEN' <<<\"\$out\""
out=$(WORK="$dir" STUB_CLASSES="SilentTest FakeTest" STUB_SILENT=SilentTest "$HERE/run-tests.sh" -c SilentTest -c FakeTest -j 1 2>&1)
check "a class after one whose log ends mid-line still counts" "grep -q '^RES FakeTest 1 run' <<<\"\$out\" && ! grep -q 'FakeTest BROKEN' <<<\"\$out\""
# Many classes that launch images run two at a time, in lanes of their own: twelve at once
# overloaded the box (2026-11-01). A few run in the pool as before (#31).
many="LaunchATest LaunchBTest LaunchCTest LaunchDTest LaunchETest"
out=$(WORK="$dir" STUB_CLASSES="$many" STUB_LANES="$many" "$HERE/run-tests.sh" $(printf -- '-c %s ' $many) -j 6 2>&1)
check "five classes that launch images run in two lanes" "grep -q '5 launching images, in 2 lane(s)' <<<\"\$out\""
check "each of them reports its result" "[ \$(grep -c '^RES Launch.Test 1 run' <<<\"\$out\") -eq 5 ]"
few="LaunchATest LaunchBTest LaunchCTest"
out=$(WORK="$dir" STUB_CLASSES="$few" STUB_LANES="$few" "$HERE/run-tests.sh" $(printf -- '-c %s ' $few) -j 6 2>&1)
check "three of them run in the pool" "grep -q '3 launching images, in 0 lane(s)' <<<\"\$out\""
out=$(WORK="$dir" STUB_CLASSES="$many" STUB_LANES="$many" SERIAL_LANES=0 "$HERE/run-tests.sh" $(printf -- '-c %s ' $many) -j 6 2>&1)
check "SERIAL_LANES=0 still runs them all in the pool" "grep -q '5 launching images, in 0 lane(s)' <<<\"\$out\""
rm -rf "$dir"

echo "== run-tests-test: $failures failing"
exit $(( failures > 0 ))
