context protocol
tempAt: anIndex

	"The value of the nth argument or temporary of this frame, counting the way a context
	counts: arguments first, then temporaries.

	Asked of the VM. Its arguments sit above the frame pointer, pushed by whoever called it,
	and its temporaries below, past the method, the flags and the receiver; the VM knows
	that layout and counts from zero. Reading past the temporaries reaches the operand
	stack, which is not a temporary of anything, so the count bounds it."

	| count |
	count := [ self compiledCode numTemps ] on: Error do: [ :e | 0 ].
	(anIndex between: 1 and: count) ifFalse: [
		^ self error: 'this frame has no temporary ' , anIndex printString ].

	^ memory objectAt:
		  (memory interpreter temporary: anIndex - 1 in: framePointer)
