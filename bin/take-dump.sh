#!/usr/bin/env bash
# Take a core dump of a running Pharo VM, for stage 2 to read.
#
#   bin/take-dump.sh [output] [image]
#
# Yama's ptrace_scope is 1 on this box: a process may only be traced by an ancestor,
# so `gdb -p <pid>` is refused and gdb has to *start* the VM itself.
#
# Two things that cost an afternoon each:
#   - LD_LIBRARY_PATH is set for the INFERIOR, never for gdb. Point gdb itself at the
#     VM's bundled libraries and it loads them and dies on a libcurl symbol.
#   - The breakpoint is pending: the symbol lives in a library not yet loaded when gdb
#     reads this, so `set breakpoint pending on` is required or the run never stops.
#
# Do not write the dump to /tmp -- a reboot clears it, and rebuilding one is minutes.
set -euo pipefail
WORK="${WORK:-$HOME/polyphemus}"
OUT="${1:-$WORK/pharo.core}"
IMAGE="${2:-$WORK/dev.image}"
VM="$WORK/pharo-vm"

cd "$WORK"
[ -f "$WORK/idle.st" ] || { echo "need $WORK/idle.st (a script that just waits)"; exit 1; }

echo "== taking a dump of $IMAGE into $OUT =="
gdb --batch \
    -ex "set breakpoint pending on" \
    -ex "set environment LD_LIBRARY_PATH $VM/lib" \
    -ex "break ioRelinquishProcessorForMicroseconds" \
    -ex run \
    -ex "gcore $OUT" \
    -ex kill \
    --args "$VM/lib/pharo" --headless "$IMAGE" st "$WORK/idle.st" 2>&1 \
  | grep -vE "^\[|^warning: |Thread debugging|^$" | tail -20

ls -lh "$OUT"
