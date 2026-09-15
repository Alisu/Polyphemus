tests
testAnAddressNoRegionHeldIsAbsent

	| dump |
	dump := ElfCoreDump on: dumpFile.

	self assert: (dump byteAt: 16r123456) isNil.
	self deny: (dump hasAddress: 16r123456)
