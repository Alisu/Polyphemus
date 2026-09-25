running
setUp

	super setUp.
	path := PharoImageAccessor pathToPharo10.
	written := FileLocator temp / 'polyphemus-fixed.image'.
	written ensureDelete.
	reading := Polyphemus readImageFile: path
