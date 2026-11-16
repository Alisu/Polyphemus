tests
testAHeaderTheSimulatorsWalkStopsAtIsRefusedSayingAfterWhichObject
	<readsAnUnsoundHeap>

	"#207: the header of an object of fixed fields a tagged word, then all ones, opened as the
	MCP and the inspector open a file, without the ladder. VMMaker's walk, which every object is
	reified from, asserts on what follows: refused by name, with the last object it gave."

	{ 16r29. 16rFFFFFFFFFFFFFFFF } do: [ :word |
		self withACopyDamagedBy: (self firstObjectOfFormat: 1) address -> word do: [ :copy |
			self
				should: [ FullyReifiedMemory on: (Polyphemus interpreterOnImageFile: copy fullName) objectMemory ]
				raise: SpurCannotRead
				withExceptionDo: [ :refusal |
					self assert: refusal level equals: #objects.
					self assert: refusal reason equals: #theSimulatorsWalkStopped.
					self assert: (refusal messageText includesSubstring: 'after the object at 16r') ] ] ]
