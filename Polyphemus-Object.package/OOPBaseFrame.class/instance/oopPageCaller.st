accessing
oopPageCaller

	"The context that called into this page, where this frame's reader says the VM keeps it.
	nil for the first activation of a process."

	self refuseIfMachineCode.
	^ self layout objectAt: (self layout callerContextOf: framePointer)
