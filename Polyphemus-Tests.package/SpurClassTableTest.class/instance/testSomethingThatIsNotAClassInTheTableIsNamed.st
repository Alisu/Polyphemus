tests
testSomethingThatIsNotAClassInTheTableIsNamed

	"The quietest damage there is. Nothing crashes; every object of that class simply gets
	the wrong name, and no other check would notice -- the heap walks, the free lists add
	up, the object is perfectly well formed. It just is not a class."

	| space problems |
	space := self spaceFor: (self heapWithAClassTableHolding: #( 18 2 5 )).

	problems := (SpurHeapScanner on: space)
		            classTableProblemsFrom: self baseAddress
		            upTo: self baseAddress + space size.

	self
		assert: (problems collect: [ :each | each key ]) asArray
		equals: #( #classTableHoldsSomethingThatIsNotAClass ).
	self assert: problems first value equals: self entryAddress
