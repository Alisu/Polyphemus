running
setUp

	"A dump small enough to write here. A real one needs a crashed VM and is hundreds of
	megabytes; the reader cannot tell the difference, because all it reads is an ELF header
	and a program header table."

	super setUp.
	dumpFile := PolyphemusEdition current scratch / 'polyphemus-test.core'.
	dumpFile ensureDelete.
	dumpFile binaryWriteStreamDo: [ :stream | stream nextPutAll: self coreBytes ]
