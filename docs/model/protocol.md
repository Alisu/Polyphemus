# The hold protocol, as the code does it

Read from stage2 at 26cbcae (2026-10-29). The basis of the TLA+ models beside it (#137): who acts, what
they share, each step and the method it comes from, and what must hold whatever the interleaving.

## Actors

- **Observer (O)**: the Pharo image running Polyphemus. Can die at any moment.
- **Kernel (K)**: stops and resumes the image (SIGSTOP/SIGCONT on Linux, task suspend on macOS)
  for O; reports a process ended.
- **Image (I)**, with four processes inside:
  - **Watcher (W)**, priority 70, put in by O (`WatcherInjection`).
  - **Agent (A)**, the script `do.st` that W runs while holding; serves O's requests.
  - **Trap (T)**, a MetaLink that `runUntil:` installs; fires in whatever process reaches the method.
  - **User (U)**, the image's own processes (priority 40 and below), which run only when W and A
    are not spinning.
- The image can also end (killed, crash) at any moment.

## Shared state

| Variable | Where | Meaning |
|---|---|---|
| `excess` | the semaphore's 3rd slot (`excessSignals`) | signals not yet consumed; W waits on it, A spins on it as its bell. O's ring sets it to 1 and wakes nobody (`countOneSignalOnExternalSemaphore:`); only a VM signal (the hold's, the trap's) resumes a waiting W |
| `stopped` | kernel | the image is stopped by O |
| `interrupted`, `released`, `trap`, `do.st`, `do-failed` | files in the watch folder | W's and T's signals to O; O's script for W |
| `channel/serving` | file | A started serving |
| `channel/request.N`, `channel/answer.N` | files | one request and its answer (written under `.tmp`, then renamed) |
| `channel/go` | file | O asks A to end |
| `channel/expired` | file | A ended by itself after the hold limit |
| `semaphore-index` | file | where W's semaphore is in the external objects table |

## Steps

### Putting the watcher in (`WatcherInjection>>inject`, `whileStoppedAtASafeMoment:`)
1. O stops I, at a quiet moment or else outside a collection (up to 45 tries, else refused).
2. If a watcher is already there: answered as it is when a process waits on its semaphore; refused
   when the semaphore is there but nobody waits on it (W is holding) (#124, #132).
3. Else O writes W's objects into I's memory (semaphore, context, process), registers the semaphore,
   queues W on it, writes `semaphore-index`; resumes I.

### Holding (`HeldImage>>holdWithin:`)
1. O deletes `interrupted`, `released`.
2. O stops I, signals the semaphore (`excess := excess + 1`, W made runnable), reads which process
   was active, resumes I.
3. W runs (priority 70): writes `interrupted`; spins until `excess > 0` **or 60 s pass**
   (`holdSourceAfterwards:`); sets `excess := 0`; runs `do.st` if present, else goes on.
4. O waits for `interrupted` (its timeout, else "never took the interrupt").
5. `serveAndHold:`: O deletes `channel/`, writes `do.st` (A's source), and rings
   (stop, `excess := 1`, resume). The ring wakes nobody: W sees it only while it spins.
6. W sees `excess > 0`, runs `do.st`: A starts, creates `channel/`, writes `serving` unless `go`
   is there already.

### The agent serving (`sourceServing:bell:limit:`)
- Loop, spinning (no yield, priority 70): wait until `excess > 0` or `now - last > limit`.
  - Rung: `excess := 0`; if `request.(count+1)` exists, run it in a process of its own, named
    `PolyphemusAgent requestProcessName`, at A's priority, and answer it (`answer.(count+1)`);
    else read `go`: if there, end. While the request runs, A keeps spinning, yielding to it: the
    image is never left with nothing to run (#161). A watchdog one priority above stops a request
    still running after `requestLimit` (50 s, under O's minute), and the answer says so.
  - Limit passed (an hour by default, none with `holdLimit: nil`): write `expired`, run `letGo`
    if the image's debugger left one, end.
- Letting go and Stop resume (or end) the held process, then unregister it from a process at
  background priority: held inside the external semaphore table's lock, waiting for it would hold
  the image for ever (#162).
- After A ends, W writes `released` and waits on the semaphore again. A ring after that sets
  `excess` to 1 under a waiting W: the next hold then breaks (seen on the Mac, 2026-10-30).

### Asking (`DirectoryChannel>>ask:within:`)
1. If `expired`: refused. If I ended: refused at once (#127).
2. Wait for `serving`, until the deadline (every 500 ms: ended?).
3. Write `request.N`, ring.
4. Wait for `answer.N` until the deadline; meanwhile `expired`? ended (every 500 ms)?

### Letting go (`HeldProcess>>letGo`, `DirectoryChannel>>letGoWithin:`)
1. If `expired` or I ended: nothing to do.
2. Ask A to put back the held process (`call: #letGo`).
3. Wait for `serving` (5 s), write `go`, ring if serving.

### Running until a method (`HeldImage>>runUntil:within:`)
1. O asks A to install T on the method, then lets go (A ends, I runs).
2. T fires in the first other process that reaches the method: uninstalls itself, writes `trap`,
   signals the semaphore. W holds as in "Holding" 3 to 6.
3. If `trap` does not come in time: O holds the image anyway (`holdWithin:`) and asks A to remove T.

## Properties to check

Safety (nothing bad ever happens):
1. **One agent at a time** per channel folder.
2. **One watcher** per image and folder; a second is never put in beside it (#124).
3. **No lost ring**: a request written while A serves is always seen by A (#49).
4. **A request never lands in a folder that is not A's** (#90).
5. **A ring meant for A never makes W hold again**, nor breaks its next hold, once A has ended. *The code does not have this
   property today*: `limitations.md` says a hold ending as O asks can hold the image once more,
   for up to a minute (W's 60 s). The model should show the interleaving.
6. **The trap fires at most once**, and is never left installed after `runUntil:` gives up.

Liveness (something good eventually happens):
7. **Every ask ends**: answered, refused as expired, refused as gone, or timed out.
8. **If O dies, I runs again**: within W's 60 s before A starts, within the hold limit after (#96).
   Not with `holdLimit: nil`, which is documented.
9. **After a let-go that succeeded, U runs again.**
10. **Two observers never hold each other for ever** (#117): to model with two O's and two I's.
11. **No ring written where no semaphore is**: a ring on A's own bell after A unregistered it
    would write past nil.
12. **No lost hold**: O never gives up waiting on an image that is alive and whose agent did not
    expire.
13. **No unserved hold**: W holds the image only while O is in a hold, never by itself between
    two of them.
14. **The trap is taken out once**: O's removal never takes out a trap already taking itself
    out (the second `uninstall` is an error).
15. **No process of ours takes the trap**: neither A nor a request A runs (#161).
16. **Never nothing to run**: while the image is held, some process can always run (#161).
17. **No object written over**: nothing O makes in I's memory is written over by I's own objects,
    nor the other way round (#137, #167). In `Writes.tla`.
18. **No remembered entry lost**: an entry O adds to the remembered set stays in it, and takes the
    place of none of I's (#167). In `Writes.tla`.
19. **Every observer gets through its stop**, or is refused after its tries (#187). In
    `StopHelper.tla`.

## What the model leaves out

- Memory, readings, copies: no Spur, no heap in `Hold.tla`. Since 2026-11-12 `Writes.tla` has the
  three words O writes that I reads and writes back itself (`freeStart`, `pastSpaceStart`,
  `rememberedSetSize`) and nothing else of the heap. That side is for the invariants in tests.
- The process a hold names. Held again when the one caught at the stop had ended (#172) is a let
  go and another plain hold, which the two holds in a row of version 8's last row cover.
- Timing beyond order and timeouts: a timeout is a step that may happen when its condition holds.
- What a request does inside the image, beyond ending, never ending, and meeting the trap
  (version 7). Locks taken inside the image (#162's) are not in it.

## Results (TLC 2.19, 2026-10-31)

`Hold.tla` (version 6) checks properties 5 to 9 and 11 to 14 on a small instance: one observer, one
image, a plain hold with one request, then a `runUntil:`; either side dying at any step; the
agent's hour running out at any step. Timing kept realistic: a live observer acts within the
watcher's 60 s unless paused (idle, or its user deciding), and its own deadlines pass only when the
image can make no step, except `runUntil:`'s, which may pass at any moment, the trap still armed.
Version 3 (2026-10-30) follows the Mac trial: the observer's ring only counts (it never wakes a
waiting watcher); version 2 had it wake one, and missed the lost holds. Version 4 (2026-10-31)
follows the box: the observer's signal (`signalExternalSemaphore:`) is queued, and the VM delivers
it at a later step of the image; version 3 had it delivered at once, and missed a lost hold.
Version 5 adds property 13, which version 4's property 5 let through: a hold signalled for by the
observer, but after the observer was done with it. Version 6 follows the box again: the trap
fires in two steps of the user process that reached the method (it takes itself out, then writes
its file and signals), and a stop or the agent can come between them.
`check_all.sh` runs every combination, and leaves each counterexample in `results/`; `trace.py`
prints one step by step.

The fixes, each a switch of the model: the stop helper (the stop ends with the observer), the
agent's own bell, `bell-ended` before the bell is let go, `runUntil:`'s fallback looking for the
trap's file once the image is stopped, the watcher spinning until its `do.st` is there as well
as a signal, a file saying a hold is wanted, and the trap claimed in one step.

| Design | 5 stray hold | 6 trap left | 11 write past nil | 12 lost hold | 13 unserved hold | 14 trap out twice | 7 ask ends | 8 observer dies | 9 through |
|---|---|---|---|---|---|---|---|---|---|
| Today | fails (17) | fails (39) | holds | fails (28) | fails (30) | fails (48) | holds | fails (4) | holds |
| Own bell | holds | fails (55) | fails (16) | fails (45) | fails (49) | fails (50) | holds | fails (4) | holds |
| Own bell, `bell-ended` | holds | fails (55) | holds | fails (45) | fails (49) | fails (50) | holds | fails (4) | holds |
| and the fallback sees the trap | holds | fails (55) | holds | fails (48) | fails (49) | fails (50) | holds | fails (4) | holds |
| and the watcher waits for its `do.st` | holds | fails (55) | holds | holds | fails (59) | fails (50) | holds | fails (4) | holds |
| and the hold wanted is a file | holds | fails (55) | holds | holds | fails (59) | fails (50) | holds | fails (4) | holds |
| and the trap claimed in one step | holds | holds | holds | holds | holds | holds | holds | fails (4) | holds |
| All of the above and the stop helper | holds | holds | holds | holds | holds | holds | holds | holds | holds |

(Steps of the shortest counterexample in brackets. The stop helper alone fixes 8 and nothing
else; with it, every row is the same except 8.)

What the failures are:
- **5, stray hold:** the observer writes a request; before its ring, the agent reaches its hour and
  ends; the ring lands before the watcher waits again, and its wait returns at once: the watcher
  holds the whole image again, with no agent, for 60 s.
- **6, trap left installed:** a ring left over from an earlier let-go makes the watcher start the
  next agent early; that agent takes the serving ring for the request's, the real request ring comes
  after it ended, and the observer gives up with the trap it asked for still in the image.
- **12, lost hold, today:** the next hold's signal arrives while the last agent still serves; the
  agent consumes it with its own ring, and the watcher never holds. The Mac trial showed another
  way: a ring after the agent ended sets the count to 1 under the waiting watcher; the next hold
  wakes it, it finds the count, skips its wait for the serve ring, finds no `do.st` yet and leaves;
  the observer waits a minute for an agent that never comes.
- 5, 6 and 12 have one cause: the watcher's interrupt and the agent's bell are one semaphore.
  **Fix: the agent rings on a bell of its own that nobody waits on.**
- **11, write past nil:** with its own bell, a ring after the agent unregistered it finds nil in
  that slot of the external objects table and writes 24 bytes past nil. **Fix: the agent writes
  `bell-ended` before it lets its bell go; the observer, while the image is stopped, rings only if
  that file is not there.**
- **12, lost hold, with the bell:** `runUntil:`'s deadline passes just as the trap fires; the
  fallback hold signals a watcher the trap already woke, which takes it as its serve ring and
  leaves with no agent, while the observer waits for an `interrupted` it deleted. **Fix: the
  fallback stops the image first and looks for `trap`; if it is there, it takes the trap's hold.**
- **12, lost hold, with that fix too** (version 4, and on the box, 2026-10-31): the fallback finds
  no trap yet and signals; the VM has not delivered the signal when the trap fires and wakes the
  watcher; delivered then, the signal is taken for the serve ring, and the watcher leaves with no
  `do.st`. **Fix: the watcher spins until a signal and its `do.st`, never a signal alone.**
- **13, unserved hold, with every fix above** (version 5): the same race, the other way round.
  The fallback's signal is still queued when the trap fires; the trap's hold goes through, the
  trap is taken out, the observer lets go; then the VM delivers the fallback's signal, and the
  watcher holds the image for 60 s with nobody to serve it. No check on the observer's side can
  take back a signal already queued. **Fix: a hold wanted is a file.** The observer writes `hold`
  while the image is stopped, before it signals; the trap writes `trap`; letting go deletes both.
  A watcher woken with neither there waits again without holding.
- **6, 13 and 14, with every fix above** (version 6, and on the box, 2026-10-31): the trap fires
  in two steps. Stopped between them, it has taken itself out but written no `trap`: the fallback
  holds and asks the agent to take the trap out, and the second `uninstall` fails (14). Let go,
  the user process finishes the trap: it writes `trap` after the observer deleted it, and
  signals; the watcher holds for nobody (13). On the box the same process went through the trap
  twice. **Fix: the trap claims itself in one step** (`Smalltalk globals removeKey:
  #PolyphemusTrap`, unpreempted), and only the claimant takes the link out; the agent's removal
  claims it the same way and answers which happened: *removed*, *firing* (claimed, its hold to
  come: the observer lets go and takes it) or *fired* (the hold the observer has is the trap's).
  With the claim, the file of the hold wanted is no longer needed by the model; it is kept
  against signals the model does not foresee.
- **8:** the observer dies while the image is stopped (SIGSTOP, task suspend): stopped for ever
  (#96). **Fix: a stop the system ends when the observer dies**: a stop helper (#137): it holds
  the SIGSTOP and lets the image go when the observer says so, dies, or cannot within a bound.
  Tried on macOS on 2026-10-30, all three cases work. Polyphemus stops with SIGSTOP on macOS too.

Known and left out of 13: an agent that reached its hour while a `runUntil:` waited leaves the
trap armed (the observer cannot ask it to take it out); a process reaching the method later is
held 60 s with nobody to serve it.

Not modelled yet: putting the watcher in (2, 4), one agent per folder (1); two observers (10) are
in `HoldPair.tla`.

## Version 7: requests that may not end (#161), 2026-11-09

An answer was one step until #161 showed what that hid: a request that never ends (an endless
loop stepped over, a wait) held the image for good. Version 7 lets a plain request start, then end
or hang; run apart, a watchdog stops a hung one; while it runs it may reach the trapped method;
and with A asleep meanwhile, a hung request that blocks leaves the VM nothing to run when the held
process is its idle process. Four switches, on top of version 6's final design with the stop
helper: requests may hang, run apart with a watchdog, the trap passing A's requests, A asleep.

| Design | 12 lost hold | 15 our trap | 16 nothing to run | 8 observer dies | 9 through | others |
|---|---|---|---|---|---|---|
| Requests never hang (version 6) | holds | holds | holds | holds | holds | hold |
| They may hang, A runs them (before #161) | fails (17) | holds | holds | fails (18) | fails (25) | hold |
| Apart, A asleep (#161's first try) | holds | holds | fails (17) | holds | holds | hold |
| Apart, the trap passing only A (CI, 2026-11-09) | holds | fails (51) | holds | holds | holds | hold |
| Apart, the trap passing A's requests, A spinning (now) | holds | holds | holds | holds | holds | hold |

Each failure is a bug the code had that day: #161 itself, where an observer dying did not free the
image either, the hour limit being checked only between requests; the VM abort of #161's first
try ("scheduler could not find a runnable process"); the trap taken by a request process, found by
CI. Property 16 is close to built in (the abort is a step of the model when its condition holds):
it records the lesson rather than finding it.

## Version 8: what the flakes of 2026-11-12 showed

Three flakes fixed that day were steps the model took for whole, or for done. Version 8 puts two
of them in `Hold.tla`, on top of version 7's final design (the third is #187, in `StopHelper.tla`
below; what was behind the second is `Writes.tla`'s).

- **A ring can be refused** (#186). A ring writes into the semaphore, which a collection may be
  moving: its stop is taken outside a collection, and one that lands in one writes nothing. From
  2026-11-10 to 11-12 the code then went on as if it had rung. The model's ring may be refused
  twice in a run, and is then made again or dropped. Property 3 (no lost ring) is checked for the
  first time: while O waits for an answer and A serves, A's bell is rung.
- **The watcher can be gone** (#137). Made in eden, it was written over by the image's own
  objects before it first woke, one injection in ten into a loop that makes objects; the slot its
  index names holds an object that is no semaphore, and the VM signals nothing there. The model
  may start with the watcher gone.

| Design | 3 lost ring | 12 lost hold | 13 unserved hold | 6 trap left | others |
|---|---|---|---|---|---|
| Rings always land, the watcher is there (version 7) | holds | holds | holds | holds | hold |
| A ring refused is dropped (2026-11-10 to 11-12, #186) | fails (14) | fails (10) | fails (10) | fails (46) | hold |
| A ring refused is made again (now) | holds | holds | holds | holds | hold |
| The watcher made in eden may be gone (until 2026-11-12, #137) | holds | fails (5) | holds | holds | hold |
| Two plain holds in a row, rings made again (#172's hold again) | holds | holds | holds | n/a | hold |

The dropped ring's ten steps are the failure CI showed, "the image did not answer: nothing was
serving": W woke and wrote `interrupted`, O left `do.st` and its ring was refused, W span with
nobody ringing. The forty-six steps are one CI did not show: the hold `runUntil:` falls back to
loses its ring the same way, and O gives up with the trap still in the image. The lost watcher's
five steps are "the image never took the interrupt". Nothing in `Hold.tla` can keep a watcher
from being written over; the fix is where it is made (`Writes.tla`, below), and the row stays
as the record of what its loss looks like from the protocol.

## Two observers holding each other (#117): `HoldPair.tla`

Image A's observer holds B, B's observer holds A. An observer is a user process of its image: it
runs only while its own image runs and is not held there. A stop is issued by the observer and
applied by the kernel, so on two cores both observers can issue theirs at the same instant.
Property 10: both observers get through and both images run again.

| Design | with the hour limit | with no limit |
|---|---|---|
| Today: stops issued and lifted by the observer | fails (6 to 10 steps) | fails |
| A watcher refusing to hold while its image's observer holds another | fails | fails |
| Stops held by a watchdog helper | holds | holds |

- **The failure:** both observers issue a stop of the other's image at once; the kernel applies both;
  each observer is now in a stopped image and cannot resume the other: **both stopped for ever.**
  A refusal by the watcher does not help: the watchers are stopped too.
- **The fix:** the stop is held by a small helper process outside the observer, which lets the image
  go when the observer says so, when the observer dies (#96), or after a bound if the observer
  cannot (#117). The observer, resumed late or not, checks whether its stop lasted the whole
  reading and reads again if not. Simultaneous holds through the watchers then end by the
  watcher's 60 s: both images freeze for a minute, no longer.

## Two observers putting a watcher into the same image: `InjectPair.tla`

Two observers run `WatcherInjection>>inject` on the same image and folder at once. SIGSTOP and
SIGCONT are not counted: the first resume lets the image go for both.

| | no lock (today) | a stop lock per image |
|---|---|---|
| 4. nothing written into the image while it runs | fails (8 steps) | holds |
| 2. one watcher per image and folder | fails (7 steps) | holds |
| both observers get through | holds | holds |

- **The failure:** both stop the image, both find no watcher, the first writes its watcher and
  resumes the image, the second writes its own into the running image: memory written while the
  image runs (corruption), and two watchers on one folder.
- **The fix:** the stop helper takes a lock named after the pid (`flock` on a file, released by the
  system if the helper dies) before stopping; a second observer waits for it. All stops of an image
  then go through one place, which covers #96 (observer dies), #117 (observers stopping each other)
  and this.

## The stop helper itself: `StopHelper.tla`

The helper #137 proposes, checked before it is written: two observers each read (and may write
into) the same image, every stop through a helper of their own. A helper takes a lock named after
the image's pid, stops the image, leaves a mark naming itself, and resumes the image when its
observer says so, when its observer dies (its input ends), or at its bound. An observer whose stop
ended early, or whose helper is gone, throws its reading away and tries again. A helper can be
killed: the system then lets its lock go, not its stop. A helper taking the lock resumes an image
a dead helper's mark says is stopped.

| Property | Result |
|---|---|
| no reading accepted that the image moved under, no write into the running image | holds |
| at most one helper holds the image stopped | holds |
| the image is never stopped for ever | holds, unless helpers are killed (`kill -9`) and every observer is gone |

The last case cannot be fixed from inside: a killed process does not clean up. The mark covers it
for whoever comes next (a helper or an observer resumes an image a dead helper's mark says is
stopped); otherwise `kill -CONT` by hand.

**The helper's program** (#187, 2026-11-12). The model had helpers that start; the code builds the
program first, when it is not there, and two test images starting together on a fresh machine
each did. Built in place, it is there from its first byte, and the other observer starts it half
written: a helper that says nothing. The observer waited for it as for another observer's stop,
five minutes. In the model an observer builds the program when there is none (in place, or under
another name and renamed), and a helper started from a half-written one is silent for ever.

| Design | 19 every observer through | the three above |
|---|---|---|
| Built in place, a silent helper waited for (before #187) | fails (5) | hold |
| Built in place, a silent helper given up | holds | hold |
| Renamed whole, a silent helper waited for | holds | hold |
| Renamed whole, a silent helper given up (now) | holds | hold |

Either half of #187's fix is enough in the model; the code has both.

## Writes into a running VM: `Writes.tla`

What `Hold.tla` leaves out, and where #137's last flake was. O stops I wherever it is and writes
into its new space: an object (the watcher, a method, a literal) and an entry of the remembered
set for the old object that now names it. I reads, changes and writes back the same words in more
than one instruction; stopped between, it goes on with what its register held (#167; risk 3 of
#163). The VM's steps are VMMaker's, read on 2026-11-12:

- the JIT's primitive new loads `freeStart`, stores it moved on, then writes the header
  (`CogObjectRepresentationFor64BitSpur>>genPrimitiveNew`: "get freeStart as early as possible");
- C's allocation reads `freeStart`, writes the header, then stores `freeStart`
  (`SpurMemoryManager>>allocateNewSpaceSlots:format:classIndex:`);
- remembering, in C and called from machine code's store check, reads the size, stores the entry,
  then stores the size (`VMRememberedSet>>rememberWithoutMarkingAsRemembered:`);
- a scavenge sets `gcPhaseInProgress`, copies survivors, stores `pastSpaceStart` from where the
  copying ended, and clears the flag (`SpurMemoryManager>>doScavenge:`).

Two switches: where O makes its object (eden, at `freeStart`, until 2026-11-12; the end of past
space, at `pastSpaceStart`, since), and the stop it writes at.

| Made in | The stop written at | 17 no object written over | 18 no remembered entry lost |
|---|---|---|---|
| eden | any | fails | fails |
| eden | outside a collection | fails | fails |
| eden | and outside machine code (#163's guard) | fails | fails |
| eden | and outside the VM's remembering | fails | holds |
| eden | outside a collection, in machine code or at rest | fails | holds |
| eden | quiet: at rest in the kernel | holds | holds |
| past space | any | fails | fails |
| past space | outside a collection | holds | fails |
| past space | and outside machine code (the code until #167's guard) | holds | fails |
| past space | and outside the VM's remembering (not in the code) | holds | holds |
| past space | outside a collection, in machine code or at rest (the code now) | holds | holds |
| past space | quiet | holds | holds |

What it says:

- **In eden, no stop short of a quiet one is safe**, the guard against machine code included: C's
  allocation is in flight outside machine code too, and there it is O that writes over I's
  header. #137's flake was the JIT's case, I writing over O's.
- **At the end of past space, outside a collection is enough for objects.** The guard against
  machine code added nothing there.
- **The remembered set was open at every stop that is not quiet**, wherever objects are made.
  Stopped inside the VM's remembering, O's entry and I's land at the same index: one is lost,
  and an old object then names a young one the scavenger is not told of. Not seen; the window
  is a few instructions of C.
- **The guard turned round closes it.** Remembering is C, reached from machine code through a
  trampoline (`genStoreCheckReceiverReg:valueReg:scratchReg:inFrame:` only tests the object's
  bit): a VM stopped in machine code is in none of its own routines. So O makes objects and
  remembers at a stop outside a collection where the VM is in machine code or at rest, and
  refuses one in the VM's own code (`ProcessMemory class>>whyNotToAllocateIn:`, since
  2026-11-12; #163's guard refused machine code and let the VM's own code through). The row
  that refuses only the remembering routine needs its place from the VM's symbols and trusts
  the compiler not to have put it inline elsewhere; it is not in the code.

The model has one VM thread, three words and whose object is where; no heap, no free lists (so
nothing of #165), and no reader walking past space with an end it read before the stop, which
misses what O made and is not harmed by it.

## Running the checks

```bash
cd docs/model && ./check_all.sh
```

It needs Java and `tools/tla2tools.jar` (TLA+ 1.7.4, from the TLA+ releases on GitHub,
github.com/tlaplus/tlaplus), which is not kept in the repository. About five minutes on four cores for all 285 checks.
To read a counterexample: `python3 trace.py results/<the check's file>.txt`.
