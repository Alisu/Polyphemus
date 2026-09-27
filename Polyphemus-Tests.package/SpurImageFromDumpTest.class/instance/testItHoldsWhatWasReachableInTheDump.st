tests
testItHoldsWhatWasReachableInTheDump

	"VMMaker's collection ran: the image holds what the dump could reach and no more -- fewer
	objects than both its spaces held (new space is tenured, so old space alone is no bound:
	Pharo 13's dump had more survivors than garbage), and no free chunk between them."

	| file written |
	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.

	self assert: written heapStart equals: raw heapStart.
	self
		assert: written heapWalk objectCount
		< (self objectsOfTheDumpsOldSpace + self objectsOfTheDumpsNewSpace).
	self assert: written heapWalk objectCount > (self objectsOfTheDumpsOldSpace * 9 // 10).
	self assert: written heapWalk freeChunkCount equals: 0.
	file close
