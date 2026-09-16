checking
heapWalk

	"What stepping over every object found. Kept, because a dump does not change while we
	look at it and the walk costs fifteen seconds."

	self findHeap.
	^ walk
