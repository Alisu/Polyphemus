tests
testAnObjectWhoseHeaderSaysMoreSlotsThanTheMemoryHoldsKeepsThoseAsUnreadable

	"#118: the last object of the heap overwritten, in the memory once loaded, into an Array whose
	slot count runs past the end of the memory. A slot past that end stands as unreadable, in its
	place, where VMMaker says only that it has no such key."

	| victim memory object slots |
	memory := DamagedCandleImage readingPokedWith: [ :clean |
		          | arrayTag |
		          clean allOldSpaceObjectsDo: [ :each | victim := each ].
		          self assert: (clean numSlotsOf: victim) >= 255 description: 'its slot count is in the word before its header'.
		          arrayTag := (clean oopClassNamed: 'PCArray') instancesOop first oopClassTag.
		          {
			          (victim - 8 -> ((255 bitShift: 56) + 20000)).
			          (victim -> ((255 bitShift: 56) + (2 bitShift: 24) + arrayTag)) } ].
	object := memory reifyOop: victim.
	slots := object allReifiedSlots.

	self assert: slots size equals: 20000.
	self assert: slots last isUnreadableSlot.
	self assert: (memory readSlot: 20000 of: object ifUnreadable: [ #unreadable ]) equals: #unreadable.
	self should: [ object reifiedSlotAt: 20000 ] raise: NotInTheReading
