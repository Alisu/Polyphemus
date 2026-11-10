#!/usr/bin/env bash
# Tests of bin/already-judged.sh, with gh and the verdict stood in for. No network.
#
#   bin/already-judged-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d); mkdir -p "$dir/bin"

# gh answers the runs of the commit asked for: GH_RUNS, as "id branch" lines.
cat > "$dir/bin/gh" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "${GH_RUNS:-}" | awk 'NF == 2 && $2 ~ /^ci\// { print $1 }'
STUB
# The verdict of each run: VERDICT_OF_<id>.
cat > "$dir/verdict" <<'STUB'
#!/usr/bin/env bash
v="VERDICT_OF_$1"; echo "VERDICT ${!v:-new: look at it}"
STUB
chmod +x "$dir/bin/gh" "$dir/verdict"
judge() { PATH="$dir/bin:$PATH" VERDICT="$dir/verdict" GITHUB_REPOSITORY=o/r "$HERE/already-judged.sh" abc123 2>&1; }

out=$(GH_RUNS=$'11 ci/topic' VERDICT_OF_11="green or known: fast-forward stage2" judge)
check "a ci/ run judged green or known lets stage2 skip its suite" "grep -qx 'skip=true' <<<\"\$out\" && grep -qx 'run=11' <<<\"\$out\""

out=$(GH_RUNS=$'11 ci/topic' VERDICT_OF_11="new: look at it" judge)
check "one judged new does not" "grep -qx 'skip=false' <<<\"\$out\""

out=$(GH_RUNS=$'12 stage2' VERDICT_OF_12="green or known: fast-forward stage2" judge)
check "stage2's own run is no ci/ run" "grep -qx 'skip=false' <<<\"\$out\""

out=$(GH_RUNS=$'11 ci/a\n13 ci/b' VERDICT_OF_13="green or known: fast-forward stage2" judge)
check "any of the commit's ci/ runs will do" "grep -qx 'run=13' <<<\"\$out\""

out=$(GH_RUNS="" judge)
check "a commit no ci/ branch ran is run" "grep -qx 'skip=false' <<<\"\$out\""

rm -rf "$dir"
echo "== already-judged-test: $failures failing"
[ "$failures" = 0 ]
