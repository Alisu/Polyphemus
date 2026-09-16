# Opening the debugger on someone else's image

How to get a Pharo debugger onto a process that lives in an image **file**, from a healthy
image. Everything here runs in the host image; nothing runs in the file.

## Open the image as a snapshot

```smalltalk
| test memory |
test := SchedulerOnRealImageTest new.
test imagePath: PharoImageAccessor pathToPharo10.
test setUpForResourceMarrying: false.   "false: read it, do not start it"
memory := test instVarNamed: 'reifiedMemory'.
```

`setUpForResourceMarrying: false` is the whole difference between reading an image and
booting one. With `true` the VM startup runs and marries the running process' context to a
frame, and that process' stack then looks one frame deep instead of three. See
`docs/image-facts.md`.

In tests, use `Pharo10SnapshotResource` / `CandleSnapshotResource`, which answer false.

## Find a process

```smalltalk
memory allReifiedProcesses.            "every process, not just the queued ones"
memory processStates.                  "process -> #active | #runnable | #waiting | #suspended"
memory processInconsistencies.         "queues that a working VM could not have written"
memory contextInconsistencies.         "stacks likewise"
```

The scheduler only knows the queued ones: in the pinned Pharo 10 image that is 3 processes
out of 8. `allReifiedProcesses` scans the heap for instances of the process class.

## Look at a stack without a debugger

```smalltalk
| process |
process := memory allReifiedProcesses
	detectMax: [ :each | (memory contextsOfProcess: each) size ].

memory stackDescriptionOfProcess: process.        "'SessionManager>>snapshot:andQuit:' ..."
memory sourceOfContext: (memory contextsOfProcess: process) first.
memory disassemblyOfContext: (memory contextsOfProcess: process) first.
```

`SnapshotProcessBrowser on: memory` opens all three panes at once: processes, frames, source.

## Open the debugger

```smalltalk
| context exception session |
context := (memory contextsOfProcess: process) first.

exception := (OupsNullException fromSignallerContext: context)
	             messageText: 'Snapshot of a Pharo 10 image';
	             yourself.

session := DebugSession named: 'snapshot' on: nil startedAt: context.
session exception: exception.

StDebugger openOn: session withFullView: true
```

`on: nil` is what makes it post-mortem: there is no process to resume, and the title says so.

## What works, and what a snapshot cannot answer

Works: the stack, each frame's class and method, the source read from the image's own
`.sources`, the receiver and its instance variables in the inspector, variables resolving in
the source pane, and the arguments and temporaries of each frame, by name and by value.

```smalltalk
context tempNames.              "#(#isImageStarting #save #quit #wait)"
context tempNamed: 'wait'.      "the Semaphore of that image"
```

Names are not in the file. A context holds values in order and nothing else, so the names
come from parsing the method's source and analysing it against the class it came from — the
front half of this image's compiler, used on the other image's code. Only the front half:
code generated here is **not** the code in the file, so nothing is generated.

Three things follow, and they are the parts worth knowing:

- **A frame without source names nothing.** No source, no names. It never falls back to a
  decompilation, whose `arg1` and `tmp1` are inventions of this image.
- **A captured temporary lives in a vector**, not in the frame, and its index counts inside
  that vector. Reading it as an ordinary temporary answers whatever else sits at that position.
- **A name is read in the frame that *holds* it, which is not always the one that declares
  it.** A block sees its method's temporaries, and there are three ways it can get at one: it
  carries a copy, it holds a copy of the vector the variable lives in, or it has to read it
  where it lives. Which one is the compiler's decision and nothing in the file records it, so
  each frame resolves the name itself and the first that actually holds what it resolved
  answers. Seeing is not enough: an index means something only in the frame whose scope
  declared it.

  Getting this wrong is quiet. `SessionManager>>snapshot:andQuit: [block]` lists
  `isImageStarting` among its names — the method declares it, the block reads it — and the
  frame that holds its vector is the block, because the block was forked into another process
  and given a copy.

Reading a value that cannot be read raises instead of answering nil, because nil is a value a
temporary genuinely holds; the inspector shows `cannot read <name>`.

Everything resolves **in the image being read**, never in ours: instance variables from the
receiver's class there, class variables from the class that declares them there, and globals
from that image's own `SystemDictionary`, reachable at special objects slot 9 —
`memory globalNamed: 'Process'`. Falling back to our globals would bind a name to a class of
this image that merely shares a name with the one in the file.

A name that image does not have comes back as an *undeclared* variable rather than as nil.
Both show as unknown, but nil makes the compiler write the name into **our** `Undeclared`
dictionary: reading somebody else's image left eleven names behind in ours, saved with the
image, still there the next run.

Does not, and does not pretend to:

- **Stepping, restarting, evaluating.** The toolbar buttons are there because it is the real
  debugger, but there is no process behind them.

## The line a frame is on

```smalltalk
context pcRangeContextIsActive: false.   "(262 to: 281) -- an interval into the source"
context sourceNodeExecuted.              "the same place, as a syntax tree node"
```

