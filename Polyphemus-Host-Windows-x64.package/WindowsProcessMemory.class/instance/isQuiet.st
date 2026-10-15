testing
isQuiet

	"Whether the VM is idle rather than half way through changing its heap: its main thread
	waits in the kernel, as LinuxProcessMemory>>isQuiet reads it from /proc."

	^ (self registersOfThread: self mainThreadId)
		  ifNil: [ false ]
		  ifNotNil: [ :registers | self isInASystemCallAt: (registers at: #rip) ]
