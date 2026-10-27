tests
testAReadAcrossTwoBlocksIsWhole

	process stop.
	self assert: (process bytesAt: 16r10FFFE count: 4) asArray equals: #( 255 0 1 2 )
