tests
testItWritesAnImageFileOfTheDumpsHeap

	"A 64-bit Spur image whose header says where the dump's old space was, and whose one
	segment holds it. Collecting for the snapshot may move the special objects array (#73):
	the header names the array the file holds, as long as the dump's."

	| file written |
	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.

	self assert: file isSpur64.
	self assert: file oldBaseAddress equals: raw heapStart.
	self assert: file specialObjectsOop equals: written specialObjectsOop.
	self
		assert: (written scanner slotCountIn: (written scanner headerAt: file specialObjectsOop))
		equals: (raw scanner slotCountIn: (raw scanner headerAt: raw specialObjectsOop)).
	self assert: file loadableSegments size equals: 1.
	self assert: file dataSize equals: file firstSegmentSize.
	file close
