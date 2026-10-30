-------------------------- MODULE InjectPair --------------------------
(* Putting the watcher in (WatcherInjection>>inject) from two observers at once, into the same
   image and the same folder. Each stops the image, looks for a watcher already there
   (watcherAlreadyIn: the semaphore in semaphore-index, and a process waiting on it), writes the
   watcher's objects if there is none, and resumes the image. SIGSTOP and SIGCONT are not
   counted: one resume lets the image go for everyone who stopped it. *)

EXTENDS Naturals

CONSTANTS
    StopLock   \* TRUE: one observer at a time may stop the image (a lock named after its pid)

Obs == {"O1", "O2"}

VARIABLES
    stopped,     \* the image is stopped
    watchers,    \* watchers put in
    indexFile,   \* semaphore-index names a watcher
    lock,        \* the observer holding the stop lock, or "none"
    pc,          \* [Obs -> idle | stopping | checking | writing | resuming | done]
    found,       \* [Obs -> BOOLEAN]: it found a watcher already there
    badWrite     \* some observer wrote into the image while it ran

vars == <<stopped, watchers, indexFile, lock, pc, found, badWrite>>

Init ==
    /\ stopped = FALSE /\ watchers = 0 /\ indexFile = FALSE /\ lock = "none"
    /\ pc = [o \in Obs |-> "idle"] /\ found = [o \in Obs |-> FALSE] /\ badWrite = FALSE

Stop(o) ==
    /\ pc[o] = "idle"
    /\ StopLock => lock = "none"
    /\ lock' = IF StopLock THEN o ELSE lock
    /\ stopped' = TRUE /\ pc' = [pc EXCEPT ![o] = "checking"]
    /\ UNCHANGED <<watchers, indexFile, found, badWrite>>

Check(o) ==   \* watcherAlreadyIn, read while it believes the image stopped
    /\ pc[o] = "checking"
    /\ found' = [found EXCEPT ![o] = indexFile]
    /\ pc' = [pc EXCEPT ![o] = IF indexFile THEN "resuming" ELSE "writing"]
    /\ UNCHANGED <<stopped, watchers, indexFile, lock, badWrite>>

Write(o) ==   \* the watcher's objects, its semaphore registered, semaphore-index written
    /\ pc[o] = "writing"
    /\ watchers' = watchers + 1 /\ indexFile' = TRUE
    /\ badWrite' = (badWrite \/ ~stopped)
    /\ pc' = [pc EXCEPT ![o] = "resuming"]
    /\ UNCHANGED <<stopped, lock, found>>

Resume(o) ==
    /\ pc[o] = "resuming"
    /\ stopped' = FALSE /\ lock' = IF StopLock THEN "none" ELSE lock
    /\ pc' = [pc EXCEPT ![o] = "done"]
    /\ UNCHANGED <<watchers, indexFile, found, badWrite>>

Next == \E o \in Obs : Stop(o) \/ Check(o) \/ Write(o) \/ Resume(o)

Spec == Init /\ [][Next]_vars /\ \A o \in Obs : WF_vars(Stop(o) \/ Check(o) \/ Write(o) \/ Resume(o))

\* 4. Nothing is written into the image while it runs.
NoWriteWhileRunning == ~badWrite

\* 2. One watcher per image and folder.
OneWatcher == watchers <= 1

\* Both observers get through.
BothDone == <>(\A o \in Obs : pc[o] = "done")
=============================================================================
