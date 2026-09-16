tests
testAListThatLeavesTheHeapIsNamed

	"A pointer into nowhere. Following it would read whatever happens to be there, which is
	how a checker invents objects; the bounds are known, so it says so instead."

	| base space walk |
	base := self baseAddress.
	space := self spaceFor: (self heapWithFreeLists: { (3 -> 16r10000000000) }).

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: base
		        upTo: base + space size.

	self deny: walk isIntact.
	self
		assert: (walk problems collect: [ :each | each key ]) asArray
		equals: #( #chunkOutsideTheHeap )
