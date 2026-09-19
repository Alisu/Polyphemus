helpers
heapStartOfSelf

	| live |
	live := LinuxProcessMemory onSelf.
	^ [ (SpurDumpedMemory on: live) raw heapStart ] ensure: [ live close ]
