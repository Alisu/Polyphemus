tests
testACountOf255OrMoreIsInTheWordBefore

	| header word |
	header := SpurHeader headerFor: 300 format: 2 classIndex: 51.
	self assert: (SpurHeader slotCountOf: header) equals: 255.
	self assert: (SpurHeader overflowsItsSlotCount: header).
	self deny: (SpurHeader overflowsItsSlotCount: (SpurHeader headerFor: 254 format: 2 classIndex: 51)).
	word := SpurHeader overflowWordFor: 300.
	self assert: (word bitShift: -56) equals: 255.
	self assert: (SpurHeader countInOverflowWord: word) equals: 300
