accessing
scanner

	^ SpurHeapScanner on: (VMMakerAddressSpace on: objectMemory memoryManager)
