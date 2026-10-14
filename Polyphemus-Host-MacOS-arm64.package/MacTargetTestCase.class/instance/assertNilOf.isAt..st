helpers
assertNilOf: aMacProcessMemory isAt: anAddress

	"nil is the special objects array's first slot: two of the VM's variables and its heap
	agree, on every VM (#80), where an address measured on one VM held for no other."

	| specialObjects |
	specialObjects := (VMVariables on: aMacProcessMemory) at: 'specialObjectsOop'.
	self assert: anAddress equals: (aMacProcessMemory unsignedAt: specialObjects + 8 size: 8)
