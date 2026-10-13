holding it still
whileStoppedWhenQuiet: aBlock

	"Held still only: when a VM is quiet (no collection, no allocation half done) is not measured
	on macOS yet, where Linux reads it from /proc (LinuxProcessMemory>>isQuiet)."

	^ self whileStopped: aBlock
