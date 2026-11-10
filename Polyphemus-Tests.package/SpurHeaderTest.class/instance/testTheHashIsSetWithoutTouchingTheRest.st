tests
testTheHashIsSetWithoutTouchingTheRest

	| header hashed |
	header := SpurHeader headerFor: 5 format: 9 classIndex: 3.
	hashed := SpurHeader withHash: 16r123 in: header.
	self assert: (SpurHeader hashOf: hashed) equals: 16r123.
	self assert: (SpurHeader withHash: 0 in: hashed) equals: header.
	self assert: (SpurHeader hashOf: (SpurHeader withHash: SpurHeader hashMask in: header)) equals: 16r3FFFFF
