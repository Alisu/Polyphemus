#!/usr/bin/env bash
# Tests of bin/ci-verdict.sh on made-up job logs, timestamps and all, against a made-up list of
# known flakes. No GitHub; a second.
#
#   bin/ci-verdict-test.sh
set -uo pipefail
VERDICT="$(cd "$(dirname "$0")" && pwd)/ci-verdict.sh"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d)
printf '%s\n' '# test | message start | issue' \
  'RingTest>>testRace | the image never took the interrupt | #137' > "$dir/known"
log() { sed 's/^/2026-11-01T12:26:06.4241060Z /' > "$dir/log"; }
verdict() { KNOWN_FLAKES="$dir/known" "$VERDICT" --log "$dir/log" > "$dir/out" 2>&1; echo $?; }

log <<'LOG'
== totals: 965 run, 0 failures, 0 errors, 0 broken, 0 flaky ==
LOG
check "a clean suite is green" "[ \$(verdict) -eq 0 ] && grep -q '^VERDICT green' $dir/out"

log <<'LOG'
    ERROR OtherTest>>testSlow -- TestTookTooMuchTime
    FLAKY OtherTest>>testSlow
== totals: 965 run, 0 failures, 0 errors, 0 broken, 1 flaky ==
LOG
check "a test that passed again alone is no failure" "[ \$(verdict) -eq 0 ] && grep -q '^VERDICT green' $dir/out"

log <<'LOG'
    ERROR RingTest>>testRace -- Error the image never took the interrupt: is it running the watcher
== totals: 965 run, 0 failures, 1 errors, 0 broken, 0 flaky ==
LOG
check "a listed flake failing twice is known" "[ \$(verdict) -eq 0 ] && grep -q '^VERDICT known' $dir/out"
check "it names the flake's issue" "grep -q 'KNOWN #137 RingTest>>testRace' $dir/out"

log <<'LOG'
    ERROR RingTest>>testRace -- KeyNotFound key #itor not found
== totals: 965 run, 0 failures, 1 errors, 0 broken, 0 flaky ==
LOG
check "a listed test failing with another message is new" "[ \$(verdict) -eq 1 ] && grep -q '^VERDICT new' $dir/out"

log <<'LOG'
    FAIL  SomeTest>>testIt -- TestFailure Assertion failed
    ERROR RingTest>>testRace -- Error the image never took the interrupt
== totals: 965 run, 1 failures, 1 errors, 0 broken, 0 flaky ==
LOG
check "an unlisted failure is new, beside a known one" "[ \$(verdict) -eq 1 ] && grep -q 'NEW SomeTest>>testIt' $dir/out"

log <<'LOG'
RES HeavyTest BROKEN no result (exit 1)
== totals: 965 run, 0 failures, 0 errors, 1 broken, 0 flaky ==
LOG
check "a broken class is new" "[ \$(verdict) -eq 1 ] && grep -q 'NEW HeavyTest BROKEN' $dir/out"

log <<'LOG'
RES HeavyTest BROKEN no result (exit 1)
    FLAKY HeavyTest
== totals: 965 run, 0 failures, 0 errors, 0 broken, 1 flaky ==
LOG
check "a broken class that ran again green is no failure" "[ \$(verdict) -eq 0 ]"

log <<'LOG'
WARM ERR target image :: Could not fetch cleanP13.image into resources: is curl there, and files.pharo.org reachable?
!! warm.image was not built from the working copy
##[error]Process completed with exit code 1.
LOG
check "no suite run is the infrastructure" "[ \$(verdict) -eq 2 ] && grep -q '^VERDICT infra' $dir/out"
check "it says what stopped it" "grep -q 'Could not fetch' $dir/out"

mkdir "$dir/bin"
printf '%s\n' '#!/bin/sh' 'echo "HTTP 403: API rate limit exceeded" >&2' 'exit 1' > "$dir/bin/gh"
chmod +x "$dir/bin/gh"
PATH="$dir/bin:$PATH" "$VERDICT" 41390051210 > "$dir/out" 2>&1; rc=$?
check "a run GitHub would not show is unread, not green" \
  "[ $rc -eq 2 ] && grep -q '^VERDICT unread' $dir/out && ! grep -q green $dir/out"

rm -rf "$dir"
echo "== ci-verdict-test: $failures failing"
exit $(( failures > 0 ))
