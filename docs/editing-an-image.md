# Editing another image

Reading an image tells you what went wrong. Editing one is what a Pharo debugger does next: fix
the method and carry on. Here the method is in *another* image -- a file, a dump, or a live
process -- and the compiler that fixes it is this one, never a simulator's.

## The trap that comes first: a reading's addresses are not the file's

`Polyphemus readImageFile:` loads the image through VMMaker, which puts it where it pleases. On
the pinned Pharo 10 the reading sits **0x151CD20** above the file: nil is at `17D85920` where
the file says `16868C00`. An edit aimed at the address an inspector shows would land in a
neighbouring object and report success.

So `SpurImageEdit>>reading:` takes the reading, and everything aimed at an object it shows goes
through `#addressInFileOf:`. `#store:inSlot:ofObjectShown:` tags an integer, translates an
object, and refuses anything the image does not already hold.

## Where a method keeps its code

A compiled method is a byte object whose contents are: the method header word, the literals, the
bytecodes, then the trailer. So in the file:

```
bytecodes = method address + 8 + (initialPC - 1)
```

The 8 is the object header; `initialPC` counts from the method's first content byte, so it
already includes the header word and the literals. Writing a method's own code back over itself
leaves the file identical byte for byte, which is how that arithmetic is tested.

## Rung 1: code that fits where it is

`SpurImageEdit>>replaceCodeOfMethodShown:from:to:` writes bytecodes over a method in place. It
needs both compilations, because what makes it safe is the check highlighting already does:
**the file must hold exactly what the old compilation says it does**. It refuses when the
literals differ, when the lengths differ, or when the file holds something else.

That covers the classic fix: `Integer>>digitSubtract:` in the pinned image is 124 bytecodes, and
swapping a `<` for a `<=` changes **one byte**, with the literal frame untouched.

## Rung 2: code that does not fit

