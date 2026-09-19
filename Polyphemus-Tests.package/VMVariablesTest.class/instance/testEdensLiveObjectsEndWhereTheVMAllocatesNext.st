tests
testEdensLiveObjectsEndWhereTheVMAllocatesNext

	| eden freeStart |
	eden := variables boundsOf: 'eden'.
	freeStart := variables at: 'freeStart'.

	self assert: eden key < eden value.
	self assert: (freeStart between: eden key and: eden value)
