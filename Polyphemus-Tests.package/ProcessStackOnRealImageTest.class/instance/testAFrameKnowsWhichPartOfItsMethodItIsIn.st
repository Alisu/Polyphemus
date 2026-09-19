tests
testAFrameKnowsWhichPartOfItsMethodItIsIn

	"A frame's source range is built as a context's is, from its pc."

	| frame range source |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	source := reifiedMemory sourceOfContext: frame.
	range := frame pcRangeContextIsActive: true.

	self deny: range isEmpty.
	self
		assert: (source copyFrom: range first to: range last)
		equals: 'snapshotResult := Smalltalk snapshotPrimitive'
