tests
testItReadsItsOwnVirtualMachinesVariables

	"Through the library's symbols, as on Linux: where nil is, as this VM says it keeps old
	space, and new space, which VM 10 keeps in its memory map, not where Linux's VM puts it."

	| memory variables |
	memory := MacProcessMemory onSelf.
	variables := VMVariables on: memory.
	self assertTheHeapOfThisVirtualMachineStartsAt: (variables at: 'nilObj').
	self assert: (memory hasAddress: (variables at: 'newSpaceStart'))
