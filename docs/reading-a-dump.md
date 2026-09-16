# Reading memory that is not an image file

Stage two's own problem: the bytes come from a process, not from a file. Written from the VM's
source rather than from memory of it — `v10.0.0`, which is what we are pinned to.

## The seam is already there

`StackInterpreterSimulator>>openOn:extraMemory:` does three things:

```smalltalk
memoryManager ifNil: [
    memoryManager := MachineSimulatorMemoryManager new.
    objectMemory memoryManager: memoryManager.
    memoryManager wordSize: objectMemory wordSize ].
(f := self openImageFileNamed: fileName) ifNil: [ ^ self ].
systemAttributes at: 1 put: fileName; at: 2 put: nil.
[ imageReader readImageFromFile: f StartingAt: 0 ] ensure: [ f close ]
```

Two things fall out of it.

**The memory really is a flat buffer.** `MachineSimulatorMemoryManager`, addressed with
`uint32AtPointer:` and `uint32AtPointer:put:`; the accessors above it (`longAt:`,
`long64At:`) are arithmetic on that. So there is nothing to convert: bytes taken out of a
process can be put into it as they are.

**Loading is already abstracted.** `imageReader` is a `SpurImageReader`, and everything
file-shaped happens inside it:

| Method | What it does |
|---|---|
| `readImageFromFile:StartingAt:` | header, then the rest |
| `readHeaderFrom:startingAt:` | version, header size, data size, old base address, special objects oop |
| `readSegmentsFromImageFile:header:` | the segments, and the bridges between them |
| `sq:Image:File:Read:` | *N bytes from the file into this address* |
| `loadImageFromFile:withHeader:` | ends with `interpreter initializeInterpreter: bytesToShift` |

A reader for dumps is a sibling of that class, not a change to anything else.

## Reading a dump should be *simpler* than reading an image

`bytesToShift` exists because an image is written at one base address and loaded at another, so
every oop in it has to be adjusted. A dump is the memory of a process that was already running:
put each segment back at **the address it had**, and the shift is zero. Nothing to swizzle,
nothing to adjust — the oops in the bytes are already correct for where they sit.

What has to come from the dump instead of from a header:

- where the heap is, and how big;
- the object memory's registers — `oldSpaceStart`, `freeStart`, `endOfMemory`, the special
  objects oop, the class table root;
- the stack pages, which are **not** in the object heap. They are the VM's own C memory, and
  they are the reason stage two reads a dump rather than reconstructing an image file from it:
  rebuild an image and the frames are gone, and the frames are the point.

## Finding the heap

Two ways, and we will want both.

**By symbol.** `pharo-vm/lib/pharo` on the box is *not stripped and carries `debug_info`*, so
the VM's own globals name the heap and the registers directly. Exact, and it depends on having
the very binary the dump came from.

**By shape.** A Spur object header is eight bytes carrying a class index, a slot count and a
format. That makes the heap self-describing: from a real header, the slot count says where the
next object begins, and there another well-formed header must be. A run of those that walks for
megabytes without landing on nonsense is not a coincidence — no other region of a process looks
like that.

The shape scan is the one that survives what the symbol lookup cannot: a stripped VM, a build
we do not have, a version we do not know, and the case this whole tool exists for — damage in
the very structure being used to navigate. It is the same idea as the open question in
`CLAUDE.md`: prefer what can be checked over what has to be trusted.

Anchors worth using once a candidate region is found: nil, false and true are the first three
objects of old space, so the first header should be nil's and `oldBaseAddress` should point at
it; the special objects array is an ordinary object of known shape; the class table is reachable
from it.

## Getting a dump at all

**Linux.** Yama's `ptrace_scope` is 1 on the box, which means a process may only be traced by an
ancestor. So `gdb -p <pid>` fails, and a dump has to be taken by a gdb that *started* the VM:

```bash
gdb --batch -ex "set environment LD_LIBRARY_PATH <vm>/lib" \
    -ex "break ioRelinquishProcessorForMicroseconds" -ex run \
    -ex "gcore /tmp/pharo.core" -ex kill \
    --args <vm>/lib/pharo --headless <image> st idle.st
```

