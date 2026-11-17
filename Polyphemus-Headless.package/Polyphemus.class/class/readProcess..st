reading
readProcess: aPid

	"The memory of a running VM, held still while it is copied at a safe moment (#66, #113), and
	read from that copy (#85) as it is looked at (#129): /proc on Linux, its task port on macOS."

	| dumped |
	dumped := SpurDumpedMemory on: (self copyProcess: aPid).
	^ dumped reifiedMemory
		  completeFrom: dumped;
		  yourself
