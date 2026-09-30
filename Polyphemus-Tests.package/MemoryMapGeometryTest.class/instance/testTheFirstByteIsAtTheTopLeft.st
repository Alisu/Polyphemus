tests
testTheFirstByteIsAtTheTopLeft

	self assert: (map pointOf: 16r1000) equals: 0 @ 0
