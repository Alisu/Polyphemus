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

## What is not done

| Left | Why |
|---|---|
| A literal the image does not hold | interning a new symbol means placing it in the target's own symbol table |
| A new selector | the method dictionary has to grow, which is more than one store |
| Editing a live process | the same passes with a third destination, and a heap that moves under them |
| The old method's source pointer | the installed method carries its new source embedded; the old object is left where it was |
