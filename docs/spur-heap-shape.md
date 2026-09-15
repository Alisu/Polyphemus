# The shape of a Spur heap, and how to find one in a dump

A dump says nothing about objects. Finding the heap inside it is our problem, and the heap's own
shape is what solves it. Field values here are from VMMaker `v10.0.0`, which is what we are
pinned to; where a number appears it was read out of that source rather than remembered.

## The object header, 64 bit

Every object begins with an 8-byte header. Some fields matter to us, some do not.

| Bits | Field | Notes |
|---|---|---|
| 0–21 | class index | 22 bits, `classIndexMask` = `16r3FFFFF`; an index into the class table, **not** a pointer |
| 22–23 | — | |
| 24–28 | format | 5 bits, `formatShift` = 24, `formatMask` = `16r1F` |
| 29–31 | — | marked, remembered, pinned and friends |
| 32–53 | identity hash | 22 bits |
| 56–63 | slot count | 8 bits; **255 means "too many, look in the word before"** |

Two consequences we use.

**Objects are self-sizing.** From a header you know the slot count, so you know where the object
ends and the next one begins: `address + 8 + slots*8`, rounded to the allocation unit, which is
8. An object with a slot count of 255 has a second header word *in front of it* holding the real
count, and then the object itself starts 8 bytes later — so the whole object is 16 bytes of
header plus its slots.

**A slot count of zero is still one slot wide.** Spur never produces a zero-length object; the
smallest is the header plus one slot, because a forwarding pointer has to fit.

The formats, which tell us what the slots mean:

| Format | Meaning |
|---|---|
| 0 | no slots (nil, true, false…) |
| 1 | fixed fields only (Point…) |
| 2 | indexable, no fixed fields (Array…) |
| 3 | indexable with fixed fields (Context…) |
| 4 | weak indexable |
| 5 | ephemeron |
| 9 | 64-bit indexable |
| 10–11 | 32-bit indexable |
| 12–15 | 16-bit indexable |
| 16–23 | byte indexable (strings…) |
| 24–31 | compiled method |

## Why a heap can be recognised by shape

Take any address and read eight bytes as a header. The slot count says where the next object
starts. Read the header there. If that is also well formed, step again.

In a real heap that chain walks from one end to the other and lands exactly on the boundary
every time. Elsewhere it stops, and *how soon* it stops was measured rather than assumed: three
thousand walks from random places in two megabytes of noise.

| Checks applied | Median run | Longest of 3000 |
|---|---:|---:|
| format is a used one, class index is not zero | 6 objects | **78** |
| and the class index is below 100 000 | **0** | **2** |

The class index carries the discrimination. It is 22 bits wide, so noise offers values up to
four million, while a real image has some tens of thousands of classes; requiring a plausible
one rejects about ninety-eight walks in a hundred at every step.

That is the scan: **start somewhere, walk, and count how far you get.** A Pharo heap walks for
millions of objects; noise manages two. Anything in between is worth looking at rather than
believing, and the number to beat should be generous -- hundreds, not tens -- because real
memory is not noise. It holds text, zeros and pointers, which walk differently from random bits
and will produce longer accidental runs than the table above.

What makes a header implausible, in the order that is cheapest to check:

1. the object runs past the end of its segment;
2. the slot count is enormous for a small object, without the overflow marker preceding it;
3. the class index is zero, or past the largest index the class table can hold;
4. the format is one of the unused values (6, 7, 8);
5. a pointer-format object whose slots are neither immediates nor addresses inside a mapped
   region.

Only the first four are needed to find the heap. The fifth is what tells you the heap is
*intact*, which is a different question and the one stage one already asks.

## Anchors, once a region looks like a heap

- **nil, false and true are the first three objects of old space**, in that order. So the first
  object of the region should have format 0 and a slot count of zero, and the three should be
  16 bytes apart -- an object of no slots is still one slot wide. That is a strong confirmation
  and costs nothing.
- **The special objects array** is an ordinary object whose slots are the VM's well-known
  objects; nil, false and true are its first three, which finds it and cross-checks the region.
- **The class table** is reachable from there, and every object's class index should resolve in
  it. A region where most class indices resolve is a heap; one where few do is a coincidence.

## Why this route rather than the VM's symbols

The binary on the work box is unstripped and carries `debug_info`, so the heap's whereabouts can
simply be read out of the VM's own globals. That is exact, and it needs the very binary the dump
came from.

The shape scan needs nothing but the bytes. It works on a stripped VM, on a build we do not
have, on a version we have never seen — and on a dump whose VM globals are themselves damaged,
which is the case this tool exists for. It is the same principle as the open question in
`CLAUDE.md`: prefer what can be checked over what has to be trusted.

Both are worth having. The symbol route is a fast path; the shape scan is the one that always
works, and the one that can *disagree* with the symbols and so catch a dump that is not what it
claims.

## What a real dump taught us

Tried against a 204 MB core of a running VM (42 segments, 41 of them memory, none with holes --
`gcore` writes everything).

**The scanner is right.** Pointed at a heap we know is one -- the pinned image file, read from
its `oldBaseAddress` -- it walked **70,029 objects** through four megabytes and stopped only
because it reached the end of the window we gave it. The first object is nil: class index 3075,
format 0, no slots.

**Finding that heap inside the dump is the part that is not solved.** What was tried:

- Walking from the start of each large region: nothing. The heap does not begin at a region
  boundary.
- Walking from the image's own `oldBaseAddress`: the word there is zero. The VM did not load the
  image at the address the file names, even though the largest region begins 3072 bytes below it,
  which is too close to be a coincidence and worth understanding.
