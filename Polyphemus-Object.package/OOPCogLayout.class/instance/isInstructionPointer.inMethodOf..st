reading
isInstructionPointer: anAddress inMethodOf: aFramePointer

	"Whether anAddress lies within the frame's method: its bytes when interpreted, its CogMethod
	in the code zone when jitted. A jitted idle loop left for C in a primitive keeps its pc in
	instructionPointer, a machine code address (#62)."

	| method cogMethod |
	(self isMachineCodeFrame: aFramePointer) ifTrue: [
		cogMethod := [ self cogit cogMethodSurrogateAt: (self cogMethodOf: aFramePointer) ]
			             on: Error
			             do: [ :e | ^ false ].
		^ anAddress > cogMethod asUnsignedInteger and: [
			  anAddress < (cogMethod asUnsignedInteger + cogMethod blockSize) ] ].
	method := self methodOf: aFramePointer.
	^ anAddress > method and: [
		  anAddress < (method + (memory simulator objectMemory bytesInObject: method)) ]
