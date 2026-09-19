reading
readProcess: aPid

	"The memory of a virtual machine that is still running, on Linux.

	It is held still only as long as it takes to copy its memory out, then let go: everything
	after that reads the copy. Refused, with the reason, if there is no such process, if it is
	not a Pharo virtual machine, or if the system will not let us look -- for which see
	`LinuxObservationPermission` and `bin/pharo-debuggable`."

	| reader dumped |
	reader := LinuxProcessMemory on: aPid.
	[ reader whileStopped: [
		  dumped := SpurDumpedMemory on: reader.
		  dumped raw bytes ] ] ensure: [ reader close ].
	^ dumped reifyEverything: dumped reifiedMemory
