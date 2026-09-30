tests
testAddressesRunAlongARowThenWrap

	self assert: (map pointOf: 16r1000 + 24) equals: 3 @ 0.
	self assert: (map pointOf: 16r1000 + 32) equals: 0 @ 1
