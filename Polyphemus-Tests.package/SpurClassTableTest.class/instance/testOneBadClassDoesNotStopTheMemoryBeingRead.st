tests
testOneBadClassDoesNotStopTheMemoryBeingRead

	"One table entry that is not a class costs that index's name only: the table resolves, the
	heap is a heap, and every other object reads."

	| space dumped |
	space := self spaceFor: (self heapWithAClassTableHolding: #( 18 2 5 )).
	dumped := SpurDumpedMemory
		          on: space
		          from: self baseAddress
		          to: self baseAddress + space size.

	self assert: dumped raw classTableStructureProblems asArray equals: #(  ).
	self assert: dumped raw unreadableClassIndexes asArray equals: #( 3 ).
	self assert: (dumped raw readability canRead: #classes)
