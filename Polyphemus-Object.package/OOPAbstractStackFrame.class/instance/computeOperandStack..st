update
computeOperandStack: limit

	"Every word from the first temporary down to limit, exclusive. A nil limit means the
	stack pointer is not known, and the stack is left empty."

	| address reader wordSize |
	operandStack := OrderedCollection new.
	limit ifNil: [ ^ self ].
	reader := self layout.
	address := reader firstTemporaryAddressOf: framePointer.
	wordSize := memory wordSize.
	[ address > limit ] whileTrue: [
		operandStack add: (reader objectAt: (reader wordAt: address)).
		address := address - wordSize ]
