tests
testLettingGoForgetsTheBlocksRead

	process stop.
	process bytesAt: 16r100010 count: 4.
	process resume.
	process stop.
	process bytesAt: 16r100010 count: 4.
	self assert: process asked equals: 2
