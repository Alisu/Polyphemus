tests
testAWordNotWhollyHereIsNotRead

	"#152: read straight from the bytes, a word must still be all there or not read at all."

	| space |
	space := ByteArrayAddressSpace on: #[ 1 2 3 4 5 6 7 8 9 ] at: 16r1000.
	self assert: (space unsignedAt: 16r1002 size: 8) isNil.
	self assert: (space unsignedAt: 16r0FFF size: 8) isNil.
	self assert: (space unsignedAt: 16r1009 size: 1) isNil
