tests
testACoreCutShortReadsWhatItHoldsAndSaysWhereItEnds

	"#182: a core cut short (a full disk, a ulimit) read fewer bytes than its header promised, and
	the word read from them raised. Past the cut is absent, as what was not written, and said."

	<readsAnUnsoundHeap>
	| bytes dump |
	bytes := self coreBytes.
	dumpFile ensureDelete.
	dumpFile binaryWriteStreamDo: [ :stream | stream nextPutAll: (bytes copyFrom: 1 to: 64 + (3 * 56) + 16r100 + 16r100) ].
	dump := ElfCoreDump on: dumpFile.

	self assert: (dump unsignedAt: 16r7F0000000 size: 8) equals: 16rBBBBBBBBBBBBBBBB.
	self assert: (dump hasAddress: 16r7F00000F8).
	self deny: (dump hasAddress: 16r7F0000100).
	self assert: (dump bytesAt: 16r7F00000F8 count: 16) isNil.
	self deny: (dump hasAddress: 16r7F0000200).
	self assert: (dump cutShort includesSubstring: '2 of its regions').
	self assert: ((SpurRawHeap on: dump) readability reasonFor: #heap) equals: #itsFileIsCutShort.
	self assert: ((SpurRawHeap on: (ElfCoreDump on: self wholeCore)) readability reasonFor: #heap) equals: #noSpurHeapHere