querying
stackp

	"How many slots of this frame's stack are in use, in the form a context carries. The
	VM converts a stack pointer into that index itself; the active frame's pointer is the
	interpreter's register.

	Refused for a machine code frame, whose stack is not laid out this way."

	self refuseIfMachineCode.
	^ self isActiveFrame
		  ifTrue: [
			  [
			  memory interpreter
				  stackPointerIndexForFrame: framePointer
				  WithSP: memory interpreter stackPointer ]
				  on: Error
				  do: [ :e | nil ] ]
		  ifFalse: [
			  [ memory interpreter stackPointerIndexForFrame: framePointer ]
				  on: Error
				  do: [ :e | nil ] ]
