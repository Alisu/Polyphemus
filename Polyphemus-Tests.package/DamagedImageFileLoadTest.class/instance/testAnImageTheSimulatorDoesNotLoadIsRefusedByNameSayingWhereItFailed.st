tests
testAnImageTheSimulatorDoesNotLoadIsRefusedByNameSayingWhereItFailed
	<readsAnUnsoundHeap>

	"#207: nil's special object zeroed in one copy, the first word of the free lists a tagged word
	in another. The ladder passes both and VMMaker's loader fails on each with an error of its
	own: refused by name, with VMMaker's step."

	| nilSlot freeLists |
	nilSlot := DamagedCandleImage slot: 1 of: clean reifiedSpecialObjectArray.
	freeLists := clean reifiedNilObject address + 48 + 8.
	{ (nilSlot -> 0). (freeLists -> 16r29) } do: [ :damage |
		| refusal |
		refusal := self refusalOfACopyDamagedBy: damage.
		self assert: refusal level equals: #image.
		self assert: refusal reason equals: #theSimulatorDidNotLoadIt.
		self assert: (refusal messageText includesSubstring: 'VMMaker''s ') ]
