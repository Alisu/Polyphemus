tests
testWhereThereIsNoMemoryThereIsNothing

	self deny: (space hasAddress: 8).
	self assert: (space unsignedAt: 8 size: 8) isNil
