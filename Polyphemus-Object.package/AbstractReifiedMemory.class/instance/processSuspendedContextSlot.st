scheduler
processSuspendedContextSlot

	"VMMaker calls this one SuspendedContextIndex and indexes it from zero. In a
	snapshot this is where a process' whole stack hangs: the VM turned every frame
	into a context before writing the image."

	^ 2
