#!/usr/bin/env bash
# One command for the TDD loop: working copy -> image -> tests.
#
#   bin/tdd.sh -c StackPageReificationTest -t testTopFrameIsWellFormed
#   bin/tdd.sh --fast
#   bin/tdd.sh              (fast tier, then slow tier if green)
#   PREPARE_ONLY=1 bin/tdd.sh   compile the working copy and rebuild warm.image, run nothing
#   SKIP_PREPARE=1 bin/tdd.sh   run from the images as they are (bin/gate.sh prepares first)
#
# There is a single image on disk, shared read-only by every test process, so the
# edits are compiled once here rather than per process.
set -uo pipefail
WORK="${WORK:-$HOME/polyphemus}"
cd "$WORK"
HERE="$WORK/Polyphemus/bin"

# A gate running here would test images this run is about to overwrite (bin/gate.sh).
held=$(cat .gate.pid 2>/dev/null || true)
if [ -z "${GATE_OWNED:-}${FORCE:-}" ] && [ -n "$held" ] && kill -0 "$held" 2>/dev/null; then
  echo "!! a gate (pid $held) is using $WORK: run on another setup, wait for it, or FORCE=1"
  exit 3
fi

if [ -z "${SKIP_PREPARE:-}" ]; then
echo "== compiling working copy into dev.image =="
sync=$(timeout 600 ./pharo dev.image --no-default-preferences st "$HERE/sync-from-working-copy.st" 2>&1 | tr -d '\033')
grep -E '^SYNC|^CREATED|^REMOVED|^REDEFINED|^IVAR|^COMPILE ERR|^SKIP|^NO COMMENT|^RETAGGED' <<<"$sync"
# No summary line means the script itself failed, and the tests would run the image as it was.
if ! grep -q '^SYNC' <<<"$sync"; then
  echo "!! the working copy was not compiled; the sync script said:"
  tail -20 <<<"$sync"
  exit 1
fi

# Method comments are one to three lines (CLAUDE.md, Working agreement).
command -v python3 >/dev/null && python3 "$HERE/long-comments.py" "$HERE/.."

echo "== rebuilding warm.image =="
cp -f dev.image warm.image
cp -f dev.changes warm.changes
timeout 600 ./pharo warm.image --no-default-preferences st "$HERE/build-warm.st" 2>/dev/null \
  | tr -d '\033' | grep -E 'fixture ready|WARM ERR' || true
fi
[ -n "${PREPARE_ONLY:-}" ] && exit 0

exec "$HERE/run-tests.sh" "$@"
