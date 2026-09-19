reading
readProcess: aPid

	"The memory of a running VM on Linux, held still only while it is copied. Refused, with the
	reason, if missing, not Pharo, or not readable (see LinuxObservationPermission)."

	| reader dumped |
	reader := LinuxProcessMemory on: aPid.
	[ reader whileStopped: [
		  dumped := SpurDumpedMemory on: reader.
		  dumped raw bytes ] ] ensure: [ reader close ].
	^ dumped reifyEverything: dumped reifiedMemory
