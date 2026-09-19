reading
isInstructionPointer: anAddress inMethodOf: aFramePointer

	"Whether anAddress lies within the bytes of an interpreted frame's method."

	| method |
	(self isMachineCodeFrame: aFramePointer) ifTrue: [ ^ false ].
	method := self methodOf: aFramePointer.
	^ anAddress > method and: [
		  anAddress < (method + (memory simulator objectMemory bytesInObject: method)) ]