A snapshot carries no map from a pc to a place in the source. This one is built by **compiling
the method's own source here** — against the class it came from, with sources embedded so the
tree belongs to the real text — and then **comparing the bytecodes with the ones in the file**.
The map is used only where they are the same code. Where they are not, the interval is empty
and nothing is highlighted: a highlight over the wrong line is not a near miss, because the
reader has no way of telling.

45 of the 47 frames of the pinned image highlight, blocks included. The frame on top of the
stack has its pc on the instruction about to run; every frame below it has already moved past
the send it is waiting on, so theirs is read one bytecode back — Pharo's own rule.

Two things had to be right for blocks. A block's code lives in a compiled block of its own, so
the block running has to be matched to the block compiled here, by order and then by its
bytecodes. And those bytecodes have to be read with `bytecodeAt:`: `at:` answers the nth raw
byte for a block, which matches nothing and costs every block frame its highlight without ever
showing a wrong one.

## When the image is actually damaged

```smalltalk
memory processInconsistencies.   "process -> #suspendedContextIsUnreadable, ..."
memory processStates.            "the damaged one is #unknown, the rest still say where they are"
memory contextsOfProcess: p.     "empty for a process whose pointer is gone, never invented"
```

A slot of a damaged image can hold something that is not an object at all. Reifying it does not
answer a broken object, it raises, from a long way down: the word is taken for an address, its
header for a class index, and it surfaces as a key missing from a dictionary. Every walk over an
image we did not write reads slots through `readSlot:of:ifUnreadable:` so that the unreadable
case is a **line in the report** instead — the report is the answer, and it has to cover the
whole image rather than stop at the first bad word.

`BlankedContextImageTest` reads a copy of the pinned image with the running process' stack
pointer blanked in the **file**, by something that is not the reader, and never repaired.

## Known wart

The variables pane lists `address` and `memory` as instance variables of the receiver. Those
are the reifier's own, not the receiver's in the image being read. The names, the source and
the temporaries all resolve over there; this one list still comes from here.

## Why the debugger needs help at all

It asks a context for a long protocol. `OOPContext` answers it from slots, and three small
patches make the rest work, all fork-only:

- `DebugSession>>isContextPostMortem:` and `>>isLatestContext:` ask the interrupted process,
  which a snapshot session does not have.
- `StDebuggerContextInteractionModel>>behavior` asks the receiver for its class, which for us
  is `OOPRegularObject` in this image. It has to be the receiver's class **in the image being
  read**, or nothing in the source resolves and every variable shows as unknown.

These patch Pharo classes, so they stay in the fork.

## Opening the tools on a dump or a live process

Stage one's presenters take what they always took -- a reified memory, or the interpreter it was
built into -- so nothing about them had to change. A dump is handed to them the same way an image
file is.

```smalltalk
"from a core file"
dumped := SpurDumpedMemory on: (ElfCoreDump on: '/home/you/pharo.core' asFileReference).

"or from a process that is still running, held still while it is read"
reader := LinuxProcessMemory on: 4321.
reader stop.
dumped := SpurDumpedMemory on: reader.

reified := dumped reifyEverything: dumped reifiedMemory.
```

Then any of the three:

```smalltalk
"the read only browser: every process, and its stack"
(SnapshotProcessBrowser on: reified) open.

"the memory inspector, which opens on the interpreter rather than the memory"
(MemoryInspector newOn: dumped interpreter) open.

"the real debugger, post mortem, on one process's stack.
 Choosing the process is not incidental: the one that was *running* has no contexts to
 give, because at the moment of the dump its stack was frames. So take one that was not
 running, and prefer a deep one -- most are a single context waiting on a semaphore."
process := reified allReifiedProcesses
	           detect: [ :each | (reified contextsOfProcess: each) size > 3 ]
	           ifNone: [
		           reified allReifiedProcesses
			           detect: [ :each | (reified contextsOfProcess: each) notEmpty ]
			           ifNone: [ nil ] ].
contexts := reified contextsOfProcess: process.
StDebugger
	openOn: (DebugSession named: 'a dumped image' on: nil startedAt: contexts first)
	withFullView: true.
```

Run against the core here, that picks the nine deep one out of seventeen processes, fifteen of
which are a single context and one of which -- the process that was running -- has none at all.

**Which process, though.** The one that was *running* has no contexts to give you: its stack was
frames at the moment of the dump, which is the whole reason stage two reads frames at all. The
suspended and waiting ones have their stacks as contexts, and those are what the debugger opens
on today. In the core we test against there are ten waiting processes, one of them nine contexts
deep -- `AtomicSharedQueue>>waitForNewItems`, `>>next`, `TKTWorkerProcess>>privateNextTask`.

**On reading yourself.** `SpurDumpedMemory on: LinuxProcessMemory onSelf` works, and opening a
browser on it is a strange thing to do: reifying allocates in the very heap being read, and you
cannot hold yourself still, so the thing under the glass grows and moves as you look. Fine for
structural curiosity, wrong for anything you intend to believe. Point it at another image and
stop that one first.

**A gap worth knowing.** Some methods read back as `an unreadable selector` from a dump --
`DelayMicrosecondTicker>>`, `Delay>>` in the core here -- where the same methods read fine from a
snapshot. The tool is reporting honestly rather than guessing, but something about reading a
selector out of a dump is not yet right, and it has not been chased.
