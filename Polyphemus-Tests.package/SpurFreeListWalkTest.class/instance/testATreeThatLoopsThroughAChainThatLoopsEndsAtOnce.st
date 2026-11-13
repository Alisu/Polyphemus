tests
testATreeThatLoopsThroughAChainThatLoopsEndsAtOnce

	"#182: a tree allowed a million visits, each following its node's chain to its own bound: a
	node that is its own smaller, and its own next, took that product. A node seen again ends it."

	| base node bytes space walk |
	base := self baseAddress.
	node := base + 48 + 520.
	bytes := self spaceFor: (self heapWithFreeLists: { (0 -> node) }) , {
			         { 0. 1. 6. { node. 0. 0. node. 0. 0 } } }.
	space := CountingAddressSpace on: bytes.

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: base
		        upTo: base + bytes size.

	self deny: walk isIntact.
	self assert: ((walk problems collect: [ :each | each key ]) includes: #freeTreeDoesNotEnd).
	self assert: space reads < 10000