context protocol
compiledCode

	"The method or block this activation is running.

	A machine code frame holds a CogMethod here, which is not an object and must not be
	reified as one -- that is how a wrong answer would get out. Answering nil says we cannot
	read it yet."

	^ self isReadable
		  ifTrue: [ self oopMethod ]
		  ifFalse: [ nil ]
