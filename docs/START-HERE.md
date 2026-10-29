# Start here

Polyphemus reads the memory of a Pharo virtual machine **from outside it**, from a healthy image,
and turns what it finds back into objects you can ask questions: which processes there are, what
each one's stack is, the source of each frame. Pharo's debugger opens on the result. It runs on
Pharo 10 to 14, one **edition** per Pharo (`docs/editions.md`), on Linux x64 and macOS on Apple
silicon; Windows is under way (`docs/handover-windows.md`).

It reads three kinds of thing, and holds the third:

| | What | Needs |
|---|---|---|
| an **image file** | a snapshot on disk, possibly damaged | nothing |
| a **core dump** | the memory of a VM that died, or of one we dumped | nothing: it is a file (ELF; macOS's own Mach-O cores are not read yet, #81) |
| a **running process** | a VM that is still going: read it, or hold it and debug it | the right to look into it (section 2) |

## Which page next

- To debug a running image, step it and fix it: `docs/guide.md`.
- To read an image file, a dump or a process from code: section 3.
- To ask it through an agent: section 4.
- What it does not do yet: `docs/limitations.md`.
- What changed from one version to the next: `docs/patch-notes.md`.
- To work on Polyphemus itself: section 5.

## 1. Get it

Pick the Pharo you want to use. The same load works in each: the baseline picks the edition and
the VMMaker for it.

| Pharo | VMMaker it loads | edition |
|---|---|---|
| 10 | v10.0.0 | Pharo10 |
| 11 | v10.0.5 | Pharo11 (also reads Pharo 10 images) |
| 12 | v10.3.2 | Pharo12 |
| 13 | v10.3.11 | Pharo13 |
| 14 (build 771, not released) | v12.0.5-beta | Pharo14 |

In that image, in a Playground:

```smalltalk
Metacello new
	baseline: 'Polyphemus';
	repository: 'github://Alisu/Polyphemus:v0.1.0';
	load.
```

`v0.1.0` is the version released; `stage2` instead loads the latest work, which may not be finished.
It takes several minutes: most of it is VMMaker. Then check which edition you have:

```smalltalk
PolyphemusEdition current name.   "'Polyphemus-Pharo13-Linux-x64-for-Pharo13' on Pharo 13"
```

On a Mac it answers `'Polyphemus-Pharo13-MacOS-arm64-for-Pharo13'`: the baseline loads the host
package for the system it runs on (`Polyphemus-Host-Linux-x64` or `Polyphemus-Host-MacOS-arm64`).
Each edition is also a git tag (`git diff edition/pharo13 edition/pharo14`).

## 2. The right to read a running process

Image files and dumps need nothing. A running process does, and the target always stays as
downloaded.

**On macOS**, there is nothing to build: run the observing Pharo as root (`sudo`), and macOS gives
it the task port of a stock Pharo VM, which is not hardened.

**On Linux**, build the launcher once, in the clone Iceberg made of the repository (Iceberg shows
where; under the image's `pharo-local/iceberg` by default):

```bash
cc -O2 -o bin/pharo-debuggable bin/pharo-debuggable.c
```

A target started through it can be read by a sibling process, without changing anything on the
machine (Yama's `ptrace_scope` stays as it is, normally 1). A VM already running, started without
it by anyone, is refused to you by Yama; run the observer as root (`sudo`) to read it, hold it and
debug it.

## 3. From code

The examples were run exactly as written on Pharo 13, Linux x64; the numbers in comments are what
it answered then. Where macOS differs, it is said.

### An image file

Any image file works; a copy of a fresh Pharo image of the same version is the simplest target.
The examples use `/tmp/target/target.image`, with its `.changes` and `.sources` beside it.

```smalltalk
memory := Polyphemus readImageFile: '/tmp/target/target.image'.
memory allReifiedProcesses size.                  "9"
(memory activationsOfProcess: (Polyphemus deepestProcessIn: memory)) size.   "19"
Polyphemus browse: memory.                        "every process, its stack, the source of each frame"
Polyphemus debugDeepestProcessIn: memory.         "Pharo's debugger, on the deepest stack"
```

### A running process

On Linux, start the target through the launcher, idle (on macOS, start it as you like and run the
observer as root):

```bash
POLYPHEMUS_OBSERVER=any ./bin/pharo-debuggable /path/to/pharo-vm/pharo --headless /tmp/target/target.image eval "(Delay forSeconds: 900) wait" &
```

With its pid:

```smalltalk
memory := Polyphemus readProcess: 175398.        "your pid"
memory allReifiedProcesses size.                  "16"
```

It is stopped only while it is copied, and only at a moment its VM is quiet. A busy target (in
a loop) has such moments too, when its VM polls for events between bytecodes, but if none comes
within a few seconds it is refused, saying so:

```
SpurCannotRead: cannot read bytes: itWasNeverQuietWhenStopped
```

Holding it works whatever it is doing (below).

To know where a process is stuck before touching it, from `/proc` on Linux, from its task port
on macOS:

```smalltalk
Polyphemus whereIsStuck: 175398.
```

It says where each of its threads waits: blocked in a C call, idle waiting for events, or running
in machine code. What it printed for three kinds of target is in `docs/reading-a-live-process.md`.

### A dump

```smalltalk
Polyphemus dumpProcess: 175398 to: '/tmp/target/target.core'.     "137 MB"
(Polyphemus readCoreDump: '/tmp/target/target.core') allReifiedProcesses size.   "16"
```

A core from the kernel, or from gdb, reads the same way. On macOS, as root, `dumpProcess:to:`
writes the same kind of core (ELF), which `readCoreDump:` reads; macOS's own cores are Mach-O
and are not read yet (#81).

### Hold a busy image, debug it, let it go

`docs/guide.md` walks through this step by step. In short, start a second target, busy in a loop
(on macOS, any way, the observer as root):

```bash
POLYPHEMUS_OBSERVER=any ./bin/pharo-debuggable /path/to/pharo-vm/pharo --headless /tmp/busy/target.image eval "[ true ] whileTrue: [ 100 factorial ]" &
```

A stock image carries nothing of ours, so first put a watcher into it. Then open Pharo's debugger
on what it is busy with: its buttons step that image, a method accepted there is fixed in it, and
Proceed lets it go.

```smalltalk
Polyphemus putAWatcherInto: 175431 watchedIn: '/tmp/busy/watch' asFileReference.
Polyphemus debugProcess: 175431 watchedIn: '/tmp/busy/watch' asFileReference.
```

Without the debugger, the same hold can be asked questions:

```smalltalk
session := Polyphemus holdProcess: 175431 watchedIn: '/tmp/busy/watch' asFileReference.
session heldProcess ask: '3 + 4'.                                        "'7'"
session heldProcess ask: '(self at: #process) suspendedContext printString'.
                                                  "'SmallInteger(Integer)>>factorial'"
session resume.                                   "it runs on"
```

## 4. Ask it through an agent

An MCP server answers an agent (Claude Code, or any MCP client) with the same readings, one tool
each: `open_image`, `open_core`, `open_process`, `processes`, `stack`, `inspect`, `census`,
`packages`, `where_stuck`. All read only; a running process is held still only while it is copied.
The debugger opens from Pharo, as in section 3: holding an image, stepping it and saving a fix are
done there, not through these tools (tools that act are #128).
How to start it and register it is in `docs/mcp.md`. On macOS, `open_process` and `where_stuck`
need the server run as root, as the observer does.

## 5. Working on Polyphemus

### The tests

They live in `Polyphemus-Tests` (and `Polyphemus-Tests-MemoryMap` from Pharo 11 on), and the
macOS ones in `Polyphemus-Host-MacOS-arm64`. Run them from the Test Runner, one class at a time
rather than all at once: some classes launch target images and take minutes. A good first set,
by stage:

| stage | classes |
|---|---|
| 1, image files | `SchedulerOnRealImageTest`, `ProcessStackOnRealImageTest`, `PharoImagesOopTest`, `SourceReadabilityTest`, `BlankedContextImageTest` |
| 2, dumps and processes | `LinuxProcessMemoryTest`, `SpurDumpedMemoryTest`, `StackOfADumpTest` |
| 3, live images | `LiveDebuggingTest`, `LiveSteppingTest`, `LiveEditingTest`, `WatcherInjectionTest` |
| 2 and 3 on macOS, as root | `MacProcessMemoryTest`, `MacStuckReportTest`, `MacHoldTest`, `MacMCPToolsTest` |

What to expect on a first run:
- The tests download the pinned image of each Pharo they use from files.pharo.org, once.
- The dump classes skip without a dump beside your image (`pharo.core`, or the path in
  `POLYPHEMUS_CORE`), saying so.
- The Linux live classes need `bin/pharo-debuggable` built (section 2), and skip on other systems.
  The macOS ones read another process only when the Test Runner runs as root, and otherwise skip,
  saying so.
- Some tests skip on purpose where your Pharo cannot reproduce the fixture's code, and say why.

### The classes worth knowing first

| Class | What it is |
|---|---|
| `Polyphemus` | the front door: everything above |
| `PolyphemusEdition` | which host this is, and what it reads |
| `AbstractReifiedMemory` | a memory whose objects can be asked questions |
| `OOPAbstractEntity` | one object read out of it |
| `OOPContext`, `OOPAbstractStackFrame` | an activation, as a context or as a frame |
| `ElfCoreDump`, `LinuxProcessMemory`, `MacProcessMemory` | where the bytes come from; all answer the same three messages |
| `PolyphemusMadeFor` | which system this host is, and its process reader and stuck report |
| `SpurDumpedMemory` | a dump or a process, turned into a memory the rest can read |
| `ReifiedDebugSession`, `HeldProcess` | Pharo's debugger on another image, and the image held for it |
| `SpurReadability` | how much can be read, and why not the rest |

### Where things are

`docs/` holds the longer notes: `debugging-a-snapshot.md` first, then `reading-a-dump.md`,
`reading-a-live-process.md`, `stage3-live-image.md`, `editions.md` and `patch-notes.md`.
`docs/mistakes.md` is worth a look before any long hunt.

`CLAUDE.md`, `AGENTS.md` and `bin/` (apart from `pharo-debuggable`) are this fork's working
tools, written for our Linux box. You do not need them to use Polyphemus.
