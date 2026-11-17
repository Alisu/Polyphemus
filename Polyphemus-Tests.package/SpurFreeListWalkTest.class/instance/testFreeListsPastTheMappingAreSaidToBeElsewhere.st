tests
testFreeListsPastTheMappingAreSaidToBeElsewhere

	"#195: a heap that ends after nil, false and true puts the free lists past its end; the walk
	sent formatIn: to the nil read there. It names the problem instead."

	<readsAnUnsoundHeap>
	| space walk |
	space := self spaceFor: {
			         #( 3075 0 0 ).
			         #( 3077 0 0 ).
			         #( 3079 0 0 ) }.

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: self baseAddress
		        upTo: self baseAddress + space size.

	self deny: walk isIntact.
	self
		assert: (walk problems collect: [ :each | each key ]) asArray
		equals: #( #freeListsAreNotWhereTheHeapSaysTheyAre )