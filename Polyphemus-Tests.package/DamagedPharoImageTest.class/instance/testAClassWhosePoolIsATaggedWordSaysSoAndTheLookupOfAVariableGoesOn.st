tests
testAClassWhosePoolIsATaggedWordSaysSoAndTheLookupOfAVariableGoesOn

	| delay |
	delay := reifiedMemory oopClassNamed: 'Delay'.

	self should: [ delay oopAllClassVariablesNames ] raise: NotInTheReading.
	self assert: (delay classVariableNamed: 'Scheduler') isNil.
	self assert: ((reifiedMemory oopClassNamed: 'Character') classVariableNamed: 'CharacterTable') notNil
