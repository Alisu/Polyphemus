tests
testALibraryThatIsNotOnThisMachineIsTakenFromWhereTheEnvironmentSays

	"A core read on another machine than its own names a library that is not there: a copy is
	taken from POLYPHEMUS_VM_LIBRARY, and without one the refusal says what is missing. Whether
	the copy is of the same build is the build check's to say."

	| memory variables here before |
	memory := RegionsDouble new.
	memory mapFile: '/nowhere/lib/libPharoVMCore.so' from: 16r7F0000000000 to: 16r7F0000010000.
	memory region: 16r7F0000000000 bytes: (ByteArray new: 16r10000) writable: false.
	variables := VMVariables on: memory.
	here := Smalltalk image imageFile fullName.
	before := OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' ifAbsent: [ nil ].
	[
	OSEnvironment current removeKey: 'POLYPHEMUS_VM_LIBRARY'.
	self
		should: [ variables libraryPath ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal | self assert: refusal reason equals: #itsVMLibraryIsNotOnThisMachine ].
	OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' put: '/nowhere/else/libPharoVMCore.so'.
	self should: [ variables libraryPath ] raise: SpurCannotRead.
	OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' put: here.
	self assert: variables libraryPath equals: here ] ensure: [
		before
			ifNil: [ OSEnvironment current removeKey: 'POLYPHEMUS_VM_LIBRARY' ]
			ifNotNil: [ OSEnvironment current at: 'POLYPHEMUS_VM_LIBRARY' put: before ] ]
