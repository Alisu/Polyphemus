# Polyphemus as an MCP server

Polyphemus answers an agent's questions about a Pharo image through the Model Context Protocol
(#71). The server runs in the observer image only. It reads images without changing them, except
through the tools that hold a running VM, step it and save a fix into it (#128): those put our
watcher into a VM that has none.

## Starting it

Over ssh's standard input and output, one JSON-RPC message per line, so nothing listens on the
network and ssh's key is the only access control:

```bash
ssh worker-box '~/polyphemus/Polyphemus/bin/polyphemus-mcp.sh'
```

`WORK` picks the setup (default `~/polyphemus/pharo13`), as for `bin/tdd.sh`; the server runs that
setup's `warm.image`, which `bin/tdd.sh` keeps at the working copy, and never saves it. The
script is written for that box; a launcher on another machine, a Mac for one, is #82.

Registered in an agent, for example Claude Code:

```bash
claude mcp add polyphemus -- ssh worker-box '~/polyphemus/Polyphemus/bin/polyphemus-mcp.sh'
```

## Tools

| Tool | Answers |
|---|---|
| `open_image(path)` | A handle, and how many objects and bytes the image's old space holds. Reads the file; nothing runs in it |
| `census(handle, top)` | Instances and bytes of each class, the heaviest first (`HeapCensus`) |
| `packages(handle, top)` | What each package owns, the heaviest first (`PackageFootprint`) |
| `open_core(path)` | A handle on a core dump of a VM (up to a minute to read), for `processes` and `stack` |
| `processes(handle)` | Each Smalltalk process, numbered: state, priority, name, depth, the method on top |
| `stack(handle, process, depth)` | Its frames: method, the statement it was in, receiver, temporaries and values |
| `inspect(handle, address, limit)` | An object: class, format, named slots and the first indexable ones, a string's characters |
| `where_stuck(pid)` | Where a running VM is, from `/proc` (on macOS its task port, as root): each thread's system call or pc, the signals it catches |
| `hold(pid, directory)` | Holds a running VM on what it is busy with, in its own debugger, our watcher put in first if none waits on `directory` (by default a folder of ours under the temporary folder). A handle, and the held process's frames, top first. It stays held until `let_go`, or an hour without requests |
| `run_until(handle, method, seconds)` | Lets the held VM run until some process reaches `Class >> #selector`, and holds it there; if not in time (60 s by default), where it got to. Whether it was reached, and the frames |
| `step(handle, how, frame)` | Steps the held process `into`, `over` (the default) or `through`, at the top frame or the one below (`frame` 1 or 2), as the debugger's buttons do. Its frames afterwards |
| `save(handle, source, frame)` | Saves a method's new source into the held VM where the frame's method is (the top one by default), and restarts that frame in it, as the debugger does on accept; the image keeps the source in its changes. Not saved (a source that does not parse or compile), the answer is a failure saying why, and the VM stays held |
| `stop(handle)` | Ends the held process, its ensure blocks run, as the debugger's Stop does, and lets the VM run on without it; the handle is forgotten |
| `let_go(handle)` | The held VM runs on, the process held with it, and the handle is forgotten |
| `open_process(pid)` | A handle on a running VM's memory, copied while it was held still at a quiet moment, then let go, for `processes`, `stack` and `inspect`. On macOS through the VM's task port, which needs the server run as root (`docs/handover-macos.md`) |

`processes` and `stack` give the address of each process, receiver and temporary value, and
`inspect` the address of each slot that holds an object, so an agent follows references from one
to the next. A handle from `open_process` is the moment it was copied: the image runs on after it. `where_stuck` and `open_process` read a live process: one that is running rather than waiting is
stopped for a moment to look, then let go, and nothing in it changes; it needs permission to read
that process (on Linux an ancestor, or `bin/pharo-debuggable`; on macOS root).

`census` and `packages` read image files; on a core they say so. A frame's temporaries are named
only where this host compiles its method as the image did (#6): on another version's image their
values come by number, with a note saying why, and the edition made for that image names them.

Every tool but `hold`, `run_until`, `step`, `save`, `stop` and `let_go` is annotated read-only;
those are annotated as changing a VM, so a client may ask before it runs them, and `save` and
`stop` as destructive: letting go does not undo them. A tool that fails says so in its result (`isError`, with the reason),
for the agent to read; JSON-RPC errors are kept for the protocol's own (unknown method, unknown
tool, unreadable JSON).

## Standard output is the protocol's

Anything else written there breaks the client. `traceCr` goes to stdout in headless Pharo, and
VMMaker v10.3 and later trace `Spur Image Format detected` whenever an image is loaded, so
`bin/mcp-serve.st` keeps stdout for the protocol and sends the Transcript to stderr. Measured on
Pharo 10 to 14 before writing it: Pharo itself writes nothing to stdout under
`--no-default-preferences`, and a line read from stdin with stdin left open is answered at once.

## Not yet

Tools that change a target (hold, step,
edit), which will be annotated as such; HTTP, for several clients or other machines (#70).
