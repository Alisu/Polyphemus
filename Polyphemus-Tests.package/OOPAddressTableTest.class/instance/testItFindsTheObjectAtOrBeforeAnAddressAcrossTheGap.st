tests
testItFindsTheObjectAtOrBeforeAnAddressAcrossTheGap

	table at: 16r340000008 put: #young.
	table at: 16r10000000010 put: #old.
	self assert: (table atOrBefore: 16r10000000008) equals: #young.
	self assert: (table atOrBefore: 16r10000000010) equals: #old.
	self should: [ table atOrBefore: 16r340000000 ] raise: NotFound
