accessing
libraryPath

	"Where the VM library is read from: the copy POLYPHEMUS_VM_LIBRARY names when it names one
	that is there, as for a core read elsewhere than where it was taken; else the file the
	memory says it mapped. That a copy is of the same build is #checkBuild's to say."

	| mapped elsewhere |
	elsewhere := OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' ifAbsent: [ nil ].
	(elsewhere notNil and: [ elsewhere asFileReference exists ]) ifTrue: [ ^ elsewhere ].
	mapped := self mapping path.
	mapped asFileReference exists ifTrue: [ ^ mapped ].
	^ self refuse: #itsVMLibraryIsNotOnThisMachine
