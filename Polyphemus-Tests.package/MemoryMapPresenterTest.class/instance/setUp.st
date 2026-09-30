running
setUp

	super setUp.
	memory := (Polyphemus interpreterOnImageFile: PharoImageAccessor pathToCandle64Bit) objectMemory.
	presenter := MemoryMapPresenter on: memory.
	presenter whenObjectChosenDo: [ :address | chosen := address ]
