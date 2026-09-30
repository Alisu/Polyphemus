running
setUp

	super setUp.
	memory := (Polyphemus interpreterOnImageFile: PharoImageAccessor pathToCandle64Bit) objectMemory.
	space := VMMakerAddressSpace on: memory memoryManager
