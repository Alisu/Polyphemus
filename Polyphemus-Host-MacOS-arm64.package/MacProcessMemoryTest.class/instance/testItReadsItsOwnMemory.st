tests
testItReadsItsOwnMemory

	| bytes reader |
	bytes := self sixteenBytes.
	reader := MacProcessMemory onSelf.
	self assert: (reader bytesAt: bytes asInteger count: 16) asArray equals: (1 to: 16) asArray.
	self assert: (reader unsignedAt: bytes asInteger size: 2) equals: 16r0201.
	bytes free
