tests
testItsMethodSaysWhereAPcIsInItsSource

	| frame node |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	node := frame compiledCode sourceNodeForPC: frame executedPC.

	self deny: (node isKindOf: OOPUnknownSourceNode).
	self assert: node equals: frame sourceNodeExecuted
