tests
testReadsWithinABlockWhileHeldAskTheProcessOnce

	process stop.
	self assert: (process bytesAt: 16r100010 count: 4) asArray equals: #( 17 18 19 20 ).
	self assert: (process bytesAt: 16r100100 count: 2) asArray equals: #( 1 2 ).
	self assert: process asked equals: 1