Set `LD_LIBRARY_PATH` for the *inferior*, never for gdb: pointed at the VM's bundled libraries,
gdb loads them itself and dies on a libcurl symbol.

A VM that crashes on its own leaves a dump through whatever the machine's `core_pattern` says —
apport here — which is the case the tool is actually for.

**macOS is not the same mechanism.** There is no Yama there: attaching goes through
`task_for_pid`, gated by code signing, entitlements and SIP. Your own process, built without a
hardened runtime, can be attached to by lldb without lldb being its parent — which is why it
felt like no such restriction existed. It is a real platform difference, not a
misremembering.

## From a dump back to a bootable image

Two ways, and they are not equally hard.

**With the simulator.** Put the dump's segments into the simulator's memory, set the object
memory's registers, and let it snapshot: `reifiedMemory simulator coInterpreter
primitiveSnapshot`, which is what the *Resurrecting Dead Images* note does at the end. The VM
then does everything a snapshot does -- collect, promote, turn frames into contexts, write the
header -- and the result is an image because a VM made it one. This is the route that works.

**By moving bytes only.** Possible, and it is worth knowing exactly what it costs, because four
of the five steps are easy and the other two are the whole job.

Easy:

- *The header.* Version, header size, data size, old base address, special objects oop, last
  hash, flags. Writing the **runtime base address** as the old base means every oop in the heap
  is already correct for it and nothing needs relocating -- the same trick that makes reading a
  dump easier than reading an image.
- *The heap bytes.* Copy old space out of the segments, contiguously.

Hard:

- **New space.** Spur keeps recently made objects in eden, and a snapshot runs a full collection
  to promote them into old space first. Copy old space alone and every young object is quietly
  gone, with old-space pointers left dangling at them. There is no cheap fix: promoting by hand
  is a garbage collector.
- **The running stacks.** Frames live in the VM's own C memory, not in the heap, which is why
  they are in a dump at all and not in an image. A snapshot runs `divorceAllFrames` to turn each
  one into a Context object in the heap. Doing that by hand means allocating those objects at
  `freeStart`, filling the six fixed slots and the temporaries, pointing each process at its
  new top context, and rewriting the sender of every married context -- all of which we now know
  how to read, and none of which we have ever written.

And a caveat over both: a dump is taken at an arbitrary instant, so it can catch the VM
mid-scavenge or mid-become, with forwarding objects about and free lists inconsistent. A
snapshot never happens at such a moment.

So: **a readable image first** -- one our own reader opens, which is what forensic work needs
and is little more than the dump plus a header -- and a **bootable** one through the simulator.
Byte-only booting is a research project whose failure mode is an image that loads and then
behaves oddly, which is the worst kind of wrong.

## From a dump to a memory the rest of the tool can read

`SpurImageReader` sits in a seat: `StackInterpreterSimulator>>openOn:` makes a memory manager,
gives it to the object memory, and hands the filling to a reader. `SpurDumpedMemory` takes that
seat with a core file. Nothing above it -- the reified memory, and so the whole of stage one --
ever learns which it was given.

### The mapping goes back where it was

The VM asks the operating system for its heap in **one** mapping, so the largest loadable
segment is it. In the core we test against that is 114 MB at `0xF63...`, with the object heap
starting 22 MB into it.

The simulator's memory is not one flat array: `SlangMemoryManager` keeps **sparse regions**
indexed by the high bits of an address. So a region can be registered at the dump's own address
and cost its own size, not the four gigabytes beneath it. Which means no oop has to move:

> a dump is memory that was already running, so `bytesToShift` is zero.

That is the one way reading a dump is *easier* than reading an image file, where every segment
is relocated and every pointer adjusted.

### The registers an image header would have carried

| Register | Where it comes from in a dump |
|---|---|
| `oldSpaceStart` | the nil/false/true triple, found by shape |
| `freeOldSpaceStart` | the end of the live objects, from walking them |
| `endOfMemory` | the end of the mapping |
| `specialObjectsOop` | the only object whose first three slots are nil, false, true |
| `hiddenRootsObj` | two objects past true: nil, false, true, free lists, hidden roots |
| `freeLists` | the first indexable field of that free lists object |

**The VM's own code confirms this layout.** `SpurMemoryManager>>initializeObjectMemory:` asserts
that nil is `oldSpaceStart`, that false and true follow it, and that the free lists and hidden
roots come next -- which is exactly how they are found here, arrived at by reading a dump before
that assertion was read.

That method is **not** called, though. It writes a segment bridge, rebuilds the free lists,
swizzles oops and starts the collector's machinery: all reasonable when loading an image to run
it, all mutations of the thing we are trying to examine. What *is* called is
`#setHiddenRootsObj:`, because it audits what it is given -- it checks the first class table page
is the right size and that the root pages are valid, and would refuse a memory we had described
wrongly.

