tests
testItHoldsWhatWasReachableInTheDump

	"VMMaker's collection ran: the image holds what the dump could reach and no more --
	fewer objects than its old space held, and no free chunk between them."

	| file written |
	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.

	self assert: written heapStart equals: raw heapStart.
	self assert: written heapWalk objectCount < self objectsOfTheDumpsOldSpace.
	self assert: written heapWalk objectCount > (self objectsOfTheDumpsOldSpace * 9 // 10).
	self assert: written heapWalk freeChunkCount equals: 0.
	file close
