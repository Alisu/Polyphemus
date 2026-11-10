tests
testItReadsTheFieldsOfAHeaderItMade

	| header |
	header := SpurHeader headerFor: 5 format: 9 classIndex: 3.
	self assert: header equals: (5 bitShift: 56) + (9 bitShift: 24) + 3.
	self assert: (SpurHeader slotCountOf: header) equals: 5.
	self assert: (SpurHeader formatOf: header) equals: 9.
	self assert: (SpurHeader classIndexOf: header) equals: 3
