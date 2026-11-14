tests
testASlotOverwrittenWithATaggedWordIsUnreadableWhereAnObjectWasExpected

	"#118: a class's name overwritten in the file with a tagged word, a SmallInteger. What the slot
	holds is no object with slots: asked for one, it refuses by name, and the place that answers
	for an unreadable slot answers for it."

	| victim memory class name |
	memory := DamagedCandleImage readingWith: [ :clean |
		          victim := clean oopClassNamed: 'PCPoint'.
		          { ((self slot: victim slotIndexForClassName of: victim) -> 16r29) } ].
	class := memory reifyOop: victim address.
	name := class reifiedSlotAt: class slotIndexForClassName.

	self assert: name isImmediateOop.
	self assert: (memory readSlot: 1 of: name ifUnreadable: [ #unreadable ]) equals: #unreadable.
	self should: [ name reifiedSlotAt: 1 ] raise: NotInTheReading.
	self should: [ name oopNumberOfSlots ] raise: NotInTheReading.
	self should: [ name oopSlotNamed: #anything ] raise: NotInTheReading.
	self deny: class hasAReadableName.
	self assert: (memory oopClassNamed: 'PCAssociation') hasAReadableName
