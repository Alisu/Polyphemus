running
setUp

	super setUp.
	path := PharoImageAccessor pathToPharo10.
	written := PolyphemusEdition current scratch / 'polyphemus-fixed.image'.
	written ensureDelete.
	reading := self readingOfThePinnedImage