- Sampling two thousand offsets at ten depths through the largest region: best run 60 objects.
- Searching the whole dump for nil's header -- format 0, class index 3075, so the low four bytes
  are `03 0C 00 00` -- found three candidates, two of which walk **358 objects** before stopping.

358 is far above what noise produces, so those are real objects; but 5792 bytes is not a heap.
The walk stops on a word reading `61 68 20 46 …`, which is ASCII: it left the objects and went
into text.

**It was the anchor that was wrong, not the walk.** Two things came of chasing it.

Free chunks were a real bug and not this one. Spur marks free space with a class index of zero
(`isFreeObjectClassIndexPun`), and this scanner treated that as a reason to stop -- so a walk
through a living heap would have halted at the first hole. Fixed: free chunks are stepped over
and counted apart, since memory nobody has written reads as one free chunk after another and
would otherwise look like the finest heap in the dump. The runs that were failing had no free
chunks in them at all, so it fixed a fault we had not yet hit.

The anchor was the fault. **One header that looks like nil proves nothing.** The three
candidates found that way were a table of small numbers whose low bytes happen to read as a
class index and a format; walking it produced 358 well formed "objects" in a row before
wandering into text. Held against the image file, the difference was plain: a real heap begins
nil, false, true -- classes 3075, 3077, 3079, no slots, sixteen bytes apart -- while the table
began 3075, 3843, 16391, 4867.

**The triple is the signature.** Searched over the whole 204 MB dump it matched in exactly one
place, and the walk from there ran **1,106,303 objects across 92 MB** before reaching the end of
the region. That is the heap of a dead process, read out of its core dump.

`#heapStartFrom:upTo:` does this: find the triple, then believe it only if the walk from it runs.

## What the dump says about the image that died

Once the heap is found, the walk measures it -- every object it steps over has a size, and free
chunks are counted apart from live ones:

| | |
|---|---|
| mapping the VM asked the operating system for | 114.0 MB |
| reserved, before the heap begins | 22.0 MB |
| heap | 92.0 MB |
| **live objects** | **1,106,303 in 76.9 MB** |
| free space | 15.1 MB, in a single chunk at the end |
| average object | 73 bytes |

So the image was using 76.9 MB of the 114 MB its VM had taken, and the allocator was holding
15 MB spare against the next allocation.

**And the number checks itself.** The image file on disk is 76.9 MB -- the same figure the walk
arrives at by adding up objects it found in a core dump, with no knowledge of that file. An
image is its heap; counting the heap in memory and measuring the file on disk are two ways of
asking the same question, and they agree.

## What is at the start of a heap, and what is not

The first three objects are nil, false and true. What follows them was worth reading rather
than assuming, because it is easy to expect the special objects array there and it is not.
Read out of the core dump, the first ten objects of old space are:

| # | Class index | Format | Slots | What it is |
|---|---:|---:|---:|---|
| 1–3 | 3075, 3077, 3079 | 0 | 0 | nil, false, true |
| 4 | 19 | 9 | 64 | the **free lists** |
| 5 | 16 | 2 | 4104 | the **hidden roots** |
| 6–9 | 16 | 2 | 1024 each | **class table pages**, pointed at by the hidden roots |
| 10 | 3165 | 1 | 3 | an ordinary object; the heap proper has begun |

So the hidden roots hold 4096 slots of class table and eight more. Those eight are the obj
stacks the garbage collector uses -- the mark stack and the weakling stack, whose pages are
`ObjStackPageSlots` (4092) slots of format 9, which is why they read as large word arrays
rather than as anything recognisable.

**The special objects array is not among them.** It is not reachable from the hidden roots at
all: the VM keeps it in a variable of its own, and a snapshot writes it into the *image
header* -- which is a structure of the file, not of the memory, so a core dump has no copy of
it. Anything reading a dump has to find it another way.

## Finding the special objects array by its contents

The same trick as the heap itself, one level down. Its first three slots are nil, false and
true, and by the time it is wanted those three addresses are already known.

Measured over the whole dump -- all 1,106,303 objects -- asking only for a pointer object of
at least three slots whose first three are those oops matched in **exactly one place**, and
that object has 60 slots, which is the size of the array this Pharo really uses. The size
guard that seemed prudent turned out to carry no weight, so the code does not have one.

**And it checks itself.** The array found in the core dump of a dead process has nil in slots

    1, 12, 23, 25, 32, 33, 34, 36, 38, 40, 47, 48, 53, 54, 55, 56, 57

and the same array in the living image that did the reading has nil in exactly those slots.
Seventeen agreements, from a search that only ever looked at three.

`#specialObjectsArrayFrom:upTo:` does this, and it is the last of the registers a reified
memory needs: with the heap start, the end, and this, a dump can be read the way stage one
reads an image file.

## What references it, which is one object and one line of VM

Two ways of asking, and they give the same answer.

**In the dump.** Searching all 114 MB of the mapping for the array's address found it written in
**exactly one word**: slot 2 of an object of class 3135, three fixed fields. That object is
`Smalltalk` -- the sole `SmalltalkImage`, whose instance variables are `globals`,
`specialObjectsArray` and `vm`. And slot 9 of the special objects array is that same object.
The two point at each other and at nothing else, which is a second signature, harder to forge
than the first: the array's ninth slot holds an object whose second slot is the array.

**In VMMaker.** `#specialObjectsOop:` has one sender that matters,
`SpurImageReader>>readImageFromFile:StartingAt:`. The VM does not find this array by walking
anything -- it reads the oop out of the image header as the file is loaded, and keeps it in a
variable from then on. That is why a core dump does not hand it over, and why the hidden roots
do not have it: nothing in the object graph is responsible for holding it.
