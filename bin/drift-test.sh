#!/usr/bin/env bash
# Tests of bin/drift.py on made-up methods. No Pharo runs; a second.
#
#   bin/drift-test.sh
set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }

WORK=$(mktemp -d)
C="$WORK/P.package/C.class/instance"
D="$WORK/P.package/D.class/instance"
T="$WORK/P-Tests.package/CTest.class/instance"
mkdir -p "$C" "$D" "$T"
printf 'a\nread\n\n\t"on: Error do: in a comment is no handler"\n\t| x |\n\tx := [ self bytes ] on: Error do: [ :e | nil ].\n\tx ifNil: [ ^ 0 ].\n\t^ x size\n' > "$C/read.st"
printf 'a\nread\n\n\t| x |\n\tx := [ self bytes ] on: Error do: [ :e | nil ].\n\tx ifNil: [ ^ 0 ].\n\t^ x size\n' > "$D/read.st"
printf 'a\nwaitForIt\n\n\t"Until it is there (#12)."\n\t[ self isThere ] whileFalse: [ (Delay forMilliseconds: 20) wait ]\n' > "$C/waitForIt.st"
printf 'a\ntestIt\n\n\tself assert: ([ 1 / 0 ] on: ZeroDivide do: [ :e | false ]) not\n' > "$T/testIt.st"
out=$(python3 "$REPO/bin/drift.py" "$WORK" --list)

code=$(sed -n '/^== code/,/^== tests/p' <<<"$out")
tests=$(sed -n '/^== tests/,$p' <<<"$out")
check "the code and the tests are counted apart"       "grep -q 'methods  *3\$' <<<\"\$code\" && grep -q 'methods  *1\$' <<<\"\$tests\""
check "a handler of every Error is counted, not one in a comment" "grep -q 'handlers of every Error  *2 ' <<<\"\$code\""
check "a handler that answers nil is counted"          "grep -q 'answer nil, false or empty  *2 ' <<<\"\$code\""
check "a narrow handler is no handler of every Error"  "grep -q 'handlers of every Error  *0 ' <<<\"\$tests\""
check "nil checks are counted"                         "grep -q 'nil checks (ifNil:, ifNotNil:)  *2 ' <<<\"\$code\""
check "a wait loop is counted and named"               "grep -q 'hand-written wait loops  *1\$' <<<\"\$code\" && grep -q 'WAIT C>>waitForIt' <<<\"\$out\""
check "a method citing an issue in its comment is counted" "grep -q 'methods citing an issue  *1 ' <<<\"\$code\""
check "a body written twice is found, comments apart"  "grep -q '1 groups, 2 methods' <<<\"\$code\" && grep -q 'COPY C>>read = D>>read' <<<\"\$out\""
rm -rf "$WORK"

echo "== drift-test: $failures failing"
[ "$failures" -eq 0 ]
