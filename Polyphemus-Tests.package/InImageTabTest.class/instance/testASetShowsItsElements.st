tests
testASetShowsItsElements

	| set |
	set := self anInstanceOf: 'Set' suchThat: [ :each | (each oopSlotNamed: 'tally') asInteger between: 1 and: 20 ].
	self assert: (self labelsOf: set) asArray equals: ((1 to: (set oopSlotNamed: 'tally') asInteger) collect: [ :each | each printString ]) asArray
