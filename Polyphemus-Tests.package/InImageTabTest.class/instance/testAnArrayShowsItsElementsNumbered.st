tests
testAnArrayShowsItsElementsNumbered

	| array |
	array := self anInstanceOf: 'Array' suchThat: [ :each | each oopNumberOfSlots between: 2 and: 20 ].
	self assert: (self labelsOf: array) asArray equals: ((1 to: array oopNumberOfSlots) collect: [ :each | each printString ]) asArray
