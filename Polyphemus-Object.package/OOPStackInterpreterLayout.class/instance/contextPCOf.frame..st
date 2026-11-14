reading
contextPCOf: anInstructionPointer frame: aFramePointer

	"The pointer as a context's pc, by VMMaker's own conversion, which is asked only where the
	frame's method is compiled code and the pointer lies in it: over anything else VMMaker
	fails in its own ways, and here it is refused by name."

	| method |
	method := self objectAt: (self methodOf: aFramePointer).
	(method notNil and: [ method isCompiledMethodOop or: [ method isCompiledBlockOop ] ]) ifFalse: [
		^ self refuse: #itsMethodFieldIsNoCompiledCode ].
	(anInstructionPointer isInteger and: [
		 anInstructionPointer between: method address and: method address + 8 + (memory numBytesOf: method address) ])
		ifFalse: [ ^ self refuse: #itsInstructionPointerIsOutsideItsMethod ].
	^ memory integerValueOf:
		  (memory interpreter contextInstructionPointer: anInstructionPointer frame: aFramePointer)
