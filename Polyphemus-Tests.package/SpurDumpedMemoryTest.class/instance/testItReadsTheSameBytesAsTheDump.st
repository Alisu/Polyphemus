tests
testItReadsTheSameBytesAsTheDump

	"The mapping is put back at the address it had, so a word read through the simulator
	is the word the dump holds at that same address -- no relocation in between."

	| memory dump |
	dump := ElfCoreDump on: self dumpFile.
	memory := dumped memory.

	#( 0 16 32 ) do: [ :offset |
		self
			assert: (memory memoryManager unsignedLong64At: dumped heapStart + offset)
			equals: (dump unsignedAt: dumped heapStart + offset size: 8) ].
	dump close
