# Stage 3: a live image

Stage 1 reads an image file. Stage 2 reads a process that has stopped mattering -- a core, or a
running VM copied while it was held still -- and writes back to it. Stage 3 is the one the tool
was for: **open an image that is running, look at it, change it, and let it go on running.**

Most of the mechanism arrived during stage 2, because holding an image and editing it turned out
to be the same problem. What is written here is therefore half a record of what works and half a
plan for what does not.

## What already works

| | how | where |
|---|---|---|
| interrupt a running image from outside | write the VM's `interruptPending`; it signals the image's interrupt semaphore at its next check | `docs/reading-a-live-process.md` |
| hold it there | a watcher of ours, above the wedged process, that does not yield until a word changes | same |
| read it whole while held | SIGSTOP, then the ordinary ladder -- 844,508 objects, no rung refused | same |
| fix a method in it | the passes of `docs/editing-an-image.md`, aimed at `/proc/<pid>/mem` | that doc |
| add a method it never had | allocated in eden, with the dictionary remembered | that doc |
| discard the machine code of a method | ask the held image to run `voidCogVMState` | that doc |
| let it go | write one word; the image runs on, and answers | same |

Two numbers worth keeping: the VM reaches its interrupt check about **70 times a second** while
idle (the heartbeat smashing `stackLimit`), so "soon" means milliseconds; and old space in a
running image ends at its bridge, so anything made there goes in **eden**, with the collector told
about any old object that comes to point at it.

## What stage 3 still has to do

### The instrument is the hold

Théo's framing, which unifies what was written below as two problems. **Put an instrument into
the running image, let it run at full speed, and open the debugger only when the instrument is
hit.** Then holding is not a separate mechanism at all: the instrument's own code is what stops
the image, tells us, and waits to be released. #27 and #34 differ only in what fires it --

