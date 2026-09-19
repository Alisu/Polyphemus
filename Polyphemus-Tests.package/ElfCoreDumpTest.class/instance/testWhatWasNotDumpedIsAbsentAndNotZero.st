tests
testWhatWasNotDumpedIsAbsentAndNotZero

	"Past what was written of a region, the dump does not say what was there. Answering zero, or
	the next region's byte, would be inventing memory."

	| dump |
	dump := ElfCoreDump on: dumpFile.

	self assert: (dump byteAt: 16r7F000027F) equals: 16rCC.
	self assert: (dump byteAt: 16r7F0000280) isNil.
	self assert: (dump hasAddress: 16r7F000027F).
	self deny: (dump hasAddress: 16r7F0000280)
