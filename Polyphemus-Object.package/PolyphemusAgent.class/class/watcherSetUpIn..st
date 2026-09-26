source
watcherSetUpIn: aDirectory

	^ '| interrupt dir start |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
dir ensureCreateDirectory.
interrupt := Smalltalk specialObjectsArray at: 31.'