`SpurMethodInstall` allocates instead. VMMaker's own allocator works in a reading --
`totalFreeOldSpace` is real there, unlike in a dump-built memory before the collection pass
(#23) -- so a new method is `allocateSlotsInOldSpace:format:classIndex:` with:

- **slots** for the header word, the literals and the code with its trailer;
- **format** `24 + unused bytes in the last word`, compiled code being formats 24 to 31;
- **the class index of the method being replaced**, rather than one looked up.

It fills the header word the new compilation wants, copies the literal oops from the old method
(rung 2 installs a fix that uses nothing new), and writes the code and the trailer -- which,
compiled with embedded sources, carries the new source with it.

Then the class is pointed at it: a method dictionary holds one pointer per method, and the slot
is found **by looking for the old method's oop** rather than by knowing the dictionary's shape.

The image is written by VMMaker's writer, through `memory coInterpreter writeImageFileIO`.

**The proof.** The search lands on `Integer>>*`, 18 bytecodes becoming 22, so a wrong install
would not survive one multiplication. A virtual machine runs the written image and answers
`6 * 7 * 1000000000000 * 1000000000000` with 42 followed by twenty-four zeros.

## Rung 3: a method the class never had

A new method needs literals of its own. A compiled method ends with its selector and the binding
of the class it was compiled in, so the binding is taken from a method that class already has --
every one of them ends with it -- and before those, only what can be made here: a SmallInteger,
a Character. Anything else has to be found in the image.

The dictionary entry goes where `MethodDictionary>>scanFor:` will look for it: from the
selector's **identity** hash, `(basicIdentityHash \\ array size) + 1`, on to the first free slot.
The selectors are the dictionary's own indexable slots and the methods are in its array, paired
by index -- selector at dictionary slot `2 + i` with method at array slot `i`, the two named
slots being the tally and the array itself (#28 was exactly this confusion). A dictionary that
would have to grow is refused rather than grown.

`Integer` was given `#reset`, which no integer understood: a machine said "did not understand"
before and answered 42 after.

## Interning a symbol the image does not hold

A symbol table is a `WeakSet` in `Symbol`'s class pool, and an empty slot there holds its **flag**
object rather than nil -- nil means a symbol the collector took. A symbol hashes **by its
characters** (`Symbol>>hash` is `String>>hash`), so a name hashes the same here as there, and
`Symbol class>>lookup:` scans from `(hash \\ array size) + 1`.

So Polyphemus scans that table itself and answers either the image's symbol or the slot the scan
would stop at. A new one is a byte object of the class the image's own symbols have, holding the
characters, with **its identity hash set here** -- a method dictionary is placed by that hash,
and one the machine assigned later would leave the method where no lookup goes.

Checked on the pinned Pharo 10: `polyphemusZork` was absent, its slot would be 4666, and after
installing it is there. A machine running the written image answers `#(42 true true)` to

```smalltalk
{ 3 polyphemusZork.
  (Integer >> #polyphemusZork) selector == #polyphemusZork.
  #polyphemusZork == 'polyphemusZork' asSymbol }
```

The last of those is the one that matters: the image interned the name itself and found **ours**,
not a second symbol beside it.

## The literals a real edit wants

An edit almost never keeps the literal frame. Putting `nil == nil ifTrue: [ ]` into
`digitSubtract:` was enough:

```
old: ... #normalize #to:do: #ifTrue:ifFalse: #whileTrue: #and:
new: ... #normalize #ifTrue: #ifTrue:ifFalse: #and: #to:do: #whileTrue:
```

Pharo keeps inlined selectors as literals and orders them by first appearance, so `#ifTrue:`
arrived and moved the rest along. Copying the old method's oops cannot serve that, so the frame
is built instead -- each literal found in the image or made there:

| literal | how |
|---|---|
| SmallInteger, Character, `nil`, `true`, `false`, a float | immediate, or what the memory answers for it |
| a symbol | found in the image's table, interned when absent |
| a string | a byte object of the image's `ByteString`, filled |
| a literal array | an array of the image's own, its elements translated the same way |
| another global's binding | the image's own association, **found and never copied** -- a binding points at the global |
| a large integer | its bytes, least significant first, under the class its sign asks for |
| the class's binding | taken from a method that class already has |
| the pragmas of a method that has them | the image's own state object, kept, so the pragmas must be the ones already there |
| a block of its own | a compiled block made in the image, belonging to the method (below) |

**The proof is that it runs.** With a string the image never held added to `Integer>>digitSubtract:`
and its symbols reordered, the written image answers

```smalltalk
(1000000000000000000000 - 999999999999999999999)   "1"
(12345678901234567890 - 1)                          "12345678901234567889"
```

which is that method, with the frame that was built for it, in a machine that knows nothing of us.

### A block of its own

Most edits contain a block, and a block that is not inlined is an object: a `CompiledBlock`
literal in the method's frame. It has a method's shape -- header word, literals, bytecodes -- and
**its last literal is the code it belongs to**, which is why the method is allocated first and
its blocks made afterwards, pointing back at it. A block inside a block belongs to the block, and
the same recursion serves.

Checked by running it: an edit adding
`((1 to: 3) collect: [ :each | each * 2 ]) size = 3 ifTrue: [ ]` to `Integer>>digitSubtract:`
installs, and a machine running the written image still answers `1` to
`1000000000000000000000 - 999999999999999999999` -- the statement really evaluates, so a block
put together wrongly would not survive it.

**Pragmas are the line.** A method's pragmas live in the state object it carries, which stays the
image's own; an edit that changes them is refused. That refusal had to be added twice over: the
first check compared literal frames, and `literals` does not include that state, so a
pragma-only edit compiled to the same bytecodes, took the in-place path, and reported success
while the change went nowhere. Silence of that kind is worse than a refusal.

## The live destination

The passes above write into a reading of a *file*. The same ones aim at a running image, which is
what they were for: `SpurEdit` holds what is common -- replacing a method's code with one
compiled here -- and a subclass says how to read and write bytes, and how far its addresses are
from the reading's.

| | reads and writes | shift |
|---|---|---|
| `SpurImageEdit` | a copy of the file's bytes, written out afterwards | the reading is 0x151CD20 above the file |
| `SpurProcessEdit` | `/proc/<pid>/mem`, refused unless the process is stopped | **none**: a process is read at its own addresses |

So editing a wedged image is the passes of #25 pointed at the process of #24:

1. interrupt it, and hold it without yielding;
2. stop it, read it, and check the method holds what the old compilation says it does;
3. write the new bytecodes;
4. let it go.

**Measured.** A target spinning at priority 40 was held, and `SmallInteger>>even` -- its
`= 0` made `= 1`, the same length and the same literals -- was written into it. Let go, the image
itself answered `4 even` with **false**, where the same test without the patch answers **true**.
Six seconds, end to end: nothing heavy is read, the reified memory being lazy.

A method the machine has already compiled needs one thing more, which the next section is.

## The method the machine compiled

A wedged image is wedged in hot code, so the method worth fixing is the one Cog has compiled --
and **machine code is what runs**. Patching the bytecodes of such a method changes nothing at
all, which is a quiet way to be wrong. Detecting it is one slot: a jitted method's header holds
a CogMethod where the header word belongs (#3).

`CompiledMethod>>flushCache` is not the answer, whatever its comment says. Followed into VMMaker:
primitive 116 reaches `StackInterpreter>>flushMethodCacheForMethod:`, which clears the
interpreter's own cache, its external primitives and the at-cache -- and nothing of Cog's.

**`voidCogVMState` is.** `CompiledCode>>voidCogVMState` is primitive 215 and discards that
method's machine code; `VirtualMachine>>voidCogVMState` is 214 and discards all of it. So the
held image is asked to run it, its own compiler doing the asking:

```smalltalk
(SmallInteger >> #even) voidCogVMState
```

which is why the watcher runs whatever script is left beside it before letting go. The fix is
written from outside; the un-jitting is asked of the image, through the API meant for it.

**Measured, three tests that only mean something together:**

| | what the image answers afterwards |
|---|---|
| jitted, patched, nothing discarded | `true` -- the patch is in the bytecodes and the machine code runs regardless |
| jitted, patched, `voidCogVMState` | `false` |
| not jitted, patched | `false` |

And the point of it: with the runaway process looping on `4 even`, the fix ends the loop at the
next question. The image stops running away and goes idle, alive -- which is what an image that
answers again looks like from outside.

## What is not done

| Left | Why |
|---|---|
| New code naming a whole method of its own | rare, and refused by name |
| A method whose pragmas change | its state object is the image's, kept as it is |
| A class whose method dictionary is full | growing one means a bigger array, rehashed by the image's own rules |
| Installing a *new* method in a live image | allocating in a heap the machine owns, and telling its collector about the pointer |
| A held image that cannot run anything | the un-jitting is asked of the image; one too broken to compile would need Cog's zone edited from outside |
| The old method's source pointer | the installed method carries its new source embedded; the old object is left where it was |
