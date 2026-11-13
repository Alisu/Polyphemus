#!/usr/bin/env bash
# Tests of bin/tdd.sh's preparing, on a made-up setup whose pharo only says what the real sync
# and warm build say. No Pharo runs; a few seconds.
#
#   bin/tdd-test.sh
set -uo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }

setup() {  # a made-up WORK: this repository, a dev.image, and a pharo that answers as told
  WORK=$(mktemp -d)
  ln -s "$REPO" "$WORK/Polyphemus"
  touch "$WORK/dev.image" "$WORK/dev.changes"
  cat > "$WORK/pharo" <<'STUB'
#!/usr/bin/env bash
case "$*" in
  *sync-from-working-copy*)
    [ -n "${STUB_COMPILE_ERR:-}" ] && echo "COMPILE ERR foo.st :: Variable or expression expected"
    [ -n "${STUB_SYNC_ERR:-}" ] && echo "SYNC ERR extensions of Polyphemus-Object :: it broke"
    echo "SYNC 0 classes created, 0 methods compiled, 0 removed" ;;
  *build-warm*)
    if [ -n "${STUB_WARM_FAILS:-}" ]; then echo "WARM ERR fixture :: it broke"; exit 1; fi
    echo "fixture ready" ;;
esac
STUB
  chmod +x "$WORK/pharo"
}

# A warm image whose build failed is not marked as built from this working copy.
setup
WORK="$WORK" PREPARE_ONLY=1 STUB_WARM_FAILS=1 "$REPO/bin/tdd.sh" > "$WORK/out" 2>&1
rc=$?
check "a failed warm build fails" "[ $rc -ne 0 ]"
check "a failed warm build is not kept as current" "[ ! -f $WORK/.warm-fingerprint ]"
rm -rf "$WORK"

# One that built is.
setup
WORK="$WORK" PREPARE_ONLY=1 "$REPO/bin/tdd.sh" > "$WORK/out" 2>&1
rc=$?
check "a warm build passes" "[ $rc -eq 0 ]"
check "a warm build is kept as current" "[ -f $WORK/.warm-fingerprint ]"
rm -rf "$WORK"

# A method that does not compile stops the loop: the image would run its earlier version (#178).
setup
WORK="$WORK" PREPARE_ONLY=1 STUB_COMPILE_ERR=1 "$REPO/bin/tdd.sh" > "$WORK/out" 2>&1
rc=$?
check "a method that does not compile fails the preparing" "[ $rc -ne 0 ]"
check "it says which" "grep -q 'COMPILE ERR foo.st' $WORK/out"
check "no warm image is built on it" "[ ! -f $WORK/.warm-fingerprint ]"
rm -rf "$WORK"

setup
WORK="$WORK" STUB_COMPILE_ERR=1 "$REPO/bin/tdd.sh" -c FooTest > "$WORK/out" 2>&1
rc=$?
check "nor do named classes run on it" "[ $rc -ne 0 ] && ! grep -q '== selected' $WORK/out"
rm -rf "$WORK"

# Nor does a sync that could not drop what the working copy no longer has.
setup
WORK="$WORK" PREPARE_ONLY=1 STUB_SYNC_ERR=1 "$REPO/bin/tdd.sh" > "$WORK/out" 2>&1
rc=$?
check "a sync error fails the preparing" "[ $rc -ne 0 ]"
rm -rf "$WORK"

echo "== tdd-test: $failures failing"
exit $(( failures > 0 ))
