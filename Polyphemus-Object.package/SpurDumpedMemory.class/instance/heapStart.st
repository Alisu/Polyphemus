accessing
heapStart

	^ heapStart ifNil: [ self findHeap. heapStart ]
