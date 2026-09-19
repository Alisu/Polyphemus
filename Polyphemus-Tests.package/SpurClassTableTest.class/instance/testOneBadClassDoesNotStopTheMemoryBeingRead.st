tests
testOneBadClassDoesNotStopTheMemoryBeingRead

	"One entry of the table is not a class. That costs the name of the classes at that index
	and nothing else: the table still resolves, the heap is still a heap, and the million
	objects that have nothing to do with it are still readable.

	Refusing the whole memory over one bad class would be the wrong trade -- and damage of
	that kind is far likelier than a table that has gone entirely."

	| space dumped |
	space := self spaceFor: (self heapWithAClassTableHolding: #( 18 2 5 )).
	dumped := SpurDumpedMemory
		          on: space
		          from: self baseAddress
		          to: self baseAddress + space size.

	self assert: dumped raw classTableStructureProblems asArray equals: #(  ).
	self assert: dumped raw unreadableClassIndexes asArray equals: #( 3 ).
	self assert: (dumped raw readability canRead: #classes)
