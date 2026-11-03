tests
testItFindsTheObjectsOfOneClass

	"#152: the instances of a class, found by the scanner's walk rather than the simulator's,
	including one past a free chunk and one behind an overflow word."

	| specs space found |
	specs := self aFewObjects , #( #( 18 2 1 ) #( 0 0 1 ) #( 18 2 400 ) #( 21 1 1 ) ).
	space := self spaceFor: specs.
	found := (SpurHeapScanner on: space)
		         addressesOfClassIndex: 18
		         from: self baseAddress
		         upTo: self baseAddress + space size.

	self
		assert: found asArray
		equals: ((self addressesOf: specs) select: [ :each | each value = 18 ] thenCollect: [ :each | each key ]) asArray
