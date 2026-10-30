--------------------------- MODULE HoldPair ---------------------------
(* Two observers holding each other (#117): the observer living in image A holds image B, the
   one living in B holds A. An observer is a user process of its image (priority 40): it runs only
   while its own image runs and is not held there by a watcher or an agent (priority 70). Each
   makes one hold: stop, signal, resume, wait for interrupted, serve the agent, let it go. No
   deaths and no requests here: only whether the two can block each other.
   A stop is issued by the observer and applied by the kernel: on two cores both observers can
   issue theirs at the same instant. *)

EXTENDS Naturals

CONSTANTS
    HoldLimit,          \* TRUE: an agent ends by itself after its limit
    AtomicStops,        \* TRUE: stop, signal, resume in one step, by a helper outside the observer
    RefuseWhileHolding, \* TRUE: a watcher does not hold its image while that image's observer holds another
    WatchdogStops       \* TRUE: a helper outside the observer resumes a stopped image when its observer cannot

Img == {"A", "B"}
Other(i) == IF i = "A" THEN "B" ELSE "A"

VARIABLES
    stopped,   \* [Img -> BOOLEAN]: stopped by the other image's observer
    issued,    \* [Img -> BOOLEAN]: a stop of that image issued, not yet applied
    excess,    \* [Img -> Nat]: the watcher's semaphore
    w,         \* [Img -> waiting | woken | spin | agent | after]
    a,         \* [Img -> none | starting | serving | ended]
    f,         \* [Img -> [interrupted, doSt, serving, go |-> BOOLEAN]]
    pc         \* [Img -> the program counter of the observer living in that image]

vars == <<stopped, issued, excess, w, a, f, pc>>

Init ==
    /\ stopped = [i \in Img |-> FALSE] /\ issued = [i \in Img |-> FALSE]
    /\ excess = [i \in Img |-> 0]
    /\ w = [i \in Img |-> "waiting"] /\ a = [i \in Img |-> "none"]
    /\ f = [i \in Img |-> [interrupted |-> FALSE, doSt |-> FALSE, serving |-> FALSE, go |-> FALSE]]
    /\ pc = [i \in Img |-> "idle"]

Runs(i) == ~stopped[i]
UserRuns(i) == Runs(i) /\ w[i] = "waiting" /\ a[i] = "none"
Holding(i) == pc[i] \notin {"idle", "done"}

SignalOn(t) ==
    IF w[t] = "waiting" THEN w' = [w EXCEPT ![t] = "woken"] /\ UNCHANGED excess
                        ELSE excess' = [excess EXCEPT ![t] = @ + 1] /\ UNCHANGED w

----------------------------------------------------------------------------
(* Image t's watcher and agent, as in Hold.tla, with one semaphore. *)

Spins(t) ==   \* the watcher's spin ends: the script left for it, if any, else on
    IF f[t].doSt
    THEN w' = [w EXCEPT ![t] = "agent"] /\ a' = [a EXCEPT ![t] = "starting"]
         /\ f' = [f EXCEPT ![t].doSt = FALSE]
    ELSE w' = [w EXCEPT ![t] = "after"] /\ UNCHANGED <<a, f>>

ImageStep(t) ==
    /\ Runs(t)
    /\ \/ w[t] = "woken" /\ ~(RefuseWhileHolding /\ Holding(t))
          /\ w' = [w EXCEPT ![t] = "spin"] /\ f' = [f EXCEPT ![t].interrupted = TRUE]
          /\ UNCHANGED <<excess, a>>
       \/ w[t] = "woken" /\ RefuseWhileHolding /\ Holding(t)
          /\ w' = [w EXCEPT ![t] = "after"] /\ UNCHANGED <<excess, a, f>>
       \/ w[t] = "spin" /\ excess[t] > 0 /\ excess' = [excess EXCEPT ![t] = 0] /\ Spins(t)
       \/ w[t] = "spin" /\ excess[t] = 0 /\ UNCHANGED excess /\ Spins(t)
          \* the 60 s: not while the observer holding t is alive and about to serve it
          /\ ~(pc[Other(t)] \in {"resume", "waitInterrupted", "ringResume"} /\ UserRuns(Other(t)))
       \/ w[t] = "after" /\ UNCHANGED <<a, f>>
          /\ IF excess[t] > 0
             THEN excess' = [excess EXCEPT ![t] = @ - 1] /\ w' = [w EXCEPT ![t] = "woken"]
             ELSE w' = [w EXCEPT ![t] = "waiting"] /\ UNCHANGED excess
       \/ a[t] = "starting" /\ UNCHANGED <<excess, w>>
          /\ IF f[t].go THEN a' = [a EXCEPT ![t] = "ended"] /\ UNCHANGED f
                        ELSE a' = [a EXCEPT ![t] = "serving"] /\ f' = [f EXCEPT ![t].serving = TRUE]
       \/ a[t] = "serving" /\ excess[t] > 0 /\ excess' = [excess EXCEPT ![t] = 0]
          /\ a' = [a EXCEPT ![t] = IF f[t].go THEN "ended" ELSE "serving"] /\ UNCHANGED <<w, f>>
       \/ HoldLimit /\ a[t] = "serving" /\ excess[t] = 0
          /\ a' = [a EXCEPT ![t] = "ended"] /\ UNCHANGED <<excess, w, f>>
       \/ a[t] = "ended" /\ w[t] = "agent"
          /\ a' = [a EXCEPT ![t] = "none"] /\ w' = [w EXCEPT ![t] = "after"] /\ UNCHANGED <<excess, f>>
    /\ UNCHANGED <<stopped, issued, pc>>

KernelStops(t) ==   \* an issued stop applied, whoever runs
    /\ issued[t]
    /\ stopped' = [stopped EXCEPT ![t] = TRUE] /\ issued' = [issued EXCEPT ![t] = FALSE]
    /\ UNCHANGED <<excess, w, a, f, pc>>

(* The watchdog: the image t stopped, and the observer that stopped it (living in Other(t)) cannot
   run to resume it, held or stopped itself: after its bound, the helper resumes t. *)
Watchdog(t) ==
    /\ WatchdogStops /\ stopped[t] /\ ~UserRuns(Other(t))
    /\ stopped' = [stopped EXCEPT ![t] = FALSE]
    /\ UNCHANGED <<issued, excess, w, a, f, pc>>

----------------------------------------------------------------------------
(* The observer living in image h, holding image Other(h). *)

Obs(h, p) == UserRuns(h) /\ pc[h] = p
Go(h, p) == pc' = [pc EXCEPT ![h] = p]

IssueStop(h, p, next) ==
    /\ ~AtomicStops /\ Obs(h, p)
    /\ issued' = [issued EXCEPT ![Other(h)] = TRUE] /\ Go(h, next)
    /\ UNCHANGED <<stopped, excess, w, a, f>>

HoldSignal(h) ==   \* resume and signal; with AtomicStops, stop included
    /\ IF AtomicStops THEN Obs(h, "idle")
                      ELSE Obs(h, "resume") /\ ~issued[Other(h)]   \* its stop applied first
    /\ stopped' = [stopped EXCEPT ![Other(h)] = FALSE] /\ SignalOn(Other(h))
    /\ Go(h, "waitInterrupted")
    /\ UNCHANGED <<issued, a, f>>

SeeInterrupted(h) ==   \* the serving ring needs its own stop
    /\ ~AtomicStops /\ Obs(h, "waitInterrupted") /\ f[Other(h)].interrupted
    /\ issued' = [issued EXCEPT ![Other(h)] = TRUE] /\ Go(h, "ringResume")
    /\ UNCHANGED <<stopped, excess, w, a, f>>

ServeAndRing(h) ==
    /\ IF AtomicStops THEN Obs(h, "waitInterrupted") /\ f[Other(h)].interrupted
                      ELSE Obs(h, "ringResume") /\ ~issued[Other(h)]
    /\ f' = [f EXCEPT ![Other(h)].doSt = TRUE]
    /\ stopped' = [stopped EXCEPT ![Other(h)] = FALSE] /\ SignalOn(Other(h))
    /\ Go(h, "waitServing")
    /\ UNCHANGED <<issued, a>>

LetGo(h) ==
    /\ Obs(h, "waitServing") /\ f[Other(h)].serving
    /\ f' = [f EXCEPT ![Other(h)].go = TRUE] /\ SignalOn(Other(h))
    /\ Go(h, "done")
    /\ UNCHANGED <<stopped, issued, a>>

GiveUp(h) ==   \* a deadline passes only when the image it holds can make no step
    /\ \/ Obs(h, "waitInterrupted") /\ ~f[Other(h)].interrupted
       \/ Obs(h, "waitServing") /\ ~f[Other(h)].serving
    /\ ~ENABLED ImageStep(Other(h))
    /\ Go(h, "done")
    /\ UNCHANGED <<stopped, issued, excess, w, a, f>>

ObserverStep(h) ==
    \/ IssueStop(h, "idle", "resume") \/ HoldSignal(h) \/ SeeInterrupted(h) \/ ServeAndRing(h)
    \/ LetGo(h) \/ GiveUp(h)

Next == \E i \in Img : ObserverStep(i) \/ ImageStep(i) \/ KernelStops(i) \/ Watchdog(i)

Spec ==
    /\ Init /\ [][Next]_vars
    /\ \A i \in Img : WF_vars(ObserverStep(i)) /\ WF_vars(ImageStep(i)) /\ WF_vars(KernelStops(i))
                     /\ WF_vars(Watchdog(i))

----------------------------------------------------------------------------

\* 10. The two never block each other for ever: both observers get through, both images run.
BothThrough == <>(\A i \in Img : pc[i] = "done" /\ UserRuns(i))

StateBound == \A i \in Img : excess[i] <= 3
=============================================================================
