initialization
setObjectMemory: anObjectMemory

	objectMemory := anObjectMemory.
	scanner := SpurHeapScanner on: (VMMakerAddressSpace on: anObjectMemory memoryManager).
	counts := Dictionary new.
	sizes := Dictionary new.
	names := Dictionary new
