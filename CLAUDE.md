# Polyphemus — working notes for Claude

Fork of [hogoww/Polyphemus](https://github.com/hogoww/Polyphemus): a tool that reads a Pharo VM's
memory from *outside*, reifying OOPs as Smalltalk objects in a healthy host image.

**This file and the `docs/` notes are fork-only. Never include them in a PR to hogoww.**

## Goal of this fork

Three stages, in order:

1. **Stage 1 (done)** — debug a corrupted *image file*. A snapshot has no stack frames: the VM
   turns every frame into a Context before writing (`divorceAllFrames` +
   `bereaveAllMarriedContextsForSnapshot…`), so stage 1 walks reified contexts, never frames.
2. **Stage 2 (done)** — debug a crashed/hung *process* (core dump first, live attach later).
   A dump *has* frames, which is the whole reason for it: they are what a snapshot throws away.
3. **Stage 3 (current)** — a *live* image: interrupt it, hold it, read it, fix it, let it go.
   Much of it arrived with stage 2's editing work; what is left, and what is only believed
   rather than checked, is in `docs/stage3-live-image.md`.

## Environment (on the Ubuntu box, `~/polyphemus`)

| Piece | Value |
|---|---|
| Host image | Pharo 10 (`dev.image`), 64-bit |
| VMMaker | pinned to tag **`v10.0.0`** of `pharo-project/pharo-vm`, `smalltalksrc/` |
| Repo clone | `~/polyphemus/Polyphemus`, registered in Iceberg, on branch **`stage2`** (stage 1 is the tag `stage1-done`) |
| Rebuild image | `~/build-image.sh` (`VMMAKER_REF=v10.0.0`) |
| Run tests | `Polyphemus/bin/tdd.sh` (compile, then run) or `bin/run-tests.sh` |
| A dump to try things on | `~/polyphemus/pharo.core` — `bin/take-dump.sh` makes one; **not** `/tmp`, a reboot clears it |

`VMMaker` here is the **Pharo team's** fork (`pharo-project/pharo-vm`, `smalltalksrc/`), not Eliot
Miranda's `VMMaker.oscog`.

## Why the versions are pinned

- **VMMaker must be `v10.0.0`.** Polyphemus subclasses VMMaker's *test* classes, and
  `VMSpurMemoryManagerTest>>newInterpreter` (called by `AbstractInspectorsTest>>setUpUsingImage:`)
  was removed in v10.0.4. Newer pharo-vm also pulls in `pharo-opal-simd-bytecode`, which a Pharo 10
  image cannot load (floods the log with `CleanBlockChecker … #addMappedInlinePrimitiveHandler:at:`).
- **The clone must be registered in Iceberg.** `PharoImageAccessor>>pathToImageNamed:` resolves test
  images through `IceRepository registeredRepositoryIncludingPackage:`. A `filetree://` Metacello
  load leaves that nil and *every* test errors. A `github://` load registers automatically.
- **`Polyphemus-Builder` needs a second load pass** until the load bug below is fixed.

## Headless Pharo rules (learned the hard way)

1. An unhandled error **hangs** the process — there is no debugger to open. Wrap every snippet in
   `on: Error do: [ :e | … traceCr ]`.
2. The `st` command-line handler does **not** quit by itself. End every script with
   `Smalltalk exitSuccess` (or `Smalltalk snapshot: true andQuit: true` to save).
3. `PackageOrganizer` does not exist in Pharo 10 — it is `RPackageOrganizer`.
4. Never `pkill -f <pattern>` over ssh when the pattern also appears in your own command line: it
   matches the remote shell and kills the session. Use `pkill -x pharo` or `[p]attern`.

## Running tests (`bin/`, fork-only tooling)

Pharo is single threaded *inside* an image, but nothing stops us running many images:
the runner starts one Pharo process per test class and fans them out across the box.

| Command | What it does | Measured |
|---|---|---|
| `bin/run-tests.sh -c Foo -t testBar` | one test | **0.5 s** |
| `bin/run-tests.sh -c Foo` | one class | 1–20 s |
| `bin/run-tests.sh --fast` | everything under 8 s/class | **~10 s** |
| `bin/run-tests.sh` | fast tier, then the slow tier only if fast is green | ~80 s |
| `bin/run-tests.sh --all -j 5` | everything (69 classes, 599 tests) | **~8 min** |

- **A test class that only reads must say so.** `mutatesResource` defaults to true, and a class
  that does not override it is handed `veryDeepCopy` of the interpreter and a 59 MB heap for
  **every test**: 16 s apiece. `SchedulerOnRealImageTest` went from 476 s to 6 s by answering
  false, and the whole suite from ~25 minutes to 80 s.

- **Warm image.** `bin/build-warm.st` snapshots `warm.image` with the interpreted fixture
  already in place, so each test process skips loading a 60 MB image into the simulator.
  The runner defaults to it; `IMAGE=dev.image bin/run-tests.sh` overrides.
  Rebuild it after changing fixture code.
- **Tiers are measured, not guessed**: every run writes per-class seconds to
  `.test-timings`, and anything at or above `SLOW_THRESHOLD` (8 s) moves to the slow tier.
- **Expensive tests deserve their own class**, since tiering is per class.
  `StackPageReificationTest` costs ~18 s only because
  `testInterpretedStateIsRebuiltAfterResourceReset` forces a full fixture rebuild.
- **One run at a time**: starting a run stops the one still going (a pid file, then
  `pkill -x pharo`). Two suites on this box fight for memory — three classes load a 59 MB image
  apiece — and the loser looks like a flaky test rather than an overloaded machine. A full run
  wants `-j 5`, every class in one pool: 418 s. Lanes for the classes that launch images
  (`SERIAL_LANES=n`) were slower -- two 483 s, one 573 s -- and prevented no flake.
- **What bounds a run is memory, not cores** (measured 2026-09-25). A heavy class runs ~2x
  slower beside three others -- 157 s alone, 312 s in company -- whether pinned to the
  performance cores or not, at 100% CPU with no I/O wait: they fight over cache and memory
  bandwidth. So `-j 6` is no faster than `-j 4`, and the lever is doing less, not more at once.
  The image `SpurImageFromDumpTest` writes from the dump (VMMaker's simulated snapshot GC,
  the old floor of every run) is cached in `/tmp/polyphemus-cache`, keyed on the dump and on
  every method of `Polyphemus-Object`.
- **Watch the image sizes**: `dev.image` ~80 MB, `warm.image` ~524 MB (fixtures preloaded, on
  purpose). They once grew to 896 MB and 1.09 GB because each fixture reset left its resource
  class, and each class held a loaded image. Growth like that is silent; the size is the
  symptom.
- **TDD loop**: `bin/sync-from-working-copy.st` compiles the classes you edited straight
  from the FileTree working copy (Metacello refuses to reload a package whose version is
  unchanged), then run the one test you are working on.

## The notes in `docs/`

Fork-only, and the canonical record. `mistakes.md` first if a hunt is going long.

| File | What it settles |
|---|---|
| `mistakes.md` | every wrong turn taken here and what the right way was |
| `image-facts.md` | the Spur image file: header, segments, addresses against file offsets |
| `spur-heap-shape.md` | object headers, recognising a heap by shape, what is at its start, finding the special objects array |
| `frames-and-contexts.md` | frame layout, base frames, marrying and what it costs, what Cog changes |
| `debugging-a-snapshot.md` | the stage 1 guide: processes, stacks, source, temporaries, the debugger |
| `dump-formats.md` | what a dump is and is not, across ELF cores and minidumps |
| `reading-a-dump.md` | reading an ELF core: program headers, notes, segments |
| `reading-a-live-process.md` | `/proc/pid/mem`, Mach, Windows, and why one protocol covers all three |
| `stage3-live-image.md` | what works on a live image, what stage 3 must still do, and what is only believed |
| `editions.md` | which host an edition runs on and which Pharo it reads, its name, what it refuses; one branch, editions as packages |

## Current state

Green: **626 tests, 0 failures** (`bin/run-tests.sh --all -j 5`, 7-13 min). Stage 3 done 2026-09-26; next, editions (`docs/editions.md`). The two defects this
fork started with — the load-time simulator crash and `computeOperandStack:` — are fixed.

### Stage 1 — a corrupted image file. Done.

It reads a snapshot and debugs it. Processes (including the five a heap scan finds that the
scheduler cannot see), how they are queued and where that disagrees with itself, stacks as
contexts, the source of each frame from the image's own `.sources`, and the arguments and
temporaries of each frame by name and by value. The real `StDebugger` opens on any of it,
post-mortem; `SnapshotProcessBrowser on: memory` is the read-only view.

Everything resolves **in the image being read** — instance variables through the receiver's
class there, globals through that image's own `SystemDictionary`, temporaries by analysing that
method's source against that class. Never through ours.

The line a frame is on is highlighted too, in 45 of the 47 frames of the pinned image. A
snapshot has no pc map, so it is built by compiling the method's own source here and **keeping
it only when the bytecodes come out identical to the file's**. Where they do not, nothing is
highlighted. This was written off once, on the grounds that recompiling produced different
bytecodes — it did, because of two bugs in how globals were wrapped and one in `endPC`.

Damage is read, not only injected: `BlankedContextImageTest` blanks the running process' stack
pointer in the **bytes of a copy of the image**, and never repairs it. That is what found
`readSlot:of:ifUnreadable:` — every check handled the corruption the tests injected, and three
of them raised `KeyNotFound` on the first genuinely damaged file.

What it does not do, and why:

- **No stepping, restarting or evaluating.** The buttons are there because it is the real
  debugger; there is no process behind them.
- **The receiver's instance variables in the debugger are the reifier's** (`address`, `memory`),
  not the receiver's in the image being read. Everything else resolves over there.

### Stage 2 — a crashed or stale process. Done.

Reading a dump or a live process, writing a loadable image from one, and editing either --
in place, or by installing methods and the literals they name. `docs/editing-an-image.md`
has the editing; `docs/stage3-live-image.md` carries what was learned about live images
into stage 3. Left over rather than blocking: #27 (holding an image that carries no watcher
of ours), #22 (a flaky test), #12 (waits for a newer VM), #35 (the tidy-up this work owes).

