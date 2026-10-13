tests
testItSaysItsProcessorIsArm64

	"Its own, and a core it writes: how Cog's machine code and registers are read."

	| memory file read |
	memory := MacProcessMemory onSelf.
	self assert: memory processor equals: #aarch64.
	file := PolyphemusEdition current scratch / 'polyphemus-mac-processor.core'.
	memory writeDumpTo: file regions: (memory segments first: 1).
	read := ElfCoreDump on: file.
	[ self assert: read processor equals: #aarch64 ] ensure: [
		read close.
		file ensureDelete ]