### Reified lazily, because the full reifier writes

`FullyReifiedMemory>>reifyAllOops` calls `reconstructFreeLists`, which clears the free lists
object and re-adds every chunk it finds. For an image being repaired that is the point; for
evidence it is not, and its writes go through the VM's write barrier into a scavenger a dump
cannot supply. `LazyReifiedMemory` reads without writing, in about three seconds, and
`#reifyEverything:` walks the rest in about twenty when a question needs to enumerate.

### What it answers, on a real core

| | |
|---|---|
| objects reified | 1,106,398 |
| classes of nil, false, true | `UndefinedObject`, `False`, `True` |
| special objects array | round-trips against the register |
| processes, with states | **11**, waiting and suspended |

### New space: declared empty to the VM, walked by shape by us

Two different things, and the distinction matters.

To the memory manager, new space is still declared empty -- see below -- because how full eden
was is a variable of the VM's C state and a dump does not carry it. So the VM's own
`allObjectsDo:` enumerates old space only.

Polyphemus finds those objects anyway, the same way it found the heap: **they walk, and noise
does not.** `#youngSpaceStart` looks for the first run of objects in new space,
`#youngObjectsWalk` walks it, and where that walk stops *is* the allocation mark the dump would
not tell us. On the core we test against: **2,369 objects, 415 KB**, found in seven
milliseconds, ending on untouched memory.

This was not cosmetic. The **running process lives in new space**, as the newest objects do, and
was missing from every enumeration until this existed: the processes found went from 11 to 17,
and exactly one of them is `#active` -- the process that was on the processor when the dump was
taken.

### Why the memory manager is still told new space is empty

How much of eden was in use is a variable of the VM's C state, not a fact about the heap. A dump
does not carry it, and reading past the last live object there would turn whatever the allocator
had not yet overwritten into objects. So new space is given the geometry the VM would give it
and then declared empty.

Young objects remain perfectly readable **one at a time** -- in the core we test against, the
*running process itself* is one of them, at 696 bytes into the mapping. They are missing only
from the answers that enumerate. Hence the shape of the result above: eleven processes found,
and the active one not among them.

The way out is the trick that found the heap in the first place: eden can be *walked by shape*
until the walk stops, which is how you find the last live object without being told where it is.
Not built yet.

### Taking a dump

`bin/take-dump.sh`. It writes to `~/polyphemus/pharo.core`, deliberately not `/tmp` -- a reboot
cleared the first one and rebuilding it is minutes. The gdb recipe lives in that script, with the
two traps that cost an afternoon each: `LD_LIBRARY_PATH` belongs to the inferior, never to gdb,
and the breakpoint must be `pending` because its symbol is in a library not yet loaded.

## The minimum required to read, and saying "we cannot read this"

Reading an image is not one thing that works or fails. It is a ladder, and each rung can be
damaged on its own: a heap whose class table is broken still has perfectly good objects in it,
they just have no names.

