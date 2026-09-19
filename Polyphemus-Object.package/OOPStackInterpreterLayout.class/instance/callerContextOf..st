reading
callerContextOf: aBaseFramePointer

	"The StackInterpreter keeps it where other frames keep their caller's saved ip."

	^ self wordAt: aBaseFramePointer + memory wordSize
