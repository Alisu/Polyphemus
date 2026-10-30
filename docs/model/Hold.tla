---------------------------- MODULE Hold ----------------------------
(* The hold protocol of Polyphemus (stage2 at 26cbcae), as protocol.md describes it: an observer
   holds an image through a watcher it put in, hands it an agent, asks it things, runs it until a
   method (a trap), and lets it go. Either side can die at any moment. No memory here: only who
   waits on what. Version 2: files in one record, Pharo's semaphore wait, the trap of runUntil:. *)

EXTENDS Naturals

CONSTANTS
    MaxHolds,             \* holds the observer makes in a row
    MaxAsks,              \* requests per plain hold
    WithTrap,             \* TRUE: the second hold is a runUntil:
    HoldLimit,            \* TRUE: the agent ends by itself after its limit; FALSE: holdLimit: nil
    FastObserver,         \* TRUE: a live observer acts within the watcher's 60 s
    SeparateBell,         \* TRUE: the agent's rings go to a bell of its own
    StopEndsWithObserver  \* TRUE: a stop is let go when the observer dies (ptrace); FALSE: SIGSTOP

VARIABLES
    excess,      \* the watcher's semaphore: signals counted
    bell,        \* the agent's own bell, when SeparateBell
    stopped,     \* the image is stopped by the observer
    w,           \* watcher: waiting | woken | spin | agent | after
    a,           \* agent: none | starting | serving | ended
    intent,      \* holds signalled for (by the observer or the trap) not yet taken
    trapOn,      \* the trap is installed in the image
    installing,  \* the observer's pending request installs the trap
    removing,    \* the observer's pending request removes the trap
    f,           \* the files: [interrupted, doSt, serving, go, expired, released, trap |-> BOOLEAN]
    reqN, ansN,  \* requests written, answers written, in the current channel
    oPc, ringNext, oAlive, iAlive, holds, asks

vars == <<excess, bell, stopped, w, a, intent, trapOn, installing, removing, f, reqN, ansN,
          oPc, ringNext, oAlive, iAlive, holds, asks>>

NoFiles == [interrupted |-> FALSE, doSt |-> FALSE, serving |-> FALSE, go |-> FALSE,
            expired |-> FALSE, released |-> FALSE, trap |-> FALSE]

Init ==
    /\ excess = 0 /\ bell = 0 /\ stopped = FALSE /\ w = "waiting" /\ a = "none" /\ intent = 0
    /\ trapOn = FALSE /\ installing = FALSE /\ removing = FALSE /\ f = NoFiles
    /\ reqN = 0 /\ ansN = 0
    /\ oPc = "idle" /\ ringNext = "idle" /\ oAlive = TRUE /\ iAlive = TRUE /\ holds = 0 /\ asks = 0

(* A signal on the watcher's semaphore, taken by the VM when the image runs: it resumes the
   watcher if the watcher waits on it, else it is counted. *)
Signal ==
    IF w = "waiting" THEN w' = "woken" /\ UNCHANGED excess
                     ELSE excess' = excess + 1 /\ UNCHANGED w

Image == <<excess, bell, w, a, intent, trapOn>>
Observer == <<oPc, ringNext, holds, asks>>
Channel == <<installing, removing, reqN, ansN>>

----------------------------------------------------------------------------
(* The image: the watcher (holdSourceAfterwards:) and the agent it runs (sourceServing:...),
   and the trap in a user process. They run only while the image is alive and not stopped. *)

Runs == iAlive /\ ~stopped

\* A live observer acts within the watcher's 60 s unless it is paused: idle, or its user deciding.
Pause == {"idle", "askOrLetGo"}

WatcherWakes ==
    /\ Runs /\ w = "woken"
    /\ f' = [f EXCEPT !.interrupted = TRUE] /\ w' = "spin"
    /\ intent' = IF intent > 0 THEN intent - 1 ELSE 0
    /\ UNCHANGED <<excess, bell, a, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

(* Spinning until a signal, or 60 s: then the script left for it, if any, else on. *)
WatcherSpinEnds(rung) ==
    /\ Runs /\ w = "spin"
    /\ IF rung THEN excess > 0 /\ excess' = 0
               ELSE excess = 0 /\ (FastObserver => ~oAlive \/ oPc \in Pause) /\ UNCHANGED excess
    /\ IF f.doSt
       THEN f' = [f EXCEPT !.doSt = FALSE] /\ w' = "agent" /\ a' = "starting"
       ELSE w' = "after" /\ UNCHANGED <<f, a>>
    /\ UNCHANGED <<bell, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

(* released, then interrupt wait: which returns at once when signals are counted. *)
WatcherAfter ==
    /\ Runs /\ w = "after"
    /\ f' = [f EXCEPT !.released = TRUE]
    /\ IF excess > 0 THEN excess' = excess - 1 /\ w' = "woken"
                     ELSE w' = "waiting" /\ UNCHANGED excess
    /\ UNCHANGED <<bell, a, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

AgentStarts ==
    /\ Runs /\ a = "starting"
    /\ IF f.go THEN a' = "ended" /\ UNCHANGED f
               ELSE a' = "serving" /\ f' = [f EXCEPT !.serving = TRUE]
    /\ UNCHANGED <<excess, bell, w, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

(* Rung: the ring consumed, then the next request answered if there, else go read. *)
AgentRung ==
    /\ Runs /\ a = "serving"
    /\ IF SeparateBell THEN bell > 0 /\ bell' = 0 /\ UNCHANGED excess
                       ELSE excess > 0 /\ excess' = 0 /\ UNCHANGED bell
    /\ IF reqN > ansN
       THEN /\ ansN' = ansN + 1 /\ UNCHANGED a
            /\ trapOn' = IF installing THEN TRUE ELSE IF removing THEN FALSE ELSE trapOn
            /\ installing' = FALSE /\ removing' = FALSE
       ELSE /\ a' = IF f.go THEN "ended" ELSE "serving"
            /\ UNCHANGED <<ansN, trapOn, installing, removing>>
    /\ UNCHANGED <<w, intent, f, stopped, reqN, Observer, oAlive, iAlive>>

AgentExpires ==
    /\ HoldLimit /\ Runs /\ a = "serving" /\ (IF SeparateBell THEN bell ELSE excess) = 0
    /\ f' = [f EXCEPT !.expired = TRUE] /\ a' = "ended"
    /\ UNCHANGED <<excess, bell, w, intent, trapOn, stopped, Channel, Observer, oAlive, iAlive>>

AgentEnds ==
    /\ Runs /\ a = "ended" /\ w = "agent"
    /\ a' = "none" /\ w' = "after"
    /\ UNCHANGED <<excess, bell, intent, trapOn, f, stopped, Channel, Observer, oAlive, iAlive>>

(* A user process reaches the method: the trap takes itself out, says so, signals the watcher.
   User processes run only while the watcher and the agent are not spinning. *)
TrapFires ==
    /\ Runs /\ trapOn /\ w = "waiting" /\ a = "none"
    /\ trapOn' = FALSE /\ f' = [f EXCEPT !.trap = TRUE] /\ intent' = intent + 1 /\ Signal
    /\ UNCHANGED <<bell, a, stopped, Channel, Observer, oAlive, iAlive>>

ImageDies ==
    /\ iAlive /\ iAlive' = FALSE
    /\ UNCHANGED <<Image, stopped, f, Channel, Observer, oAlive>>

ImageSteps ==
    WatcherWakes \/ WatcherSpinEnds(TRUE) \/ WatcherSpinEnds(FALSE) \/ WatcherAfter
    \/ AgentStarts \/ AgentRung \/ AgentExpires \/ AgentEnds \/ TrapFires

----------------------------------------------------------------------------
(* The observer: holdWithin:, serveAndHold:, ask:within:, letGo, runUntil:within:. The first
   hold asks MaxAsks things and lets go; with WithTrap the second is a runUntil:. *)

OStep(pc) == oAlive /\ oPc = pc
Quiet == FastObserver => ~ENABLED ImageSteps   \* a deadline passes only when nothing comes

HoldStop ==
    /\ OStep("idle") /\ holds < MaxHolds
    /\ stopped' = TRUE /\ f' = [f EXCEPT !.interrupted = FALSE, !.released = FALSE]
    /\ oPc' = "holdResume"
    /\ UNCHANGED <<Image, Channel, ringNext, holds, asks, oAlive, iAlive>>

HoldResume ==
    /\ OStep("holdResume")
    /\ stopped' = FALSE /\ intent' = intent + 1 /\ Signal
    /\ oPc' = "waitInterrupted"
    /\ UNCHANGED <<bell, a, trapOn, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

Serve(next) ==   \* serveAndHold: a fresh channel, the agent's script, then a ring
    /\ f' = [f EXCEPT !.doSt = TRUE, !.serving = FALSE, !.go = FALSE, !.expired = FALSE]
    /\ reqN' = 0 /\ ansN' = 0 /\ installing' = FALSE /\ removing' = FALSE
    /\ oPc' = "ringStop" /\ ringNext' = next

\* The hold that a runUntil: comes back to when its trap did not fire in time, then a plain one.
SeeInterrupted ==
    /\ OStep("waitInterrupted") /\ f.interrupted
    /\ Serve(IF WithTrap /\ holds = 1 /\ asks > 0 THEN "removeTrap"
             ELSE IF WithTrap /\ holds = 1 THEN "trapAskWrite" ELSE "askOrLetGo")
    /\ UNCHANGED <<Image, stopped, holds, asks, oAlive, iAlive>>

RingStop ==
    /\ OStep("ringStop")
    /\ stopped' = TRUE /\ oPc' = "ringResume"
    /\ UNCHANGED <<Image, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

\* The ring that hands the watcher its script is the hold's; the others are the agent's.
HoldRing == {"askOrLetGo", "removeTrap", "trapAskWrite", "letGoWaitServing"}

RingResume ==
    /\ OStep("ringResume")
    /\ stopped' = FALSE /\ oPc' = ringNext
    /\ IF SeparateBell /\ ringNext \notin HoldRing
       THEN bell' = bell + 1 /\ UNCHANGED <<excess, w>>
       ELSE Signal /\ UNCHANGED bell
    /\ UNCHANGED <<a, intent, trapOn, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

AskOrLetGo ==
    /\ OStep("askOrLetGo")
    /\ oPc' = IF asks < MaxAsks /\ ~(WithTrap /\ holds = 1) THEN "askWaitServing" ELSE "letGoWaitServing"
    /\ UNCHANGED <<Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

Ask(pc, kind, next) ==   \* ask:within: checks expired and gone, waits for serving, writes, rings
    /\ OStep(pc) /\ f.serving /\ ~f.expired /\ iAlive
    /\ reqN' = reqN + 1 /\ asks' = asks + 1
    /\ installing' = (kind = "install") /\ removing' = (kind = "remove")
    /\ oPc' = "ringStop" /\ ringNext' = next
    /\ UNCHANGED <<Image, stopped, f, ansN, holds, oAlive, iAlive>>

AskWrite == Ask("askWaitServing", "plain", "askWaitAnswer")
TrapAskWrite == Ask("trapAskWrite", "install", "trapWaitInstalled")
RemoveTrap == Ask("removeTrap", "remove", "removeWaitAnswer")

SeeAnswer(pc, next) ==
    /\ OStep(pc) /\ ansN = reqN
    /\ oPc' = next
    /\ UNCHANGED <<Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

\* letGoWithin: nothing once expired or gone; else go once serving, rung only if it serves.
LetGo(pc, next) ==
    /\ OStep(pc) /\ f.serving /\ ~f.expired /\ iAlive
    /\ f' = [f EXCEPT !.go = TRUE, !.trap = FALSE] /\ oPc' = "ringStop" /\ ringNext' = next
    /\ UNCHANGED <<Image, stopped, Channel, holds, asks, oAlive, iAlive>>

\* runUntil: the trap installed, the image let go, then the trap's file or the fallback hold.
SeeTrap ==
    /\ OStep("waitTrap") /\ f.trap
    /\ oPc' = "waitTrapHeld"
    /\ UNCHANGED <<Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

SeeTrapHeld ==
    /\ OStep("waitTrapHeld") /\ f.interrupted
    /\ Serve("letGoWaitServing")
    /\ UNCHANGED <<Image, stopped, holds, asks, oAlive, iAlive>>

TrapFallback ==   \* the trap never came in time: hold anyway, then take the trap out
    /\ OStep("waitTrap") /\ Quiet
    /\ stopped' = TRUE /\ f' = [f EXCEPT !.interrupted = FALSE, !.released = FALSE]
    /\ oPc' = "holdResume"
    /\ UNCHANGED <<Image, Channel, ringNext, holds, asks, oAlive, iAlive>>

GiveUp ==
    /\ oAlive /\ Quiet
    /\ \/ oPc \in {"waitInterrupted", "waitTrapHeld", "askWaitServing", "askWaitAnswer",
                   "trapAskWrite", "trapWaitInstalled", "removeTrap", "removeWaitAnswer"}
       \/ oPc \in {"letGoWaitServing", "trapLetGo"} /\ (f.expired \/ ~iAlive)
    /\ oPc' = "done"
    /\ UNCHANGED <<Image, stopped, f, Channel, ringNext, holds, asks, oAlive, iAlive>>

LetGoDeadline ==
    /\ oPc \in {"letGoWaitServing", "trapLetGo"} /\ oAlive /\ Quiet
    /\ f' = [f EXCEPT !.go = TRUE] /\ oPc' = IF oPc = "trapLetGo" THEN "waitTrap" ELSE "done"
    /\ UNCHANGED <<Image, stopped, Channel, ringNext, holds, asks, oAlive, iAlive>>

Done ==
    /\ OStep("done")
    /\ holds' = holds + 1 /\ asks' = 0 /\ oPc' = "idle"
    /\ UNCHANGED <<Image, stopped, f, Channel, ringNext, oAlive, iAlive>>

ObserverDies ==
    /\ oAlive /\ oAlive' = FALSE
    /\ stopped' = (stopped /\ ~StopEndsWithObserver)
    /\ UNCHANGED <<Image, f, Channel, Observer, iAlive>>

ObserverSteps ==
    \/ HoldStop \/ HoldResume \/ SeeInterrupted \/ RingStop \/ RingResume \/ AskOrLetGo
    \/ AskWrite \/ SeeAnswer("askWaitAnswer", "askOrLetGo") \/ LetGo("letGoWaitServing", "done")
    \/ TrapAskWrite \/ SeeAnswer("trapWaitInstalled", "trapLetGo") \/ LetGo("trapLetGo", "waitTrap")
    \/ SeeTrap \/ SeeTrapHeld \/ TrapFallback
    \/ RemoveTrap \/ SeeAnswer("removeWaitAnswer", "letGoWaitServing")
    \/ GiveUp \/ LetGoDeadline \/ Done

----------------------------------------------------------------------------

Next == ObserverSteps \/ ImageSteps \/ ObserverDies \/ ImageDies

Spec ==
    /\ Init /\ [][Next]_vars
    /\ WF_vars(ObserverSteps)
    /\ WF_vars(WatcherWakes) /\ WF_vars(WatcherSpinEnds(TRUE)) /\ WF_vars(WatcherSpinEnds(FALSE))
    /\ WF_vars(WatcherAfter) /\ WF_vars(AgentStarts) /\ WF_vars(AgentRung)
    /\ WF_vars(AgentExpires) /\ WF_vars(AgentEnds) /\ WF_vars(TrapFires)

----------------------------------------------------------------------------
(* Properties, numbered as in protocol.md. *)

UserRuns == iAlive /\ ~stopped /\ w = "waiting"

\* 5. Every hold the watcher takes was signalled for, by the observer or the trap.
NoStrayHold == w = "woken" => intent > 0

\* 6. A runUntil: the observer finished leaves no trap behind.
NoTrapLeft == (oAlive /\ iAlive /\ oPc = "idle" /\ holds = MaxHolds) => ~trapOn

\* 7. Every ask ends, unless the observer died.
AskEnds == [](oPc = "askWaitAnswer" => <>(oPc # "askWaitAnswer" \/ ~oAlive))

\* 8. If the observer dies, the image runs again (or ends).
FreeIfObserverDies == (~oAlive /\ iAlive) ~> (UserRuns \/ ~iAlive)

\* 9. Once the observer is through, the image runs again (or ends).
FreeWhenThrough == (oAlive /\ oPc = "idle" /\ holds = MaxHolds) ~> (UserRuns \/ ~iAlive)

StateBound == excess <= 3 /\ bell <= 3 /\ intent <= 3
=============================================================================
