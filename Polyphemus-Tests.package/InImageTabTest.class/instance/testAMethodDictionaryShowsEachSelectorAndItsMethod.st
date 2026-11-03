tests
testAMethodDictionaryShowsEachSelectorAndItsMethod

	"#95: a selector and its method on each line, not a tally, an array and empty slots; sorted
	by selector, as Pharo's inspector sorts a dictionary's keys."

	| dictionary items |
	dictionary := (self memory oopClassNamed: 'Object') reifiedMethodDictionary.
	items := dictionary inImageItems.
	self assert: items size equals: (dictionary oopSlotNamed: 'tally') asInteger.
	self
		assert: (items detect: [ :each | each key = '#printString' ]) value inImageDescription
		equals: 'Object >> #printString'.
	self assert: (items collect: [ :each | each key ]) asArray equals: (items collect: [ :each | each key ]) asSortedCollection asArray
