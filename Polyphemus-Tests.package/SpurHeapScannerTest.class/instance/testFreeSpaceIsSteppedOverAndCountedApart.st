tests
testFreeSpaceIsSteppedOverAndCountedApart

	"Free chunks are stepped over and counted apart, never a reason to stop."

	| bytes space walk |
	bytes := self heapBytesFor: { #( 17 1 1 ). #( 18 1 1 ). #( 19 1 1 ) }.
	"zero the middle object's class index: that is what free space looks like"
	bytes
		at: 17 put: 0;
		at: 18 put: 0;
		at: 19 put: 0.

	space := ByteArrayAddressSpace on: bytes at: self baseAddress.
	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + bytes size.

	self assert: walk reachedTheLimit.
	self assert: walk objectCount equals: 2.
	self assert: walk freeChunkCount equals: 1
