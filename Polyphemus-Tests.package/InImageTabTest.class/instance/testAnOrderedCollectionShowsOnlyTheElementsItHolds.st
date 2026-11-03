tests
testAnOrderedCollectionShowsOnlyTheElementsItHolds

	"Not the whole array behind it: from its first index to its last."

	| collection size |
	collection := self anInstanceOf: 'OrderedCollection' suchThat: [ :each |
		(each oopSlotNamed: 'lastIndex') asInteger - (each oopSlotNamed: 'firstIndex') asInteger between: 0 and: 20 ].
	size := (collection oopSlotNamed: 'lastIndex') asInteger - (collection oopSlotNamed: 'firstIndex') asInteger + 1.
	self assert: (self labelsOf: collection) asArray equals: ((1 to: size) collect: [ :each | each printString ]) asArray.
	self
		assert: collection inImageItems first value address
		equals: ((collection oopSlotNamed: 'array') reifiedSlotAt: (collection oopSlotNamed: 'firstIndex') asInteger) address
