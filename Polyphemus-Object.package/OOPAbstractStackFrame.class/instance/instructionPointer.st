accessing
instructionPointer

	"The byte this frame is about to execute.

	Only the active frame is answered. Its instruction pointer is the interpreter's
	register; any other frame's was saved by the frame it called, one word above that
	frame's pointer, and reading it needs the frame above -- which the page walk knows and
	a frame does not, yet. Answering nil until that is wired and tested is better than
	answering a plausible number."

	^ self isActiveFrame
		  ifTrue: [ [ memory interpreter instructionPointer ] on: Error do: [ :e | nil ] ]
		  ifFalse: [ nil ]
