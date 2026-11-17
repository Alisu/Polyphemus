tests
testACoreWeWriteNamesTheFilesItMapsAndItsProcessor

	"NT_FILE names the VM library, where a reader finds the VM's variables; e_machine says
	AArch64 (183), the processor the registers of a later note would be."

	| memory file read vmLibrary machine |
	memory := MacProcessMemory onSelf.
	file := PolyphemusEdition current scratch / 'polyphemus-mac-files.core'.
	vmLibrary := memory mappedFiles detect: [ :each | each path endsWith: '/libPharoVMCore.dylib' ].
	memory writeDumpTo: file regions: (memory segments first: 1).
	read := ElfCoreDump on: file.
	self assert: (read mappedFiles anySatisfy: [ :each | each path = vmLibrary path and: [ each start = vmLibrary start ] ]).
	read close.
	machine := file binaryReadStreamDo: [ :s | s next: 20 ].
	self assert: (machine at: 19) + ((machine at: 20) * 256) equals: 183.
	file ensureDelete
