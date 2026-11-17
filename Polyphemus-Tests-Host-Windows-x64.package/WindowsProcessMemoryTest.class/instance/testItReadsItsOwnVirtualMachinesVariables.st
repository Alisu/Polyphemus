tests
testItReadsItsOwnVirtualMachinesVariables

	"Through PharoVMCore.dll's symbols (PeSharedObject): nil is where the VM says, the special
	objects array's first slot -- two of its variables and its heap agree."

	| memory variables |
	memory := WindowsProcessMemory onSelf.
	variables := VMVariables on: memory.
	self
		assert: (variables at: 'nilObj')
		equals: (memory unsignedAt: (variables at: 'specialObjectsOop') + 8 size: 8)
