# Frames and contexts

Stage one reads images as snapshots, where there are no frames: the VM turned every one of
them into a context before writing the file. Anything that was running — a crashed process, a
core dump, a live VM — is the other way round, and stage two has to read both.

## A base frame is the base of its page

Not of the stack. A VM does not keep a whole stack as frames: it divorces activations into
contexts when it needs the room, when a process is suspended, and for every frame when an image
is written, then marries back only what it needs to run. So a page holds the newest activations
and everything older is contexts.

The pinned image, interpreted a few steps, has 32 pages of which one is live, holding three
frames:

| Frame | Method | saved FP |
|---|---|---|
| top | `SessionManager>>newSession` | -127080 → the middle frame |
| middle | `SessionManager>>installNewSession` | -127008 → the base frame |
| base | `SessionManager>>launchSnapshot:andQuit:` | **0** |

Only the oldest has zero. Something still called it — `SessionManager>>snapshot:andQuit:
[block]` — and that something is a **context**, sitting off the page. `#oopCaller` answers the
caller frame on the same page; `#oopPageCaller` answers the context that called into the page,
and only a base frame has one. Nothing called the very first frame of a process, and there the
slot holds nil.

## The frame layout, as read

Relative to the frame pointer, confirmed against the image rather than from memory:

| Offset | Holds |
|---|---|
| `fp - 2w` | this frame's context, when it has one |
| `fp - 1w` | its method |
| `fp + 0` | the caller's frame pointer, or **0** for a base frame |
| `fp + 1w` | the caller's saved instruction pointer — or, for a base frame, the caller **context** |
| `fp + 2w` … | the arguments, then the receiver |

## Where a frame is, and how deep its stack is

Ask the VM. `#contextInstructionPointer:frame:` is what it uses to write a pc into a context
when it divorces a frame, and `#stackPointerIndexForFrame:WithSP:` the same for the stack
pointer. Both answer tagged integers, so `#integerValueOf:` decodes them.

Working it out by hand does not agree: the instruction pointer less the method's address gives
206 where the VM says 200, and 206 is a different instruction of the same method.

The check is the same file read the other way. Read as a snapshot the activation is a context
carrying pc 200 and stackp 5, and the frame agrees. It has to be the file that checks it,
because a *married* context carries a pc of zero: while a frame is alive the pc lives in the
frame.

Only the active frame answers so far. Any other frame's instruction pointer was saved by the
frame it called, one word above that frame's pointer, which needs the frame above — the page
walk knows it, a frame does not, and it is untested.

## Marrying a frame: what it costs

The VM can turn a frame into a real context itself, with `#ensureFrameIsMarried:SP:`. It works,
and it is not free. Measured on the three-frame fixture, marrying the top frame:

- **allocates in the image being read** — `freeStart` moved 184 bytes, a new Context written
  into that heap;
- **changes the frame**, whose context slot now points at it;
- **invalidates our reading** — that frame reads as an error until the memory is reified again.

For a live VM that is legitimate. For a file, a core dump, or anything being read as evidence it
is not: it writes to what it is reading, it needs the allocator and the free lists to be sane —
which is exactly what a corrupted image cannot promise — and it cannot work at all on memory
that is genuinely read only.

So it stays available and explicit, for stage three, and nothing reads through it by default.

## Frames the JIT compiled

Everything above was read from a `StackInterpreterSimulator`, which has no JIT, so every frame in
it is an interpreted one. A dump from a real VM is another matter: Pharo ships Cog, and its stack
pages hold machine code frames as well.

The heap does not change -- Spur is Spur, so everything stage one does is unaffected. The frames
do.

**Telling them apart is one comparison.** A frame's method field holds a CompiledMethod when it
is interpreted and a CogMethod when it is jitted, and CogMethods live in the code zone, below the
object heap. So:

```smalltalk
(stackPages longAt: theFP + FoxMethod) < objectMemory startOfMemory
```

is the whole test, and it is the VM's own (`CoInterpreter>>isMachineCodeFrame:`). The same rule
tells a machine code instruction pointer from a bytecode one.

**What else differs, and would have been read wrongly:**

- `FoxCallerContext` is **undefined** in Cog. Its comment says the caller context of a base frame
  is kept *on the first word of the stack page* instead. Our `#oopPageCaller` reads one word above
  the frame pointer, which is the stack interpreter's layout: on a Cog dump it would read some
  other word and answer it confidently.
- The receiver sits at a different offset in the two kinds of frame, `FoxIFReceiver` against
  `FoxMFReceiver`, and only interpreted frames have `FoxIFrameFlags` and `FoxIFSavedIP`.
- A jitted frame's instruction pointer is an address in the code zone. Turning it back into a
  place in the source needs the map Cog keeps for exactly that purpose, which is how it divorces
  a frame into a context.

**So: recognise and refuse, before anything else.** A machine code frame answers that it is not
readable, and the readers say so rather than applying interpreted offsets to it. A wrong line in
a stack is worse than a missing one, and this is the cheapest possible way to avoid producing
several.

**And when we do read them**, it is by calling VMMaker's own code rather than reimplementing it:
`CogVMSimulator` is a subclass of `CoInterpreter`, so the JIT is simulated in VMMaker the same
way the interpreter is -- the same reason we call `primitiveSnapshot` instead of writing one.
