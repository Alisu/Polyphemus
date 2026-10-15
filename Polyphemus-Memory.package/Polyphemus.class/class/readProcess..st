reading
readProcess: aPid

	"The memory of a running VM, held still while it is copied, at a moment its VM is quiet
	(#66): /proc on Linux, its task port on macOS (as root). Refused, with the reason, if
	missing, not Pharo, unreadable, or never quiet."

	| reader dumped |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	[ reader whileStoppedWhenQuiet: [
		  dumped := SpurDumpedMemory on: reader.
		  dumped raw bytes ] ] ensure: [ reader close ].
	^ dumped reifyEverything: dumped reifiedMemory
