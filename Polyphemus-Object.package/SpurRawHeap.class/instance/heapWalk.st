checking
heapWalk

	"What stepping over every object found. Kept, because a dump does not change while we
	look at it and the walk costs fifteen seconds; walked only when asked, if the heap was
	taken from an earlier reading (assumeTheHeapOf:)."

	self findHeap.
	^ walk ifNil: [ walk := self scanner walkFrom: heapStart upTo: mappingLimit ]