A dump is memory that was already running, so it is put back at its original addresses and the
`bytesToShift` an image needs is zero. Reading one is *simpler* than reading an image file — the
hard part is that nothing in a dump says where anything is.

What exists:

- **Reading the bytes.** `ElfCoreDump` answers three messages — `hasAddress:`,
  `bytesAt:count:`, `unsignedAt:size:` — from a file, through one open stream and a 64 KB block
  cache. `ByteArrayAddressSpace` answers the same three from bytes in hand. Nothing above them
  learns which it is holding, which is where `/proc/pid/mem` and the Mach and Windows calls will
  plug in.
- **Finding the heap.** `SpurHeapScanner` finds old space by its shape: the nil/false/true
  triple, then believed only if the walk from it runs. On a real 204 MB core it found the heap
  and walked **1,106,303 objects across 92 MB**. `SpurHeapWalk` counts live objects and free
  chunks apart, so the walk also measures the image: **76.9 MB live**, which is exactly the size
  of that image's file on disk.
- **The registers.** Heap start, the end, and now `specialObjectsOop` —
  `#specialObjectsArrayFrom:upTo:` finds it by contents, since the VM keeps it in a variable and
  a dump has no image header. All three are obtainable from the dump alone.
- **Frames as activations.** `OOPAbstractStackFrame` answers the Context protocol — `receiver`,
  `method`, `pc`, `stackp`, `tempAt:`, `sender` — so the debugger opens on a stack of frames the
  same way it opens on a stack of contexts, and a base frame's caller context is reached with
  `#oopPageCaller`.

