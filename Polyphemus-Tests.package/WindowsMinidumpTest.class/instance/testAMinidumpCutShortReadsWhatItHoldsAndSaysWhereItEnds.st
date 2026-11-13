tests
testAMinidumpCutShortReadsWhatItHoldsAndSaysWhereItEnds

	"#182: a minidump cut short, as an ELF core: what its ranges promise past the file's end is
	absent, not a short read that raises, and the dump says where it ends."

	| bytes dump |
	bytes := self minidumpBytes.
	dumpFile ensureDelete.
	dumpFile binaryWriteStreamDo: [ :stream | stream nextPutAll: (bytes copyFrom: 1 to: bytes size - 16r40) ].
	dump := WindowsMinidump on: dumpFile.

	self assert: (dump unsignedAt: 16r360000000 size: 8) equals: 16rBBBBBBBBBBBBBBBB.
	self assert: (dump hasAddress: 16r360000038).
	self deny: (dump hasAddress: 16r360000040).
	self assert: (dump bytesAt: 16r360000038 count: 16) isNil.
	self assert: (dump cutShort includesSubstring: '1 of its regions')