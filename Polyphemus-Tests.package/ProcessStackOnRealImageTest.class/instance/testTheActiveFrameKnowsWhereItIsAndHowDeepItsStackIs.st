tests
testTheActiveFrameKnowsWhereItIsAndHowDeepItsStackIs

	"The active frame's pc and stackp equal those of the same activation read as a snapshot
	context: 200 and 5."

	| frame |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.

	self assert: frame pc equals: 200.
	self assert: frame stackp equals: 5
