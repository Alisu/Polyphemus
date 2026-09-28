tests
testACoreWeWriteNamesTheFilesItMapsAsTheKernelDoes

	"#66: without the NT_FILE note gdb and the kernel write, a reader of our own core could not
	find the VM's library, so neither its variables nor where new space is."

	| file read vmLibrary |
	file := PolyphemusEdition current scratch / 'polyphemus-files.core'.
	vmLibrary := memory mappedFiles detect: [ :each | each path includesSubstring: 'libPharoVMCore' ].

	memory writeDumpTo: file regions: (memory segments first: 1).
	read := ElfCoreDump on: file.

	self
		assert: ((read mappedFiles select: [ :each | each path = vmLibrary path ]) collect: [ :each | each start ]) asArray
		equals: ((memory mappedFiles select: [ :each | each path = vmLibrary path ]) collect: [ :each | each start ]) asArray.
	self assert: read loadableSegments size equals: 1.
	read close.
	file ensureDelete
