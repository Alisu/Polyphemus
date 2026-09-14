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
`.sources`, the receiver and its instance variables in the inspector, and variables resolving
in the source pane.

Everything resolves **in the image being read**, never in ours: instance variables come from
the receiver's class there, and globals from that image's own `SystemDictionary`, reachable at
special objects slot 9 — `memory globalNamed: 'Process'`. Falling back to our globals would
bind a name to a class of this image that merely shares a name with the one in the file.

Does not, and does not pretend to:

- **Temporaries.** Naming them needs the method's syntax tree analysed against the classes
  of the image it came from. `astScope` answers an empty scope, so the inspector shows the
  receiver and the stack instead of wrong names.
- **The highlighted line.** Mapping a pc to a source range needs the method's pc map, so
  nothing is highlighted rather than the wrong thing.
- **Stepping, restarting, evaluating.** The toolbar buttons are there because it is the real
  debugger, but there is no process behind them.

## Why the debugger needs help at all

It asks a context for a long protocol. `OOPContext` answers it from slots, and three small
patches make the rest work, all fork-only:

- `DebugSession>>isContextPostMortem:` and `>>isLatestContext:` ask the interrupted process,
  which a snapshot session does not have.
- `StDebuggerContextInteractionModel>>behavior` asks the receiver for its class, which for us
  is `OOPRegularObject` in this image. It has to be the receiver's class **in the image being
  read**, or nothing in the source resolves and every variable shows as unknown.

These patch Pharo classes, so they stay in the fork.
