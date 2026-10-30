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
| `excess` | the semaphore's 3rd slot (`excessSignals`) | signals not yet consumed; W waits on it, A spins on it as its bell |
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
   (stop, `excess := excess + 1`, resume).
6. W sees `excess > 0`, runs `do.st`: A starts, creates `channel/`, writes `serving` unless `go`
   is there already.

### The agent serving (`sourceServing:bell:limit:`)
- Loop, spinning (no yield, priority 70): wait until `excess > 0` or `now - last > limit`.
  - Rung: `excess := 0`; if `request.(count+1)` exists, answer it (`answer.(count+1)`); else read
    `go`: if there, end.
  - Limit passed (an hour by default, none with `holdLimit: nil`): write `expired`, run `letGo`
    if the image's debugger left one, end.
- After A ends, W writes `released` and waits on the semaphore again.

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
5. **A ring meant for A never makes W hold again** once A has ended. *The code does not have this
   property today*: `limitations.md` says a hold ending as O asks can hold the image once more,
   for up to a minute (W's 60 s). The model should show the interleaving.
6. **The trap fires at most once**, and is never left installed after `runUntil:` gives up.

Liveness (something good eventually happens):
7. **Every ask ends**: answered, refused as expired, refused as gone, or timed out.
8. **If O dies, I runs again**: within W's 60 s before A starts, within the hold limit after (#96).
   Not with `holdLimit: nil`, which is documented.
9. **After a let-go that succeeded, U runs again.**
10. **Two observers never hold each other for ever** (#117): to model with two O's and two I's.

## What the model leaves out

- Memory, readings, copies: no Spur, no heap. That side is for the invariants in tests.
- Timing beyond order and timeouts: a timeout is a step that may happen when its condition holds.
- What a request does inside the image: an answer is one step.

## Results (TLC 2.19, 2026-10-30)

`Hold.tla` (version 2, with the trap of `runUntil:` and Pharo's semaphore wait) checks properties
5 to 9 on a small instance: one observer, one image, a plain hold with one request, then a
`runUntil:`; either side dying at any step; the agent's hour running out at any step. Timing kept
realistic: a live observer acts within the watcher's 60 s unless paused (idle, or its user
deciding), and its own deadlines pass only when the image can make no step. `check_all.sh` runs
every combination, and leaves each counterexample in `results/`; `trace.py` prints one step by step.

| Design | 5 no stray hold | 6 no trap left | 7 every ask ends | 8 runs if the observer dies | 9 runs when through |
|---|---|---|---|---|---|
| Today: SIGSTOP, one semaphore | fails (16 steps) | fails (41 steps) | holds | fails (4 steps) | holds |
| Separate bell only | holds | holds | holds | fails (4 steps) | holds |
| Stop that ends with the observer only | fails | fails | holds | holds | holds |
| Both | holds | holds | holds | holds | holds |

What the failures are:
- **5, stray hold:** the observer writes a request; before its ring, the agent reaches its hour and
  ends; the ring wakes the watcher, which holds the whole image again, with no agent, for 60 s
  (the "hold once more" case of limitations.md).
- **6, trap left installed:** a ring left over from an earlier let-go makes the watcher start the
  next agent early; that agent takes the serving ring for the request's, the real request ring comes
  after it ended, and the observer gives up with the trap it asked for still in the image.
- Both have one cause: the watcher's interrupt and the agent's bell are one semaphore, so rings get
  out of step. **Fix: the agent rings on a bell of its own that nobody waits on.**
- **8:** the observer dies while the image is stopped (SIGSTOP, task suspend): stopped for ever
  (#96). **Fix: a stop the system ends when the observer dies**: a stop helper (#137): it holds
  the SIGSTOP and lets the image go when the observer says so, dies, or cannot within a bound.
  Tried on macOS on 2026-10-30, all three cases work. Polyphemus stops with SIGSTOP on macOS too.

Not modelled yet: putting the watcher in (2, 4), one agent per folder (1); two observers (10) are
in `HoldPair.tla`.

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

## Running the checks

```bash
cd docs/model && ./check_all.sh
```

It needs Java and `tools/tla2tools.jar` (TLA+ 1.7.4, from the TLA+ releases on GitHub,
github.com/tlaplus/tlaplus), which is not kept in the repository. About a minute for all 30 checks.
To read a counterexample: `python3 trace.py results/<the check's file>.txt`.
