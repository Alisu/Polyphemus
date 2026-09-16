tests
testAListThatPointsAtALiveObjectIsNamed

	"The worst kind of damage: the allocator believes a live object is free, and will hand
	it out. Its class index is not zero, which is what says so."

	| base space live walk |
	base := self baseAddress.
	live := base + 48 + 520.
	space := self spaceFor: (self heapWithFreeLists: { (3 -> live) }) , {
			         { 17. 1. 2. { 0. 0 } } }.

	walk := (SpurHeapScanner on: space)
		        freeListWalkFrom: base
		        upTo: base + space size.

	self deny: walk isIntact.
	self
		assert: (walk problems collect: [ :each | each key ]) asArray
		equals: #( #listHoldsSomethingThatIsNotFree )
