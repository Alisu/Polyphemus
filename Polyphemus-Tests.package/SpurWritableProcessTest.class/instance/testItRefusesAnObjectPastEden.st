tests
testItRefusesAnObjectPastEden

	self should: [ memory allocateSlots: 1100 format: 2 classIndex: 51 ] raise: Error.
	self assert: (memory variables at: 'freeStart') equals: 16r11000
