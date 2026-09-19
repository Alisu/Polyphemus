tests
testItPlacesTheHeapWhereItWasSaved

	"The header says where the heap was, and the heap found there by shape begins right at
	that address: nil, the first object of a Spur image."

	| file |
	file := self open: PharoImageAccessor pathToPharo10.

	self assert: file loadableSegments size equals: 1.
	self assert: file loadableSegments first address equals: file oldBaseAddress.
	self assert: (SpurRawHeap on: file) heapStart equals: file oldBaseAddress
