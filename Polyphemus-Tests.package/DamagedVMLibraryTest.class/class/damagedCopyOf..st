building
damagedCopyOf: aLibraryFile

	"A copy of the library in this edition's scratch folder, the first letter of each of
	#namesTakenOut overwritten wherever the file spells that name whole."

	| bytes copy |
	bytes := aLibraryFile binaryReadStreamDo: [ :stream | stream upToEnd ].
	self namesTakenOut do: [ :each |
		| spelled from |
		spelled := #[ 0 ] , each asByteArray , #[ 0 ].
		from := 1.
		[ (from := bytes indexOfSubCollection: spelled startingAt: from) > 0 ] whileTrue: [
			bytes at: from + 1 put: $_ asInteger.
			from := from + spelled size ] ].
	copy := PolyphemusEdition current scratch / ('polyphemus-damaged-' , aLibraryFile basename).
	copy ensureDelete.
	copy binaryWriteStreamDo: [ :stream | stream nextPutAll: bytes ].
	^ copy
