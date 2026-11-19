tests
testTheBytesOfAnIntegerReadBackAsIt

	self assert: (LittleEndian bytesOf: 16r12345678 size: 4) equals: #[ 16r78 16r56 16r34 16r12 ].
	self assert: (LittleEndian bytesOf: -2 size: 4) equals: #[ 16rFE 16rFF 16rFF 16rFF ].
	self assert: (LittleEndian bytesOf: 16r1FF size: 1) equals: #[ 16rFF ].
	#( 0 1 16rFFFFFFFFFFFFFFFF 16r8000000000000000 ) do: [ :each |
		self assert: (LittleEndian unsignedIn: (LittleEndian bytesOf: each size: 8) from: 1 size: 8) equals: each ]
