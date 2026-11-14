tests
testAClassVariableWhoseEntryIsATaggedWordKeepsItsPlaceAndTheOthersStillRead

	| float names |
	float := reifiedMemory oopClassNamed: 'Float'.
	names := float oopAllClassVariablesNames.

	self assert: names size equals: 17.
	self assert: (names count: [ :each | each = '(unreadable name)' ]) equals: 1.
	(names reject: [ :each | each = '(unreadable name)' ]) do: [ :each |
		| variable |
		variable := float classVariableNamed: each.
		self assert: variable notNil description: each.
		self deny: variable value isUnreadableSlot description: each ]
