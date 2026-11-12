---------------------------- MODULE Writes ----------------------------
(* What Hold.tla leaves out: memory. An observer stops a running VM wherever it is and writes
   into its new space -- an object (the watcher, a method, a literal) and an entry of the
   remembered set -- through words the VM itself reads, changes and writes back in more than one
   instruction. Stopped between the read and the write-back, the VM goes on with what its register
   held (#167, risk 3 of #163; seen in #137 on 2026-11-12).

   The VM's steps are those of VMMaker, read on 2026-11-12:
   - the JIT's primitive new (CogObjectRepresentationFor64BitSpur>>genPrimitiveNew): freeStart
     into a register, the new freeStart stored, then the header written;
   - C's allocation (SpurMemoryManager>>allocateNewSpaceSlots:format:classIndex:): freeStart
     read, the header written, then freeStart stored;
   - remembering (VMRememberedSet>>rememberWithoutMarkingAsRemembered:, in C, called from machine
     code's store check): the size read, the entry stored, then the size stored;
   - a scavenge (SpurMemoryManager>>doScavenge:): gcPhaseInProgress set, survivors copied to the
     other survivor space, pastSpaceStart stored from what the copying reached, freeStart back at
     eden's start, the flag cleared.
   The observer's writes are those of SpurWritableProcess: allocateSlots:..., remember:. Each is
   whole within one stop. *)

EXTENDS Naturals

CONSTANTS
    Where,      \* "eden": objects made at freeStart (until 2026-11-12); "past": at pastSpaceStart
    StopWhen,   \* the stop a write is made at: "any" | "outsideCollection" |
                \*   "outsideMachineCode" (and outside a collection) |
                \*   "outsideRemembering" (and outside a collection; not in the code yet) | "quiet"
    MaxOps,     \* operations the VM starts
    MaxWrites   \* stops at which the observer writes

Cells == 0..5

VARIABLES
    free,       \* freeStart, as a cell of eden
    past,       \* pastSpaceStart, as a cell of past space
    eden,       \* [Cells -> "none" | "vm" | "obs"]: whose object starts at that cell
    survivors,  \* [Cells -> ...]: the same for past space
    rsSize,     \* rememberedSetSize
    rs,         \* [Cells -> ...]: whose entry is at that index of the remembered set
    gc,         \* gcPhaseInProgress
    pc,         \* the VM: "idle" | "kernel" (at rest in a system call) | "jitLoaded" | "jitStored"
                \*   | "cLoaded" | "cHeader" | "remLoaded" | "remStored" | "scavCopied"
    reg,        \* what the VM's register holds
    stopped,    \* stopped by the observer
    ops, writes,
    bad         \* [over: an object written over a live one of the other side,
                \*  lost: an entry of the remembered set written over or left past its size]

vars == <<free, past, eden, survivors, rsSize, rs, gc, pc, reg, stopped, ops, writes, bad>>

None == [c \in Cells |-> "none"]

Init ==
    /\ free = 0 /\ past = 0 /\ eden = None /\ survivors = None /\ rsSize = 0 /\ rs = None
    /\ gc = FALSE /\ pc = "idle" /\ reg = 0 /\ stopped = FALSE /\ ops = 0 /\ writes = 0
    /\ bad = [over |-> FALSE, lost |-> FALSE]

Over(space, cell) == space[cell] # "none"

----------------------------------------------------------------------------
(* The VM. It runs only while not stopped. *)

Runs == ~stopped

Start(next) ==
    /\ Runs /\ pc \in {"idle", "kernel"} /\ ops < MaxOps
    /\ ops' = ops + 1 /\ pc' = next

\* At rest in the kernel, between two things it does.
Rest ==
    /\ Runs /\ pc = "idle" /\ pc' = "kernel"
    /\ UNCHANGED <<free, past, eden, survivors, rsSize, rs, gc, reg, stopped, ops, writes, bad>>

\* The JIT's new: freeStart loaded, stored back moved on, then the header.
JitLoad ==
    /\ Start("jitLoaded") /\ free < 5 /\ reg' = free
    /\ UNCHANGED <<free, past, eden, survivors, rsSize, rs, gc, stopped, writes, bad>>

JitStore ==
    /\ Runs /\ pc = "jitLoaded" /\ free' = reg + 1 /\ pc' = "jitStored"
    /\ UNCHANGED <<past, eden, survivors, rsSize, rs, gc, reg, stopped, ops, writes, bad>>

JitHeader ==
    /\ Runs /\ pc = "jitStored" /\ pc' = "idle"
    /\ bad' = [bad EXCEPT !.over = @ \/ Over(eden, reg)]
    /\ eden' = [eden EXCEPT ![reg] = "vm"]
    /\ UNCHANGED <<free, past, survivors, rsSize, rs, gc, reg, stopped, ops, writes>>

\* C's allocation: freeStart read, the header, then freeStart stored.
CLoad ==
    /\ Start("cLoaded") /\ free < 5 /\ reg' = free
    /\ UNCHANGED <<free, past, eden, survivors, rsSize, rs, gc, stopped, writes, bad>>

CHeader ==
    /\ Runs /\ pc = "cLoaded" /\ pc' = "cHeader"
    /\ bad' = [bad EXCEPT !.over = @ \/ Over(eden, reg)]
    /\ eden' = [eden EXCEPT ![reg] = "vm"]
    /\ UNCHANGED <<free, past, survivors, rsSize, rs, gc, reg, stopped, ops, writes>>

CStore ==
    /\ Runs /\ pc = "cHeader" /\ free' = reg + 1 /\ pc' = "idle"
    /\ UNCHANGED <<past, eden, survivors, rsSize, rs, gc, reg, stopped, ops, writes, bad>>

\* Remembering, in C: the size read, the entry stored, the size stored.
RemLoad ==
    /\ Start("remLoaded") /\ rsSize < 5 /\ reg' = rsSize
    /\ UNCHANGED <<free, past, eden, survivors, rsSize, rs, gc, stopped, writes, bad>>

RemEntry ==
    /\ Runs /\ pc = "remLoaded" /\ pc' = "remStored"
    /\ bad' = [bad EXCEPT !.lost = @ \/ rs[reg] # "none"]
    /\ rs' = [rs EXCEPT ![reg] = "vm"]
    /\ UNCHANGED <<free, past, eden, survivors, rsSize, gc, reg, stopped, ops, writes>>

RemStore ==
    /\ Runs /\ pc = "remStored" /\ pc' = "idle"
    /\ bad' = [bad EXCEPT !.lost = @ \/ rsSize > reg + 1]
    /\ rsSize' = reg + 1
    /\ UNCHANGED <<free, past, eden, survivors, rs, gc, reg, stopped, ops, writes>>

(* A scavenge: the flag, one survivor copied after those there (where it ends in the register),
   then pastSpaceStart stored from the register, eden empty again, the flag cleared. *)
ScavStart ==
    /\ Start("scavCopied") /\ past < 5 /\ gc' = TRUE /\ reg' = past + 1
    /\ bad' = [bad EXCEPT !.over = @ \/ Over(survivors, past)]
    /\ survivors' = [survivors EXCEPT ![past] = "vm"]
    /\ UNCHANGED <<free, past, eden, rsSize, rs, stopped, writes>>

ScavEnd ==
    /\ Runs /\ pc = "scavCopied" /\ pc' = "idle"
    /\ bad' = [bad EXCEPT !.over = @ \/ past > reg]
    /\ past' = reg /\ free' = 0 /\ eden' = None /\ gc' = FALSE
    /\ UNCHANGED <<survivors, rsSize, rs, reg, stopped, ops, writes>>

VMSteps ==
    Rest \/ JitLoad \/ JitStore \/ JitHeader \/ CLoad \/ CHeader \/ CStore
    \/ RemLoad \/ RemEntry \/ RemStore \/ ScavStart \/ ScavEnd

----------------------------------------------------------------------------
(* The observer: a stop wherever the VM is, a look at what the stop can tell, and, when that
   allows it, an object made and the old object naming it remembered; then the VM runs on. *)

InMachineCode == pc \in {"jitLoaded", "jitStored"}

\* Inside the VM's routine that remembers: its instruction pointer says so.
Remembering == pc \in {"remLoaded", "remStored"}

MayWrite ==
    CASE StopWhen = "any" -> TRUE
      [] StopWhen = "outsideCollection" -> ~gc
      [] StopWhen = "outsideMachineCode" -> ~gc /\ ~InMachineCode
      [] StopWhen = "outsideRemembering" -> ~gc /\ ~Remembering
      [] StopWhen = "quiet" -> pc = "kernel"

Stop ==
    /\ ~stopped /\ writes < MaxWrites /\ stopped' = TRUE
    /\ UNCHANGED <<free, past, eden, survivors, rsSize, rs, gc, pc, reg, ops, writes, bad>>

\* allocateSlots:format:classIndex:filledWith:, then remember:, both whole within the stop.
Write ==
    /\ stopped /\ MayWrite /\ rsSize < 5
    /\ IF Where = "eden"
       THEN /\ free < 5
            /\ eden' = [eden EXCEPT ![free] = "obs"] /\ free' = free + 1
            /\ bad' = [bad EXCEPT !.over = @ \/ Over(eden, free), !.lost = @ \/ rs[rsSize] # "none"]
            /\ UNCHANGED <<past, survivors>>
       ELSE /\ past < 5
            /\ survivors' = [survivors EXCEPT ![past] = "obs"] /\ past' = past + 1
            /\ bad' = [bad EXCEPT !.over = @ \/ Over(survivors, past), !.lost = @ \/ rs[rsSize] # "none"]
            /\ UNCHANGED <<free, eden>>
    /\ rs' = [rs EXCEPT ![rsSize] = "obs"] /\ rsSize' = rsSize + 1
    /\ writes' = writes + 1 /\ stopped' = FALSE
    /\ UNCHANGED <<gc, pc, reg, ops>>

\* The stop was not one to write at: let go, to look again.
LetGo ==
    /\ stopped /\ ~MayWrite /\ stopped' = FALSE
    /\ UNCHANGED <<free, past, eden, survivors, rsSize, rs, gc, pc, reg, ops, writes, bad>>

Next == VMSteps \/ Stop \/ Write \/ LetGo

Spec == Init /\ [][Next]_vars

----------------------------------------------------------------------------

\* No object is written where a live one of the other side is.
NoObjectWrittenOver == ~bad.over

\* No entry of the remembered set is written over, or left beyond its size.
NoRememberedLost == ~bad.lost
=============================================================================
