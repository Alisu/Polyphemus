tests
testItRefusesALibraryOfAnotherBuild

	"A symbol of another build names some other word. Nothing is read through it."

	| other |
	other := variables library file parent files detect: [ :each |
		         (each basename beginsWith: 'lib')
			         and: [ (each basename includesSubstring: '.so')
			         and: [ (each basename includesSubstring: 'PharoVMCore') not ] ] ].

	self
		should: [ (VMVariables on: dump library: (ElfSharedObject on: other)) at: 'numStackPages' ]
		raise: SpurCannotRead
