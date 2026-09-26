running
setUp

	super setUp.
	written := PolyphemusEdition current scratch / 'polyphemus-installed.image'.
	written ensureDelete.
	reading := Polyphemus readImageFile: PharoImageAccessor pathToPharo10
