reading
contextPCOf: anInstructionPointer frame: aFramePointer

	"CoInterpreter>>contextInstructionPointer:frame:. An ip below the heap is the return
	trampoline, and the real one is in the frame's saved ip. nil for machine code."

	| ip |
	(self isMachineCodeFrame: aFramePointer) ifTrue: [ ^ nil ].
	ip := anInstructionPointer < raw mappingStart
		      ifTrue: [ self wordAt: aFramePointer - (4 * memory wordSize) ]
		      ifFalse: [ anInstructionPointer ].
	^ ip - (self methodOf: aFramePointer) - memory wordSize + 2
