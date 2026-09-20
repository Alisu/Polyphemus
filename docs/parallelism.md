# The VM's components, and what threading each one would buy

Measured on the box on 2026-09-20 against the pinned VM (`pharo-vm/lib/pharo`, Pharo 9.0.22,
built 2023-03-30, with `lib/libPharoVMCore.so` carrying DWARF), VMMaker **v10.0.0** in the host
image, and `resources/cleanP10.image` (59 MB, 844,507 objects). Nothing here is recalled; every
claim names what it was checked against.

Written for the question *which component of this VM was worth threading*, not for the question
*how do we run many images* -- that one is answered at the end, briefly, because it is what the
fork actually relies on.

## 1. The components

From VMMaker v10.0.0's own class hierarchies. "State" is the instance variables of the root
class, which is what the C generator emits as process-wide variables.

| Component | Root class | Classes | Methods | State | What it owns |
|---|---|---|---|---|---|
| Interpreter | `StackInterpreter` | 11 | 1,980 | 106 | bytecode dispatch, sends, primitives, process scheduling, interrupt checks, event polling |
| ... with the JIT's half | `CoInterpreter` | 5 | 676 | **128** | stack pages, machine-code entry/exit, the code zone's owner |
| JIT | `Cogit` | 5 | 1,443 | 154 (`StackToRegisterMappingCogit` **187**) | compiling methods to machine code, inline caches, trampolines, the pc map |
| JIT back ends | `CogAbstractInstruction` | 12 | 1,594 | 11 | per-processor instruction selection and encoding |
| Object memory | `SpurMemoryManager` | 11 | 1,440 | **77** | allocation, old/new space, class table, forwarders, `become:`, the image reader's seat |
| Scavenger | `SpurGenerationScavenger` | 2 | 98 | 24 | new-space collection, tenuring, the remembered set |
| Compactors | `SpurCompactor` | 7 | 135 | 4 | `SpurPlanningCompactor`, `SpurSweeper`, `SpurSelectiveCompactor`, `SpurHybridCompactor` |
| Segments | `SpurSegmentManager` | 1 | 50 | 10 | growing and shrinking old space in segments |
| Code zone | `CogMethodZone` | 2 | 72 | 15 | allocation and compaction of machine code |
| Image reader/writer | `SpurImageReader`/`Writer` | 1 + 1 | 12 + 12 | 4 + 4 | snapshot in and out |
| Plugins | `InterpreterPlugin` | 42 | 1,143 | 4 | named primitives, including FFI |
| Struct surrogates | `VMStructType` | 36 | 2,046 | 0 | how Smalltalk code addresses C structures |
| All of VMMaker | `VMClass` | 113 | 7,888 | | |

Outside VMMaker, in the platform layer (DWARF compilation units of `libPharoVMCore.so`):
`heartbeat.c`, `aio.c` (events), `sqExternalSemaphores.c`, `threadSafeQueue.c`,
`platformSemaphore.c`, and the FFI: `pThreadedFFI.c`, `sameThread/sameThread.c`,
`worker/worker.c`, `callbacks/callbacks.c`.

The generated interpreter is `generated/64/vm/src/gcc3x-cointerp.c` -- `cointerp`, **not**
`cointerpmt`. Confirmed in the running image: `Smalltalk vm version` begins
`CoInterpreter VMMaker-tonel.1`.

## 2. Four different things "a threaded VM" can mean

They are usually conflated, and they have very different costs and payoffs.

**(a) A reentrant VM.** No process-wide mutable state: every function reaches the VM's variables
through a parameter. This buys no parallelism by itself; it is the prerequisite for everything
else, including (c). The scale of the job, counted in the pinned binary:

| | |
|---|---|
| mutable process-wide globals in `libPharoVMCore.so` | **561** (495 BSS, 66 initialised data) |
| thread-local storage of any kind | **none** -- no TLS program header, no TLS symbols, no `__tls_get_addr` |
| interpreter register cache, as single globals | `stackPointer` 0x30d318, `framePointer` 0x30d308, `instructionPointer` 0x30d2d0, `method` 0x30d2f8, `newMethod` 0x30d2c0, `argumentCount` 0x30d300, `primFailCode` 0x30d310 |

