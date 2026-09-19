# Start here

Polyphemus reads the memory of a Pharo virtual machine **from outside it**, from a healthy image,
and turns what it finds back into objects you can ask questions: which processes there are, what
each one's stack is, the source of each frame. The Pharo debugger opens on the result.

It reads three kinds of thing:

| | What | Needs |
|---|---|---|
| an **image file** | a snapshot on disk, possibly damaged | nothing |
| a **core dump** | the memory of a VM that died | nothing -- it is a file |
| a **running process** | a VM that is still going | Linux, and permission (below) |

## Get it

In a **Pharo 10** image:

```smalltalk
Metacello new
	baseline: 'Polyphemus';
	repository: 'github://Alisu/Polyphemus:stage2';
	load.
```

It takes a few minutes: VMMaker comes with it, pinned to `v10.0.0`.

Pharo 11 loads and runs it too, with one difference: the line a frame is on is not highlighted,
because that is rebuilt by recompiling in the host and a different compiler never reproduces the
same bytecodes. Those tests skip and say so.

## Try it

```smalltalk
memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
memory allReifiedProcesses.          "every process, not only the scheduled ones"
Polyphemus browse: memory.           "processes, their stacks, the source of each frame"
Polyphemus debugDeepestProcessIn: memory.
```

Candle is a tiny image that ships with the repository. Any `.image` path works the same way.

The other two sources answer exactly the same questions:

```smalltalk
Polyphemus readCoreDump: '/path/to/pharo.core'.
Polyphemus readProcess: 4321.
```

A core comes from the kernel when a VM crashes, or from `bin/take-dump.sh`. Reading a process
that is still running needs its consent on most Linux machines: start it with
`bin/pharo-debuggable` (see `docs/reading-a-live-process.md`).

## The classes worth knowing first

| Class | What it is |
|---|---|
| `Polyphemus` | the front door: everything above |
| `AbstractReifiedMemory` | a memory whose objects can be asked questions |
| `OOPAbstractEntity` | one object read out of it |
| `OOPContext`, `OOPAbstractStackFrame` | an activation, as a context or as a frame |
| `ElfCoreDump`, `LinuxProcessMemory` | where the bytes come from -- both answer the same three messages |
| `SpurHeapScanner` | finds a heap in raw bytes by its shape |
| `SpurDumpedMemory` | a dump or a process, turned into a memory the rest can read |
| `SpurReadability` | how much can honestly be read, and why not the rest |

## Where things are

- **Stage 1** -- image files -- is the tag `stage1-done`.
- **Stage 2** -- dumps and running processes -- is the branch `stage2`, which you just loaded.
- **Stage 3** -- stopping a live image at a safepoint -- has not been started.

`docs/` holds the longer notes: `debugging-a-snapshot.md` first, then `reading-a-dump.md` and
`reading-a-live-process.md`. `docs/mistakes.md` is worth a look before any long hunt.

`CLAUDE.md` and `bin/` are this fork's working tools, written for a Linux box. You do not need
them to use Polyphemus, and they are not part of it.
