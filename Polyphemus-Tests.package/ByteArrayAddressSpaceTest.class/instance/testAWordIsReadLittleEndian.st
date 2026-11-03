tests
testAWordIsReadLittleEndian

	| space |
	space := ByteArrayAddressSpace on: #[ 1 2 3 4 5 6 7 8 255 ] at: 16r1000.
	self assert: (space unsignedAt: 16r1000 size: 8) equals: 16r0807060504030201.
	self assert: (space unsignedAt: 16r1001 size: 8) equals: 16rFF08070605040302.
	self assert: (space unsignedAt: 16r1008 size: 1) equals: 255
