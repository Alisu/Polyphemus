#!/usr/bin/env bash
# Tests of bin/commit-selection.sh, on a made-up repository holding a copy of it and changes of
# each kind. No Pharo runs; a second.
#
#   bin/commit-selection-test.sh
set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }

WORK=$(mktemp -d)
mkdir -p "$WORK/bin" "$WORK/P.package/Plain.class/instance" "$WORK/P.package/Shared.trait/instance" \
  "$WORK/P.package/Plain.class/class" "$WORK/P.package/Object.extension/instance"
cp "$REPO/bin/commit-selection.sh" "$WORK/bin/"
echo Plain > "$WORK/bin/core-classes"
for f in Plain.class/instance/read..st Plain.class/class/on..st Shared.trait/instance/size.st \
         Object.extension/instance/isOurs.st Plain.class/properties.json; do
  echo old > "$WORK/P.package/$f"
done
git -C "$WORK" init -q && git -C "$WORK" add -A && git -C "$WORK" -c user.name=t -c user.email=t@t commit -qm base
for f in Plain.class/instance/read..st Plain.class/class/on..st Shared.trait/instance/size.st \
         Object.extension/instance/isOurs.st Plain.class/properties.json; do
  echo new > "$WORK/P.package/$f"
done
out=$("$WORK/bin/commit-selection.sh")

check "a class's method is listed"        "grep -qx 'CHANGE Plain read:' <<<\"\$out\""
check "a class-side method is listed"     "grep -qx 'CHANGE Plain on:' <<<\"\$out\""
check "a trait's method is listed"        "grep -qx 'CHANGE Shared size' <<<\"\$out\""
check "an extension method is listed"     "grep -qx 'CHANGE Object isOurs' <<<\"\$out\""
check "a class's definition is listed"    "grep -qx 'CHANGE Plain' <<<\"\$out\""
check "a core class is said to be one"    "grep -qx 'CORE Plain' <<<\"\$out\""
rm -rf "$WORK"

echo "== commit-selection-test: $failures failing"
exit $(( failures > 0 ))
