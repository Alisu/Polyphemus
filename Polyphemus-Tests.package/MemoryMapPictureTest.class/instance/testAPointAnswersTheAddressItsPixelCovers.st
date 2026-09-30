tests
testAPointAnswersTheAddressItsPixelCovers

	self assert: (picture addressAt: picture mapOrigin + (1 @ 0)) equals: self baseAddress + 8.
	self assert: (picture addressAt: 0 @ 0) isNil
