tests
testAHeaderReadsAsTheMemoryHasIt

	| scanner |
	scanner := SpurHeapScanner on: space.

	self
		assert: (scanner classIndexIn: (scanner headerAt: memory nilObject))
		equals: (memory classIndexOf: memory nilObject)
