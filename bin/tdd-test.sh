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
  *sync-from-working-copy*) echo "SYNC 0 classes created, 0 methods compiled, 0 removed" ;;
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

echo "== tdd-test: $failures failing"
exit $(( failures > 0 ))
