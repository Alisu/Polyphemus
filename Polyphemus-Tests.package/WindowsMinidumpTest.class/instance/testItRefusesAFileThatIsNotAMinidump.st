tests
testItRefusesAFileThatIsNotAMinidump

	| notADump |
	notADump := PolyphemusEdition current scratch / 'polyphemus-not-a-minidump'.
	notADump ensureDelete.
	notADump binaryWriteStreamDo: [ :stream | stream nextPutAll: (ByteArray new: 128 withAll: 7) ].
	[ self should: [ WindowsMinidump on: notADump ] raise: Error ] ensure: [ notADump ensureDelete ]
