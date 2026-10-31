---------------------------- MODULE Hold ----------------------------
(* The hold protocol of Polyphemus (stage2 at 26cbcae), as protocol.md describes it: an observer
   holds an image through a watcher it put in, hands it an agent, asks it things, runs it until a
   method (a trap), and lets it go. Either side can die at any moment. No memory here: only who
   waits on what. Version 2: files in one record, Pharo's semaphore wait, the trap of runUntil:.
   Version 3, after the Mac trial of 2026-10-30: the observer's ring only counts a signal (it
   never wakes a waiting process), and the agent's own bell can be rung after it let it go.
   Version 4, after the box trial of 2026-10-31: the observer's signal is queued, and delivered
   at a later step of the image. Version 5: a hold wanted is a file too (the observer's hold, the
   trap's trap), so a signal delivered after the observer let go can be told from a wanted one.
   Version 6, after the box run of 2026-10-31: the trap fires in two steps of a user process
   (taking itself out, then its file and its signal), which a stop or the agent can come between. *)

EXTENDS Naturals

CONSTANTS
    MaxHolds,             \* holds the observer makes in a row
    MaxAsks,              \* requests per plain hold
    WithTrap,             \* TRUE: the second hold is a runUntil:
    HoldLimit,            \* TRUE: the agent ends by itself after its limit; FALSE: holdLimit: nil
    FastObserver,         \* TRUE: a live observer acts within the watcher's 60 s
    SeparateBell,         \* TRUE: the agent's rings go to a bell of its own
    BellEndedGuard,       \* TRUE: the agent says bell-ended first; no ring once it is there
    FallbackSeesTrap,     \* TRUE: runUntil:'s fallback hold looks for the trap's file once stopped
    AsyncSignal,          \* TRUE: the observer's signal is queued, the VM delivers it at a later step
    WatcherWaitsForDoSt,  \* TRUE: the watcher spins until a signal *and* its do.st, not a signal alone
    AnyDeadline,          \* TRUE: runUntil:'s deadline may pass at any moment, the trap still armed
    WatcherChecksToken,   \* TRUE: woken with neither hold nor trap there, the watcher waits again
    TrapClaims,           \* TRUE: the trap or the agent's removal claims it in one step; the removal says which
    StopEndsWithObserver  \* TRUE: a stop is let go when the observer dies (ptrace); FALSE: SIGSTOP

VARIABLES
    excess,      \* the watcher's semaphore: signals counted
    bell,        \* the agent's own bell, when SeparateBell
    stopped,     \* the image is stopped by the observer
    w,           \* watcher: waiting | woken | spin | agent | after
    a,           \* agent: none | starting | serving | ended
    intent,      \* holds signalled for (by the observer or the trap) not yet taken
    trapOn,      \* the trap: off | on (installed) | firing (taken out, its file and signal to come)
    installing,  \* the observer's pending request installs the trap
    removing,    \* the observer's pending request removes the trap
    removed,     \* the removal's answer: removed | firing (its hold to come) | fired (this hold is its)
    f,           \* the files: [interrupted, doSt, serving, go, expired, released, trap,
                 \*             bellIndex, bellEnded |-> BOOLEAN]
    reqN, ansN,  \* requests written, answers written, in the current channel
    oPc, ringNext, oAlive, iAlive, holds, asks,
    pending,     \* signals the observer asked for that the VM has not delivered yet
    hist         \* [badWrite: a ring written past nil, lost: the observer gave up on a live image,
                 \*  badRemove: the removal took out a trap already taking itself out]

vars == <<hist, pending, excess, bell, stopped, w, a, intent, trapOn, installing, removing, removed, f, reqN, ansN,
          oPc, ringNext, oAlive, iAlive, holds, asks>>

NoFiles == [interrupted |-> FALSE, doSt |-> FALSE, serving |-> FALSE, go |-> FALSE,
            expired |-> FALSE, released |-> FALSE, trap |-> FALSE,
            bellIndex |-> FALSE, bellEnded |-> FALSE, hold |-> FALSE]

