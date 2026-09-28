# Start here

Polyphemus reads the memory of a Pharo virtual machine **from outside it**, from a healthy image,
and turns what it finds back into objects you can ask questions: which processes there are, what
each one's stack is, the source of each frame. Pharo's debugger opens on the result.

It reads three kinds of thing, and holds the third:

| | What | Needs |
|---|---|---|
| an **image file** | a snapshot on disk, possibly damaged | nothing |
| a **core dump** | the memory of a VM that died, or of one we dumped | nothing: it is a file |
| a **running process** | a VM that is still going: read it, or hold it and debug it | Linux, and the target started with `bin/pharo-debuggable` |

## What changed since stage 2

Since the `stage2` you may remember: stages 1 to 3 are done, and Polyphemus runs on Pharo 10 to
14, one **edition** per Pharo (`docs/editions.md`). There is no need to read the diff: what each
version changed is written in `docs/patch-notes.md`, and each edition is a git tag
(`git diff edition/pharo13 edition/pharo14`). Everything below was run exactly as written on
2026-09-28 (Pharo 13, Linux x64); the numbers are what it answered then.

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
	repository: 'github://Alisu/Polyphemus:stage2';
	load.
```

It takes several minutes: most of it is VMMaker. Then check which edition you have:

```smalltalk
PolyphemusEdition current name.   "'Polyphemus-Pharo13-Linux-x64-for-Pharo13' on Pharo 13"
```

For the running-process steps, build the launcher once, in the clone Iceberg made of the
repository (Iceberg shows where; under the image's `pharo-local/iceberg` by default):

```bash
cc -O2 -o bin/pharo-debuggable bin/pharo-debuggable.c
```

It lets a sibling process read the target without changing anything on the machine (Yama's
`ptrace_scope` stays as it is, normally 1).

## 2. An image file

Any image file works; a copy of a fresh Pharo image of the same version is the simplest target.
The examples use `/tmp/target/target.image`, with its `.changes` and `.sources` beside it.

```smalltalk
memory := Polyphemus readImageFile: '/tmp/target/target.image'.
memory allReifiedProcesses size.                  "9"
(memory activationsOfProcess: (Polyphemus deepestProcessIn: memory)) size.   "19"
Polyphemus browse: memory.                        "every process, its stack, the source of each frame"
Polyphemus debugDeepestProcessIn: memory.         "Pharo's debugger, on the deepest stack"
```

## 3. A running process

Start the target through the launcher, idle:

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

Holding it works whatever it is doing (step 5).

## 4. A dump

```smalltalk
Polyphemus dumpProcess: 175398 to: '/tmp/target/target.core'.     "137 MB"
(Polyphemus readCoreDump: '/tmp/target/target.core') allReifiedProcesses size.   "16"
```

A core from the kernel, or from gdb, reads the same way.

## 5. Hold a busy image, debug it, let it go

Start a second target, busy in a loop:

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

## 6. The tests

About 660 tests per edition (663 on 2026-09-28, all green on every edition). They live in
`Polyphemus-Tests` (and `Polyphemus-Tests-MemoryMap` from Pharo 11 on). Run them from the Test
Runner, one class at a time rather than all at once: some classes launch target images and take
minutes. A good first set, by stage:

| stage | classes |
|---|---|
| 1, image files | `SchedulerOnRealImageTest`, `ProcessStackOnRealImageTest`, `PharoImagesOopTest`, `SourceReadabilityTest`, `BlankedContextImageTest` |
| 2, dumps and processes | `LinuxProcessMemoryTest`, `SpurDumpedMemoryTest`, `StackOfADumpTest` |
| 3, live images | `LiveDebuggingTest`, `LiveSteppingTest`, `LiveEditingTest`, `WatcherInjectionTest` |

What to expect on a first run:
- The tests download the pinned image of each Pharo they use from files.pharo.org, once.
- The dump classes skip without a dump beside your image (`pharo.core`, or the path in
  `POLYPHEMUS_CORE`), saying so.
- The live classes need `bin/pharo-debuggable` built (section 1), and skip on other systems.
- Some tests skip on purpose where your Pharo cannot reproduce the fixture's code, and say why.

## The classes worth knowing first

| Class | What it is |
|---|---|
| `Polyphemus` | the front door: everything above |
| `PolyphemusEdition` | which host this is, and what it reads |
| `AbstractReifiedMemory` | a memory whose objects can be asked questions |
| `OOPAbstractEntity` | one object read out of it |
| `OOPContext`, `OOPAbstractStackFrame` | an activation, as a context or as a frame |
| `ElfCoreDump`, `LinuxProcessMemory` | where the bytes come from; both answer the same three messages |
| `SpurDumpedMemory` | a dump or a process, turned into a memory the rest can read |
| `ReifiedDebugSession`, `HeldProcess` | Pharo's debugger on another image, and the image held for it |
| `SpurReadability` | how much can be read, and why not the rest |

## Where things are

`docs/` holds the longer notes: `debugging-a-snapshot.md` first, then `reading-a-dump.md`,
`reading-a-live-process.md`, `stage3-live-image.md`, `editions.md` and `patch-notes.md`.
`docs/mistakes.md` is worth a look before any long hunt.

`CLAUDE.md`, `AGENTS.md` and `bin/` (apart from `pharo-debuggable`) are this fork's working
tools, written for our Linux box. You do not need them to use Polyphemus.