| trigger | what it is for |
|---|---|
| a flag we set from outside | interrupt it *now*, wherever it is (#27) |
| reaching a method, or a place in one | run until the interesting call (#34) |

Three things follow, and they shape everything under them.

**The first instrument is the hard one.** Installing it from outside means the caveat already
recorded: a hot method is compiled, its send sites are linked to that machine code, and pointing
the dictionary at a new method does not unlink them. But this only bites *once*. As soon as our
code runs inside the image, every later instrument can be installed by the image itself -- through
its own compiler and its own cache flushing, or through Reflectivity's metalinks, which exist for
exactly this. So the whole problem reduces to getting one instrument in, on one method Cog has
not compiled.

**A breakpoint wants a source position, not a pc.** Inserting a trap into a method renumbers its
bytecodes, so "stop at pc 41" stops meaning what it meant the moment the instrument goes in. The
place has to be named where it survives recompilation -- an ast node, or a source interval, which
is also what the debugger shows and what the highlighting already maps (#4). The pc is an output,
not an input.

**The trap should not be visible in the stack.** A trap that is an ordinary send adds a frame the
user did not write, and the debugger would open on *it* rather than on the method being debugged.
Either the instrument is inlined so no frame appears, or whatever opens the debugger steps down
one frame and says so.

### A. Hold an image that carries nothing of ours (#27)

**How the hold works today.** Every test target is launched with a watcher we planted: a process
at priority 70 that waits on the VM's interrupt semaphore (special objects slot 31), and, once
signalled, spins on that semaphore's third instance variable without yielding until Polyphemus
writes it. That is what makes "held" mean held: something above the runaway process refuses to
give the processor back.

An image that knows nothing of Polyphemus has no such process. Signalling its interrupt semaphore
reaches whatever *it* keeps there -- Pharo's own interrupt handling, or nobody at all, in which
case the signal only increments `excessSignals` and nothing happens. We can still SIGSTOP it and
read it (`whileStoppedWhenQuiet:`), but we cannot choose the moment, and an image spinning in a
loop never goes quiet, so that fallback covers the idle case and not the interesting one.

**Measured** (stock Pharo 10 image, launched headless with a busy loop at priority 40, nothing
of ours in it): nobody waits on slot 31. The semaphore's `firstLink` and `lastLink` are nil, and
signalling it only raises `excessSignals` -- the loop runs on. So Pharo gives us no handler to
borrow, and the first instrument has to be put in by us.

**Two ways to put it in:**

- **A. Patch a hot method.** Rewrite code some high-priority process of the image already runs
  (the delay scheduler at 80 wakes constantly) so that it first checks a flag of ours and holds
  while it is set.
- **B. Put a process in.** Make, inside the image, the watcher every test target is launched
  with: its method (compiled here, allocated there, in no method dictionary), a context at that
  method's start, and a process at priority 70 holding the context, queued on the interrupt
  semaphore as if it had called `wait`. The next interrupt wakes it like any waiter.

**B, because A fights the JIT and B does not touch it.** A method that runs constantly is one Cog
has compiled, and its send sites are *linked* to that machine code: changing its bytecodes or
swapping it in the dictionary changes nothing that runs until those links go, and making them go
is `voidCogVMState`, which needs the image to run our code, which is what we are trying to get.
B touches no existing method at all. The new method is interpreted on first run, like any fresh
method, and nothing links to it. Every piece B needs was built and tested already for editing
(allocating in eden, compiling here with literals made there, remembering an old object that
comes to point at a young one), and what gets woken is the same watcher source as a launched
target's, so holding, stepping and letting go are the tested paths. B also refuses cleanly: if
anything already waits on slot 31, it writes nothing (`WatcherInjection`, `Polyphemus
putAWatcherInto:watchedIn:`, tested by `WatcherInjectionTest`).

**What B risks, stated rather than hidden:** it is written in one SIGSTOP at a moment we did not
choose -- an image with no watcher has no safe moment to offer. If the VM was stopped in the
middle of allocating (eden's `freeStart` loaded but not yet stored back) or of changing the
semaphore's queue, one of our writes can be lost or undone when it resumes. The window is a few
instructions wide and has not been seen in the tests; reading the VM thread's registers and
program counter before writing would close it, and is left until a failure asks for it.

### B. A channel with answers in it (#34)

Today the watcher reads a script we leave beside it and writes files. That is enough to ask for a
cache flush; it is not enough for a debugger. Stepping needs the new context, its pc and its
receiver to come *back*, and a trap that fires has to reach us without being asked.

This is the piece that changes what Polyphemus is, and it is what "one debugger, many headless
instances" needs anyway -- so it is worth building once, deliberately, rather than twice by
accident. Whatever carries it, the debugger on screen must not learn whether it is talking to a
core, a file or an agent.

**Built.** `PolyphemusAgent sourceServing:` is Smalltalk source for a *stock* image -- nothing of
Polyphemus is in the target -- which the watcher runs as its script once held. It evaluates each
`request.N` left in a directory and writes `answer.N` beside it (each written under another name
and renamed, so neither side reads half a file), never yielding, until a file named `go` appears.
`DirectoryChannel` is our end: `ask:` answers the print string of the value over there, or
raises `PolyphemusChannelError` naming what went wrong there, or that nothing answered.

Measured on a held target (`LiveChannelTest`): it answers `3 + 4` with `7`, the agent runs at
priority 70, and a process forked at 40 does not run until `letGo`. Files, not a socket, because
checking for a file is a primitive that does not yield -- the hold survives the serving -- and
because the answers can stay small: what a step leaves behind is read from memory, which is what
Polyphemus already does. The transport sits behind `ask:` and `letGo`, so a socket can replace it
for instances on other machines.

What the agent does not have yet: state kept between requests, and a way to speak first -- a
trap that fires has to reach us unasked. Both belong to C.

### C. Stepping (#34)

Théo's shape: let the image resume, instrumented, and have it call back when it reaches the method
and pc we are waiting for. Two halves, and they are for different things:

| | what it is | speed |
|---|---|---|
| step into, step over | the image stepping its own context | one bytecode at a time |
| run until this method and pc | instrument, resume, trap, hold, call back | full speed |

The second is what makes a wedged image tractable: you do not step a hundred thousand times to
reach the interesting call.

**Checked against the source (Pharo 10, build 527):** `DebugSession>>stepInto:` sends
`Process>>step:`, which sends `Context>>step`, which is `InstructionStream on: method pc: pc`
and `interpretNextInstructionFor:` -- bytecode interpretation in Smalltalk. `stepOver:` goes
through `Process>>completeStep:` the same way. So a held image steps its own process with no
machine-level help, and stepping is a matter of what we ask over the channel.

**Single steps: built.** `HeldProcess` names the process on both sides by its identity hash (set
first, while stopped, when it has none), and the image opens a `DebugSession` of its own on it;
`ReifiedDebugSession stepWith:` sends Step Over and Step Into there and shows the debugger what
memory holds afterwards. A step costs ~20 ms in the image and ~1.7-2 s to read back (measured under load): the reading
is built whole once per hold (seconds, most of it the class table); after each step a new copy is
read, taking the last reading's classes over, and read whole again if the heap's mapping changed
or a compacting GC moved the class table or the special objects (measured: one did, and the
rebuild agreed with the image). Earlier copies are left intact for the contexts the debugger holds.

**The front door: built.** `Polyphemus debugProcess: pid watchedIn: dir` opens `StDebugger` on
what a running image is busy with; `holdProcess:watchedIn:` answers the session. The image must
run our watcher (`PolyphemusAgent watcherSourceWatching:afterwards:`), which arms itself again
after each release. Checked through StDebugger's own action model: Step Into, Over, Through,
and Proceed. What was learned wiring it:

- *Which process.* The scheduler's `activeProcess` at the moment the image is stopped to be
  interrupted, named by hash in that stop. Queue order is wrong: the target preempts with
  yielding, so a UI process waiting at the same priority comes first.
- *A copy per step.* The debugger keeps contexts of the last reading (its stack list, its
  inspector), so each step reads a new copy and leaves the old intact; refreshing one copy in
  place broke exactly that. The new reading takes the last one's classes over, and its heap's
  start, end and special objects without walking it (#46): ~1.7-2 s a step, the step itself ~20 ms.
- *Frames are not in the copy.* A preempted process keeps its newest activations as frames on
  stack pages, which live outside the heap mapping we copy. Before each read the image is asked
  for `voidCogVMState`, which moves every frame into a context; it discards machine code too,
  which the image makes again once let go.
- StDebugger needs its session to carry an exception (#41): `PolyphemusStop`, never signalled.

**"Run until": built.** `session runUntil: 'Integer >> #sqrt'` has the held image put a
Reflectivity MetaLink before that method (`PolyphemusAgent trapSourceFor:in:`), and lets it go.
The first process to reach it takes the trap out, says who it is, and signals the interrupt
semaphore -- our watcher wakes and holds the image right there. The debugger opens at the
method's own context, below the trap's frames; a step from there runs the trap out and goes on
in the method. Not reached in time, the image is held again where it got to and the trap
removed. Known edge: two processes already inside the method when it fires would signal twice,
and the watcher would read the second as our release.

**A frame selected below the top: built.** The debugger steps the frame selected in its stack
list, as Pharo's does: stepping over one below the top completes the frames above it. A context
has no name both sides share, so the session counts how many frames below the image debugger's
own it is, and the image steps the context that many senders down.

Still to do: seeding `findHeap` from the last reading (most of what a step still costs).

### D. Editing objects, not only methods (#20)

`SpurEdit>>store:inSlot:ofObjectShown:` sets any slot of any object a reading shows, and the
debugger's code pane is wired. The inspector is not. Since #35 put every memory behind one protocol
the same method reaches a running image, but no test has aimed it at one yet -- so today you can
fix a method in a running image, and correcting the instance variable that made it fail is
believed to work rather than checked.

**A slot, in a running image: built and checked.** `session store: 2 inSlot: 1 ofObjectShown:
anObject` sets it while the image is held; let go, the image goes on with it
(`LiveEditingTest`: a runaway loop on `flag first = 1` ends once the slot says 2). What had to
change, measured first:

- *A held image was not still.* The agent polled for request files, and polling allocates:
  **223 scavenges in 2 s** of being held with nobody asking. A scavenge moves every young object,
  so an address read a moment ago could be someone else's by the time we wrote to it. The agent
  now spins on a bell between requests, as the hold does, and allocates nothing
  (`sourceServing:bell:`); the channel rings it by writing the word that releases the hold. It
  looks for a request before waiting, so a ring the watcher's reset swallowed is not missed.
- *And the edit checks it.* The VM counts its collections (`statScavenges`, `statFullGCs`); the
  held process notes both in the stop it reads in, and refuses an edit if either moved by the stop
  it writes in. A process at priority 80 (the delay scheduler) can still allocate while we hold,
  so a refusal is possible, just rare; reading again and editing again is the answer.
- An object of an earlier reading, one step back, is refused too: that step ran code.

Found on the way: frames of code evaluated from a script (`UndefinedObject>>DoIt`) show no
temporaries, because names come from compiling the frame's source back (#6) and a doit's source is
not kept. The objects are still reachable, through whatever the frame's callees hold.

**A method, from the code pane: built and checked.** Accepted in the live debugger, the source is
compiled for the method's class and written into the image under the same guard, and the image
is asked for `voidCogVMState` so a jitted method stops running the old bytecodes
(`LiveEditingTest`: stopped by `runUntil: 'SmallInteger >> #even'`, `even ^ false` accepted, the
runaway loop on it ends). It is aimed at the method the class holds *now* for that selector: the
context may run an older one, and after "run until" it does -- the trap's instrumented copy,
whose bytecodes match no source. On the way, the trap was found to fire in our own agent when the
agent ran the method too (#48); it now lets the agent through.

**The inspector: built and checked.** In the Oop tab the value of a slot can be typed in -- an
integer, `nil`, `true` or `false`, since what is stored has to be in the image already -- when the
reading has an editor; a held process is the editor of every reading it takes, so this lands in
the running image under the same guard (`LiveEditingTest`), and an image file's reading given a
`SpurEdit` writes into the copy (`SpurImageEditTest`). The reading on screen still shows what was
read; the next step or reading shows the change. Not yet: temporaries by name in the debugger's
own inspector, and "save as" for a dump -- left on #20, past stage 3.

### Many instances at once -- not stage 3

The vision behind all of it, one debugger and many headless images, is its own work now (#47),
to follow stage 3.

## Order

Done: **#35** (the tidy-up), **B** (the channel), **C** (stepping, "run until", the front door),
**A (#27)** (a watcher put into an image that has none), stepping a frame selected below the
top, and **D** (a slot, a method and the inspector, in a running image). Stage 3 is done: open an
image that is running, look at it, change it, and let it go on running. What follows is #47,
many instances at once.

## Facts to check, listed so they are not assumed

- Whether a jitted method's *linked send sites* defeat a dictionary swap, and for how long (it
  decided #27 without being measured: B avoids the question).
- Why `flushCache` did not discard machine code in the measurement, when VMMaker's
  `CoInterpreterPrimitives>>primitiveFlushCacheByMethod` does send `unlinkSendsTo:andFreeIf:`.
  The measurement is solid -- `voidCogVMState` took, `flushCache` did not -- but the explanation
  written into commit `a5a750c` (that primitive 116 only reaches StackInterpreter's cache) does
  not survive reading the senders list, and the real cause is unknown.

## What stage 3 does not promise

An image too broken to run anything of its own cannot be held or asked to un-jit; it is a stage 2
subject -- stop it, read it, write out a repaired image, start that. Nothing here changes that
boundary, and the tool should say which side of it a given target is on.
