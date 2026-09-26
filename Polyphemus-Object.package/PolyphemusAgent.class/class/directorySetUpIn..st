source
directorySetUpIn: aDirectory

	^ '| interrupt dir start |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
dir ensureCreateDirectory.'
