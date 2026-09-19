checking
freeListsAreIntact

	"Whether the free lists can be believed, which decides whether they should be rebuilt.

	Rebuilding them is what `FullyReifiedMemory` does unconditionally, and it is a write
	into the memory being examined. On a dump of a VM that was running normally there is
	nothing to rebuild -- the allocator's lists are exactly right -- and the only honest
	reason to touch them is that this answers false."

	^ self freeListWalk agreesWith: self heapWalk
