tests
testItsHeapIsFoundWhereTheVirtualMachinePutsIt

	"Where the VM states nil is, not the largest region, which held a table that only looked like
	nil, false and true (2026-10-13). Not walked here: this image's own heap is 1.3 GB."

	| memory |
	memory := MacProcessMemory onSelf.
	self
		assertNilOf: memory
		isAt: (SpurRawHeap statedHeapStartIn: memory variables: (VMVariables on: memory))
