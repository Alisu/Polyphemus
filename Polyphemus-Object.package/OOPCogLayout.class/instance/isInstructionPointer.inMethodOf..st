reading
isInstructionPointer: anAddress inMethodOf: aFramePointer

	"Whether anAddress lies within the frame's method: its bytes when interpreted, its CogMethod
	in the code zone when jitted. A jitted idle loop left for C in a primitive keeps its pc in
	instructionPointer, a machine code address (#62). A frame caught while being built may hold
	in its method field what the stack held before: no pc lies in a method outside the code zone,
	or one whose size cannot be read."

	| method start size |
	(self isMachineCodeFrame: aFramePointer) ifTrue: [
		start := self cogMethodOf: aFramePointer.
		(raw isMachineCodeAddress: start) ifFalse: [ ^ false ].
		size := [ (self cogit cogMethodSurrogateAt: start) blockSize ]
			        on: Error
			        do: [ :e | ^ false ].
		^ anAddress > start and: [ anAddress < (start + size) ] ].
	method := self methodOf: aFramePointer.
	^ anAddress > method and: [
		  anAddress < (method + (memory simulator objectMemory bytesInObject: method)) ]
