accessing
operandStack

	"What its temporaries and operands refer to, newest last; nil for a word that is no object.
	Refused by name where a word of its stack did not read."

	whyNoStack ifNotNil: [ ^ self refuseItsStack ].
	^ operandStack
