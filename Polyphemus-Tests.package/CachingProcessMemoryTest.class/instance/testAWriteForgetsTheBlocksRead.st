tests
testAWriteForgetsTheBlocksRead

	process stop.
	process bytesAt: 16r100010 count: 4.
	process storeBytes: #[ 9 9 ] at: 16r100010.
	self assert: (process bytesAt: 16r100010 count: 4) asArray equals: #( 9 9 19 20 )