VMMaker already contains the ancestor of this work: **`CCodeGeneratorGlobalStructure`**
(superclass `MLVMCCodeGenerator`, 10 methods), which emits `SQ_USE_GLOBAL_STRUCT` and
`USE_GLOBAL_STRUCT_REG` and puts the globals into one struct, optionally pinned in a register.
`checkForGlobalUsage:in:` already decides which variables are global and marks the methods that
reach them (`referencesGlobalStruct`), and `placeInStructure:` decides what goes in.
`CCodeGenerator>>localizeGlobalVariables` already demotes single-use globals to locals.

**Nothing in v10.0.0 instantiates `CCodeGeneratorGlobalStructure`** -- it is unused, and the
pinned binary was not built with it (561 file-scope globals is the proof). The distance from that
generator to a reentrant VM is exactly one decision: reach the struct through a global pointer,
or receive it as an argument. There is no other trace of reentrancy work in v10.0.0 -- no method
mentions `selfArgument`, `vmArgument`, `perThread`, `threadLocal` or `reentrant` (the single
"reentran" hit is a comment in `StackInterpreter>>checkForEventsMayContextSwitch:`).

**(b) Several interpreters over one object memory.** N mutator threads running Smalltalk at once.
Reentrancy is necessary and nowhere near sufficient, because the moment two interpreters share a
heap, every shared structure needs a protocol:

| Shared thing | Why it is hard |
|---|---|
| allocation | one bump pointer into eden; needs per-thread allocation buffers |
| the scavenger and full GC | must stop *all* mutators, and roots now live on N stacks |
| the remembered set | written by every store to an old object from any thread |
| `become:` and forwarders | a forwarder followed by one thread while another installs it |
| the class table | grown while another thread looks a class up |
| the method cache and at-cache | 4,096-entry direct-mapped caches, written on every miss |
| the JIT code zone | one arena; compaction moves code other threads are executing |
| inline caches | patched in place in running machine code |
| stack pages | `numStackPages` pages, married/divorced contexts, a per-thread set needed |
| `Semaphore`, `Process`, `Processor` | Smalltalk-level scheduling assumes one runnable process |

And above all of it, the language's own promise: Smalltalk code has never had to assume a store
could be observed half-done. Every image in existence was written against one interpreter.

**(c) Threading one component while the mutator stays single-threaded.** No change to language
semantics, no shared-heap protocol, and it can use the idle cores. Candidates: the collector
(parallel marking, concurrent sweeping, incremental or concurrent compaction), the JIT
(compiling on a background thread and publishing atomically), snapshot writing, finalization and
weak processing, and event polling. This is the option this note argues for, and section 4 is
why.

**(d) Many images, one thread each.** What the fork does now. Section 6.

## 3. Where the time actually goes

The ceiling on threading any component is the share of wall time that component uses. Measured in
a fresh process per workload, GC figures from `Smalltalk vm fullGCCount / totalFullGCTime /
incrementalGCCount / totalIncrementalGCTime / tenureCount`:

| Workload | Wall | Full GCs | in full GC | Scavenges | in scavenges | Tenures | **GC share** |
|---|---|---|---|---|---|---|---|
| survivor-heavy allocation (6 M arrays, 300 k kept live) | 1,773 ms | 13 | 1,380 ms | 40 | 226 ms | 5,432,611 | **90.6 %** |
| **Polyphemus reifying `cleanP10.image`** | 10,656 ms | 8 | 611 ms | 647 | 2,796 ms | 884,298 | **32.0 %** |
| pointer-chasing over every class, nothing surviving | 297 ms | 0 | 0 ms | 39 | 7 ms | 0 | **2.4 %** |

The middle row is the one that matters here: it is what this tool does for a living, and a third
of it is the collector.

The JIT's own bookkeeping, by contrast, is noise. The VM counts it, but the image cannot read it
(`Smalltalk vm compiledMethodsCount` is parameter 75, and this VM answers **nil** for 75 to 78),
so these were read out of a live image by symbol name with Polyphemus' own
`VMVariables>>addressOf:`, after a mixed workload of 3 M survivor-heavy allocations and 12 passes
over every class:

