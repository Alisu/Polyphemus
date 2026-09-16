tests
testAMemoryWithABrokenTableRefusesToBeReified

	"The whole point of the ladder. Everything below classes is sound here -- the bytes are
	there, the heap walks, the free lists are empty and consistent -- so the memory is
	readable up to a point, and that point is named rather than guessed past."

	| space dumped raised |
	space := self spaceFor: (self heapWithAClassTableHolding: #( 18 2 5 )).
	dumped := SpurDumpedMemory
		          on: space
		          from: self baseAddress
		          to: self baseAddress + space size.

	self assert: (dumped readability canRead: #objects).
	self deny: (dumped readability canRead: #classes).
	self
		assert: (dumped readability whyNot: #classes)
		equals: #classTableHoldsSomethingThatIsNotAClass.
	self assert: dumped readability highestReadableLevel equals: #freeSpace.

	raised := [ dumped reifiedMemory. nil ]
		          on: SpurCannotRead
		          do: [ :error | error ].
	self assert: raised isNotNil.
	self assert: raised level equals: #classes
