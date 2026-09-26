tests
testItRefusesAFileThatIsNotACoreDump

	"By name, rather than by misreading it. An image file is an ELF file's opposite here:
	both are binary, and reading one as the other answers numbers that mean nothing."

	| notACore |
	notACore := PolyphemusEdition current scratch / 'polyphemus-not-a-core'.
	notACore ensureDelete.
	notACore binaryWriteStreamDo: [ :stream |
		stream nextPutAll: (ByteArray new: 128 withAll: 7) ].

	[ self should: [ ElfCoreDump on: notACore ] raise: Error ] ensure: [
		notACore ensureDelete ]
