tests
testReadingItselfAgainFindsTheSameHeap

	"#13: once this image grew by a region as large as its heap, the heap was taken to be the
	largest mapping, and the second reading looked for it somewhere else. Grown on purpose: a
	reading that copied the heap grew the next by its copy, gigabytes each time."

	| first grown second |
	first := self heapMappingOfSelf.
	grown := ByteArray new: first value - first key.
	second := self heapMappingOfSelf.

	self assert: first key notNil.
	self assert: second key equals: first key.
	self assert: grown notEmpty
