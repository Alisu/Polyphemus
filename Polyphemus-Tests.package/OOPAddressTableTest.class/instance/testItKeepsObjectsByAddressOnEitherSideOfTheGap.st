tests
testItKeepsObjectsByAddressOnEitherSideOfTheGap

	table at: 16r340000008 put: #young.
	table at: 16r10000000010 put: #old.
	self assert: (table at: 16r340000008) equals: #young.
	self assert: (table at: 16r10000000010) equals: #old.
	self assert: (table at: 16r340000010) isNil.
	self assert: (table at: 16r5000000000) isNil
