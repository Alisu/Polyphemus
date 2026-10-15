tests
testItListsItsOwnReadableRegions

	"VirtualQueryEx: every committed region it may read, each starting where it says."

	| memory |
	memory := WindowsProcessMemory onSelf.
	self assert: memory segments notEmpty.
	memory segments do: [ :each |
		self assert: each sizeInMemory > 0.
		self assert: (memory hasAddress: each address) ]
