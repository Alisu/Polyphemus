tests
testADefectReadingASlotIsNotASlotThatDoesNotRead

	"#118: a bug of our own while a slot was read stood as a slot that does not read."

	| defective memory |
	defective := OOPObjectWithASlotThatDoesNotRead new
		             failingWith: [ 1 / 0 ];
		             yourself.
	memory := FullyReifiedMemory new.

	self should: [ defective allReifiedSlots ] raise: ZeroDivide.
	self should: [ memory readSlot: 2 of: defective ifUnreadable: [ #unreadable ] ] raise: ZeroDivide.
	self
		assert: (memory readSlot: 2 of: OOPObjectWithASlotThatDoesNotRead new ifUnreadable: [ #unreadable ])
		equals: #unreadable
