tests
testLettingGoEndsTheAgent

	channel ask: 'nil'.
	channel letGo.
	self assert: (self waitFor: [ agent isTerminated ])
