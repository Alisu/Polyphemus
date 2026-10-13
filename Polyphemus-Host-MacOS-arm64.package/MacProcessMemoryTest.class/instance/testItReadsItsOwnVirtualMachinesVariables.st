tests
testItReadsItsOwnVirtualMachinesVariables

	"Through the library's symbols, as on Linux: where nil is, and new space, which VM 10 keeps
	in its memory map, not where Linux's VM puts it."

	| memory variables |
	memory := MacProcessMemory onSelf.
	variables := VMVariables on: memory.
	self assert: (variables at: 'nilObj') equals: 16r10000000000.
	self assert: (memory hasAddress: (variables at: 'newSpaceStart'))
