tests
testAClassPoolThatIsNoDictionaryIsRefusedByNameAndTheLookupOfAVariableGoesOn

	"#205: the pool was asked for the slots of an array it has not, which is nil."

	| rectangle |
	rectangle := reifiedMemory oopClassNamed: 'Rectangle'.

	self
		should: [ rectangle oopAllClassVariablesNames ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'is no dictionary') ].
	self should: [ rectangle oopNumberOfClassVariables ] raise: NotInTheReading.
	self assert: (rectangle classVariableNamed: 'NoSuchVariable') isNil
