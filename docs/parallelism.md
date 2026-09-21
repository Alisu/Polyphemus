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

## 8. Breaking the god classes down, and what that reveals

`StackInterpreter` and `SpurMemoryManager` are god classes, and the question is whether the
breakdown exposes parallelisation candidates the component list in section 1 hides. It does, but
not the ones expected -- and one of them turned out not to be worth it, which is recorded here
because measuring it is the only reason we know.

Measured by asking, for every method, which instance variables it reads or writes
(`CompiledMethod>>readsField:`/`writesField:`), then grouping by VMMaker's own method protocols.

| Class | Methods | Ivars | Protocols | Ivars only one protocol touches | Ivars its own methods never touch |
|---|---|---|---|---|---|
| `StackInterpreter` | 880 | 106 | 57 | 28 | 4 |
| `CoInterpreter` | 352 | 128 | 37 | 23 | 66 |
| `SpurMemoryManager` | 976 | 77 | 59 | 6 | 0 |
| `StackToRegisterMappingCogit` | 245 | 187 | 22 | 27 | 118 |

### The memory manager splits cleanly; the interpreter does not

**`SpurMemoryManager` has 148 methods that touch no instance variable at all** -- pure functions
over an address or a header word:

| Protocol | Methods |
|---|---|
| header access | 28 |
| header format | 27 |
| header formats | 24 |
| ffi - helpers | 12 |
| class table puns | 11 |
| object format | 10 |
| forwarding | 9 |
| immediates | 7 |
| heap management | 6 |
| word size | 4 |

That is the object-representation algebra -- header decoding, format predicates, tagging,
forwarding tests -- and it is **already stateless**. It is the first thing to extract, it makes
everything above it testable without a heap, and it is what any parallel worker needs to be able
to call safely. This matters more than it looks: the enabling condition for threading a GC phase
is that the phase's helpers have no shared mutable state, and here a sixth of the memory manager
already satisfies it.

Then come services whose state is narrow, each a plausible class:

| Protocol | Methods | Ivars touched |
|---|---|---|
| object access | 63 | 4 |
| object testing | 58 | 8 |
| free space | 61 | 13 |
| object enumeration | 40 | 10 |
| interpreter access | 36 | 4 |
| obj stacks | 33 | 10 |
| class table | 27 | 8 |
| allocation | 23 | 7 |
| snapshot | 20 | 14 |
| become implementation | 16 | 7 |
| weakness and ephemerality | 16 | 7 |
| instantiation | 13 | 2 |

And the part that resists: `accessing` (102 methods, **53** of the 77 ivars), `gc - global` (24
methods, **33** ivars), `gc - scavenging` (15 methods, 22 ivars). Ivar fan-out confirms it -- most
ivars are touched by two to five protocols, and three of them by ten. So the collector core is the
most entangled region of the most splittable class, which tempers section 4: parallelising marking
is the right target, but marking reaches a third of the memory manager's state.

**`StackInterpreter` has only 4 pure methods**, and its state does not cluster: `initialization`
alone touches 53 of 106 ivars. What it has instead is behavioural seams:

| Cluster | Protocols | Methods |
|---|---|---|
| execution engine | stack / return / jump / send / sista bytecodes, common selector sends | 163 |
| frames and stack pages | frame access (80, 8 ivars), stack pages (23, 8 ivars) | 103 |
| debugging | debug printing (82, 16 ivars), debug support (40, 16 ivars) | 122 |
| primitive dispatch | primitive support, indexing primitive support | 57 |
| plugin bridge | plugin primitive support | 26 |
| scheduler | process primitive support (27, 22 ivars) | 27 |
| image in and out | image save/restore | 18 |

The debugging surface is the largest single block and the cheapest to move: 122 methods on 16
ivars, none of it on any hot path. `frames and stack pages` is the next cleanest -- 103 methods on
about 8 ivars -- and it happens to be exactly the region Polyphemus reimplements from outside.

### The candidate this raised, priced, and rejected

`object enumeration` (40 methods) looked like the find: `allObjects`, `allInstancesOf:`,
`objectsReachableFromRoots:`, `nextObject`, `printReferencesTo:` are stop-the-world **linear walks
over old space**, which is the textbook embarrassingly-parallel shape, splittable by segment, and
resting entirely on the stateless layer above.

