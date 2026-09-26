tests
testTheAgentLeavesNoRingBehind

	"#49: every ring is consumed, the last one too, even when the agent finds go before it
	waits. A ring left in a held image's semaphore would have its watcher hold it again."

	channel letGo.
	self assert: (self waitFor: [ agent isTerminated ]).
	self assert: (bell instVarAt: 3) equals: 0
