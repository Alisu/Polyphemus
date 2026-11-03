tests
testEachReadIsAnsweredByThePieceHoldingIt

	"#152: reads going back and forth between pieces each get their own piece's bytes."

	| space |
	space := SplitAddressSpace withAll: self pieces.
	self assert: (space unsignedAt: 16r10000 + (2 * 16r100000) size: 1) equals: 128.
	self assert: (space unsignedAt: 16r10000 + 1 size: 2) equals: 16r0201.
	self assert: (space unsignedAt: 16r10000 + 16r100000 + 63 size: 1) equals: 127.
	self assert: (space bytesAt: 16r10000 + 16r100000 + 62 count: 2) equals: #[ 126 127 ].
	self assert: (space unsignedAt: 16r10000 + 16r100000 + 63 size: 2) isNil.
	self assert: (space unsignedAt: 16r10000 + 64 size: 1) isNil.
	self deny: (space hasAddress: 16r10000 + 64).
	self assert: (space hasAddress: 16r10000 + (2 * 16r100000))