Priced on the host image (113.8 MB of old space):

| | |
|---|---|
| `Array allInstances` (a full heap scan) | **8 ms**, 169,486 found |
| `CompiledMethod allInstances` | **8 ms**, 152,532 found |
| a warm full GC on the same heap | **52 ms** |

**8 ms.** Splitting it four ways saves six milliseconds, against a collector costing 52 ms on the
same heap and 611 ms across the reification workload. So it is not worth threading inside the VM,
and the candidate is withdrawn. It is recorded because the shape was convincing and only the
measurement said otherwise.

Where that work *is* worth parallelising is one level up: Polyphemus' own walk of a foreign heap
reads 844,507 objects through `/proc/<pid>/mem` and is the bulk of the 10.7 s reification (the
collector accounts for 3.4 s of it). That is our Smalltalk, not the VM's C, and the parallelism
available to it is the one that already works here -- several processes over disjoint address
ranges.

### What the breakdown is worth, then

Two things, and threading is the smaller of them. The extraction is worth doing for its own sake:
a stateless representation layer, a frame/stack component, and 122 methods of debugging lifted out
of the interpreter would make the VM legible, and would let a tool like this one reuse rather than
reimplement. For parallelism it changes the conclusion only by narrowing it: the collector is
still the prize, marking is still the target, and the 148 stateless methods are the reason a
parallel marker is feasible at all.

## 9. How entangled, and how many pieces

Section 8 found the seams. This asks the blunter question: if you pulled the shared state apart,
how many independent pieces would there be? Measured by treating protocols as nodes, drawing an
edge wherever two protocols touch the same instance variable, and counting connected components --
then removing the most-shared variables one at a time to see what falls off.

**`StackInterpreter` (880 methods, 106 ivars, 57 protocols)**

| Variables removed | Pieces | Methods in the largest piece |
|---|---|---|
| 0 | 6 | **873** |
| 1 | 17 | 833 |
| 4 | 21 | 820 |
| 10 | 22 | 783 |
| 20 | 33 | **632** |

**`SpurMemoryManager` (976 methods, 77 ivars, 59 protocols)**

| Variables removed | Pieces | Methods in the largest piece |
|---|---|---|
| 0 | 17 | **828** |
| 2 | 21 | 813 |
| 8 | 27 | 785 |
| 20 | 29 | **719** |

The "pieces" counts flatter than they are: at zero removals the interpreter is *one blob of 873
methods* with five satellites, and the memory manager is one blob of 828 with sixteen -- the
sixteen being the stateless protocols of section 8. Removing the twenty most-shared variables from
either class still leaves two thirds of it in a single piece.

And the hub variables say why:

| `StackInterpreter` | protocols touching it | | `SpurMemoryManager` | protocols |
|---|---|---|---|---|
| `objectMemory` | **46 of 57** | | `coInterpreter` | 26 |
| `stackPointer` | 24 | | `scavenger` | 19 |
| `framePointer` | 21 | | `endOfMemory` | 17 |
| `stackPages` | 17 | | `segmentManager` | 16 |
| `instructionPointer` | 17 | | `nilObj` | 16 |
| `argumentCount` | 14 | | `freeStart` | 10 |
| `stackPage` | 12 | | `totalFreeOldSpace` | 10 |
| `newMethod`, `method`, `messageSelector` | 11 each | | `hiddenRootsObj` | 10 |

These are not accidental couplings that a tidy-up would remove. They are the machine's registers
and the heap's bounds. Every part of an interpreter touches the interpreter's registers; that is
what an interpreter is. **The entanglement is essential, not accidental**, and no amount of moving
variables partitions a state machine into independent pieces.

So the realistic answer to "how many pieces" is not twenty or thirty classes. It is roughly **four
to six extractable modules, all of them peripheral**:

| Module | Methods | From |
|---|---|---|
| object representation algebra (stateless) | 148 | `SpurMemoryManager` |
| debugging, printing, leak checking | ~205 | 122 interpreter + 83 memory manager |
| simulation-only support | ~80 | 62 memory manager + 18 Cogit |
| snapshot in and out | ~38 | 20 memory manager + 18 interpreter |
| plugin/external primitive bridge | 26 | `StackInterpreter` |
| frames and stack pages (arguable: narrow state, hot path) | 103 | `StackInterpreter` |

