helpers
painterFor: specs bytesPerPixel: aNumber

	"A painter over a hand-built heap, having painted it all, and a little past its end."

	| bytes painter |
	bytes := self heapBytesFor: specs.
	painter := MemoryMapPainter
		           on: (SpurHeapScanner on: (ByteArrayAddressSpace on: bytes at: self baseAddress))
		           geometry: (MemoryMapGeometry
				            from: self baseAddress
				            to: self baseAddress + bytes size + 16
				            bytesPerPixel: aNumber
				            width: 4).
	painter paintFrom: self baseAddress upTo: self baseAddress + bytes size.
	^ painter
