tests
testItWritesWhereItIsTold

	self assert: (process storeBytes: #[ 1 2 3 ] at: 16r10010) equals: 3.
	self assert: (process bytesAt: 16r10010 count: 3) asArray equals: #( 1 2 3 )
