tests
testWhereTheWalkStopsIsPaintedUnreadable

	"Walked past the heap's end, into bytes that are not there: the walk stops, and says where."

	| bytes painter |
	bytes := self heapBytesFor: #( #( 40 1 1 ) ).
	painter := MemoryMapPainter
		           on: (SpurHeapScanner on: (ByteArrayAddressSpace on: bytes at: self baseAddress))
		           geometry: (MemoryMapGeometry
				            from: self baseAddress
				            to: self baseAddress + 64
				            bytesPerPixel: 8
				            width: 4).
	painter paintFrom: self baseAddress upTo: self baseAddress + 64.

	self assert: (self categoriesOf: painter upTo: 2) equals: #( #pointers #pointers #unreadable )
