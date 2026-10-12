tests
testItAgreesOnTheClientsVersionWhenItKnowsIt

	PolyphemusMCPServer protocolVersions do: [ :each |
		self assert: (((self initializeWith: each) at: 'result') at: 'protocolVersion') equals: each ]
