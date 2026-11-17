testing
isQuiet

	^ (SpurCannotRead new level: #bytes reason: #itsStateDoesNotRead) signal
