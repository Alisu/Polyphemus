testing
isMachineCodeFrame

	"The method field points below the heap, at a CogMethod (CoInterpreter>>isMachineCodeFrame:)."

	^ [ self layout isMachineCodeFrame: framePointer ] on: Error do: [ :e | false ]
