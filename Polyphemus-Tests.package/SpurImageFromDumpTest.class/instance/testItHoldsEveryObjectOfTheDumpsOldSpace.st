tests
testItHoldsEveryObjectOfTheDumpsOldSpace

	"As many objects as the dump's old space, at the same addresses: nothing is moved. One
	more than the dump: the bridge that ends the segment, which every image has."

	| file written |
	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.

	self assert: written heapStart equals: raw heapStart.
	self assert: written heapWalk objectCount equals: self objectsOfTheDumpsOldSpace + 1.
	file close
