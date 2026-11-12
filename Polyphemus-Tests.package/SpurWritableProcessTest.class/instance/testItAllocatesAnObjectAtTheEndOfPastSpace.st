tests
testItAllocatesAnObjectAtTheEndOfPastSpace

	"#137, #167: after the survivors, where the VM makes nothing until it scavenges, and not at
	freeStart, which its own allocation holds in a register through a stop and writes back."

	| object |
	object := memory allocateSlots: 3 format: 2 classIndex: 51.
	self assert: object equals: 16r11100.
	self assert: (memory numSlotsOf: object) equals: 3.
	self assert: (memory classIndexOf: object) equals: 51.
	self assert: (memory variables at: 'pastSpaceStart') equals: 16r11100 + 8 + (3 * 8).
	self assert: (memory variables at: 'freeStart') equals: 16r12000
