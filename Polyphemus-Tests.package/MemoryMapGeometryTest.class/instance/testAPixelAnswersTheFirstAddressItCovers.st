tests
testAPixelAnswersTheFirstAddressItCovers

	self assert: (map addressAt: 3 @ 1) equals: 16r1000 + (7 * 8)
