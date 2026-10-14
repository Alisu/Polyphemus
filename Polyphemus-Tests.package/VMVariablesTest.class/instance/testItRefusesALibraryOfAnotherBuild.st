tests
testItRefusesALibraryOfAnotherBuild

	"A symbol of another build names some other word. Nothing is read through it."

	| vm other |
	vm := variables library file asFileReference.
	other := vm parent files detect: [ :each |
		         each basename ~= vm basename and: [
			         (each basename beginsWith: 'lib') & (each basename includesSubstring: '.so')
			         | (each extension asLowercase = vm extension asLowercase) ] ].

	self
		should: [ (VMVariables on: dump library: (variables library class on: other fullName)) at: 'numStackPages' ]
		raise: SpurCannotRead
