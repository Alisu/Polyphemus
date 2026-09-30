accessing
picture

	"Old space, from nil to where it is free, at a million pixels at most."

	^ picture ifNil: [
		  | map painter |
		  map := MemoryMapGeometry
			         from: objectMemory nilObject
			         to: objectMemory freeOldSpaceStart
			         fittingPixels: 1000000
			         width: 1024.
		  painter := MemoryMapPainter
			             on: (SpurHeapScanner on: (VMMakerAddressSpace on: objectMemory memoryManager))
			             geometry: map.
		  painter paintFrom: map start upTo: map end.
		  picture := MemoryMapPicture on: painter ]
