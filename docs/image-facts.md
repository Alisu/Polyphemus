# What we probed, and what we found

Facts established by running against the two fixtures, so nobody has to rediscover them.
Fork-only notes. Every claim here was measured, not recalled.

## The fixtures

| | candle | pinned Pharo 10 |
|---|---|---|
| file | `resources/candle64Bit.image`, 206 KB, committed | `resources/cleanP10.image`, 59 MB, downloaded |
| pinned as | — | `Pharo10.0.1-0.build.527.sha.0542643` |
| class names | `PCProcess`, `PCProcessorScheduler`, `PCMethodContext` | the usual ones |
| processes | 1 | 8 |
| stacks | 1 frame, sender nil — it was bootstrapped and never ran | 1 to 19 frames |
| `.sources` | none, so source reads answer nil | `cleanP10.sources`, 39 MB |
| a test costs | ~1s | ~17s with a warm image, ~40s without |

**Never match on class names.** Candle calls them `PC*`. Everything navigates by slot.

## Object layout, as confirmed on both images

Slots are 1-based in Polyphemus (`slotAt:` does `fetchPointer: anIndex - 1`), while VMMaker
counts from zero. The named accessors on `AbstractReifiedMemory` hold the conversion.

| structure | slots |
|---|---|
| special objects array | 4 = the association whose value is the scheduler (VMMaker: `SchedulerAssociation` = 3) |
| association | 2 = value |
| ProcessorScheduler | 1 = process lists (one per priority), 2 = active process |
| Process | 1 = nextLink, 2 = suspendedContext, 3 = priority, 4 = myList |
| LinkedList | 1 = firstLink, 2 = lastLink |
| Context | 1 = sender, 2 = pc, 3 = stackp, 4 = method, 5 = closureOrNil, 6 = receiver |

## Processes are not where you expect

In the Pharo 10 image, **3 of 8** processes are in scheduler queues. Four wait in `Semaphore`
queues, and one is the running process, which belongs to no queue. Walking the scheduler
alone loses five of them, which is why `allReifiedProcesses` scans the heap for instances of
the process class instead.

Candle's single process has `myList` nil and `nextLink` nil: a running process is in no queue.

## Married contexts, and why stage one avoids them

A context married to a frame keeps **its own frame pointer**, as a small integer, in the slot
where a divorced context keeps its sender. It is not a caller. Decoding: address = integer ×
word size (candle showed −25090 → −200720, which resolved back to the same context).

A snapshot on disk holds none: the VM divorces every frame before writing. **We** used to
create one, because opening an image ran the full VM startup including `loadInitialContext`.
That made the running process' stack look 1 frame deep when the file holds 3.

Stage one therefore opens images as snapshots — `setUpUsingImageMarrying: false` via
`CandleSnapshotResource` and `Pharo10SnapshotResource`. Stage two keeps the full startup,
because it wants the frames.

## Method source

- `size` and raw byte access come from `OOPAbstractEntity>>oopSize` and `rawByteAt:`. A
  reified method's `at:` answers the **bytecode at a pc**, which the symbolic bytecode tools
  depend on, so the trailer decoder gets a byte view instead (`OOPCompiledCodeBytes`).
- A snapshot method is byte-identical to the same method in a running image: same `size` 247,
  same trailer kind `#SourcePointer`, same pointer 61087329 → file 1, position 27532897.
- `retrieveSourceFiles` must pick the files **named after the image**. Our resources directory
  holds several images, and taking the first `*.sources` handed a Pharo 11 file to a Pharo 10
  image, which answers quiet nonsense rather than failing.
- A `CompiledBlock` carries no selector: its **last literal** is its enclosing code, so climb
  until a `CompiledMethod` appears.
- All 8 processes of the Pharo 10 image have source for every frame.

## Timings that shape the loop

| | |
|---|---|
| one candle test | 0.8s |
| one real-image test | 17s warm, 39s cold |
| `tdd.sh` overhead (compile working copy + rebuild warm image) | ~6s |
| fast tier, 278 tests | 8s |
| whole suite | ~40s |

Work on candle, verify on the real image before committing.

## Traps that cost us time

- An unhandled error **hangs** headless Pharo; the `st` handler never quits by itself.
- Compiling inside a test asks for author initials, which the test environment reports as an
  error in **every** test of the run.
- SUnit re-runs `TestResource>>setUp` between suites, so state applied once at resource
  creation is lost.
- `TestCase>>defaultTimeLimit` is 10s; anything loading an image needs more or the watchdog
  fires mid-setUp and surfaces as an unrelated error.
- Two flakes seen at `-j 8` (`VMObjectIndexableLayoutTest`, `QueryWidgetTest`), never at `-j 6`,
  never reproducible alone.
