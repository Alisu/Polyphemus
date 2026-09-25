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

**The plan, measured first.** Three questions, in order, none of them answered yet:

1. **Who waits on slot 31 in a stock image?** Read the semaphore's queue from outside -- its
   `firstLink`/`lastLink` -- in a plain headless Pharo that was not launched by us. If a process
   of Pharo's own waits there, signalling gives us something that runs at high priority.
2. **What does it do when woken?** If Pharo's handler interrupts the active process, that alone is
   worth having on a runaway image, even before any hold.
3. **Can we get the first instrument in?** The pieces exist: we can install a method into a live
   image, with literals of our own making. So the shape is *bootstrap* -- patch the code some
   already-running, high-priority process is about to execute (the delay scheduler ticks at
   priority 80 and wakes constantly) so that it first looks at a flag object we allocated, and
   holds while it is set. Once our code runs inside, everything after it is the image's own work.

**The thing that decides whether this works**, and it has not been checked: a method that runs
constantly is a method Cog has compiled, and worse, its send sites are *linked* to that machine
code. Pointing the dictionary at a new method does not unlink them. So the bootstrap patch must
either land on a method that is not jitted (its header still holds the header word -- one slot to
check), or wait for the send sites to be unlinked by something else. Measure before building.

**Fallback, stated rather than hidden:** for an image with no watcher and no usable hook, stop it
with SIGSTOP when it is quiet, read, and refuse to edit -- rather than editing at a moment we did
not choose.

### B. A channel with answers in it (#34)

Today the watcher reads a script we leave beside it and writes files. That is enough to ask for a
cache flush; it is not enough for a debugger. Stepping needs the new context, its pc and its
receiver to come *back*, and a trap that fires has to reach us without being asked.

This is the piece that changes what Polyphemus is, and it is what "one debugger, many headless
instances" needs anyway -- so it is worth building once, deliberately, rather than twice by
accident. Whatever carries it, the debugger on screen must not learn whether it is talking to a
core, a file or an agent.

### C. Stepping (#34)

Théo's shape: let the image resume, instrumented, and have it call back when it reaches the method
and pc we are waiting for. Two halves, and they are for different things:

| | what it is | speed |
|---|---|---|
| step into, step over | the image stepping its own context | one bytecode at a time |
| run until this method and pc | instrument, resume, trap, hold, call back | full speed |

The second is what makes a wedged image tractable: you do not step a hundred thousand times to
reach the interesting call.

**To check before building:** Pharo's debugger appears to step by simulating in the image rather
than asking the VM (`Context>>step`), which would mean "step" needs no machine-level trick at all.
That belief has not been verified against the source, and the plan leans on it.

### D. Editing objects, not only methods (#20)

`SpurImageEdit` can set any slot of any object a reading shows, and the debugger's code pane is
wired. The inspector is not, and the live editor has no `store:inSlot:ofObjectShown:` of its own --
so today you can fix a method in a running image but not correct the instance variable that made
it fail. Same machinery, one class short.

### E. Many instances at once

The vision behind all of it: one debugger, many headless images. Nothing prevents it now -- each
target is a pid -- but nothing composes it either. It wants the channel from B, a chooser over
`LinuxProcessMemory pharoProcesses`, and a session per instance.

## Order

1. **A's measurements** -- three cheap readings of a stock image; they decide whether #27 is
   bootstrap or fallback, and they cost an afternoon.
2. **B, the channel** -- everything else leans on it.
3. **C, stepping**, first "run until", then single steps.
4. **D**, which is small and makes the debugger honest.
5. **E**, which is composition once B exists.

Before any of it: **#35**, the tidy-up. Stepping and the channel will both land on the classes that
need splitting, and they should be split first.

## Facts to check, listed so they are not assumed

- Who waits on the interrupt semaphore in a stock headless image, and what it does when woken.
- Whether a jitted method's *linked send sites* defeat a dictionary swap, and for how long.
- Whether Pharo steps by simulation in the image (`Context>>step`) as believed.
- Why `flushCache` did not discard machine code in the measurement, when VMMaker's
  `CoInterpreterPrimitives>>primitiveFlushCacheByMethod` does send `unlinkSendsTo:andFreeIf:`.
  The measurement is solid -- `voidCogVMState` took, `flushCache` did not -- but the explanation
  written into commit `a5a750c` (that primitive 116 only reaches StackInterpreter's cache) does
  not survive reading the senders list, and the real cause is unknown.

## What stage 3 does not promise

An image too broken to run anything of its own cannot be held or asked to un-jit; it is a stage 2
subject -- stop it, read it, write out a repaired image, start that. Nothing here changes that
boundary, and the tool should say which side of it a given target is on.
