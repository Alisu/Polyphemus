tests
testItWritesACoreOurOwnReaderCanReadBack

	"Taking a dump from Pharo, with no debugger involved: a few regions of this process
	written as an ELF core, and read back by the reader we use on gdb's.

	The bytes have to survive the round trip, which is what says the header arithmetic and
	the offsets are right rather than merely plausible."

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
