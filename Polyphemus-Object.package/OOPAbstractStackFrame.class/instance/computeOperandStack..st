update
computeOperandStack: limit

	"Every word from the first temporary down to limit, exclusive, as objects and as the
	words themselves. A nil limit means the stack pointer is not known, and both are empty."

	| address reader wordSize |
	operandStack := OrderedCollection new.
	stackWords := OrderedCollection new.
	limit ifNil: [ ^ self ].
	reader := self layout.
	address := reader firstTemporaryAddressOf: framePointer.
	wordSize := memory wordSize.
	[ address > limit ] whileTrue: [
		| word |
		word := reader wordAt: address.
		stackWords add: word.
		operandStack add: (reader objectAt: word).
		address := address - wordSize ]
