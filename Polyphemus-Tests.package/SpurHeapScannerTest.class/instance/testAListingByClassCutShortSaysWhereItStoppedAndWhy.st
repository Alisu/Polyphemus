tests
testAListingByClassCutShortSaysWhereItStoppedAndWhy

	"#211: a header that is no object's ends the walk; the objects before it are listed, and the
	listing says where it stopped and why, instead of passing for the whole heap's."

	| specs space found cut |
	specs := self aFewObjects , #( #( 18 2 1 ) #( 22 6 1 ) #( 18 2 1 ) ).
	space := self spaceFor: specs.
	found := (SpurHeapScanner on: space)
		         addressesOfClassIndex: 18
		         from: self baseAddress
		         upTo: self baseAddress + space size
		         ifCutShort: [ :walk | cut := walk ].

	self assert: found size equals: 2.
	self assert: cut reason equals: #unusedFormat.
	self assert: cut stoppedAt equals: ((self addressesOf: specs) detect: [ :each | each value = 22 ]) key
