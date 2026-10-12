# Polyphemus as an MCP server

Polyphemus answers an agent's questions about a Pharo image through the Model Context Protocol
(#71). The server runs in the observer image only: the images it reads are never instrumented,
and this first slice only reads.

## Starting it

Over ssh's standard input and output, one JSON-RPC message per line, so nothing listens on the
network and ssh's key is the only access control:

```bash
ssh worker-box '~/polyphemus/Polyphemus/bin/polyphemus-mcp.sh'
```

`WORK` picks the setup (default `~/polyphemus/pharo13`), as for `bin/tdd.sh`; the server runs that
setup's `warm.image`, which `bin/tdd.sh` keeps at the working copy, and never saves it.

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

Every tool is annotated read-only. A tool that fails says so in its result (`isError`, with the
reason), for the agent to read; JSON-RPC errors are kept for the protocol's own (unknown method,
unknown tool, unreadable JSON).

## Standard output is the protocol's

Anything else written there breaks the client. `traceCr` goes to stdout in headless Pharo, and
VMMaker v10.3 and later trace `Spur Image Format detected` whenever an image is loaded, so
`bin/mcp-serve.st` keeps stdout for the protocol and sends the Transcript to stderr. Measured on
Pharo 10 to 14 before writing it: Pharo itself writes nothing to stdout under
`--no-default-preferences`, and a line read from stdin with stdin left open is answered at once.

## Not yet

Cores and running images, processes and stacks, objects; tools that change a target (hold, step,
edit), which will be annotated as such; HTTP, for several clients or other machines (#70).
