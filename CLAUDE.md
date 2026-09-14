# Polyphemus — working notes for Claude

Fork of [hogoww/Polyphemus](https://github.com/hogoww/Polyphemus): a tool that reads a Pharo VM's
memory from *outside*, reifying OOPs as Smalltalk objects in a healthy host image.

**This file and the `docs/` notes are fork-only. Never include them in a PR to hogoww.**

## Goal of this fork

Three stages, in order:

1. **Stage 1 (current)** — debug a corrupted *image file*. A snapshot has no stack frames: the VM
   turns every frame into a Context before writing (`divorceAllFrames` +
   `bereaveAllMarriedContextsForSnapshot…`), so stage 1 walks reified contexts, never frames.
2. **Stage 2** — debug a crashed/hung *process* (core dump first, live attach later).
3. **Stage 3** — observe a *live* image: stop/read/resume at the VM's interrupt-check safepoint.

## Environment (on the Ubuntu box, `~/polyphemus`)

| Piece | Value |
|---|---|
| Host image | Pharo 10 (`dev.image`), 64-bit |
| VMMaker | pinned to tag **`v10.0.0`** of `pharo-project/pharo-vm`, `smalltalksrc/` |
| Repo clone | `~/polyphemus/Polyphemus`, registered in Iceberg |
| Rebuild image | `~/build-image.sh` (`VMMAKER_REF=v10.0.0`) |
| Run tests | `~/run-tests.sh [timeout]` → one Pharo process per test class |

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
| `bin/run-tests.sh --all -j 4` | everything (40 classes, 402 tests) | **80 s** |

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
  wants `-j 4`; classes that load an image want `TMO=900`.
- **Watch the image sizes**: `dev.image` ~80 MB, `warm.image` ~524 MB (fixtures preloaded, on
  purpose). They once grew to 896 MB and 1.09 GB because each fixture reset left its resource
  class, and each class held a loaded image. Growth like that is silent; the size is the
  symptom.
- **TDD loop**: `bin/sync-from-working-copy.st` compiles the classes you edited straight
  from the FileTree working copy (Metacello refuses to reload a package whose version is
  unchanged), then run the one test you are working on.

## Current state

Green. The two defects this fork started with — the load-time simulator crash and
`computeOperandStack:` — are fixed, and stage 1 is done.

**Stage 1 reads a snapshot and debugs it.** Processes (including the five a heap scan finds that
the scheduler cannot see), how they are queued and where that disagrees with itself, stacks as
contexts, the source of each frame from the image's own `.sources`, and the arguments and
temporaries of each frame by name and by value. The real `StDebugger` opens on any of it,
post-mortem; `SnapshotProcessBrowser on: memory` is the read-only view. See
`docs/debugging-a-snapshot.md`.

Everything resolves **in the image being read** — instance variables through the receiver's class
there, globals through that image's own `SystemDictionary`, temporaries by analysing that method's
source against that class. Never through ours.

The line a frame is on is highlighted too, in 45 of the 47 frames of the pinned image. A
snapshot has no pc map, so it is built by compiling the method's own source here and **keeping
it only when the bytecodes come out identical to the file's**. Where they do not, nothing is
highlighted. This was written off once, on the grounds that recompiling produced different
bytecodes — it did, because of two bugs in how globals were wrapped and one in `endPC`.

What stage 1 does not do, and why:

- **No stepping, restarting or evaluating.** The buttons are there because it is the real
  debugger; there is no process behind them.
- **The receiver's instance variables in the debugger are the reifier's** (`address`, `memory`),
  not the receiver's in the image being read. Everything else resolves over there.

Damage is read, not only injected: `BlankedContextImageTest` blanks the running process' stack
pointer in the **bytes of a copy of the image**, and never repairs it. That is what found
`readSlot:of:ifUnreadable:` — every check handled the corruption the tests injected, and three
of them raised `KeyNotFound` on the first genuinely damaged file.

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

## Working agreement

- **TDD**: red test first, then the fix. No implementation before a failing test.
- **Prefer a check to a claim.** Where two images have to agree — bytecodes, block order, a
  name — compare them and answer nothing when they disagree, rather than answering something
  plausible. Wrong information in a debugger costs more than missing information.
- Keep changes that upstream would want separable from fork-only files (this file, `docs/`).
