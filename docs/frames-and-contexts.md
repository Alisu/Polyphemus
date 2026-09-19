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

**Read, not only refused, on a dump.** The frame classes no longer read words themselves. They
ask the memory's `vmLayout`:
- `OOPStackInterpreterLayout` reads the simulator's pages with the StackInterpreter's offsets.
- `OOPCogLayout` reads a dump's bytes with Cog's offsets (`CoInterpreter class>>initializeFrameIndices`).

The same `OOPTopFrame`/`OOPMiddleFrame`/`OOPBaseFrame` therefore serve both, and a dump gets the
whole debugger protocol. On a Cog dump:

- **A machine code frame** holds a CogMethod in its method field, with hasContext and isBlock in
  its low bits. The CompiledMethod or CompiledBlock is that CogMethod's `methodObject`, and
  `numArgs` is its `cmNumArgs`. The receiver is at `FoxMFReceiver`.
- **Its pc** is a code address. Mapping it back to a bytecode needs Cog's method map, so `pc`
  answers nil and `instructionPointer` raises `#itIsAMachineCodeFrameAndWeHaveNoJITMapYet`.
- **An interpreted frame's pc** is the ip its callee saved, or its own `FoxIFSavedIP` when that
  ip is the return trampoline. It is converted as `CoInterpreter>>contextInstructionPointer:frame:`
  does, which gives an absolute pc like a context's.
- **A base frame** is laid out by `CoInterpreter>>makeBaseFrameFor:`. Above the stacked receiver
  comes the frame's *own* context (for cannotReturn:), then the caller's. `callerContextOf:`
  reads the caller only if the own context is where it should be.
- **A compiled method Cog jitted** has its CogMethod's address in its header slot, and the real
  header is in the CogMethod. Reading that address as a header gave a garbage literal count,
  which made "an unreadable selector" (#3). `OOPCogLayout>>methodHeaderOf:` follows it, but
  only if the CogMethod's `methodObject` points back.

On the real core this takes the 17 processes from **24 contexts to 77 activations**: 58 frames,
28 of them jitted, each married frame agreeing with its context on method and receiver.

**What the VM's own variables add** (`VMVariables`, see `docs/reading-a-dump.md`):

- **Names for the routines a frame returns through.** Every `ce...` variable whose value lies from
  `codeBase` to `methodZoneBase` names a trampoline or enilopmart. A saved ip of
  `ceReturnToInterpreterTrampoline` is recognised by name, as `contextInstructionPointer:frame:`
  does, and the inspector shows it by name. Every base frame returns through
  `ceBaseFrameReturnTrampoline`.
- **The page records**, read through VMMaker's own `CogStackPageSurrogate64`. A suspended
  process's newest frame is its page's `headFP`, and the word at `headSP` is the ip it resumes
  at. So that frame has a pc and an operand stack. (A one-frame page used to lose an operand
  here: #10.)
- **The running process.** It has no context. Its frames start at `framePointer`, where the VM
  saved its registers on leaving for C, and its ip is `instructionPointer`. That is believed
  only if:
  - no thread's `rip` is in the code zone (then the newest frames would be only in registers:
    machine code calling machine code saves nothing);
  - the frame pointer is on the active page and walks down to its base;
  - the ip lies inside the newest frame's method.

  The active page's own record is stale. On the real core the running process was the idle
  process, in its relinquish primitive.

**A machine code frame's pc**, through Cog's own map, read by VMMaker's own Cogit
(`Cogit>>bytecodePCFor:startBcpc:in:`). `OOPCogLayout>>cogit` is a `StackToRegisterMappingCogit`
set up as the Pharo VM is built (SistaV1, x64) and wired to two stand-ins:
- `OOPCogCodeMemory`: code zone bytes come from the dump, everything else from the dumped heap.
- `OOPCogInterpreterStandIn`: a method's start pc is taken from its real header (#3).

Initializing the Cogit's class only fills Cog's own pools; none of the StackInterpreter's
change, and stage 1's stack tests pass in an image where it ran.

**Checked without Cog:** on the real core all 28 JIT frames have a pc, and a frame below another
is just after the send that made it. That send is the callee's selector, a `value...` for a
block, or a send that runs a method under another name (`withArgs:executeMethod:`). The dumped
VM was built from VMMaker v9.0.22 and is read with v10.0.0; the map agreed on every frame.

**Still missing:** a live process cannot yet say whether it was stopped in machine code (no
registers without ptrace), so its running process is refused. And a running process caught *in*
machine code would need its newest frames from `rbp`/`rsp`.

## Finding a dump's frames, through the heap

Stack pages are not in the object heap. They are the virtual machine's own C memory, and nothing
in a dump says where they are -- which looked like the thing standing between stage two and
reading stacks at all.

The heap says where they are. A **married** context keeps its frame pointer where a sender would
be, and married contexts are ordinary objects sitting in a heap we can already read. So the
frames are reached from the objects, not searched for.

Each one is believed only if the frame **points back**: the word two below the frame pointer is
the frame's context, and it has to be the context that named it. One side can be a coincidence;
both cannot. It is the same mutual reference that confirms the special objects array.

On the real core:

| | |
|---|---|
| contexts in the heap | 832 |
| contexts naming a frame | 94 |
| **frames confirmed by pointing back** | **43** |
| of those, running machine code | **12** |
| running bytecodes | 31 |

The 51 that name a frame without being pointed back at are contexts whose frame is long gone --
which is what a divorced context looks like from this side.

All the frame pointers land in a single 328 KB region far above the heap, which is the memory the
stack pages live in. We did not have to know that in advance, and did not have to find it: the
heap gave us the addresses and the addresses gave us the region.

### The jitted frames are real, and now there are examples

The 12 machine code frames have method fields *below the start of the mapping* -- in the code
zone, where no object could be. That is the VM's own test for a jitted frame
(`CoInterpreter>>isMachineCodeFrame:`), and this is the first time it has been applied to
anything but an interpreted frame here.

It also means the refusal in `OOPAbstractStackFrame` was written against no real examples and now
has twelve. They are now read through `OOPCogLayout` (see above); only their pc still waits on
Cog's map.
