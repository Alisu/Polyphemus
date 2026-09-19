tests
testDamageInOnePartDoesNotHideWhatIsSoundInAnother

	"A walk that stops part way is damage there only: it is recorded, the climb carries on, and
	the untouched class table stays readable."

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
