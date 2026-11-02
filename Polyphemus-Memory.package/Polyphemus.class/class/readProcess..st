reading
readProcess: aPid

	"The memory of a running VM, held still while it is copied, at a moment its VM is quiet
	(#66), and read from that copy (#85), as it is looked at (#129): /proc on Linux, its task port
	on macOS (as root). Refused, with the reason, if missing, not Pharo, unreadable, or never quiet."

	| dumped |
	dumped := SpurDumpedMemory on: (self copyProcess: aPid).
	^ dumped reifiedMemory
		  completeFrom: dumped;
		  yourself
