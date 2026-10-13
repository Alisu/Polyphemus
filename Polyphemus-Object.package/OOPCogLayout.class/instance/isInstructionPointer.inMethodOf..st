reading
isInstructionPointer: anAddress inMethodOf: aFramePointer

	"Whether anAddress lies within the frame's method: its bytes, or its CogMethod when jitted
	(a machine code pc, #62). A method field outside the code zone, or whose size cannot be read,
	holds no pc: a frame caught while being built may still hold what the stack held (#17)."

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
