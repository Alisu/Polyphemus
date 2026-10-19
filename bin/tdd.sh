#!/usr/bin/env bash
# One command for the TDD loop: working copy -> image -> tests.
#
#   bin/tdd.sh -c StackPageReificationTest -t testTopFrameIsWellFormed
#   bin/tdd.sh --fast
#   bin/tdd.sh              (fast tier, then slow tier if green)
#   PREPARE_ONLY=1 bin/tdd.sh   compile the working copy and rebuild warm.image, run nothing
#   SKIP_PREPARE=1 bin/tdd.sh   run from the images as they are (bin/gate.sh prepares first)
#
# Classes named with -c run on dev.image once compiled, building only the fixtures they use; a
# tier or the whole suite runs on warm.image, rebuilt only when the working copy changed.
#
# There is a single image on disk, shared read-only by every test process, so the
# edits are compiled once here rather than per process.
set -uo pipefail
WORK="${WORK:-$HOME/polyphemus}"
cd "$WORK"
HERE="$WORK/Polyphemus/bin"
. "$HERE/portable.sh"
# The setup's environment (its target Pharo, its core), for warm.image too: its resources may
# open the target's image, which is this edition's own, not Pharo 10's.
[ -f "$WORK/polyphemus.env" ] && { set -a; . "$WORK/polyphemus.env"; set +a; }

# A gate running here would test images this run is about to overwrite (bin/gate.sh).
held=$(cat .gate.pid 2>/dev/null || true)
if [ -z "${GATE_OWNED:-}${FORCE:-}" ] && [ -n "$held" ] && kill -0 "$held" 2>/dev/null; then
  echo "!! a gate (pid $held) is using $WORK: run on another setup, wait for it, or FORCE=1"
  exit 3
fi

# What the images are built from: every package file, the scripts that build them, the setup's
# environment. The same as when warm.image was last built: kept, its two minutes saved.
# FORCE_PREPARE=1 builds it anyway.
fingerprint=$( { ( cd "$HERE/.." && find . -path ./.git -prune -o -type f \( -path '*.package/*' \
    -o -name build-warm.st -o -name sync-from-working-copy.st \) -print | LC_ALL=C sort | xargs cksum );
  cat "$WORK/polyphemus.env" 2>/dev/null; } | cksum | awk '{print $1}')
if [ -z "${SKIP_PREPARE:-}${FORCE_PREPARE:-}" ] && [ -f warm.image ] &&
   [ "$fingerprint" = "$(cat .warm-fingerprint 2>/dev/null)" ]; then
  echo "== the working copy is as warm.image was built from: kept =="
  SKIP_PREPARE=1
fi

if [ -z "${SKIP_PREPARE:-}" ]; then
rm -f .warm-fingerprint
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

# The TDD loop, classes named with -c and no tier: they run on the image just compiled, each
# building only the fixtures it uses, rather than waiting two minutes for all of warm.image's.
only_classes=
case " $* " in *" -c "*) only_classes=yes ;; esac
case " $* " in *" --fast "*|*" --slow "*|*" --all "*) only_classes= ;; esac
if [ -n "$only_classes" ] && [ -z "${PREPARE_ONLY:-}" ]; then
  echo "== classes named: run on dev.image as just compiled, warm.image left to the next tier run =="
  export IMAGE=dev.image
else
echo "== rebuilding warm.image =="
cp -f dev.image warm.image
cp -f dev.changes warm.changes
timeout 600 ./pharo warm.image --no-default-preferences st "$HERE/build-warm.st" 2>/dev/null \
  | tr -d '\033' | grep -E 'fixture ready|WARM ERR' || true
echo "$fingerprint" > .warm-fingerprint
fi
fi
[ -n "${PREPARE_ONLY:-}" ] && exit 0

exec "$HERE/run-tests.sh" "$@"
