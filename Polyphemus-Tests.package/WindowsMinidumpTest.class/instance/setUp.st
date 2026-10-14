running
setUp

	super setUp.
	dumpFile := PolyphemusEdition current scratch / 'polyphemus-test.dmp'.
	dumpFile ensureDelete.
	dumpFile binaryWriteStreamDo: [ :stream | stream nextPutAll: self minidumpBytes ]
