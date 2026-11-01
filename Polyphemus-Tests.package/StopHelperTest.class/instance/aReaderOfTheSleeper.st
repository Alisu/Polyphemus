helpers
aReaderOfTheSleeper

	"Stopping and resuming need no leave to read, so a sleep will do; Linux's reader is the one made
	with a pid alone, and macOS's stops the same way."

	PolyphemusMadeFor current processMemoryClass == LinuxProcessMemory ifFalse: [ self skip ].
	^ LinuxProcessMemory unchecked: target
