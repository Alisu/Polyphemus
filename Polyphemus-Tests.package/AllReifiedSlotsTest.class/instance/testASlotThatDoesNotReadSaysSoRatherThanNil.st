tests
testASlotThatDoesNotReadSaysSoRatherThanNil

	"#118: a slot that did not read was answered as nil, which the inspector and the debugger then
	showed as a real nil. It stands as unreadable, in its place, saying why."

	| slots |
	slots := OOPObjectWithASlotThatDoesNotRead new allReifiedSlots.
	self assert: slots size equals: 3.
	self assert: slots first equals: 1.
	self assert: slots last equals: 3.
	self assert: (slots at: 2) isUnreadableSlot.
	self deny: (slots at: 2) isNilOop.
	self assert: (slots at: 2) index equals: 2.
	self assert: ((slots at: 2) printString includesSubstring: 'its word points nowhere')
