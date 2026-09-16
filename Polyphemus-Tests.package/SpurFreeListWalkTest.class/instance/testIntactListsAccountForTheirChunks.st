tests
testIntactListsAccountForTheirChunks

	"Two chunks of 24 bytes strung through the list for that size. The walk should find
	both, and add up to what they occupy."

	| base space first second walk |
	base := self baseAddress.
	first := base + 48 + 520.
	second := first + 24.
	space := self spaceFor: (self heapWithFreeLists: { (3 -> first) }) , {
			         { 0. 1. 2. { second. 0 } }.
			         { 0. 1. 2. { 0. 0 } } }.

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: base
		        upTo: base + space size.

	self assert: walk problems asArray equals: #(  ).
	self assert: walk isIntact.
	self assert: walk chunkCount equals: 2.
	self assert: walk bytes equals: 48