What remains after those is an execution core of roughly 750 methods and a memory/GC core of
roughly 800, and both stay monolithic because they are the state machine rather than services
around it.

## 10. Is it still only the collector?

Yes -- and after section 9 for a better reason than "that is where the time is".

**The structural reason.** The collector is the only major component whose work is
*phase-structured* rather than *state-machine-structured*. Marking, sweeping and compacting are
passes over a data structure: they have a beginning, an end, and a partitionable domain. Passes
over data parallelise. Interpretation is a dependent sequence of operations over a register set,
and a dependent sequence does not, no matter how it is refactored. That is the same fact that
section 9 measured from the other side.

**The measured reason**, now on ordinary Pharo work rather than on this tool's own workload. GC
share of wall time, `cleanP10.image`, one fresh process:

| Workload | Wall | Full GCs | in full GC | in scavenges | **GC share** |
|---|---|---|---|---|---|
| recompile `Collections-Sequenceable` | 173 ms | 0 | 0 ms | 1 ms | **0.6 %** |
| recompile `Kernel` | 1,314 ms | 0 | 0 ms | 29 ms | **2.2 %** |
| sort 2 M integers | 1,000 ms | 2 | 126 ms | 0 ms | **12.6 %** |
| read every `Kernel` method's source | 101 ms | 0 | 0 ms | 45 ms | **44.6 %** |
| build a `Dictionary` of 1 M associations | 640 ms | 2 | 210 ms | 108 ms | **49.7 %** |
| **run the Collections test suite (64 classes)** | 3,995 ms | **61** | **2,326 ms** | 45 ms | **59.3 %** |
| build a 20 MB `String` by streaming | 402 ms | 7 | 340 ms | 0 ms | **84.6 %** |
| (Polyphemus reifying `cleanP10.image`, section 3) | 10,656 ms | 8 | 611 ms | 2,796 ms | 32.0 % |

Two corrections to section 4 fall out of this.

**Compilation is almost GC-free** -- 0.6 % and 2.2 %. The most characteristic Pharo activity
allocates heavily but dies in eden, and the scavenger clears it in 29 ms out of 1,314. A concurrent
collector would do nothing for a compile. So the case is not "Pharo spends its life in the
collector".

**Anything that builds long-lived structure is dominated by it**, and that includes running a test
suite: 59.3 %, higher than this tool's own workload. That is the strongest single argument here,
because running tests is the heavy thing a Pharo developer does most.

But note *which* collections: 61 full GCs in 4 seconds, and 7 to build one 20 MB string. Those are
driven by **old-space growth**, not by garbage density -- the VM is collecting because it is
growing. So part of that 59 % and 85 % is reachable by tuning growth policy
(`growHeadroom`, `shrinkThreshold`, `maxOldSpaceSize`) and costs no threading at all. Anyone
betting on a concurrent collector should first find out how much of the pause is growth rather
than garbage; it is the cheaper experiment and it has not been run.

### Everything else, priced

| Candidate | Measured cost | Verdict |
|---|---|---|
| collector | 0.6–85 % of wall, 59 % on a test suite | **the prize** |
| ... its compaction phase | 353 ms of 608 ms of full GC (58 %) | the biggest slice, and the one needing a load barrier |
| JIT code generation | not separately counted; code zone compacted **once** in a heavy run | no |
| JIT code zone management | **669 µs** | no |
| heap enumeration | **8 ms** per full scan of 113.8 MB | no (section 8) |
| writing a snapshot | 60 MB image: **~70–150 ms** (0.22 s vs 0.15 s to start and exit) | no, and `fork()` would make it free |
| event polling | already only runs when the image would idle; `statIdleUsecs` accounts for it | already off the path |
| FFI | already threaded, one OS thread per `TFWorker` | done |
| several interpreters | speeds up no single program; section 2(b) is the bill | no |

### What Spur already has for it, and what it lacks

Two of the three things a concurrent collector needs are in the VM:

