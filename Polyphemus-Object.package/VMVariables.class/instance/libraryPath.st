accessing
libraryPath

	"Where the VM library is read from: the file the memory says it mapped or, when that one is
	not on this machine, as for a core read elsewhere than where it was taken, the copy that
	POLYPHEMUS_VM_LIBRARY names. That the copy is of the same build is #checkBuild's to say."

	| mapped elsewhere |
	mapped := self mapping path.
	mapped asFileReference exists ifTrue: [ ^ mapped ].
	elsewhere := OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' ifAbsent: [ nil ].
	(elsewhere notNil and: [ elsewhere asFileReference exists ]) ifTrue: [ ^ elsewhere ].
	^ self refuse: #itsVMLibraryIsNotOnThisMachine
