running
frames

	"The frames of the deepest stack, newest first, read anew."

	^ (memory activationsOfProcess: process) select: [ :each | each isStackFrame ]