| Counter | Value |
|---|---|
| `statFullGCUsecs` | 607,612 µs |
| `statScavengeGCUsecs` | 120,159 µs |
| `statCompactionUsecs` | **353,214 µs** -- 58 % of the full-GC time above |
| `statCodeCompactionCount` | **1** |
| `statCodeCompactionUsecs` | **669 µs** |
| `statIdleUsecs` | 210,078 µs |
| `statForceInterruptCheck` / `statCheckForEvents` / `statProcessSwitch` | 793 / 408 / 56 |
| `statStackOverflow` / `statStackPageDivorce` | 31,007 / 0 |

**728 ms of collector against 0.67 ms of code-zone management, in the same run.** The machine code
zone is 1.4 MB (parameter 46) and it compacted once.

## 4. So which component was worth threading

**The collector, and within it the compactor.** It is where the time is (32 % of the work this
tool does, 90 % of a survivor-heavy load), the compaction phase is 58 % of full-GC time, and none
of it requires the mutator to be multi-threaded. Two distinct wins, worth separating:

- **parallel collection** -- N threads inside the existing stop-the-world pause. Shortens the
  pause itself. The marker is the obvious target (per-thread mark stacks with work stealing); the
  planning compactor's passes are more ordered and harder to split.
- **concurrent collection** -- collect while the mutator runs. Does not reduce total CPU, it moves
  work off the critical path, which on a box with idle cores converts almost directly into wall
  time. Spur already has the write barrier this needs, because the generational scavenger already
  maintains a remembered set.

With one mutator thread, the arithmetic is Amdahl's and it is favourable: hiding the collector
entirely would take the reification workload from 10.7 s to about 7.3 s, and no Smalltalk
semantics change.

**The JIT was not worth threading.** 669 µs. Background compilation is the right design for a VM
whose compiler is expensive (a tracing or optimising JIT); Cog's template JIT is cheap enough
that moving it off-thread buys nothing measurable, and it would cost atomic publication of code
and safe inline-cache patching.

**Snapshot writing** is a genuine but narrow win: it is a bounded pause proportional to heap size,
and `fork()` plus copy-on-write is the cheap version, needing no VM threading at all.

**Finalization and weak processing** are small here but would follow the collector's design for
free.

**Event polling** is already effectively off the critical path: it runs on the interpreter thread
but only when the image would otherwise idle (`aioPoll` is called from
`ioRelinquishProcessorForMicroseconds`), and the measured `statIdleUsecs` shows the VM already
accounting for that time as idle.

**Several interpreters was the least rewarding of the options**, which the retrospective doubt was
right about. It carries the whole table in section 2(b), it changes what every existing image is
allowed to assume, and it does not speed up one program at all -- it only lets two programs share
a heap, which is a thing few Pharo workloads want and which many images cannot survive. The
throughput it would add is already available, safely, by running more images (section 6).

## 5. What the de-globalisation actually bought

It is the prerequisite for the *good* option, not only for the abandoned one. A parallel marker
needs per-thread mark stacks; a concurrent collector needs its own state separate from the
mutator's; a background JIT thread needs the Cogit's 187 fields not to be one global set. Every
form of threading in section 2(c) needs the VM's state to be addressable per worker, which is
exactly what passing it as an argument gives.

So the 561 globals were the right thing to attack, and `CCodeGeneratorGlobalStructure` shows the
VM's own authors had gone as far as putting them in one struct and stopped there. What the work
lacked was not the refactor but the *next* choice: it went towards (b), several interpreters, when
(c), one threaded component, is where this VM's time is.

## 6. The pinned VM as it stands, for the record

