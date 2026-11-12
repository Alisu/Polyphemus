-------------------------- MODULE StopHelper --------------------------
(* The stop helper of #137, before it is written: two observers each read (and may write into)
   the same image, every stop going through a helper of their own. A helper takes a lock named
   after the image's pid, stops the image, leaves a mark naming itself, and resumes the image when
   its observer says so, when its observer dies, or at its bound. An observer whose stop ended
   early (or whose helper died) throws its reading away and tries again. A helper can be killed
   too: the system then releases its lock, but not the stop.
   Since #187 (2026-11-12) the helper's program is in it too: an observer builds it when it is not
   there, and one built in place can be started by another observer while half written. Such a
   helper says nothing, for ever. *)

EXTENDS Naturals, FiniteSets

CONSTANTS
    RecoverStale,  \* TRUE: a helper taking the lock resumes an image a dead helper left stopped
    MaxTries,      \* readings an observer tries before giving up
    HelpersKillable, \* FALSE: a helper is never killed (it only ends by resuming)
    BuiltInPlace,    \* TRUE (before #187): the program is written where it is run from, there while half written
    GiveUpSilent     \* TRUE (#187): a helper that says nothing is given up, and another started

Obs == {"O1", "O2"}

VARIABLES
    img,         \* "running" | "stopped"
    lock,        \* the observer whose helper holds the lock, or "none"
    mark,        \* the observer whose helper stopped the image, or "none" (a file beside the lock)
    h,           \* [Obs -> none | waiting | holding | gone | silent]: each observer's helper
    pc,          \* [Obs -> idle | building | waitStop | reading | writing | done | dead]
    program,     \* the helper's program: "none" | "partial" (being written in place) | "whole"
    early,       \* [Obs -> BOOLEAN]: the stop ended before the observer said resume
    disturbed,   \* [Obs -> BOOLEAN]: the image ran while the observer was reading
    tries,       \* [Obs -> Nat]
    bad          \* a reading accepted though disturbed, or a write into the running image

vars == <<img, lock, mark, h, pc, program, early, disturbed, tries, bad>>

Init ==
    /\ img = "running" /\ lock = "none" /\ mark = "none"
    /\ h = [o \in Obs |-> "none"] /\ pc = [o \in Obs |-> "idle"]
    /\ early = [o \in Obs |-> FALSE] /\ disturbed = [o \in Obs |-> FALSE]
    /\ tries = [o \in Obs |-> 0] /\ bad = FALSE /\ program = "none"

Readers == {o \in Obs : pc[o] \in {"reading", "writing"}}

\* The image runs again: whoever was reading it is disturbed.
Runs == /\ img' = "running"
        /\ disturbed' = [o \in Obs |-> disturbed[o] \/ o \in Readers]

----------------------------------------------------------------------------

(* No program there: the observer builds it. In place, it is there, half written, from the first
   byte; under another name and renamed, it is there only whole. *)
BuildStart(o) ==
    /\ pc[o] = "idle" /\ program = "none"
    /\ pc' = [pc EXCEPT ![o] = "building"]
    /\ program' = IF BuiltInPlace THEN "partial" ELSE program
    /\ UNCHANGED <<img, lock, mark, h, early, disturbed, tries, bad>>

BuildEnd(o) ==
    /\ pc[o] = "building"
    /\ pc' = [pc EXCEPT ![o] = "idle"] /\ program' = "whole"
    /\ UNCHANGED <<img, lock, mark, h, early, disturbed, tries, bad>>

Request(o) ==   \* the observer starts its helper: one started half written says nothing
    /\ pc[o] = "idle" /\ tries[o] < MaxTries /\ program # "none"
    /\ h' = [h EXCEPT ![o] = IF program = "whole" THEN "waiting" ELSE "silent"]
    /\ pc' = [pc EXCEPT ![o] = "waitStop"]
    /\ early' = [early EXCEPT ![o] = FALSE] /\ disturbed' = [disturbed EXCEPT ![o] = FALSE]
    /\ tries' = [tries EXCEPT ![o] = @ + 1]
    /\ UNCHANGED <<img, lock, mark, program, bad>>

Acquire(o) ==   \* the lock, then (if a dead helper left the image stopped) a resume, then the stop
    /\ h[o] = "waiting" /\ lock = "none"
    /\ lock' = o /\ h' = [h EXCEPT ![o] = "holding"]
    /\ img' = "stopped" /\ mark' = o
    \* a stale stop is resumed first, then stopped again: a reader of the dead helper is disturbed
    /\ disturbed' = [x \in Obs |-> disturbed[x] \/
                       (RecoverStale /\ mark # "none" /\ x \in Readers)]
    /\ UNCHANGED <<pc, early, tries, bad, program>>

\* The helper says "stopped": the observer reads.
ReadStart(o) ==
    /\ pc[o] = "waitStop" /\ h[o] = "holding"
    /\ pc' = [pc EXCEPT ![o] = "reading"]
    /\ UNCHANGED <<img, lock, mark, h, early, disturbed, tries, bad, program>>

\* The reading done, maybe a write into the image (the watcher, a method), then resume.
ReadEnd(o) ==
    /\ pc[o] = "reading"
    /\ pc' = [pc EXCEPT ![o] = "writing"]
    /\ UNCHANGED <<img, lock, mark, h, early, disturbed, tries, bad, program>>

Write(o) ==   \* the observer writes only while its helper still holds the stop and said nothing else
    /\ pc[o] = "writing"
    /\ IF h[o] = "holding" /\ ~early[o]
       THEN /\ bad' = (bad \/ img # "stopped" \/ disturbed[o])
            /\ pc' = [pc EXCEPT ![o] = "resuming"]
       ELSE /\ pc' = [pc EXCEPT ![o] = "idle"] /\ UNCHANGED bad   \* ended early: read again
    /\ UNCHANGED <<img, lock, mark, h, early, disturbed, tries, program>>

Resume(o) ==   \* the observer says resume: the helper resumes, removes its mark, lets the lock go
    /\ pc[o] = "resuming" /\ h[o] = "holding"
    /\ Runs /\ mark' = "none" /\ lock' = "none"
    /\ h' = [h EXCEPT ![o] = "none"] /\ pc' = [pc EXCEPT ![o] = "done"]
    /\ UNCHANGED <<early, tries, bad, program>>

\* The bound passes (the observer is slow, stopped by someone else, or dead): the helper resumes.
Bound(o) ==
    /\ h[o] = "holding" /\ pc[o] \in {"waitStop", "reading", "writing", "dead"}
    /\ Runs /\ mark' = "none" /\ lock' = "none"
    /\ h' = [h EXCEPT ![o] = "none"] /\ early' = [early EXCEPT ![o] = TRUE]
    /\ UNCHANGED <<pc, tries, bad, program>>

\* The observer dies: its helper reads the end of its input and resumes at once.
ObserverDies(o) ==
    /\ pc[o] \notin {"done", "dead"}
    /\ pc' = [pc EXCEPT ![o] = "dead"]
    /\ UNCHANGED <<img, lock, mark, h, early, disturbed, tries, bad, program>>

\* The helper is killed: the system lets its lock go, not its stop; its observer sees it gone.
HelperKilled(o) ==
    /\ HelpersKillable /\ h[o] \in {"waiting", "holding"}
    /\ h' = [h EXCEPT ![o] = "gone"] /\ early' = [early EXCEPT ![o] = TRUE]
    /\ lock' = IF lock = o THEN "none" ELSE lock
    /\ UNCHANGED <<img, mark, pc, disturbed, tries, bad, program>>

\* An observer whose helper is gone or ended early starts over; with GiveUpSilent, one whose
\* helper said nothing too.
StartOver(o) ==
    /\ pc[o] \in {"waitStop", "reading"}
    /\ (h[o] = "gone" \/ (early[o] /\ h[o] = "none") \/ (GiveUpSilent /\ h[o] = "silent"))
    /\ pc' = [pc EXCEPT ![o] = "idle"] /\ h' = [h EXCEPT ![o] = "none"]
    /\ UNCHANGED <<img, lock, mark, early, disturbed, tries, bad, program>>

GiveUp(o) ==
    /\ pc[o] = "idle" /\ tries[o] >= MaxTries
    /\ pc' = [pc EXCEPT ![o] = "done"]
    /\ UNCHANGED <<img, lock, mark, h, early, disturbed, tries, bad, program>>

Step(o) ==
    BuildStart(o) \/ BuildEnd(o) \/ Request(o) \/ Acquire(o) \/ ReadStart(o) \/ ReadEnd(o) \/ Write(o) \/ Resume(o)
    \/ StartOver(o) \/ GiveUp(o)

Next == \E o \in Obs : Step(o) \/ Bound(o) \/ ObserverDies(o) \/ HelperKilled(o)

\* Steps happen if they stay possible; deaths and kills are never forced. The bound is not forced
\* either, except for a dead observer's helper, which resumes as soon as its input ends.
Spec ==
    /\ Init /\ [][Next]_vars
    /\ \A o \in Obs : WF_vars(Step(o)) /\ WF_vars(Bound(o) /\ pc[o] = "dead")

----------------------------------------------------------------------------

\* No reading accepted that the image moved under, no write into the running image.
NoBadReadOrWrite == ~bad

\* At most one helper holds the image stopped.
OneHolder == Cardinality({o \in Obs : h[o] = "holding"}) <= 1

\* The image is never left stopped for ever.
NeverStoppedForEver == [](img = "stopped" => <>(img = "running"))

\* Every observer gets through: its reading done, or refused after its tries, unless it died.
EveryObserverThrough == \A o \in Obs : <>(pc[o] \in {"done", "dead"})

TypeOK == mark \in Obs \cup {"none"}
=============================================================================
