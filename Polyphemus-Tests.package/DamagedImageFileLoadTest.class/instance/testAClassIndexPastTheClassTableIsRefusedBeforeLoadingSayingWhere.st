tests
testAClassIndexPastTheClassTableIsRefusedBeforeLoadingSayingWhere
	<readsAnUnsoundHeap>

	"#207: the header of an object of fixed fields a tagged word, then all ones. The walk steps on
	into its slots, and one read as a header names a class past the class table, which VMMaker
	asserts on: the ladder refuses the file at objects, saying where."

	{ 16r29. 16rFFFFFFFFFFFFFFFF } do: [ :word |
		| refusal |
		refusal := self refusalOfACopyDamagedBy: (self firstObjectOfFormat: 1) address -> word.
		self assert: refusal level equals: #objects.
		self assert: refusal reason equals: #aClassIndexIsPastTheClassTable.
		self assert: (refusal messageText includesSubstring: 'the object at 16r') ]
