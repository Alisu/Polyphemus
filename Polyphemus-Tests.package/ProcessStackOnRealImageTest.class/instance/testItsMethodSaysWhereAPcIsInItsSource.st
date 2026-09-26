tests
testItsMethodSaysWhereAPcIsInItsSource

	"Pharo 11's debugger asks the method, not the frame, where a pc is (StDebugger>>updateStep):
	the node is the one the frame knows."

	| frame node |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	self deny: frame isBlockContext.
	node := frame compiledCode sourceNodeForPC: frame executedPC.
	self deny: (node isKindOf: OOPUnknownSourceNode).
	self assert: node equals: frame sourceNodeExecuted
