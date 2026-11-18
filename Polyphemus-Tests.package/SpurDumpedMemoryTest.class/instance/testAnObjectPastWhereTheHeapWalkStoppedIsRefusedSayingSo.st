tests
testAnObjectPastWhereTheHeapWalkStoppedIsRefusedSayingSo

	"#211: bytes in hand say nothing of where the heap ends, so the walk that looks for its end stops
	at a damaged header. The raw heap says where and why for an address past it; a reading that
	refuses such an address, or cannot be set up (not every edition cuts the heap there), says it too."

	<readsAnUnsoundHeap>
	| says |
	says := [ :text | (text includesSubstring: 'unusedFormat') and: [ text includesSubstring: 'the walk over the heap stopped' ] ].
	self withAHeaderDamagedAt: 1 do: [ :broken :victim :last |
		| reified |
		broken raw liveEnd.
		self assert: (says value: (broken raw whyPastItsWalk: last)).
		self assert: ((broken raw whyPastItsWalk: last) includesSubstring: victim printStringHex).
		self assert: (broken raw whyPastItsWalk: broken raw heapStart) isNil.
		reified := broken reifiedMemory.
		[ reified reifyOop: last ]
			on: NotInTheReading
			do: [ :refusal | self assert: (says value: refusal messageText) ] ].
	self withAHeaderDamagedAt: 2 / 3 do: [ :broken :victim :last |
		[ broken reifiedMemory ]
			on: NotInTheReading
			do: [ :refusal | self assert: (says value: refusal messageText) ] ]
