tests
testDamageInOnePartDoesNotHideWhatIsSoundInAnother

	"A heap that stops walking part way through is damaged where it stops, and nowhere else.
	Its class table is untouched, and refusing to read it because the walk ended early would
	be answering a question about one end of the memory with a fact about the other.

	So the walk failing is recorded, the climb carries on, and classes stay readable."

	| space dumped |
	space := self spaceFor:
		         (self heapWithAClassTableHolding: #( 17 1 3 ))
		         , { #( 17 7 2 ) "format 7 is not a format" }.
	dumped := SpurDumpedMemory
		          on: space
		          from: self baseAddress
		          to: self baseAddress + space size.

	self deny: (dumped raw readability canRead: #objects).
	self assert: (dumped raw readability canRead: #classes).
	self assert: dumped raw classTableProblems asArray equals: #(  ).
	self assert: (dumped raw readability refusals includesKey: #objects)