Init ==
    /\ excess = 0 /\ bell = 0 /\ stopped = FALSE /\ w = "waiting" /\ a = "none" /\ intent = 0
    /\ trapOn = "off" /\ installing = FALSE /\ removing = FALSE /\ removed = "removed" /\ f = NoFiles
    /\ reqN = 0 /\ ansN = 0
    /\ oPc = "idle" /\ ringNext = "idle" /\ oAlive = TRUE /\ iAlive = TRUE /\ holds = 0 /\ asks = 0
    /\ hist = [badWrite |-> FALSE, lost |-> FALSE, badRemove |-> FALSE] /\ pending = 0

(* A signal on the watcher's semaphore, taken by the VM when the image runs: it resumes the
   watcher if the watcher waits on it, else it is counted. *)
Signal ==
    IF w = "waiting" THEN w' = "woken" /\ UNCHANGED excess
                     ELSE excess' = excess + 1 /\ UNCHANGED w

\* signalExternalSemaphore: from the observer, queued for the VM's next check when AsyncSignal.
ObserverSignal ==
    IF AsyncSignal THEN pending' = pending + 1 /\ UNCHANGED <<excess, w>>
                   ELSE Signal /\ UNCHANGED pending

Image == <<excess, bell, w, a, intent, trapOn>>
Observer == <<oPc, ringNext, holds, asks>>
Channel == <<installing, removing, removed, reqN, ansN>>

----------------------------------------------------------------------------
(* The image: the watcher (holdSourceAfterwards:) and the agent it runs (sourceServing:...),
   and the trap in a user process. They run only while the image is alive and not stopped. *)

Runs == iAlive /\ ~stopped

\* A live observer acts within the watcher's 60 s unless it is paused: idle, or its user deciding.
Pause == {"idle", "askOrLetGo"}

\* With WatcherChecksToken, a wake nobody wants (no hold, no trap) is a signal to drop: wait again.
WatcherWakes ==
    /\ Runs /\ w = "woken"
    /\ intent' = IF intent > 0 THEN intent - 1 ELSE 0
    /\ IF ~WatcherChecksToken \/ f.hold \/ f.trap
       THEN f' = [f EXCEPT !.interrupted = TRUE] /\ w' = "spin" /\ UNCHANGED excess
       ELSE /\ IF excess > 0 THEN excess' = excess - 1 /\ UNCHANGED w
                              ELSE w' = "waiting" /\ UNCHANGED excess
            /\ UNCHANGED f
    /\ UNCHANGED <<hist, pending, bell, a, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

(* Spinning until a signal, or 60 s: then the script left for it, if any, else on. *)
WatcherSpinEnds(rung) ==
    /\ Runs /\ w = "spin"
    /\ IF rung THEN excess > 0 /\ (WatcherWaitsForDoSt => f.doSt) /\ excess' = 0
               ELSE /\ IF WatcherWaitsForDoSt THEN ~(excess > 0 /\ f.doSt) ELSE excess = 0
                    /\ (FastObserver => ~oAlive \/ oPc \in Pause) /\ excess' = 0
    /\ IF f.doSt
       THEN f' = [f EXCEPT !.doSt = FALSE] /\ w' = "agent" /\ a' = "starting"
       ELSE w' = "after" /\ UNCHANGED <<hist, pending, f, a>>
    /\ UNCHANGED <<hist, pending, bell, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

(* released, then interrupt wait: which returns at once when signals are counted. *)
WatcherAfter ==
    /\ Runs /\ w = "after"
    /\ f' = [f EXCEPT !.released = TRUE]
    /\ IF excess > 0 THEN excess' = excess - 1 /\ w' = "woken"
                     ELSE w' = "waiting" /\ UNCHANGED excess
    /\ UNCHANGED <<hist, pending, bell, a, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

\* With SeparateBell: a new Semaphore registered, its index left in bell-index.
AgentStarts ==
    /\ Runs /\ a = "starting"
    /\ LET g == [f EXCEPT !.bellIndex = SeparateBell] IN
       IF f.go THEN a' = "ended" /\ f' = g
               ELSE a' = "serving" /\ f' = [g EXCEPT !.serving = TRUE]
    /\ bell' = 0
    /\ UNCHANGED <<hist, pending, excess, w, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