| Level | Needs | How it is checked | What failing costs you |
|---|---|---|---|
| `bytes` | a mapping we can read | the segments parse | everything |
| `heap` | nil, false, true, and a walk that runs | `#heapStartFrom:upTo:` | *there is no Spur heap here* |
| `objects` | the walk reaching the end | `SpurHeapWalk>>reason` | objects up to where it stopped -- **and it says where, and why** |
| `freeSpace` | the lists agreeing with the walk | `SpurFreeListWalk>>agreesWith:` | nothing to read, everything to write: the allocator is not to be trusted |
| `classes` | a class table that can be *navigated* -- hidden roots present, pages in the heap and the right size | `#classTableStructureProblems` | no object anywhere can be given a class |
| `specialObjects` | the array, found by its contents | `#specialObjectsArrayFrom:upTo:` | no processes, no scheduler |

Source is a rung above, and is not checked here: a method's trailer and the `.sources` file are
per-method questions, answered where they are asked.

**Two kinds of rung.** `bytes`, `heap` and `classes` are *preconditions*: without readable
memory, a heap, or a navigable class table there is nothing to be done with any object anywhere.
One of those failing stops the climb, because the rungs above it cannot even be tested.

The others are *local damage*. A walk that stops half way through is damaged where it stops and
nowhere else; a free chunk that is not one is a fact about that chunk; a class index that answers
nothing costs the names of that one class. None of them says anything about the rest of the
heap -- so they are recorded, the climb carries on, and what they cost belongs in the data:
`OOPAbnormalEntity` for a stretch that cannot be decoded, and an unreadable class for an object
that cannot be named. Refusing to read a heap because its walk ended early would be answering a
question about one end of the memory with a fact about the other.

**The rule that makes it worth having.** Every question declares the rung it needs, and a
question asked above a failed precondition raises `SpurCannotRead` -- carrying the level and the
reason -- instead of answering. `#reifiedMemory` requires `classes`, because every object
reified through a broken table gets a name and the name is wrong.

This is `readSlot:of:ifUnreadable:` lifted from single slots to the structures we navigate by,
and it is the answer to the question this fork left open: *what if the damage is in the thing we
read with?* You find out first, and you say so.

### A bad class costs a name, not the memory

The rung is about the table being *navigable*, not about every entry being perfect, and the
difference matters more than it first looks.

A page that is missing, in the wrong place or the wrong size is fatal: resolving a class index is
arithmetic -- page number and offset, ten bits each -- and if the pages are not there it has
nowhere to land, so *no* object anywhere can be given a class. That is worth refusing over.

One entry holding something that is not a class is not that. It costs exactly the classes at that
one index: those objects are still readable -- their slots, their sizes, their contents, their
place in the heap -- they simply have no name to give. Every other object still gets its own.
Refusing to read a million objects because one class went bad is the wrong trade, and damage of
that kind is far likelier than a table that has gone entirely.

So entry damage is reported rather than refused: `#unreadableClassIndexes` says which indexes
answer nothing, and those classes are the anonymous ones. Reporting them by *index* rather than
by address is deliberate -- the index is what identifies the objects left without a name.

What is not built yet is the other half of that: reifying such an object with an explicit
anonymous class, the way `OOPAbnormalEntity` stands in for a chunk that is not an object, so the
reader sees *this object's class is damaged* instead of an object that quietly refuses to say
what it is.

### Why the class table is worth auditing at all

Damage anywhere else eventually announces itself. A broken free list hands out memory that is in
use and something crashes; a broken object header stops the walk. A broken class table does
nothing at all: the heap still walks, the free lists still add up, every object is still well
formed. It simply answers the wrong name for every object of that class, and no other check
notices. So every entry of every page in use is audited -- each must be an object of fixed
fields, inside the heap -- which on the core we test against is 4096 entries and half a minute,
and comes back empty.

### Checks are not only for refusing

The free list check earned itself the first time it ran, and not by finding corruption. It
reported a chunk eight bytes outside the heap, which turned out to be a bug in *our* reading: the
heap ran into a second mapping we were not looking at. Two independent routes to the same number
disagreeing is how you learn that one of them is wrong -- and it is worth remembering that the
one that is wrong may be yours.
