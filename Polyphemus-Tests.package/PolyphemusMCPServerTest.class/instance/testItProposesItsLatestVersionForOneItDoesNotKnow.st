tests
testItProposesItsLatestVersionForOneItDoesNotKnow

	self
		assert: (((self initializeWith: '1999-01-01') at: 'result') at: 'protocolVersion')
		equals: PolyphemusMCPServer protocolVersions last
