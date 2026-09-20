tests
testItWritesAnImageFileOfTheDumpsHeap

	"A 64-bit Spur image whose header says where the dump's old space was, and whose one
	segment holds it."

	| file |
	file := SpurImageFile on: self written.

	self assert: file isSpur64.
	self assert: file oldBaseAddress equals: raw heapStart.
	self assert: file specialObjectsOop equals: raw specialObjectsOop.
	self assert: file loadableSegments size equals: 1.
	self assert: file dataSize equals: file firstSegmentSize.
	file close
