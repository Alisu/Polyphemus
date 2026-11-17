The front door. Every way of reading a Pharo virtual machine's memory, and every tool that shows
what was read, starts here.

	Polyphemus readImageFile: '/path/to/some.image'.   "an image on disk"
	Polyphemus readCoreDump: '/path/to/pharo.core'.    "a virtual machine that died"
	Polyphemus readProcess: 4321.                      "one that is still running (Linux)"

Each answers the same thing: a reified memory, whose objects can be asked questions -- its
processes, their stacks, the source of each frame.

	Polyphemus browse: memory.                  "every process and its stack"
	Polyphemus debugDeepestProcessIn: memory.    "the real debugger, post mortem"

Nothing here is new machinery; it names the few lines each case needs, which were otherwise
spread over test classes a newcomer should never have to open.
