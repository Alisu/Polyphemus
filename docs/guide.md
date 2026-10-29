# Debugging a running Pharo with Polyphemus

A Pharo image is running and something is wrong in it: it is frozen, looping, or doing something
it should not. Polyphemus lets you look inside it **from another Pharo**, stop it where you want,
step it in Pharo's own debugger, fix a method, and let it run on. This guide walks through that,
step by step. Reading image files and core dumps, and the MCP server for agents, are in
[START-HERE.md](START-HERE.md); what does not work yet is in [limitations.md](limitations.md).

## Two images

- The **observer** is your Pharo, with Polyphemus loaded. You work in it.
- The **observee** is the image you look into. It needs nothing installed: a stock Pharo works.

Both must be the same Pharo version (10 to 14), because an observer reads the Pharo of its own
edition only.

## 1. Before the first time

Load Polyphemus in the observer as [START-HERE.md](START-HERE.md) shows (section 1). It takes
several minutes, once.

Looking into another running process needs the right to:

- **macOS**: run the observer as root, `sudo ./pharo-ui observer.image`. A root observer leaves
  files owned by root (the watch folder, Iceberg's clone); before working as yourself again,
  `sudo chown -R "$USER" <that folder>`.
- **Linux**: start the observee through `bin/pharo-debuggable` (built once, START-HERE section 2),
  or run the observer as root for a VM someone else started.

## 2. Find the observee

You need its process id (`ps aux | grep pharo`, or the Activity Monitor). To see where it is stuck
without touching it:

```smalltalk
Polyphemus whereIsStuck: 12345.
```

It says, for each thread, whether it waits in the kernel, runs machine code, or is blocked in a C
call. An image stuck in a C call (an FFI call, a primitive) cannot be held: take a core instead
(section 7).

## 3. Hold it where you want

In a new Playground in the observer, with the observee's pid and a folder of your choice:

```smalltalk
| pid dir session |
pid := 12345.
dir := '/tmp/watch' asFileReference.
Polyphemus putAWatcherInto: pid watchedIn: dir.
session := Polyphemus holdProcess: pid watchedIn: dir.
session runUntil: 'Counter >> #tick:'.
StDebugger openOn: session withFullView: true.
```

- `putAWatcherInto:watchedIn:` puts a small watcher into the observee, once per run of it, at a
  moment its memory is safe to write (never during a garbage collection). Asked again, it keeps
  the one there; while that one holds the image, it refuses and says so.
- `holdProcess:watchedIn:` holds the whole image still.
- `runUntil:` lets it run until some process reaches that method, and holds it there. Leave it
  out to debug whatever the image was busy with; `Polyphemus debugProcess: pid watchedIn: dir`
  does that in one line.

While it is held, **the whole observee stands still**: its windows are not redrawn, and a CPU core
stays busy until you let it go.

## 4. Step it

The debugger is Pharo's own, on the observee's stack:

- **Step Over, Step Into, Step Through** run the observee's code for real. A step over a call that
  waits (a `Delay`, a semaphore, a socket) really waits, and the observee's other processes run
  meanwhile.
- **Run to here** steps until the selection.
- **Variables** of a frame show the observee's values. Evaluating code in a frame runs in the
  observer, not in the observee.
- **Refused, saying so**: Break on stack, Restart, Return entered value, Peel to first like this,
  and assigning a frame's variable. They would rewrite the observee's stack, which Polyphemus does
  not do yet. To stop at another method, hold it there with `runUntil:`.
- **Browse, senders, implementors** look in the observer, not in the observee.

## 5. Fix a method

Change the method in the code pane and save it (Cmd+S). It is compiled in the observer against
the observee's class, written into the observee, and its source is kept there. The frame you
edited restarts in the new code, as in Pharo.

- Code that does not compile is shown in the pane, at the error, as Pharo shows it.
- A change to a method's pragmas is refused.
- **A save can crash the observee**, later, most often after stepping (#119); the cause is not
  known yet. Save a copy of the observee (or take a core, section 7) before changing a method in
  an image that matters.

## 6. Let it go

**Proceed** lets the observee run again, with your changes. Closing the debugger's window does
the same. To look again, hold it again (section 3; `putAWatcherInto:` again does nothing, the watcher
is already there). After Proceed, a save in that debugger does nothing: the image is no longer held.

## 7. When something goes wrong

- **The observee stays frozen** after the observer itself crashed or was killed during a hold
  (#96). If it was caught stopped, `kill -CONT <its pid>` lets it go; if our agent was waiting in
  it, the agent lets it go by itself an hour after the last request (`Polyphemus holdLimit:`), or
  kill it. Save a copy before holding an image that matters.
- **"the hold ended after 60 minutes without a request"**: the debugger was left that long, and
  the observee went on. Hold it again. For a longer hold, `Polyphemus holdLimit: 3 hours` before
  holding; `Polyphemus holdLimit: nil` for no limit, at the cost of the line above.
- **"the image did not answer within 1:00"**: a step over something that waits longer than a
  minute. The observee is still inside that step, waiting; next time, hold it further on with
  `runUntil:` rather than stepping over the wait ([limitations.md](limitations.md), "Stepping in
  the debugger").
- **Refused to hold** an image that is never quiet, loops at priority 70 or more, or is stuck in
  C: the table in [limitations.md](limitations.md) says which and why. You can still take a core
  and read it, without holding anything:

  ```smalltalk
  Polyphemus dumpProcess: 12345 to: '/tmp/observee.core'.
  Polyphemus debugDeepestProcessIn: (Polyphemus readCoreDump: '/tmp/observee.core').
  ```

- **Your own pid is refused**: an observer does not hold itself. Hold from one observer at a time,
  as two observers holding each other both freeze.

## 8. More

- [START-HERE.md](START-HERE.md): image files, core dumps, the MCP server, the tests.
- [limitations.md](limitations.md): every known limit, why, and what to do instead.
- [editions.md](editions.md): which edition for which Pharo.
