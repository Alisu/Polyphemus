#!/usr/bin/env bash
# Tests of bin/long-comments.py on made-up methods. No Pharo runs; a second.
#
#   bin/long-comments-test.sh
set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }

WORK=$(mktemp -d)
M="$WORK/P.package/C.class/instance"
mkdir -p "$M"
printf 'a\nleading\n\n\t"one\n\ttwo\n\tthree\n\tfour"\n\t^ 1\n' > "$M/leading.st"
printf 'a\ninner\n\n\t"short"\n\t| x |\n\t"one\n\ttwo\n\tthree\n\tfour"\n\tx := 1.\n\t^ x\n' > "$M/inner.st"
printf 'a\nquoted\n\n\t"short"\n\t^ '"'"'a "string\n\tthat\n\tspans\n\tlines" here'"'"' , $" asString , '"'"'"'"'"'\n' > "$M/quoted.st"
printf 'a\ndoubled\n\n\t"it says ""one\n\ttwo"" and stops"\n\t^ 1\n' > "$M/doubled.st"
out=$(python3 "$REPO/bin/long-comments.py" "$WORK")
rc=$?

check "a long leading comment is reported"            "grep -q 'C.class/instance/leading.st (4 lines)' <<<\"\$out\""
check "a long comment inside a method is reported"     "grep -q 'C.class/instance/inner.st (4 lines)' <<<\"\$out\""
check "quotes in a string or \$\" are no comment"      "! grep -q quoted.st <<<\"\$out\""
check "a doubled quote stays inside its comment"       "! grep -q doubled.st <<<\"\$out\""
check "it fails when it reports"                       "[ $rc -ne 0 ]"
rm -f "$M/leading.st" "$M/inner.st"
python3 "$REPO/bin/long-comments.py" "$WORK" >/dev/null
check "it passes when it reports nothing"              "[ $? -eq 0 ]"
rm -rf "$WORK"

echo "== long-comments-test: $failures failing"
exit $(( failures > 0 ))
