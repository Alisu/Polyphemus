# Handover: Polyphemus on Windows x64 (the Helios laptop)

Written 2026-09-28 on the Ubuntu box, for the agent that takes Polyphemus to Windows. Read
`AGENTS.md` first (Théo's rules), then this, then `docs/editions.md` and `docs/patch-notes.md`.

## Where we stand

- **Stages 1 to 3 are done on Linux x64.** Image files, dumps and live processes are read; a
  running image is held, stepped, inspected and edited (`CLAUDE.md`, "Current state").
- **Five editions, one per host Pharo, all on Linux x64**: Pharo 10 (VM 9), 11 (VM 10.0.5), 12
  (VM 10.3.2), 13 (VM 10.3.11), 14 (VM 12.0.5-beta, build 771, unreleased). About 660 tests
  each, green; `git diff edition/pharo13 edition/pharo14` shows what an edition changed, and
  `docs/patch-notes.md` says it in prose.
- **The box overheats** (99-114 C under load): a gate of every edition takes 45-60 min, so
  commits are gated on one or two editions and pushes on all (`CLAUDE.md`, Working agreement).
- **Open**: two intermittent live-test failures (#62, and targets that sometimes never start, on
  #31); todos #63 (re-pin Pharo 14 at its release), #64 (composed image format), #65 (exact
  mode), #53 (back in time, after every version and OS), and older ones listed with the `todo`
  label.
- **Next: operating systems.** Windows x64 first, on this laptop: same CPU as the box, so only the
  OS changes. macOS comes after, on the MacBook, inside a macOS VM, and it is arm64 (another JIT).
  Docker cannot stand in for either: a container shares the Linux kernel, and every OS-specific
  part of Polyphemus is about the kernel.

## The goal here

An edition `Polyphemus-Pharo13-Windows-x64-for-Pharo13`, its suite green on this laptop:
Pharo 13 (the latest release) on its Windows VM `PharoVM-v10.3.11+0.a585304b1-Windows-x86_64`,
with VMMaker `v10.3.11` as on the Linux Pharo 13 edition. Windows natively: **not WSL**, which is
Linux and would test Linux again.

`PolyphemusHost` already names this host `Windows` / `x64` (`currentOS`, `currentCPU`), so the
edition's name follows from `forThisHost`.

## What is Linux-only today

In Smalltalk (`Polyphemus-Object`):
- `LinuxProcessMemory`: reads another process through `/proc/<pid>/maps` and `/proc/<pid>/mem`,
  stops it with SIGSTOP, finds where its threads are through `/proc/<pid>/task/*/syscall`.
- `LinuxObservationPermission`: Yama's ptrace scope, and `bin/pharo-debuggable.c`, a launcher
  that lets a sibling read the target.
- `ElfCoreDump` and its `Elf*` classes: Linux core files. Windows has minidumps instead
  (`docs/dump-formats.md`).
- `VMVariables`: finds the VM's own variables through the ELF symbols and DWARF of
  `libPharoVMCore.so`. Whether the Windows VM (`PharoVMCore.dll`) ships symbols, and in which
  format, is not known yet.
- `SpurWritableProcess`, `HeldProcess`: write into and hold a live image, through the same memory
  protocol.

Tests that need `/proc` skip themselves where it is missing (`LiveImageTestCase>>setUp`), and
dump tests skip without a dump, so on Windows they will skip, not fail, until replaced.

The tooling in `bin/` is bash with Linux tools: `timeout`, `xargs -P`, `awk`, `pkill`,
`kill -0`, `/proc`, `setsid`, `gdb`. Only `bin/sync-from-working-copy.st`, `collect-tests.st`
and `build-warm.st` are plain Pharo scripts.

What should work unchanged: everything that reads image files (stage 1), the reification, the
debugger on image files, and the memory protocol every reader answers (`hasAddress:`,
`bytesAt:count:`, `unsignedAt:size:`, `docs/reading-a-live-process.md`), which is how a Windows
reader plugs in without anything above it knowing.

## A plan, in steps

Each step ends with something Théo can see work. Ask for the downloads of each step when you
reach it.

1. **Set up.** Git for Windows, Claude Code, a clone of `Alisu/Polyphemus` on branch `windows`
   made from `stage2` (Théo signs in). Downloads to ask for: the Pharo 13 image
   (`Pharo13.0-SNAPSHOT.build.749.sha.d7c6f761d5.arch.64bit.zip`, files.pharo.org/image/130/, the
   build the Linux edition pins) and the Windows VM above (files.pharo.org/vm/pharo-spur64-headless/
   Windows-x86_64/). Loading also clones VMMaker from GitHub.
2. **Load, and a Windows edition package.** Copy `Polyphemus-Edition-Pharo13` as the model. The
   baseline picks packages by Pharo version (`spec for: #'pharo13.x'`); whether Metacello also
   offers an OS attribute to pick a Windows edition package is **to verify** on the laptop, not
   known. If it does not, the choice needs another hook: propose it to Théo before building it.
3. **Stage 1 green on Windows.** Run the classes that read image files. That needs a way to run
   the suite: the bash runner under Git Bash, or a small runner of our own; measure both and
   propose.
4. **Dumps.** How to take a minidump of a running Pharo VM on Windows, what it holds (the heap,
   the stack pages, the VM's data segment?), and a reader for it answering the memory protocol.
   Then what `VMVariables` needs: the VM's symbols on Windows.
5. **Live processes.** `OpenProcess`, `ReadProcessMemory`, `WriteProcessMemory`, suspending
   threads and reading where they are (`GetThreadContext`), through Pharo's FFI. What rights a
   process of the same user has, without elevation, is to measure, not assume. The hold (the
   watcher's own external semaphore) and the agent should then work as on Linux.

## How the work comes back

`stage2` is the one branch every edition lives on, and nothing reaches it red on any edition.
Here: commit on `windows`, gated on the Windows suite. Before `windows` is merged into `stage2`,
the box runs every Linux edition's suite on it, since shared code changes reach them too. Push
`windows` to the fork freely; `stage2` only after both gates. Théo decides when to merge.

## Things learned the hard way on Linux

- A test that passes on its retry in the same image is not a flake until it has run alone, in
  fresh images, several times (#58, #60). The runner prints the first run's exception and where.
- Suspending a process from outside can leave it holding a lock (#59): park it instead.
- An overheating machine doubles every timing: measure CPU temperature before believing one.
- Each Pharo version renames things; look the name up where versions differ
  (`AbstractReifiedMemory class>>syntaxErrors`, `parserClass`, `PolyphemusEdition
  packageOrganizer`) rather than assuming one.
