tests
testASlotZeroedInTheFileIsUnreadable

	"A class's name zeroed in the file: loaded, the zero word is shifted with every pointer and
	points nowhere. The slot stands as unreadable, in its place, and the class says it has no name."

	| victim memory class slots |
	memory := DamagedCandleImage readingWith: [ :clean |
		          victim := clean oopClassNamed: 'PCPoint'.
		          { ((self slot: victim slotIndexForClassName of: victim) -> 0) } ].
	class := memory reifyOop: victim address.
	slots := class allReifiedSlots.

	self assert: (slots at: class slotIndexForClassName) isUnreadableSlot.
	self assert: (slots count: [ :each | each isUnreadableSlot ]) equals: 1.
	self
		assert: (memory readSlot: class slotIndexForClassName of: class ifUnreadable: [ #unreadable ])
		equals: #unreadable.
	self deny: class hasAReadableName
