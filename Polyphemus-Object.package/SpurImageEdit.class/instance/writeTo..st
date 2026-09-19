writing
writeTo: aPath

	"The edited copy, as a file of its own. The original is left alone."

	aPath asFileReference ensureDelete.
	aPath asFileReference binaryWriteStreamDo: [ :stream | stream nextPutAll: bytes ].
	^ aPath asFileReference
