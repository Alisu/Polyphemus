tests
testItNamesTheModulesItLoaded

	"As a minidump's ModuleList does: each module's path and where its image lies, the VM's
	library among them, at a path that exists."

	| vm |
	vm := WindowsProcessMemory onSelf mappedFiles
		      detect: [ :each | VMVariables isTheVMLibrary: each path ]
		      ifNone: [ nil ].
	self assert: vm notNil.
	self assert: vm fileOffset equals: 0.
	self assert: vm stop > vm start.
	self assert: vm path asFileReference exists