(* Rung: the ring consumed, then the next request answered if there, else go read. *)
AgentRung ==
    /\ Runs /\ a = "serving"
    /\ IF SeparateBell THEN bell > 0 /\ bell' = 0 /\ UNCHANGED excess
                       ELSE excess > 0 /\ excess' = 0 /\ UNCHANGED bell
    /\ IF reqN > ansN
       THEN /\ ansN' = ansN + 1 /\ UNCHANGED a
            /\ trapOn' = IF installing THEN "on"
                          ELSE IF removing /\ trapOn = "on" THEN "off" ELSE trapOn
            /\ removed' = CASE ~removing -> removed
                             [] trapOn = "on" -> "removed"
                             [] trapOn = "firing" -> "firing"
                             [] OTHER -> "fired"
            /\ hist' = [hist EXCEPT !.badRemove = hist.badRemove
                                       \/ (removing /\ trapOn = "firing" /\ ~TrapClaims)]
            /\ installing' = FALSE /\ removing' = FALSE
       ELSE /\ a' = IF f.go THEN "ended" ELSE "serving"
            /\ UNCHANGED <<hist, ansN, trapOn, installing, removing, removed>>
    /\ UNCHANGED <<pending, w, intent, f, stopped, reqN, Observer, oAlive, iAlive>>

AgentExpires ==
    /\ HoldLimit /\ Runs /\ a = "serving" /\ (IF SeparateBell THEN bell ELSE excess) = 0
    /\ f' = [f EXCEPT !.expired = TRUE] /\ a' = "ended"
    /\ UNCHANGED <<hist, pending, excess, bell, w, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

\* With SeparateBell: bell-ended (with the guard), then the bell unregistered.
AgentEnds ==
    /\ Runs /\ a = "ended" /\ w = "agent"
    /\ a' = "none" /\ w' = "after"
    /\ f' = [f EXCEPT !.bellEnded = SeparateBell /\ BellEndedGuard]
    /\ UNCHANGED <<hist, pending, excess, bell, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

(* A user process reaches the method: the trap takes itself out, then says so and signals the
   watcher, two steps. User processes run only while the watcher and the agent are not spinning. *)
TrapStarts ==
    /\ Runs /\ trapOn = "on" /\ w = "waiting" /\ a = "none"
    /\ trapOn' = "firing"
    /\ UNCHANGED <<hist, pending, excess, bell, w, a, intent, f, stopped, Channel, Observer, oAlive, iAlive>>

TrapFires ==
    /\ Runs /\ trapOn = "firing" /\ w = "waiting" /\ a = "none"
    /\ trapOn' = "off" /\ f' = [f EXCEPT !.trap = TRUE] /\ intent' = intent + 1 /\ Signal
    /\ UNCHANGED <<hist, pending, bell, a, stopped, Channel, Observer, oAlive, iAlive>>

\* The VM delivers a queued signal at its next check for events, while the image runs.
DeliverSignal ==
    /\ Runs /\ pending > 0
    /\ pending' = pending - 1 /\ Signal
    /\ UNCHANGED <<hist, bell, a, intent, trapOn, f, stopped, Channel, Observer, oAlive, iAlive>>

ImageDies ==
    /\ iAlive /\ iAlive' = FALSE
    /\ UNCHANGED <<hist, pending, Image, stopped, f, Channel, Observer, oAlive>>

ImageSteps ==
    WatcherWakes \/ WatcherSpinEnds(TRUE) \/ WatcherSpinEnds(FALSE) \/ WatcherAfter
    \/ AgentStarts \/ AgentRung \/ AgentExpires \/ AgentEnds \/ TrapStarts \/ TrapFires \/ DeliverSignal

----------------------------------------------------------------------------
(* The observer: holdWithin:, serveAndHold:, ask:within:, letGo, runUntil:within:. The first
   hold asks MaxAsks things and lets go; with WithTrap the second is a runUntil:. *)

OStep(pc) == oAlive /\ oPc = pc
Quiet == FastObserver => ~ENABLED ImageSteps   \* a deadline passes only when nothing comes

