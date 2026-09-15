tests
testALongRunOfObjectsLooksLikeAHeap

	"And the other half: something that really is a run of objects has to be recognised as
	one."

	| specs space |
	specs := (1 to: 600) collect: [ :index | { 17. 1. index \\ 4 + 1 } ].
	space := self spaceFor: specs.

	self assert: ((SpurHeapScanner on: space)
			 looksLikeAHeapFrom: self baseAddress
			 upTo: self baseAddress + space size)
