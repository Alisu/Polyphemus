tests
testACoreLeavesOutTheSystemsSharedLibraries

	"The shared libraries cache is mapped as a submap: 4.7 of 5.5 GB readable in this process
	(2026-10-13). A core leaves it out, and keeps the heap and the VM library it is read with."

	| memory dumped all library |
	memory := MacProcessMemory onSelf.
	all := memory segments inject: 0 into: [ :sum :each | sum + each sizeInMemory ].
	dumped := memory dumpableSegments inject: 0 into: [ :sum :each | sum + each sizeInMemory ].
	library := memory mappedFiles detect: [ :each | (each path endsWith: '/libPharoVMCore.dylib') and: [ each fileOffset = 0 ] ].
	self assert: dumped < (all / 2).
	self assert: (memory dumpableSegments anySatisfy: [ :each | each holdsAddress: 16r10000000000 ]).
	self assert: (memory dumpableSegments anySatisfy: [ :each | each holdsAddress: library start ])
