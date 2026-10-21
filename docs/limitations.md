# What Polyphemus does not do yet, and what to do instead

Checked against the code and the issues on 2026-10-21. Each limit says what happens, why, what to
do instead, and the issue that tracks it. When one is lifted, its entry goes.

## Where it runs

- **Linux x64 and macOS on Apple silicon**, Pharo 10 to 14. Intel Macs are not supported (#82).
- **Windows x64: Pharo 13 only**, a preview: images and minidumps are read, live work is partial (#32).
- **Pharo 14 is pinned to a beta build** and its VM 12 beta; it is re-pinned when they are released
  (#63).
- **Images in the composed format** (if Pharo makes it the default) are not read (#64).
- **macOS's own core files** (Mach-O `MH_CORE`) are not read; cores Polyphemus writes are (#81).

## Installing

- **The first load takes about six minutes**, five and a half of them VMMaker, and the image does
  not answer meanwhile. Wait; it happens once per image (#30).
- **Update with Iceberg's Pull**, not by loading the baseline again: Metacello reuses the local
  clone and loads nothing new.

## Rights to look into a running Pharo

- **Linux:** the observer must be an ancestor of the process, or the process started through
  `bin/pharo-debuggable`, as Yama asks; for a VM someone else started, the observer runs as root.
- **macOS:** the observer runs as root (`sudo`). The process looked into need not.
- **An observer run as root leaves files owned by root** (the watch folder, and Iceberg's clone
  if it fetched meanwhile). Before working again as yourself:
  `sudo chown -R "$USER" <the folder>`.

## While an image is held

- **The whole image stands still**, not only the process the debugger shows: the watcher's agent
  spins at priority 70 without yielding. Its window is not redrawn until it is let go, and the
  spinning keeps a CPU core busy. A step does run the code (a label's contents change); the
  screen catches up on Proceed.
- **Processes above priority 70 still run**, the delay timer at 80 among them.
- **An image that allocates without ever pausing is sometimes not held** (the hold reads it at a
  bad moment): try again, or hold it at a method with `runUntil:` (#98).
- **If the observer itself crashes during a hold, the image stays stopped** (`SIGSTOP`). Let it go
  with `kill -CONT <pid>` (#96). An error inside Polyphemus during a hold does not do this: the
  image is let go before the error is shown.
- **The watcher is written in eden**: an image busy allocating at the exact moment it is put in
  could overwrite it. Not seen; an idle image or one waiting on its window is not exposed (#99).
- **macOS: two large copies of a held process at once can crash the observer** (Pharo 13, a full
  collection after two 1.4 GB copies). Read one copy at a time (#97).

## Stepping in the debugger

Pharo's debugger steps by simulating the process, and runs a step over a call for real, in the
process doing the stepping -- here the agent holding the image. The held process itself is kept
suspended while held and after each step, as Pharo's debugger keeps the one it debugs (#103: left
in its run queue, it ran behind the debugger, or the VM dropped it as a zombie). What remains:

- **A step over a call that waits really waits** -- `Delay>>wait`, `Semaphore>>wait`,
  `Mutex>>critical:` on a lock someone holds, a socket or file waiting for data. Meanwhile the
  image's other processes run: its window may redraw, and objects may move (the debugger reads
  the image again after each step). A wait that never ends leaves the debugger waiting with it:
  hold the image again further on with `runUntil:` instead.
- **Stepping over `fork`, `resume`, `yield` or `terminate`** acts on real processes: a forked
  process exists for real and runs once the image is let go, or during a step that waits.
- **Stepping over code with effects outside the image** (files, sockets, FFI,
  `Smalltalk snapshot:`) does them, as in any Pharo debugger.

## Saving methods

- **Kept as source only in a held image**: a method saved from the debugger of a held image keeps
  its source in that image's changes file. A method fixed in an image *file* (post mortem) is
  written without its source.
- **A change to a method's pragmas is refused**: they are kept as the image had them.
- **After Proceed, a save does nothing and says nothing**: the image was let go. Hold it again to
  change it (#107).

## Reading

- **Code without source shows as bytecodes**, not decompiled: a script's own code (a `DoIt`
  frame; Pharo 13 keeps no source for it), or a method of an image shipped without sources.
- **A frame in machine code** shows its bytecodes, not the machine code (#19), and no C frames
  under a primitive or an FFI call (#18).
- **Reading a dump and an image file in the same observer image** breaks the image side (#12).
