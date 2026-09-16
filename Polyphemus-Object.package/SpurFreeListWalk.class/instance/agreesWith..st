testing
agreesWith: aHeapWalk

	"Whether the allocator's own account of the free space matches what stepping over the
	heap found. This is the check that matters: the lists can be internally tidy and still
	have lost a chunk, and only the heap walk would notice."

	^ self isIntact and: [
		  chunkCount = aHeapWalk freeChunkCount and: [
			  bytes = aHeapWalk freeBytes ] ]
