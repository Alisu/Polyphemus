tests
testTheActiveFrameKnowsWhereItIsAndHowDeepItsStackIs

	"A frame and a context are the same activation in two forms, so the same two numbers
	have to come out of either: where in the method it is, and how much of its stack is in
	use.

	While a frame is alive those numbers are not in its context -- a married context keeps
	a pc of zero, because the frame is where the pc lives. They are the interpreter's
	registers, and turning a register into the number a context would carry is the VM's own
	arithmetic, not ours: it does it in #contextInstructionPointer:frame: whenever it
	divorces a frame.

	The check is the same file read the other way. Stage one reads it as a snapshot, where
	this activation is a context that carries pc 200 and stackp 5. The frame has to agree."

	| frame |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.

	self assert: frame pc equals: 200.
	self assert: frame stackp equals: 5