The order of what remains, decided rather than assumed:

1. ~~The dump's heap into a reified memory.~~ **Done.** `SpurDumpedMemory` takes the seat
   `SpurImageReader` sits in; on a real 219 MB core it reifies **1,106,398 objects** and finds
   **11 processes with their states**. Lazily and without writing, because the full reifier
   rebuilds the free lists of the memory it reads. New space is declared empty and that is a
   stated limitation — the running process lives there, readable by address but absent from
   enumerations. `docs/reading-a-dump.md` has the whole of it.
   ~~Next, and small: walk eden by shape.~~ **Done.** `#youngObjectsWalk` finds new space's
   objects by shape and stops where the allocation mark would be. The running process lives
   there: processes found went from 11 to 17, one of them `#active` at last.
2. ~~Live reading through `/proc/pid/mem`.~~ **Done, and it needs no FFI.** `LinuxProcessMemory`
   answers the same three messages plus `loadableSegments`, so `SpurDumpedMemory` takes one where
   it takes a core file. `#writeDumpTo:` writes an ELF core our own reader reads back, so a dump
   can be taken from Pharo with no debugger.
   Being *allowed* to read turned out to be the real work: `bin/pharo-debuggable` and
   `LinuxObservationPermission` let an image consent, so one image reads another with
   `ptrace_scope` left at 1. `docs/reading-a-live-process.md` has it.
   ~~Still missing: stopping the target first.~~ **Done.** `#whileStopped:` sends SIGSTOP,
   reads, and SIGCONT afterwards -- which needs no permission beyond being allowed to signal,
   unlike reading. Held still, a live image reads with every rung of the ladder passing.
