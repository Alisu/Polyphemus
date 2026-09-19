reading
framesFrom: aFramePointer stackTop: anAddress

	"The frames from aFramePointer down to the base of its page; its own stack ends just above
	anAddress, or is left unread when anAddress is nil."

	| frames current |
	current := OOPAbstractStackFrame
		           newTopFrameFrom: nil
		           startingAt: aFramePointer
		           endingAt: anAddress
		           on: memory.
	frames := OrderedCollection with: current.
	[ current isBaseFrame ] whileFalse: [
		current := current oopCaller.
		frames add: current ].
	^ frames
