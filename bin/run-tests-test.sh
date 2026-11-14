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
# The probe of #118, where the runner's script installs it, says what reached a handler.
grep -q "probe-handlers-install.st" "$script" && echo "    NOTE ARRIVAL $class | 2 | AHandler>>m | KeyNotFound | key 1 | Dictionary>>at:"
# A test that fails, then is skipped when run again alone: the retry runs one selector.
if [ -n "${STUB_FAIL_THEN_SKIP:-}" ]; then
  if grep -q "selector: #" "$script"; then echo "RES $class 1 run 0 failures 0 errors 1 skipped"
  else echo "RES $class 1 run 1 failures 0 errors"; echo "    FAIL  $class>>testX -- boom"; fi
  exit 0
fi
if [ -n "${STUB_SKIPPED:-}" ]; then echo "RES $class 3 run 0 failures 0 errors 2 skipped"
else echo "RES $class 1 run 0 failures 0 errors"; fi
STUB
chmod +x "$dir/pharo"

# A failure skipped when run again alone did not pass: it stays a failure, not a flake (#177).
out=$(WORK="$dir" STUB_FAIL_THEN_SKIP=1 "$HERE/run-tests.sh" -c SkipTest -j 1 2>&1); rc=$?
check "a failure whose retry is skipped is no flake" "! grep -q 'FLAKY SkipTest' <<<\"\$out\" && grep -q 'still failing: SkipTest>>testX' <<<\"\$out\""
check "and the run is red" "[ $rc -ne 0 ]"

# Classes asked for, none of them in this image, run nothing: not the whole suite (#177).
out=$(WORK="$dir" STUB_CLASSES="ATest BTest" "$HERE/run-tests.sh" -c XTest -c YTest -j 1 2>&1)
check "asked-for classes none of which is here run no other class" "! grep -q '^RES ATest' <<<\"\$out\" && ! grep -q '^RES BTest' <<<\"\$out\""
check "it says none was here" "grep -q 'none of the classes asked for is in this image' <<<\"\$out\""

# The workers are fresh shells: every function they call must reach them.
out=$(WORK="$dir" "$HERE/run-tests.sh" -c FakeTest -j 1 2>&1)
check "a class run in the pool reports its result" "grep -q '^RES FakeTest 1 run 0 failures 0 errors' <<<\"\$out\""

# The probe of #118 is asked for (PROBE_HANDLERS=yes): no other run installs it.
check "a run installs no probe of the handlers unasked" "! grep -q 'NOTE ARRIVAL' <<<\"\$out\""
out=$(WORK="$dir" PROBE_HANDLERS=yes "$HERE/run-tests.sh" -c FakeTest -j 1 2>&1)
check "PROBE_HANDLERS=yes installs it, and what reached a handler is said" "grep -q 'NOTE ARRIVAL FakeTest | 2 | AHandler>>m | KeyNotFound' <<<\"\$out\""

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

# Where no run was timed, as on CI's runners, a class weighs what bin/class-weights.txt says: the
# heaviest starts first, not whichever sorts first.
printf 'AaTest 5\nBbTest 500\n' > "$dir/weights"
out=$(WORK="$dir" WEIGHTS="$dir/weights" STUB_CLASSES="AaTest BbTest" "$HERE/run-tests.sh" --all -j 1 2>&1)
check "with no timings, the class the weights call heaviest runs first" "[ \"\$(grep '^RES ' <<<\"\$out\" | head -1 | awk '{print \$2}')\" = BbTest ]"
rm -f "$dir/.test-timings"

# A suite shared out over runners (SHARD=k/n): each class in one shard and only one, the classes
# that launch images and the rest each shared out by weight, the same on every runner.
seven="LaunchATest LaunchBTest LaunchCTest LaunchDTest PlainATest PlainBTest PlainCTest"
launching="LaunchATest LaunchBTest LaunchCTest LaunchDTest"
printf 'LaunchATest 1200\nLaunchBTest 700\nLaunchCTest 400\nLaunchDTest 300\nPlainATest 1200\nPlainBTest 50\n' > "$dir/weights"
one=$(WORK="$dir" WEIGHTS="$dir/weights" STUB_CLASSES="$seven" STUB_LANES="$launching" SHARD=1/2 "$HERE/run-tests.sh" --all -j 2 2>&1)
rm -f "$dir/.test-timings"
two=$(WORK="$dir" WEIGHTS="$dir/weights" STUB_CLASSES="$seven" STUB_LANES="$launching" SHARD=2/2 "$HERE/run-tests.sh" --all -j 2 2>&1)
ran() { grep '^RES ' <<<"$1" | awk '{print $2}' | sort | tr '\n' ' '; }
check "the two shards run every class between them" "[ \"\$( { ran \"\$one\"; ran \"\$two\"; } | tr ' ' '\n' | grep . | sort | tr '\n' ' ')\" = \"\$(tr ' ' '\n' <<<\"\$seven\" | sort | tr '\n' ' ')\" ]"
check "the heaviest launching class is alone against the three others" "[ \"\$(ran \"\$one\")\" = 'LaunchATest PlainATest ' ] && [ \"\$(ran \"\$two\")\" = 'LaunchBTest LaunchCTest LaunchDTest PlainBTest PlainCTest ' ]"
check "a shard says how many of the suite's classes are its own" "grep -q '^== shard 1/2: 2 of 7 classes ==' <<<\"\$one\" && grep -q '^== shard 2/2: 5 of 7 classes ==' <<<\"\$two\""
check "a shard's totals are of its own classes" "grep -q '^== totals: 2 run, 0 failures' <<<\"\$one\""
printf 'LaunchATest 9\nPlainATest 9\nPlainBTest 9\n' > "$dir/.test-timings"
again=$(WORK="$dir" WEIGHTS="$dir/weights" STUB_CLASSES="$seven" STUB_LANES="$launching" SHARD=1/2 "$HERE/run-tests.sh" --all -j 2 2>&1)
check "a runner's own timings do not move a class to another shard" "[ \"\$(ran \"\$again\")\" = 'LaunchATest PlainATest ' ]"
check "a shard's run keeps the timings of the other shards' classes" "grep -q '^PlainBTest ' '$dir/.test-timings'"
rm -f "$dir/.test-timings"
WORK="$dir" STUB_CLASSES="$seven" SHARD=3/2 "$HERE/run-tests.sh" --all -j 2 > /dev/null 2>&1
check "a shard past the last is refused" "[ $? -eq 2 ]"
out=$(WORK="$dir" WEIGHTS="$dir/weights" STUB_CLASSES="$seven" STUB_LANES="$launching" SHARD=2/2 "$HERE/run-tests.sh" -c LaunchATest -j 1 2>&1)
check "a class asked for by name runs whatever the shard" "grep -q '^RES LaunchATest 1 run' <<<\"\$out\""
rm -rf "$dir"

echo "== run-tests-test: $failures failing"
exit $(( failures > 0 ))
