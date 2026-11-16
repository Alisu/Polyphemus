tests
testAHeaderTheSimulatorsWalkStopsAtIsRefusedSayingAfterWhichObject
	<readsAnUnsoundHeap>

	"#207: the header of an object of fixed fields a tagged word, then all ones. Our walk steps on
	and the ladder passes; VMMaker's walk, which every object is reified from, asserts on what
	follows: refused by name, with the last object it gave."

	{ 16r29. 16rFFFFFFFFFFFFFFFF } do: [ :word |
		| refusal |
		refusal := self refusalOfACopyDamagedBy: (self firstObjectOfFormat: 1) address -> word.
		self assert: refusal level equals: #objects.
		self assert: refusal reason equals: #theSimulatorsWalkStopped.
		self assert: (refusal messageText includesSubstring: 'after the object at 16r') ]
