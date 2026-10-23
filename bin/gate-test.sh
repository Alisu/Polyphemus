#!/usr/bin/env bash
# Tests of bin/gate.sh, on a made-up setup tree: two editions (10 at $ROOT, 13 at $ROOT/pharo13)
# whose tdd.sh only says what it was asked and when. No Pharo runs; a few seconds.
#
#   bin/gate-test.sh
set -uo pipefail
GATE="$(cd "$(dirname "$0")" && pwd)/gate.sh"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }

tree() {  # a fresh made-up ROOT, its stub tdd.sh logging to $ROOT/calls
  ROOT=$(mktemp -d)
  mkdir -p "$ROOT/Polyphemus/bin" "$ROOT/pharo13"
  git -C "$ROOT/Polyphemus" init -q && git -C "$ROOT/Polyphemus" -c user.name=gate-test -c user.email=gate-test@invalid commit -q --allow-empty -m start
  cat > "$ROOT/Polyphemus/bin/tdd.sh" <<'STUB'
#!/usr/bin/env bash
[ -n "${PREPARE_ONLY:-}" ] && { [ -n "${STUB_NO_COMMENT:-}" ] && echo "NO COMMENT Foo.class -- a Metacello load will fail on it"; exit 0; }
echo "$(basename "$WORK") start $(date +%s.%N) $*" >> "$(dirname "$0")/../../calls"
sleep 1
echo "$(basename "$WORK") end $(date +%s.%N)" >> "$(dirname "$0")/../../calls"
echo "== totals: 1 run, 0 failures, 0 errors, 0 broken, 0 flaky =="
STUB
  printf '#!/usr/bin/env bash\nexit 0\n' > "$ROOT/Polyphemus/bin/commit-selection.sh"
  chmod +x "$ROOT/Polyphemus/bin/"*.sh
  ln -s "$ROOT/Polyphemus" "$ROOT/pharo13/Polyphemus"
  touch "$ROOT/dev.image" "$ROOT/pharo13/dev.image"
}
calls() { grep " start " "$ROOT/calls" | grep "^$1 "; }

# The slow classes named, not looked for: each edition runs the fast tier, then those classes.
tree
ROOT="$ROOT" JOBS=2 "$GATE" --commit --classes "AlphaTest BetaTest" 13 10 > "$ROOT/out" 2>&1
rc=$?
check "--classes: the gate passes" "[ $rc -eq 0 ]"
check "--classes: Pharo 13 runs the named classes" "calls pharo13 | grep -q -- '-c AlphaTest -c BetaTest'"
check "--classes: Pharo 10 runs the named classes" "calls ${ROOT##*/} | grep -q -- '-c AlphaTest -c BetaTest'"
check "--classes: both run the fast tier" "[ \$(grep -c ' start .*--fast' $ROOT/calls) -eq 2 ]"

# The editions side by side: Pharo 10 starts before Pharo 13 is done.
first13=$(grep "^pharo13 start" "$ROOT/calls" | head -1 | awk '{print $3}')
last13=$(grep "^pharo13 end" "$ROOT/calls" | tail -1 | awk '{print $3}')
first10=$(grep "^${ROOT##*/} start" "$ROOT/calls" | head -1 | awk '{print $3}')
check "the editions run side by side" "awk -v a=$first10 -v b=$last13 -v c=$first13 'BEGIN { exit !(a < b && c < b) }'"

# Jobs per edition: JOBS_10 for Pharo 10, JOBS for the others.
rm -rf "$ROOT"; tree
ROOT="$ROOT" JOBS=2 JOBS_10=1 "$GATE" --commit --classes "AlphaTest" 13 10 > "$ROOT/out" 2>&1
check "JOBS_10: Pharo 10 runs one job" "calls ${ROOT##*/} | grep -q -- '-j 1'"
check "JOBS: Pharo 13 runs two" "calls pharo13 | grep -q -- '-j 2'"
rm -rf "$ROOT"

# A class without its comment loads here but not through Metacello: the gate is red.
tree
ROOT="$ROOT" JOBS=2 STUB_NO_COMMENT=1 "$GATE" --commit --classes "AlphaTest" 13 > "$ROOT/out" 2>&1
rc=$?
check "a class without its comment makes the gate red" "[ $rc -ne 0 ] && grep -q 'NO COMMENT Foo.class' $ROOT/out"
rm -rf "$ROOT"

echo "== gate-test: $failures failing"
exit $(( failures > 0 ))
