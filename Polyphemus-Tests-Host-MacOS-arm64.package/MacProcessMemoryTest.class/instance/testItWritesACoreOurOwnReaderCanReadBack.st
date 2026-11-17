tests
testItWritesACoreOurOwnReaderCanReadBack

	"A few regions of its own task written as an ELF core, as LinuxProcessMemory writes one, and
	read back by the reader of gdb's cores: the bytes surviving says the offsets are right."

	| memory file written read |
	memory := MacProcessMemory onSelf.
	file := PolyphemusEdition current scratch / 'polyphemus-mac-round-trip.core'.
	written := (memory segments select: [ :each | each sizeInFile between: 4096 and: 65536 ]) first: 3.
	memory writeDumpTo: file regions: written.
	read := ElfCoreDump on: file.
	self assert: read loadableSegments size equals: written size.
	written do: [ :each |
		self assert: (read bytesAt: each address count: 32) equals: (memory bytesAt: each address count: 32) ].
	read close.
	file ensureDelete
