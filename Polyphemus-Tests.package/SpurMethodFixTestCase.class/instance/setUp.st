running
setUp

	super setUp.
	path := PharoImageAccessor pathToTargetImage.
	written := PolyphemusEdition current scratch / 'polyphemus-fixed.image'.
	written ensureDelete.
	reading := self readingOfThePinnedImage
