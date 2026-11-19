tests
testAnUnsignedIntegerIsReadLowestByteFirst

	| bytes |
	bytes := #[ 16rFF 16r78 16r56 16r34 16r12 16rEF 16rCD 16rAB 16r90 ].
	self assert: (LittleEndian unsignedIn: bytes from: 1 size: 1) equals: 16rFF.
	self assert: (LittleEndian unsignedIn: bytes from: 2 size: 2) equals: 16r5678.
	self assert: (LittleEndian unsignedIn: bytes from: 2 size: 4) equals: 16r12345678.
	self assert: (LittleEndian unsignedIn: bytes from: 2 size: 8) equals: 16r90ABCDEF12345678
