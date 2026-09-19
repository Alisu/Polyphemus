tests
testItWritesACoreOurOwnReaderCanReadBack

	"Regions of this process written as an ELF core by Pharo, no debugger, and read back by the
	reader used on gdb's cores: the bytes surviving says the header and offsets are right."

	| file written read |
	file := FileLocator temp / 'polyphemus-round-trip.core'.
	written := memory segments
		           select: [ :each | each sizeInFile between: 4096 and: 65536 ]
		           thenCollect: [ :each | each ].
	written := written first: (3 min: written size).
	self assert: written size > 0.

	memory writeDumpTo: file regions: written.
	read := ElfCoreDump on: file.

	self assert: read loadableSegments size equals: written size.
	written do: [ :each |
		self
			assert: (read bytesAt: each address count: 32)
			equals: (memory bytesAt: each address count: 32) ].
	read close.
	file ensureDelete
