tests
testAChunkInTheWrongListIsNamed

	"A 24-byte chunk hung on the list for 40-byte chunks. Everything about it is otherwise
	well formed, so only its size gives it away -- and the allocator handing it out would
	write 40 bytes into 24."

	| base space chunk walk |
	base := self baseAddress.
	chunk := base + 48 + 520.
	space := self spaceFor: (self heapWithFreeLists: { (5 -> chunk) }) , {
			         { 0. 1. 2. { 0. 0 } } }.

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: base
		        upTo: base + space size.

	self deny: walk isIntact.
	self
		assert: (walk problems collect: [ :each | each key ]) asArray
		equals: #( #chunkIsInTheListForAnotherSize )
