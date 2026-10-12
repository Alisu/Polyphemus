tests
testItSaysWhoItIsWhenInitialized

	| result |
	result := (self initializeWith: '2025-06-18') at: 'result'.
	self assert: ((result at: 'serverInfo') at: 'name') equals: 'polyphemus'.
	self assert: ((result at: 'capabilities') includesKey: 'tools')
