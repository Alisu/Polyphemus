tests
testItFindsTheNextObjectAcrossTheGap

	table at: 16r340000008 put: #young.
	table at: 16r10000000010 put: #old.
	self assert: (table after: 16r340000008) equals: #old.
	self assert: (table after: 16r10000000010) isNil
