#!/usr/bin/env bash
# One command for the TDD loop: working copy -> image -> tests.
#
#   bin/tdd.sh -c StackPageReificationTest -t testTopFrameIsWellFormed
#   bin/tdd.sh --fast
#   bin/tdd.sh              (fast tier, then slow tier if green)
#
# There is a single image on disk, shared read-only by every test process, so the
# edits are compiled once here rather than per process.
set -uo pipefail
WORK="${WORK:-$HOME/polyphemus}"
cd "$WORK"
HERE="$WORK/Polyphemus/bin"

echo "== compiling working copy into dev.image =="
timeout 600 ./pharo dev.image st "$HERE/sync-from-working-copy.st" 2>/dev/null \
  | tr -d '\033' | grep -E '^SYNC|^CREATED|^REMOVED|^COMPILE ERR|^SKIP' || true

echo "== rebuilding warm.image =="
cp -f dev.image warm.image
cp -f dev.changes warm.changes
timeout 600 ./pharo warm.image st "$HERE/build-warm.st" 2>/dev/null \
  | tr -d '\033' | grep -E 'fixture ready|WARM ERR' || true

exec "$HERE/run-tests.sh" "$@"