- a **write barrier** -- the scavenger's remembered set, maintained on every store to an old object;
- the **relocation primitive** -- forwarders, with `followForwarded:`, `isForwarded:`,
  `isUnambiguouslyForwarder:`, `followForwardedObjectFields:toDepth:`,
  `followForwardingPointersInStackZone:`, and a `forwardedFormat`. Brooks pointers are essentially
  this, and `forwarding` is one of the stateless protocols of section 8.

What is missing is the **load barrier**: the guarantee that every read follows a forwarder, rather
than the specific points Spur follows them at today. And emitting that barrier is the **Cogit's**
job, not the memory manager's. Which lands on the most expensive phase: parallel *marking* is
reachable with what Spur has; concurrent *relocation* is a JIT project as much as a GC one.

## 11. Growth, garbage, and a claim withdrawn

Section 10 said a test suite spends 59 % of its time collecting, and called that the strongest
argument here. That was measured correctly and interpreted wrongly. Two follow-ups, both cheap,
change the conclusion.

### How much of it is the heap merely growing

Re-run with `shrinkThreshold` raised to 1 GB and `growHeadroom` to 512 MB (VM parameters 24 and
25), so the VM grows instead of collecting:

| Workload | Default | Roomy | Full GCs |
|---|---|---|---|
| build a 20 MB `String` | 440 ms, **85.0 %** | **82 ms, 0.0 %** | 7 -> **0** |
| `Dictionary` of 1 M associations | 644 ms, 48.4 % | 636 ms, **47.2 %** | 2 -> 2 |
| Collections test suite | 3,815 ms, 60.2 % | 3,906 ms, **59.6 %** | 61 -> 61 |
| Polyphemus reifying `cleanP10.image` | 10,725 ms, 31.7 % | 10,335 ms, **29.5 %** | 8 -> 3 |

**The string case was entirely an artifact of growth policy**: 85 % to nothing, and five times
faster, from two parameters and no threading. Anyone quoting a figure like that as a reason to
build a concurrent collector is quoting a tuning bug.

The other three barely move. So growth explains one of four workloads, and the collector is
genuinely earning its time in the rest.

### The test suite figure was the tests asking for it

Of the 64 Collections test classes, **7 contain 27 methods that call `garbageCollect` explicitly** --
`WeakRegistryTest`, `WeakSetTest`, `WeakKeyDictionaryTest`, `WeakValueDictionaryTest`,
`WeakOrderedCollectionTest`, `WeakIdentityKeyDictionaryTest`, `ByteSymbolTest`. Testing weakness and
finalization means forcing a collection, so those tests *are* the collector's workload.

| The Collections suite | Wall | Full GCs | in full GC | GC share |
|---|---|---|---|---|
| all 64 classes | 3,790 ms | 61 | 2,271 ms | **61.0 %** |
| the 7 that force a GC | 2,290 ms | 40 | 1,495 ms | 65.7 % |
| **the other 57** | 1,519 ms | 20 | 728 ms | **48.5 %** |

So two thirds of the full GCs were requested by the tests, and **59 % should have been 48.5 %**.
The claim is withdrawn as stated; the corrected figure is still high, and the trigger for the
remaining 20 full GCs in 1.5 s is **not identified** -- it is not growth, since raising the headroom
left the count unchanged, and the search for explicit calls covered only the test classes
themselves, not their superclasses or SUnit's own machinery. Worth finding before anyone leans on
this number.

### Which phase, though

The reification workload is the clearest case of genuine collector cost, and it is not the phase
section 4 pointed at. Its 3.4 s of GC is **2.8 s of scavenging across 648 scavenges** with 884,298
tenures, against 0.6 s of full GC -- and raising the headroom cut full GCs from 8 to 3 while leaving
scavenging identical at 2,834 ms.

That is the scavenger copying survivors, over and over, because the workload builds a large
*live* graph. So the phase worth parallelising depends on what the image does:

| If the workload... | the cost is | and the target is |
|---|---|---|
| builds a large long-lived graph | scavenging, tenuring | the **scavenger** (copy survivors in parallel) |
| runs long against a full, fragmented heap | full GC, 58 % of it compaction | the **compactor** |
| compiles, or allocates short-lived garbage | almost nothing (0.6–2.2 %) | nothing |
| grows the heap fast | growth policy, not garbage | two parameters |

