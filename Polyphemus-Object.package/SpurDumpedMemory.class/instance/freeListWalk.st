checking
freeListWalk

	"What the allocator's own lists account for. Compare it with `#heapWalk`: two routes to
	the same free space, and a damaged allocator is where they part company."

	^ self scanner freeListWalkFrom: self heapStart upTo: mappingLimit
