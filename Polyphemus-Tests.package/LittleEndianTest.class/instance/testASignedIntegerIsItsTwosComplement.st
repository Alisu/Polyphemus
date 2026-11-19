tests
testASignedIntegerIsItsTwosComplement

	self assert: (LittleEndian signedIn: #[ 16rFE 16rFF 16rFF 16rFF ] from: 1 size: 4) equals: -2.
	self assert: (LittleEndian signedIn: #[ 16rFF 16rFF 16rFF 16r7F ] from: 1 size: 4) equals: 16r7FFFFFFF.
	self assert: (LittleEndian signedIn: #[ 0 16r80 ] from: 1 size: 2) equals: -32768
