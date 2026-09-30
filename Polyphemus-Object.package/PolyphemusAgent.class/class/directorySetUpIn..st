source
directorySetUpIn: aDirectory

	^ '| interrupt dir start |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
[ dir exists ] whileFalse: [ [ dir ensureCreateDirectory ] on: DirectoryExists do: [ :e | ] ].'
