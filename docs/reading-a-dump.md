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

Anchors worth using once a candidate region is found: nil, true and false are the first three
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
