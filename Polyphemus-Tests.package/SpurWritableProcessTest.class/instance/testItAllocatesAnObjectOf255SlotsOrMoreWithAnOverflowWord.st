tests
testItAllocatesAnObjectOf255SlotsOrMoreWithAnOverflowWord

	"Its header's count says 255, the real one in the word before the header; the object starts
	after that word, which is part of it."

	| object |
	process storeWord: 16r12000 at: 16r10000 + (9 * 8).
	object := memory allocateSlots: 300 format: 2 classIndex: 51.
	self assert: object equals: 16r11108.
	self assert: ((memory wordAt: object) bitShift: -56) equals: 255.
	self assert: (memory numSlotsOf: object) equals: 300.
	self assert: (memory classIndexOf: object) equals: 51.
	self assert: (memory variables at: 'pastSpaceStart') equals: 16r11100 + 16 + (300 * 8)
