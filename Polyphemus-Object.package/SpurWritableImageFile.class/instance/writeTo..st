writing
writeTo: aPath

	"The edited copy, as a file of its own. The original is left alone. Read back at once when a
	test watches (#141)."

	aPath asFileReference ensureDelete.
	aPath asFileReference binaryWriteStreamDo: [ :stream | stream nextPutAll: bytes ].
	SpurHeapWatch checkFileWritten: aPath asFileReference.
	^ aPath asFileReference