HoldStop ==
    /\ OStep("idle") /\ holds < MaxHolds
    /\ stopped' = TRUE /\ f' = [f EXCEPT !.interrupted = FALSE, !.released = FALSE, !.hold = TRUE]
    /\ oPc' = "holdResume"
    /\ UNCHANGED <<hist, pending, Image, Channel, ringNext, holds, asks, oAlive, iAlive>>

HoldResume ==
    /\ OStep("holdResume")
    /\ stopped' = FALSE /\ intent' = intent + 1 /\ ObserverSignal
    /\ oPc' = "waitInterrupted"
    /\ UNCHANGED <<hist, bell, a, trapOn, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

Serve(next) ==   \* serveAndHold: a fresh channel, the agent's script, then a ring
    /\ f' = [f EXCEPT !.doSt = TRUE, !.serving = FALSE, !.go = FALSE, !.expired = FALSE,
                     !.bellIndex = FALSE, !.bellEnded = FALSE]
    /\ reqN' = 0 /\ ansN' = 0 /\ installing' = FALSE /\ removing' = FALSE /\ removed' = "removed"
    /\ oPc' = "ringStop" /\ ringNext' = next

\* The hold that a runUntil: comes back to when its trap did not fire in time, then a plain one.
SeeInterrupted ==
    /\ OStep("waitInterrupted") /\ f.interrupted
    /\ Serve(IF WithTrap /\ holds = 1 /\ asks > 0 THEN "removeTrap"
             ELSE IF WithTrap /\ holds = 1 THEN "trapAskWrite" ELSE "askOrLetGo")
    /\ UNCHANGED <<hist, pending, Image, stopped, holds, asks, oAlive, iAlive>>

RingStop ==
    /\ OStep("ringStop")
    /\ stopped' = TRUE /\ oPc' = "ringResume"
    /\ UNCHANGED <<hist, pending, Image, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

(* The ring (countOneSignalOnExternalSemaphore:), decided while the image is stopped: it sets
   the semaphore's count to 1 and wakes nobody. With SeparateBell it goes to bell-index once that
   exists; a bell no longer registered is a write past nil. With the guard, none after bell-ended. *)
BellRegistered == a \in {"serving", "ended"}

RingResume ==
    /\ OStep("ringResume")
    /\ stopped' = FALSE /\ oPc' = ringNext
    /\ CASE BellEndedGuard /\ f.bellEnded -> UNCHANGED <<hist, pending, excess, bell>>
         [] SeparateBell /\ f.bellIndex ->
              IF BellRegistered THEN bell' = 1 /\ UNCHANGED <<hist, pending, excess>>
              ELSE hist' = [hist EXCEPT !.badWrite = TRUE] /\ UNCHANGED <<excess, bell>>
         [] OTHER -> excess' = 1 /\ UNCHANGED <<hist, pending, bell>>
    /\ UNCHANGED <<pending, w, a, intent, trapOn, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

AskOrLetGo ==
    /\ OStep("askOrLetGo")
    /\ oPc' = IF asks < MaxAsks /\ ~(WithTrap /\ holds = 1) THEN "askWaitServing" ELSE "letGoWaitServing"
    /\ UNCHANGED <<hist, pending, Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

Ask(pc, kind, next) ==   \* ask:within: checks expired and gone, waits for serving, writes, rings
    /\ OStep(pc) /\ f.serving /\ ~f.expired /\ iAlive
    /\ reqN' = reqN + 1 /\ asks' = asks + 1
    /\ installing' = (kind = "install") /\ removing' = (kind = "remove")
    /\ oPc' = "ringStop" /\ ringNext' = next
    /\ UNCHANGED <<hist, pending, Image, stopped, f, ansN, removed, holds, oAlive, iAlive>>

AskWrite == Ask("askWaitServing", "plain", "askWaitAnswer")
TrapAskWrite == Ask("trapAskWrite", "install", "trapWaitInstalled")
RemoveTrap == Ask("removeTrap", "remove", "removeWaitAnswer")

SeeAnswer(pc, next) ==
    /\ OStep(pc) /\ ansN = reqN
    /\ oPc' = next
    /\ UNCHANGED <<hist, pending, Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

