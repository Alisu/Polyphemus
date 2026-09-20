tests
testItHoldsEveryObjectOfTheDumpsOldSpace

	"Every object of the dump's old space, at the same addresses: nothing is moved. More of
	them: the bridge that ends the segment, and a context for each frame that had none."

	| file written added |
	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.
	added := written heapWalk objectCount - self objectsOfTheDumpsOldSpace - 1.

	self assert: written heapStart equals: raw heapStart.
	self assert: added >= 1.
	self assert: added <= self class frames.
	file close
