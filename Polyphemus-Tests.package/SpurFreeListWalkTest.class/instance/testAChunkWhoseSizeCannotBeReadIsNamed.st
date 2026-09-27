tests
testAChunkWhoseSizeCannotBeReadIsNamed

	"#60: a header saying its size is in the word before it, where no such word is -- what a
	read of a running heap can meet half way through a change. It was counted as nil."

	| base bytes chunk walk |
	base := self baseAddress.
	chunk := base + 48 + 520.
	bytes := self heapBytesFor: (self heapWithFreeLists: { (5 -> chunk) }) , {
			         { 0. 1. 2. { 0. 0 } } }.
	bytes at: chunk - base + 8 put: 255.

	walk := (SpurHeapScanner on: (ByteArrayAddressSpace on: bytes at: base))
		        freeListWalkFrom: base
		        upTo: base + bytes size.

	self deny: walk isIntact.
	self
		assert: (walk problems collect: [ :each | each key ]) asArray
		equals: #( #chunkSizeCannotBeRead )
