tests
testAnObjectPastWhereTheHeapWalkStoppedIsRefusedSayingSo

	"#211: bytes in hand say nothing of where the heap ends, so it ends where the walk stops, at a
	damaged header here. An object past it is refused saying where the walk stopped and why: asked
	of a reading that opened (damage near the end), and when the reading cannot be set up at all."

	<readsAnUnsoundHeap>
	self withAHeaderDamagedAt: 1 do: [ :broken :victim :last |
		| reified |
		reified := broken reifiedMemory.
		self
			should: [ reified reifyOop: last ]
			raise: NotInTheReading
			withExceptionDo: [ :refusal |
				self assert: (refusal messageText includesSubstring: victim printStringHex).
				self assert: (refusal messageText includesSubstring: 'unusedFormat') ] ].
	self withAHeaderDamagedAt: 2 / 3 do: [ :broken :victim :last |
		self
			should: [ broken reifiedMemory ]
			raise: NotInTheReading
			withExceptionDo: [ :refusal |
				self assert: (refusal messageText includesSubstring: victim printStringHex).
				self assert: (refusal messageText includesSubstring: 'unusedFormat') ] ]
