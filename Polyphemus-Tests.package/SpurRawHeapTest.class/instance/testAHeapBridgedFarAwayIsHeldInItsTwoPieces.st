tests
testAHeapBridgedFarAwayIsHeldInItsTwoPieces

	"#133: the mapping reaches the far segment across the bridge, and holds its two pieces, not
	the gap between them."

	| raw |
	raw := SpurRawHeap on: self copyOfAHeapBridgedFarAway.
	self assert: raw mappingStart equals: 16r10000000.
	self assert: raw mappingLimit equals: 16r7FB741EF6000 + 16r1000.
	self assert: (raw pieces collect: [ :each | each size ]) asArray equals: #( 16r2000 16r1000 )
