tests
testAFrameNamesItsTemporariesAsTheHostDoes

	| frame |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	self requireAHostThatReproduces: frame.

	self assert: frame tempNames asArray equals: (self hostTempNamesOf: frame)
