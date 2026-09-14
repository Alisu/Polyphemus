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
| `bin/run-tests.sh --fast` | everything under 8 s/class (32 classes, 248 tests) | **7 s** |
| `bin/run-tests.sh` | fast tier, then the slow tier only if fast is green | ~27 s |
| `bin/run-tests.sh --all -j 8` | everything (35 classes, 347 tests) | **27 s** |

- **Warm image.** `bin/build-warm.st` snapshots `warm.image` with the interpreted fixture
  already in place, so each test process skips loading a 60 MB image into the simulator.
  The runner defaults to it; `IMAGE=dev.image bin/run-tests.sh` overrides.
  Rebuild it after changing fixture code.
- **Tiers are measured, not guessed**: every run writes per-class seconds to
  `.test-timings`, and anything at or above `SLOW_THRESHOLD` (8 s) moves to the slow tier.
- **Expensive tests deserve their own class**, since tiering is per class.
  `StackPageReificationTest` costs ~18 s only because
  `testInterpretedStateIsRebuiltAfterResourceReset` forces a full fixture rebuild.
- **TDD loop**: `bin/sync-from-working-copy.st` compiles the classes you edited straight
  from the FileTree working copy (Metacello refuses to reload a package whose version is
  unchanged), then run the one test you are working on.

## Current state

Baseline: **273 tests run, 0 failures, 9 errors**, all in `StackPageReificationTest`.

Two open defects, same subsystem:

- **Loading.** `StackPageReificationTest class>>initialize` calls `self currentImage`, so *loading
  the package* downloads an image and runs the simulator, which dies with `AssertionFailure` in
  `StackInterpreter>>contextInstructionPointer:frame:`. The load aborts before
  `Polyphemus-Builder`, leaving `OOPBuilder` undefined.
- **Stack frames.** `OOPAbstractStackFrame>>computeOperandStack:` sends `last` to an empty
  `operandStack` (`SubscriptOutOfBounds: 0`) when a frame has no operands, and uses
  `remove: operandStack last` where it means `removeLast` — with duplicate oops on the stack that
  removes the wrong element.

## Working agreement

- **TDD**: red test first, then the fix. No implementation before a failing test.
- Fix the loading, the stack pages and their tests before adding stage 1 code.
- Keep changes that upstream would want separable from fork-only files (this file, `docs/`).
