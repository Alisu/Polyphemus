initialization
setObjectMemory: anObjectMemory

	super setObjectMemory: anObjectMemory.
	scanner := SpurHeapScanner on: (VMMakerAddressSpace on: anObjectMemory memoryManager).
	names := Dictionary new
