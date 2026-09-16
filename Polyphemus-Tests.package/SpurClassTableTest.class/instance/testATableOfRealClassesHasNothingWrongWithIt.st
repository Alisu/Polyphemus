tests
testATableOfRealClassesHasNothingWrongWithIt

	"A class is an object of fixed fields. One in the table is not a problem, and saying it
	was would make every sound image look broken."

	| space problems |
	space := self spaceFor: (self heapWithAClassTableHolding: #( 17 1 3 )).

	problems := (SpurHeapScanner on: space)
		            classTableProblemsFrom: self baseAddress
		            upTo: self baseAddress + space size.

	self assert: problems asArray equals: #(  )