3. **JIT frames properly.** ~~Detect and refuse.~~ ~~Read a dump's frames past the married
   context, in Cog's layout.~~ **Done** through `OOPCogLayout`: 24 contexts became 77 activations
   on the real core, and #3 (jitted method headers) is fixed on the way;
   `docs/frames-and-contexts.md` has it. Eden (#8) is walked
   from the VM's own variables (`VMVariables`, `docs/reading-a-dump.md`). Trampolines by name,
   each page's newest frame and its pc (the page records), and the running process (the VM's
   saved registers, checked against the threads' `rip`) are done. A machine code pc is
   mapped by VMMaker's own Cogit over the dump. **Item 3 is done**, for cores and for
   stopped live processes (`/proc/<pid>/task/*/syscall` gives each thread's pc). Item 4 is parked until these are done.
4. **Editing and writing back** -- unparked 2026-09-19. **a. Done:** `SpurImageEdit` (since #35, `SpurEdit` on a
   `SpurWritableImageFile`) edits an image file's objects in a copy of its bytes, addressed as its heap addresses them, and writes
   the copy out. Repairing the blanked-context fixture's slot with the clean image's word gives
   back the clean file byte for byte. **b. Done:** `SpurImageFromDump` writes a dump as an image file a virtual machine starts:
   jitted method headers restored from their CogMethods, frames divorced into contexts (JIT pcs
   through Cog's map), widowed contexts bereaved, then VMMaker's own `garbageCollectForSnapshot`
   and `SpurImageWriter`. Read back it climbs every rung of the ladder, each of its processes
   has the stack it had in the dump, and the machine running these tests loads the file and goes
   on running it (`docs/reading-a-dump.md`). The C
   stack (#18) and jitted code (#19) are shown, never edited: the JIT regenerates machine code.

## Open question, raised 2026-09-15 - partly answered 2026-09-16

**Answered for stage 2, in `SpurReadability`.** Reading is a ladder - bytes, heap, objects, free
space, classes, special objects - each rung checked, each question declaring the rung it needs,
and anything above the highest readable rung raising `SpurCannotRead` with the level and reason
rather than answering. `docs/reading-a-dump.md` has the table. **Done 2026-09-19:** stage 1's
image path climbs the same ladder (`SpurImageFile`, checked in `Polyphemus readImageFile:`), and
the rung above, source, is `SourceReadability`.

The original note follows, because the reasoning still applies.

## Open question, raised 2026-09-15

**What if the damage is in the thing we read with?** Everything here is reached through
structures that could themselves be the corrupted ones: the special objects array, the class
table, the class identity of the running process (which is how every other process is found),
the method headers, the source pointers and the sources file. A stage-one tool is for images
that are damaged, so the case where it cannot read is exactly the case it exists for.

Worth thinking about, not answered:

- Find objects by **shape** rather than by class identity, so a broken class table costs less.
- Cross-check the paths that overlap — the scheduler's queues against a heap scan, a method's
  trailer against its bytecodes — and **say which one disagreed** rather than picking one.
- Report *why* something is unreadable, naming the structure that failed, instead of answering
  nothing. The reports already do this for slots (`#suspendedContextIsUnreadable`); the
  structures we navigate by do not.
- The free-list recovery work on the `recoveryFreeListV2` branch (issue #20) is the same
  problem from the other end.

## Cog is the real case, and the split is not where it looks

Every image anyone runs is run by **Cog**: every dump and every live process we have read is a
Cog VM. The StackInterpreter is the simulator we host a *heap* in, not a VM anyone uses.

The line that matters is not Cog against StackInterpreter, it is:

- **The object memory is the same in both.** Spur is Spur, so VMMaker's memory manager, its
  allocator, its stores, its collection and its image writer are reused whole, on a dump as on
  an image file.
- **The execution state is Cog's**: frames on stack pages, a code zone of CogMethods, machine
  code pcs. There we reuse VMMaker's *descriptions* -- `CoInterpreter class>>initializeFrameIndices`,
  `CogStackPageSurrogate64`, `CogMethodSurrogate64`, the Cogit's map -- through `OOPVMLayout`,
  but not its engine, because a dump's frames and code zone are outside the simulator and
  building a `CogVMSimulator` costs a native processor emulator and the frame-constants pool
  (#23).

So: anything about objects goes through VMMaker. Anything about frames or compiled code goes
through the layout, which is Cog's for a dump or a live process and the StackInterpreter's for a
snapshot opened in the simulator. Stage 3 (a live image) is where Cog's own machinery may be
worth its cost; #23 holds what that would take.

## Working agreement

- **Bugs go to GitHub issues** on `Alisu/Polyphemus` -- `gh` on the box is logged in as Alisu and the clone's default is the fork, so `gh issue create` never lands on hogoww's. A bug gets an issue first -- what fails,
  how to reproduce it, what was ruled out -- then a regression test that names it (`"#12"` in its
  comment), then a fix whose commit says `Fixes #12`. The investigation lives in the issue, not
  in code comments. **Features stay plain TDD**: red test, then code, no issue needed.
- **Method comments are one to three lines**: what the method does, and any trap a caller must
  know. History ("an earlier version..."), measurements and the reasoning behind a design go in
  the issue, the commit message or `docs/`. On 2026-09-19, 98 comments longer than six lines were
  cut to this; the originals are in git history.

- **TDD**: red test first, then the fix. No implementation before a failing test.
- **Prefer a check to a claim.** Where two images have to agree — bytecodes, block order, a
  name — compare them and answer nothing when they disagree, rather than answering something
  plausible. Wrong information in a debugger costs more than missing information.
- **Measure before adding a guard.** A filter that looks prudent may carry no weight: the
  special objects array is found with no size check because measuring showed one was not
  needed, and the numbers in `docs/` are there so the next person need not take our word.
- **When two things that should agree don't, suspect your own side first.** Highlighting was
  written off on the grounds that recompiling gives different bytecodes; it was three of our
  own bugs, and every method frame of the pinned image now recompiles byte for byte.
- Keep changes that upstream would want separable from fork-only files (this file, `docs/`,
  `bin/`).
