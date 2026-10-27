tests
testItAllocatesAnObjectInEden

	| object |
	object := memory allocateSlots: 3 format: 2 classIndex: 51.
	self assert: object equals: 16r11000.
	self assert: (memory numSlotsOf: object) equals: 3.
	self assert: (memory classIndexOf: object) equals: 51.
	self assert: (memory variables at: 'freeStart') equals: 16r11000 + 8 + (3 * 8)
