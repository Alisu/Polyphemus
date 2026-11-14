accessing
memory

	"The setup's core read once for the class with the damaged copy of its library, which
	POLYPHEMUS_VM_LIBRARY names for the time its variables are first asked."

	| core library before |
	Memory ifNotNil: [ ^ Memory ].
	core := SpurDumpedMemoryTest new dumpFile.
	library := (VMVariables on: (FileAddressSpace onDump: core)) libraryPath asFileReference.
	before := OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' ifAbsent: [ nil ].
	OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' put: (self damagedCopyOf: library) fullName.
	^ [
	  Memory := Polyphemus readCoreDump: core fullName.
	  Memory vmLayout raw vmVariables library.
	  Memory ] ensure: [
		  before
			  ifNil: [ OSEnvironment current removeKey: 'POLYPHEMUS_VM_LIBRARY' ]
			  ifNotNil: [ OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' put: before ] ]
