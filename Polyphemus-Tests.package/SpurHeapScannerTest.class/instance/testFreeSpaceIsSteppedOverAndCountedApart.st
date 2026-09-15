tests
testFreeSpaceIsSteppedOverAndCountedApart

	"Spur marks free space with a class index of zero, and a running heap is full of it: a
	snapshot is collected before it is written, so an image file holds an uninterrupted run of
	live objects, and a living one does not.

	So free space cannot be a reason to stop -- a walk that stopped at the first hole would
	never cross a real heap. It is stepped over and counted apart, because a walk through
	memory nobody has written is free chunks the whole way and has found nothing."

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
