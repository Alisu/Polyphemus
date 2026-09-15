accessing
instructionPointer

	"The byte this frame is about to execute.

	The active frame has it in the interpreter's register. Every other frame saved it when
	it called into the frame above, which keeps it one word above its own frame pointer --
	and the page walk has already read it from there while collecting the operand stacks.

	nil when there is none to be had: the top frame of a page that is not the active one has
	no register to read and nothing above it to have saved anything."

	^ self isActiveFrame
		  ifTrue: [ [ memory interpreter instructionPointer ] on: Error do: [ :e | nil ] ]
		  ifFalse: [ savedIP ]
