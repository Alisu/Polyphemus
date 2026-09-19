reading
framesFromContext: aContext

	"The frames of the page this context runs on, from its own frame to the oldest. Its
	own frame is the top of the page: the stack pointer above it is not known yet."

	| fp frames current |
	fp := (self framePointerOf: aContext) ifNil: [ ^ #(  ) ].
	current := OOPAbstractStackFrame
		           newTopFrameFrom: nil
		           startingAt: fp
		           endingAt: nil
		           on: memory.
	frames := OrderedCollection with: current.
	[ current isBaseFrame ] whileFalse: [
		current := current oopCaller.
		frames add: current ].
	^ frames
