tests
testAnAddressNoRangeHeldIsAbsent

	| dump |
	dump := WindowsMinidump on: dumpFile.
	self deny: (dump hasAddress: 16r10000000100).
	self assert: (dump byteAt: 16r35FFFFFFF) isNil
