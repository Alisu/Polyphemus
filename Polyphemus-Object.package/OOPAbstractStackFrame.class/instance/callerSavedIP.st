accessing
callerSavedIP

	"The word above the frame pointer: where this frame returns to. In the StackInterpreter,
	a base frame keeps its caller context there instead."

	^ self layout wordAt: framePointer + memory wordSize
