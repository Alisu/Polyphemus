running
setUp

	super setUp.
	written := FileLocator temp / 'polyphemus-installed.image'.
	written ensureDelete.
	reading := Polyphemus readImageFile: PharoImageAccessor pathToPharo10