\* letGoWithin: nothing once expired or gone; else go once serving, rung only if it serves.
LetGo(pc, next) ==
    /\ OStep(pc) /\ f.serving /\ ~f.expired /\ iAlive
    /\ f' = [f EXCEPT !.go = TRUE, !.trap = FALSE, !.hold = FALSE] /\ oPc' = "ringStop" /\ ringNext' = next
    /\ UNCHANGED <<hist, pending, Image, stopped, Channel, holds, asks, oAlive, iAlive>>

\* With TrapClaims, a removal that found the trap firing: let go, and take the trap's hold to come.
SeeRemoved ==
    /\ OStep("removeWaitAnswer") /\ ansN = reqN
    /\ oPc' = IF TrapClaims /\ removed = "firing" THEN "claimedLetGo" ELSE "letGoWaitServing"
    /\ UNCHANGED <<hist, pending, Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

SeeTrapClaimed ==
    /\ OStep("waitTrapClaimed") /\ f.trap
    /\ oPc' = "waitTrapHeld"
    /\ UNCHANGED <<hist, pending, Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

\* runUntil: the trap installed, the image let go, then the trap's file or the fallback hold.
SeeTrap ==
    /\ OStep("waitTrap") /\ f.trap
    /\ oPc' = "waitTrapHeld"
    /\ UNCHANGED <<hist, pending, Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

SeeTrapHeld ==
    /\ OStep("waitTrapHeld") /\ f.interrupted
    /\ Serve("letGoWaitServing")
    /\ UNCHANGED <<hist, pending, Image, stopped, holds, asks, oAlive, iAlive>>

