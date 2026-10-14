tests
testAnAddressIsReadFromTheRangeThatHeldIt

	| dump |
	dump := WindowsMinidump on: dumpFile.
	self assert: (dump byteAt: 16r10000000000) equals: 16rAA.
	self assert: (dump byteAt: 16r100000000FF) equals: 16rAA.
	self assert: (dump byteAt: 16r360000000) equals: 16rBB.
	self assert: (dump unsignedAt: 16r360000078 size: 8) equals: 16rBBBBBBBBBBBBBBBB
