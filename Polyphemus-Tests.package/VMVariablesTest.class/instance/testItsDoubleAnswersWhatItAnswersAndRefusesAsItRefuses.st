tests
testItsDoubleAnswersWhatItAnswersAndRefusesAsItRefuses

	"#164: the tests of writing into a live VM's new space rest on a double of these variables.
	It answers no message the real one does not, but for its own set-up, and a variable its memory
	does not hold is refused with the real one's reason, not answered nil."

	| double |
	self
		assert: ((VMVariablesDouble selectors reject: [ :each | #( #setMemory:addresses: #machineCode: ) includes: each ])
				 reject: [ :each | VMVariables canUnderstand: each ]) asArray
		equals: #(  ).
	double := VMVariablesDouble new
		          setMemory: (ByteArrayAddressSpace on: (ByteArray new: 16) at: 16r1000)
		          addresses: (Dictionary new at: 'elsewhere' put: 16r9000; yourself).
	self
		should: [ double at: 'elsewhere' ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal | self assert: refusal reason equals: #itsVariableWasNotDumped ]
