tests
testItReadsItsOwnVirtualMachinesVariables

	"Through the library's symbols, as on Linux: where nil is, and new space, which VM 10 keeps
	in its memory map, not where Linux's VM puts it."

	| memory variables |
	memory := MacProcessMemory onSelf.
	variables := VMVariables on: memory.
	self assertNilOf: memory isAt: (variables at: 'nilObj').
	self assert: (memory hasAddress: (variables at: 'newSpaceStart'))
