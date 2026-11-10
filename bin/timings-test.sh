#!/usr/bin/env bash
# Tests of bin/timings.sh, which keeps each class's times: the worst for its time limit, the best
# for its tier. A few milliseconds, no Pharo.
#
#   bin/timings-test.sh
set -uo pipefail
. "$(cd "$(dirname "$0")" && pwd)/timings.sh"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d)

# A busy run makes a class slower: its limit grows, its tier does not move.
printf 'QuickTest 3\n' > "$dir/timings"
printf 'QuickTest 12\n' > "$dir/new"
merge_timings "$dir/timings" "$dir/new"
check "the worst time is kept, for the limit" "[ \$(worst_time_of QuickTest '$dir/timings') = 12 ]"
check "the best time is kept, for the tier" "[ \$(best_time_of QuickTest '$dir/timings') = 3 ]"
check "a class that once ran fast stays fast" "! is_slow_in '$dir/timings' QuickTest 8"

# A class recorded slow comes back to the fast tier once it runs fast.
printf 'DriftedTest 15\n' > "$dir/timings"
check "a class only seen slow is slow" "is_slow_in '$dir/timings' DriftedTest 8"
printf 'DriftedTest 4\n' > "$dir/new"
merge_timings "$dir/timings" "$dir/new"
check "it is fast again once it ran fast" "! is_slow_in '$dir/timings' DriftedTest 8"
check "its limit still knows the worst" "[ \$(worst_time_of DriftedTest '$dir/timings') = 15 ]"

# A class never run is not slow, and has no time.
check "a class never timed is not slow" "! is_slow_in '$dir/timings' NewTest 8"
check "a class never timed has no worst time" "[ -z \"\$(worst_time_of NewTest '$dir/timings')\" ]"
# A worst time from a busy day falls out after five runs (#164): it set the limit for good.
printf 'SlowTest 1059 143\n' > "$dir/timings"
for t in 150 160 150 155 150; do printf 'SlowTest %s\n' "$t" > "$dir/new"; merge_timings "$dir/timings" "$dir/new"; done
check "the limit comes from the last five runs" "[ \$(worst_time_of SlowTest '$dir/timings') = 160 ]"
check "so does the tier" "[ \$(best_time_of SlowTest '$dir/timings') = 150 ]"
printf 'SlowTest 400\n' > "$dir/new"; merge_timings "$dir/timings" "$dir/new"
check "a slow run among them still sets the limit" "[ \$(worst_time_of SlowTest '$dir/timings') = 400 ]"

# A class the suite no longer has goes from the timings, which the lanes are balanced on.
printf 'GoneTest 1883\nKeptTest 5\n' > "$dir/timings"
prune_timings "$dir/timings" KeptTest OtherTest
check "a class no longer in the suite is dropped" "! grep -q GoneTest '$dir/timings'"
check "a class still in it is kept" "[ \$(worst_time_of KeptTest '$dir/timings') = 5 ]"
rm -rf "$dir"

echo "== timings-test: $failures failing"
exit $(( failures > 0 ))
