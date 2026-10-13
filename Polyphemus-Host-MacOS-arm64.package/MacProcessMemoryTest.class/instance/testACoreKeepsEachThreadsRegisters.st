tests
testACoreKeepsEachThreadsRegisters

	"NT_PRSTATUS for each thread, in Linux's aarch64 layout, read back by ElfCoreDump: what a
	running process's newest frames are found from (#17)."

	| memory file read |
	memory := MacProcessMemory onSelf.
	file := PolyphemusEdition current scratch / 'polyphemus-mac-registers.core'.
	memory writeDumpTo: file regions: (memory segments first: 1).
	read := ElfCoreDump on: file.
	self assert: read threadRegisters size equals: memory threadRegisters size.
	read threadRegisters do: [ :each |
		self assert: (each at: #pc) > 0.
		self assert: (memory hasAddress: (each at: #sp)) ].
	read close.
	file ensureDelete
