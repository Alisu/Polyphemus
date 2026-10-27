tests
testLettingGoSaysTheAgentWasThere

	channel ask: 'nil'.
	self assert: (channel letGoWithin: 5 seconds)
