tests
testADictionaryShowsItsKeysAndValues

	| dictionary items |
	dictionary := self anInstanceOf: 'Dictionary' suchThat: [ :each | (each oopSlotNamed: 'tally') asInteger between: 1 and: 20 ].
	items := dictionary inImageItems.
	self assert: items size equals: (dictionary oopSlotNamed: 'tally') asInteger.
	self assert: (items allSatisfy: [ :each | each value isKindOf: OOPAbstractEntity ])
