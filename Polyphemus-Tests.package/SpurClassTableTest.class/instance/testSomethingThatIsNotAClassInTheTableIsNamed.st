tests
testSomethingThatIsNotAClassInTheTableIsNamed

	"An entry that is not a class crashes nothing -- its objects just get a wrong name. It is
	reported by the class index it answers to: that says which objects lose their name."

	| space problems |
	space := self spaceFor: (self heapWithAClassTableHolding: #( 18 2 5 )).

	problems := (SpurHeapScanner on: space)
		            classTableProblemsFrom: self baseAddress
		            upTo: self baseAddress + space size.

	self
		assert: (problems collect: [ :each | each key ]) asArray
		equals: #( #classTableHoldsSomethingThatIsNotAClass ).
	self assert: problems first value equals: 3