(* The trap did not come in time: hold anyway, then take the trap out. Its deadline can pass
   just as the trap fires: with FallbackSeesTrap, the stop finds the trap's file and takes the
   trap's hold instead of signalling a second time. *)
TrapFallback ==
    /\ OStep("waitTrap") /\ (AnyDeadline \/ Quiet)
    /\ stopped' = TRUE /\ oPc' = "fallbackResume"
    /\ UNCHANGED <<hist, pending, Image, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

FallbackResume ==
    /\ OStep("fallbackResume")
    /\ IF FallbackSeesTrap /\ f.trap
       THEN /\ stopped' = FALSE /\ oPc' = "waitTrapHeld"
            /\ UNCHANGED <<hist, pending, Image, f>>
       ELSE /\ f' = [f EXCEPT !.interrupted = FALSE, !.released = FALSE, !.hold = TRUE]
            /\ stopped' = FALSE /\ intent' = intent + 1 /\ ObserverSignal /\ oPc' = "waitInterrupted"
            /\ UNCHANGED <<hist, bell, a, trapOn>>
    /\ UNCHANGED <<Channel, ringNext, holds, asks, oAlive, iAlive>>

\* What the observer waits for in each state, there already: no reason to give up.
Awaited ==
    CASE oPc \in {"waitInterrupted", "waitTrapHeld"} -> f.interrupted
      [] oPc = "waitTrapClaimed" -> f.trap
      [] oPc \in {"askWaitServing", "trapAskWrite", "removeTrap"} -> f.serving /\ ~f.expired
      [] oPc \in {"askWaitAnswer", "trapWaitInstalled", "removeWaitAnswer"} -> ansN = reqN
      [] OTHER -> FALSE

\* Giving up on an image alive and not expired: the hold was lost.
GiveUp ==
    /\ oAlive /\ Quiet /\ ~Awaited
    /\ \/ oPc \in {"waitInterrupted", "waitTrapHeld", "askWaitServing", "askWaitAnswer",
                   "trapAskWrite", "trapWaitInstalled", "removeTrap", "removeWaitAnswer", "waitTrapClaimed"}
       \/ oPc \in {"letGoWaitServing", "trapLetGo", "claimedLetGo"} /\ (f.expired \/ ~iAlive)
    /\ oPc' = "done"
    /\ hist' = [hist EXCEPT !.lost = hist.lost \/ (iAlive /\ ~f.expired)]
    /\ UNCHANGED <<pending, Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

LetGoDeadline ==
    /\ oPc \in {"letGoWaitServing", "trapLetGo", "claimedLetGo"} /\ oAlive /\ Quiet
    /\ f' = [f EXCEPT !.go = TRUE, !.hold = FALSE]
    /\ oPc' = CASE oPc = "trapLetGo" -> "waitTrap" [] oPc = "claimedLetGo" -> "waitTrapClaimed" [] OTHER -> "done"
    /\ UNCHANGED <<hist, pending, Image, stopped, Channel, ringNext, holds, asks, oAlive, iAlive>>

Done ==
    /\ OStep("done")
    /\ holds' = holds + 1 /\ asks' = 0 /\ oPc' = "idle"
    /\ UNCHANGED <<hist, pending, Image, stopped, f, Channel, ringNext, oAlive, iAlive>>

ObserverDies ==
    /\ oAlive /\ oAlive' = FALSE
    /\ stopped' = (stopped /\ ~StopEndsWithObserver)
    /\ UNCHANGED <<hist, pending, Image, f, Channel, Observer, iAlive>>

ObserverSteps ==
    \/ HoldStop \/ HoldResume \/ SeeInterrupted \/ RingStop \/ RingResume \/ AskOrLetGo
    \/ AskWrite \/ SeeAnswer("askWaitAnswer", "askOrLetGo") \/ LetGo("letGoWaitServing", "done")
    \/ TrapAskWrite \/ SeeAnswer("trapWaitInstalled", "trapLetGo") \/ LetGo("trapLetGo", "waitTrap")
    \/ SeeTrap \/ SeeTrapHeld \/ TrapFallback \/ FallbackResume
    \/ RemoveTrap \/ SeeRemoved \/ LetGo("claimedLetGo", "waitTrapClaimed") \/ SeeTrapClaimed
    \/ GiveUp \/ LetGoDeadline \/ Done

----------------------------------------------------------------------------

Next == ObserverSteps \/ ImageSteps \/ ObserverDies \/ ImageDies

Spec ==
    /\ Init /\ [][Next]_vars
    /\ WF_vars(ObserverSteps)
    /\ WF_vars(WatcherWakes) /\ WF_vars(WatcherSpinEnds(TRUE)) /\ WF_vars(WatcherSpinEnds(FALSE))
    /\ WF_vars(WatcherAfter) /\ WF_vars(AgentStarts) /\ WF_vars(AgentRung)
    /\ WF_vars(AgentExpires) /\ WF_vars(AgentEnds) /\ WF_vars(TrapStarts) /\ WF_vars(TrapFires)
    /\ WF_vars(DeliverSignal)

----------------------------------------------------------------------------
(* Properties, numbered as in protocol.md. *)

UserRuns == iAlive /\ ~stopped /\ w = "waiting"

\* 5. Every hold the watcher takes was signalled for, by the observer or the trap.
NoStrayHold == w = "woken" => intent > 0

\* 6. A runUntil: the observer finished leaves no trap behind.
NoTrapLeft == (oAlive /\ iAlive /\ oPc = "idle" /\ holds = MaxHolds) => trapOn = "off"

\* 7. Every ask ends, unless the observer died.
AskEnds == [](oPc = "askWaitAnswer" => <>(oPc # "askWaitAnswer" \/ ~oAlive))

\* 8. If the observer dies, the image runs again (or ends).
FreeIfObserverDies == (~oAlive /\ iAlive) ~> (UserRuns \/ ~iAlive)

\* 9. Once the observer is through, the image runs again (or ends).
FreeWhenThrough == (oAlive /\ oPc = "idle" /\ holds = MaxHolds) ~> (UserRuns \/ ~iAlive)

\* 13. The watcher holds only while the observer is in a hold: never by itself between holds.
NoUnservedHold == (w = "spin" /\ oAlive /\ iAlive /\ ~f.expired) => oPc \notin {"idle", "done"}

\* 14. The trap's removal never takes out a trap already taking itself out (an error there).
NoBadRemove == ~hist.badRemove

\* 11. No ring is written into the image where no semaphore is.
NoBadWrite == ~hist.badWrite

\* 12. The observer never gives up on an image that is alive and whose agent did not expire.
NoLostHold == ~hist.lost

StateBound == excess <= 3 /\ bell <= 3 /\ intent <= 3 /\ pending <= 3
=============================================================================