Both the scavenger and the compactor are passes over data, so section 10's structural argument
stands for either. But for the work this fork does, it is the scavenger.

## 12. Has anyone upstream done this?

Checked against the repositories, not recalled.

**`pharo-project/pharo-vm`** (default branch `pharo-12`, last pushed 2026-09-17, so actively
developed): no branch whose name mentions gc, concurrent, parallel, incremental or thread. The
Spur collector classes on `pharo-12` are **exactly those in the pinned v10.0.0** -- `SpurCompactor`,
`SpurHybridCompactor`, `SpurPlanningCompactor`, `SpurSelectiveCompactor`, `SpurGenerationScavenger`,
and their simulators. No new class for incremental, concurrent or parallel collection.

**One attempt exists**, and it is instructive:

> **PR #650, "[WIP] Incremental gc"** -- LucFabresse, opened 2023-07-15, **closed unmerged**
> 2024-06-28. Two commits, one file (`SpurMemoryManager.class.st`), +123 / −15. "Start thinking in
> an incremental GC during a VM dojo."

It split `fullGC` into `incrementalFullGC` and `finishIncrementalFullGCWithoutInterruption` and let
Pharo code run between steps of the **mark phase**. The VM compiled and then crashed, and the
author's own diagnosis is the tri-colour invariant, stated plainly:

- the GC should suspend at chosen points (after N objects marked) rather than where they cut it;
- **"newly allocated objects are not marked and will be thrown away"** -- there is no marking
  barrier, only the generational remembered set;
- mark-phase internal structures may be lost across a suspension.

That is exactly the missing piece section 10 identified from the other direction: Spur has a write
barrier for *generational* purposes and no barrier for *marking*, and without one (SATB or
incremental-update) a mark phase cannot be interrupted, let alone run concurrently.

**`OpenSmalltalk/opensmalltalk-vm`**: nothing. No branch, no issue, and no class matching
incremental, concurrent or parallel collection.

So: one 138-line exploratory attempt, at *incremental* rather than parallel collection, abandoned
after eleven months on the barrier problem. Nothing parallel has been attempted in either lineage.

## 13. Which collector design fits, and why "most advanced" is the wrong axis

Shenandoah and ZGC exist to avoid stopping **many** mutator threads on **very large** heaps. This
VM has **one** mutator thread and a heap measured here between 103 MB and 566 MB. Stopping one
thread is cheap and uncontroversial; the machinery that avoids stopping it is therefore mostly
paying for a problem this VM does not have.

Which points at a much smaller first step than section 4 implied:

**Parallel, not concurrent.** With one mutator, a stop-the-world collector whose *marking is spread
over N threads* captures most of the available win and needs **no new barrier at all** -- the world
is stopped, so the tri-colour invariant that sank PR #650 never arises. Per-thread mark stacks with
work stealing, over a heap the segment manager already partitions. The scavenger's survivor copying
is the same shape and is where the reification time actually is.

Concurrency, and therefore barriers, only becomes necessary when the pause itself is the problem --
interactive latency, not throughput. That is a later and much larger project, and it is the one
where the design choice matters:

| Design | Fit here |
|---|---|
| **Shenandoah** (Brooks forwarding pointer, concurrent evacuation, load-reference barriers) | closest conceptually: Spur already has forwarders and `followForwarded:`, which is the same primitive. Needs the load barrier, emitted by the Cogit. |
| **ZGC** (coloured pointers + load barrier) | more invasive: Spur treats an oop as an address with low tag bits, so stealing high bits for colours touches every address computation and the JIT's addressing. |
| **G1** (region-based, parallel evacuation, mostly stop-the-world) | a good match for the segment manager, and closer to "parallel not concurrent", which is the step that fits. |
| **Immix** (mark-region, opportunistic defragmentation) | worth a look precisely because `SpurSelectiveCompactor` already compacts only selected segments -- the same instinct, already in the tree. |

So the order that the measurements argue for: parallel marking and parallel survivor copying first,
with no barrier; then region-selective compaction, building on `SpurSelectiveCompactor`; and only
then, if pause latency is the goal rather than throughput, the load barrier that concurrent
evacuation needs -- which is a Cogit project.
