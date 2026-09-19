update
computeOperandStack: limit

	"Every word from the first temporary down to limit. Below a frame above us, the lowest
	of them is not ours but our saved ip, kept in that frame (#frameCallerSavedIP:). A nil
	limit means the stack pointer is not known, and the stack is left empty."

	| address reader wordSize |
	operandStack := OrderedCollection new.
	limit ifNil: [ ^ self ].
	reader := self layout.
	address := reader firstTemporaryAddressOf: framePointer.
	wordSize := memory wordSize.
	[ address > limit ] whileTrue: [
		operandStack add: (reader objectAt: (reader wordAt: address)).
		address := address - wordSize ].
	self isTopFrame ifFalse: [
		operandStack ifNotEmpty: [
			savedIP := reader wordAt: address + wordSize.
			operandStack removeLast ] ]
