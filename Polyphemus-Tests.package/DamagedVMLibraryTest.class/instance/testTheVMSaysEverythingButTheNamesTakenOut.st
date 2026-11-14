tests
testTheVMSaysEverythingButTheNamesTakenOut

	"What the other tests stand on: the copy is of the same build and names the rest."

	| variables |
	variables := memory vmLayout raw vmVariables.
	self assert: (variables at: 'nilObj') > 0.
	self class namesTakenOut do: [ :each |
		self
			should: [ variables at: each ]
			raise: SpurCannotRead
			withExceptionDo: [ :refusal | self assert: refusal reason equals: #theVMLibraryHasNoSuchSymbol ] ]
