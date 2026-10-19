tests
testItListsTheRegionsItHolds

	| copy |
	copy := ProcessMemoryCopy of: process.
	self
		assert: (copy loadableSegments collect: [ :each | each address ]) asArray
		equals: #( 16r10000 16r20000 )
