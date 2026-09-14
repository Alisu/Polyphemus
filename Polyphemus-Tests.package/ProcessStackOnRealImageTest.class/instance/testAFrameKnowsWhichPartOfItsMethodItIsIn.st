tests
testAFrameKnowsWhichPartOfItsMethodItIsIn

	"The last thing stage one learned, now answered by a frame as well: where in the source
	this activation is.

	The map is built the same way -- compile the method's own source here, keep it only if
	the bytecodes are the file's -- and the frame supplies the pc, which is the VM's own
	conversion of its instruction pointer.

	This frame is the active one, so its pc is on the instruction about to run: the
	primitive the image was written inside."

	| frame range source |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	source := reifiedMemory sourceOfContext: frame.
	range := frame pcRangeContextIsActive: true.

	self deny: range isEmpty.
	self
		assert: (source copyFrom: range first to: range last)
		equals: 'snapshotResult := Smalltalk snapshotPrimitive'
