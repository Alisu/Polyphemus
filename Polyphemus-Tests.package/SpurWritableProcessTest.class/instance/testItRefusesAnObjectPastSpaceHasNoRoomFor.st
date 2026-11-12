tests
testItRefusesAnObjectPastSpaceHasNoRoomFor

	self should: [ memory allocateSlots: 300 format: 2 classIndex: 51 ] raise: NotInTheReading.
	self assert: (memory variables at: 'pastSpaceStart') equals: 16r11100
