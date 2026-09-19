helpers
damagedCopyOf: aPath keeping: aCount

	"The first aCount bytes of the file at aPath, as a file of their own."

	| copy |
	copy := FileLocator temp / ('polyphemus-damaged-' , aCount printString , '.image').
	copy ensureDelete.
	copy binaryWriteStreamDo: [ :out |
		out nextPutAll: (aPath asFileReference binaryReadStreamDo: [ :in | in next: aCount ]) ].
	^ copy
