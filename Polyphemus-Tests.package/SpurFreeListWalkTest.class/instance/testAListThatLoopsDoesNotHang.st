tests
testAListThatLoopsDoesNotHang

	"A chunk whose next is itself. The answer matters less than the fact that there is one:
	a checker that hangs on damaged memory is worse than no checker."

	| base space chunk walk |
	base := self baseAddress.
	chunk := base + 48 + 520.
	space := self spaceFor: (self heapWithFreeLists: { (3 -> chunk) }) , {
			         { 0. 1. 2. { chunk. 0 } } }.

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: base
		        upTo: base + space size.

	self deny: walk isIntact.
	self
		assert: (walk problems collect: [ :each | each key ]) asArray
		equals: #( #listDoesNotEnd )
