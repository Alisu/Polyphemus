reading
readProcess: aPid

	"The memory of a running VM on Linux, held still while it is copied, at a moment its VM is
	quiet (#66). Refused, with the reason, if missing, not Pharo, unreadable, or never quiet."

	| reader dumped |
	reader := LinuxProcessMemory on: aPid.
	[ reader whileStoppedWhenQuiet: [
		  dumped := SpurDumpedMemory on: reader.
		  dumped raw bytes ] ] ensure: [ reader close ].
	^ dumped reifyEverything: dumped reifiedMemory
