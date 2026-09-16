tests
testEmptyListsAreIntactAndAccountForNothing

	"A heap with nothing free is sound, not broken. Answering a problem here would make
	every freshly compacted image look damaged."

	| base space walk |
	base := self baseAddress.
	space := self spaceFor: (self heapWithFreeLists: {  }).

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: base
		        upTo: base + space size.

	self assert: walk isIntact.
	self assert: walk chunkCount equals: 0.
	self assert: walk bytes equals: 0