**Not a threaded VM.** No symbol matches `cogmt`/`mtvm`/`multithread`. `CoInterpreterMT`,
`CogThreadManager` and `CogVMThread` are absent from v10.0.0, and `COGMTVM` has **0 senders**
across its 113 `VMClass` subclasses. `ownVM`/`disownVM` exist but are stubs that shuffle
`inFFIFlags`, `newMethod` and `argumentCount`; **nothing calls them** (they appear only as two
`R_X86_64_GLOB_DAT` relocations in the interpreter proxy, and no shipped plugin imports them).
`ceTryLockVMOwner`/`ceUnlockVMOwner` are BSS variables no instruction references, and their
VMMaker counterparts `Cogit>>cogitTryLockVMOwner`/`cogitUnlockVMOwner` have no senders but
themselves.

**Two OS threads.** Only three `pthread_create` call sites exist: `ioInitHeartbeat`,
`vm_main_with_parameters` (the `--worker` path) and `worker_newSpawning`. A headless image at rest
has the interpreter (in `select()` inside `aioPoll`) and the heartbeat
(`pthread_create(beatStateMachine)`, in `nanosleep` or parked on a futex while the VM polls).
There is **no event thread**: `aioPoll` is called only from `ioProcessEvents` and
`ioRelinquishProcessorForMicroseconds`. Each `TFWorker` adds exactly one thread -- measured 2, 3,
5, 8 threads for 0, 1, 3, 6 workers.

**Green processes serialise exactly.** Fixed work per process, one image: 169 / 337 / 674 /
1361 ms for 1 / 2 / 4 / 8 processes (1.00 / 1.99 / 3.99 / 8.05). They do interleave rather than
starve -- two non-yielding loops at equal priority both advanced -- because any preemption puts
the running process at the back of its queue and the heartbeat forces checks constantly. Fair,
not parallel.

**A foreign thread cannot enter Smalltalk.** `callbackFrontend` calls
`queue_add_pending_callback` and blocks; the Smalltalk side drains it with
`primitiveReadNextCallback` -> `queue_next_pending_callback`, in an ordinary Pharo process
(`'Callback queue'` at priority 70, visible in a stock image's process list). The only thing a
foreign thread may do is `signalSemaphoreWithIndex`: take a mutex, set a word in
`signalRequests`, leave; the interpreter collects it at `checkForEventsMayContextSwitch` ->
`doSignalExternalSemaphores`.

**Threaded FFI** is compiled in and is the current backend (`TFFIBackend`). Measured with the VM's
own `libTestLibrary.so`, each runner in its own fresh image: same-thread **0.10 µs/call** but a
3 s C call freezes the whole image (a 500 ms `Delay` returned after 3001 ms); worker
**10.79 µs/call** and the image ran 1,054,200,000 iterations during the same call. A plain
Smalltalk send is 0.011 µs. `FFILibrary>>runner` defaults to `TFSameThreadRunner uniqueInstance`,
so workers are opt-in per library. Beware: UFFI caches the bound callout in the compiled method,
so two runners exercised in one image share whichever bound first.

**Across images.** An idle instance of the 59 MB image is 84.7 MB RSS, 76.8 MB of it private
dirty, only 3.1 MB shared; 16 instances cost 1.24 GB of `MemFree`, so ~79 MB each. Startup is
0.14 s. Fixed CPU work in N concurrent instances gives aggregate throughput 1.00 / 2.01 / 3.37 /
3.59 / 4.02 / 3.89 / 3.93 / 3.45 for N = 1 / 2 / 4 / 6 / 8 / 10 / 12 / 16 -- a plateau near **4x**
around N=8, falling back past 12, on a box with 18 CPUs but a 28 W power budget shared with an
Android emulator. **Memory allows ~240 instances; the CPU allows about 8.**

## 7. Reading the VM's own accounting from outside

Worth keeping for its own sake: the counters in section 3 were not available to the image. This
VM answers **nil** for parameters 75 to 78, so `Smalltalk vm compiledMethodsCount` and
`compiledBlocksCount` cannot be asked. Polyphemus read them anyway, from a live process, by
symbol name through `VMVariables>>addressOf:` with the build id checked -- `statFullGCUsecs`,
`statCompactionUsecs`, `statCodeCompactionUsecs` and the rest, as 8-byte words at the addresses
the shared object declares.

So the tool can measure a VM that will not report on itself. Any VM global is fair game by name.
