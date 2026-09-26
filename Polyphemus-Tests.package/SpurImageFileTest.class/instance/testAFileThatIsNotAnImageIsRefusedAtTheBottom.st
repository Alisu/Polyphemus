tests
testAFileThatIsNotAnImageIsRefusedAtTheBottom

	| zeros readability |
	zeros := PolyphemusEdition current scratch / 'polyphemus-not-an-image.image'.
	zeros ensureDelete.
	zeros binaryWriteStreamDo: [ :out | out nextPutAll: (ByteArray new: 4096) ].
	readability := (SpurRawHeap on: (self open: zeros)) readability.

	self deny: (readability canRead: #heap).
	self should: [ Polyphemus readImageFile: zeros ] raise: SpurCannotRead
