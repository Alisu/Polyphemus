running
setUp

	super setUp.
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	browser := SnapshotProcessBrowser on: memory
