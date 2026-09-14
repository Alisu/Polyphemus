update
computeOperandStack: limit

	| address stackpages wordSize |
	operandStack := OrderedCollection new.
	address := self offsetForOperandStack.
	stackpages := memory interpreter stackPages.
	wordSize := memory wordSize.

	[ address > limit ]
		whileTrue: [
			operandStack add: (memory objectAt:
					 (stackpages longAt: address)).
			address := address - wordSize ].

	"An empty operand stack is legal: the frame was prepared but not used yet.
	When this frame has a frame above it, the lowest slot collected is not one of
	our operands but our own saved instruction pointer, which lives in the frame
	above at its frame pointer plus one word (VMMaker reads it with
	#frameCallerSavedIP:)."
	self isTopFrame ifFalse: [
		operandStack ifNotEmpty: [
			savedIP := stackpages longAt: address + wordSize.
			operandStack removeLast ] ]
