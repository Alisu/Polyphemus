checking
freeListsAreIntact

	"Whether the free lists can be believed. Only false justifies rebuilding them, which writes
	into the memory being examined -- FullyReifiedMemory does it regardless."

	^ self freeListWalk agreesWith: self heapWalk
