building the dump
wholeCore

	"The test core as it was built, not cut: no Spur heap in it, said as such."

	| whole |
	whole := PolyphemusEdition current scratch / 'polyphemus-test-whole.core'.
	whole ensureDelete.
	whole binaryWriteStreamDo: [ :stream | stream nextPutAll: self coreBytes ].
	^ whole