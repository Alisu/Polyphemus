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
class=$(grep -ao "RES [A-Za-z0-9]* '" "$script" | head -1 | awk '{print $2}')
echo "RES $class 1 run 0 failures 0 errors"
STUB
chmod +x "$dir/pharo"

# The workers are fresh shells: every function they call must reach them.
out=$(WORK="$dir" "$HERE/run-tests.sh" -c FakeTest -j 1 2>&1)
check "a class run in the pool reports its result" "grep -q '^RES FakeTest 1 run 0 failures 0 errors' <<<\"\$out\""
check "no class is broken by the runner itself" "! grep -q 'BROKEN' <<<\"\$out\""
rm -rf "$dir"

echo "== run-tests-test: $failures failing"
exit $(( failures > 0 ))
