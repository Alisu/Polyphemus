reading
framesFrom: aFramePointer stackTop: anAddress

	"The frames from aFramePointer down to the base of its page, or to one whose saved frame
	pointer leads no further; its own stack ends just above anAddress, or is left unread when
	anAddress is nil."

	| frames current |
	current := OOPAbstractStackFrame
		           newTopFrameFrom: nil
		           startingAt: aFramePointer
		           endingAt: anAddress
		           on: memory.
	frames := OrderedCollection with: current.
	[ current isLastReadOfItsPage ] whileFalse: [
		current := current oopCaller.
		frames add: current ].
	^ frames
