tests
testReadingItselfAgainFindsTheSameHeap

	"#13: reading itself grows this image by a region as large as its heap, and the heap was
	taken to be the largest mapping -- the second reading looked for it somewhere else."

	| first second |
	first := self heapStartOfSelf.
	second := self heapStartOfSelf.

	self assert: first notNil.
	self assert: second equals: first
