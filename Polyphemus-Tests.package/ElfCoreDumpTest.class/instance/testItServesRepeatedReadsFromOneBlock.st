tests
testItServesRepeatedReadsFromOneBlock

	"Nearby reads come from a block already in hand, which is what lets a heap walk finish.
	Caching must change no answer, including at a region's edges and past them."

	| dump |
	dump := ElfCoreDump on: dumpFile.

	16r7F0000000 to: 16r7F00001FF do: [ :address |
		self assert: (dump byteAt: address) equals: 16rBB ].

	self assert: (dump byteAt: 16r7F0000200) equals: 16rCC.
	self assert: (dump byteAt: 16r7F000027F) equals: 16rCC.
	self assert: (dump byteAt: 16r7F0000280) isNil.
	self assert: (dump unsignedAt: 16r7F0000000 size: 8) equals: 16rBBBBBBBBBBBBBBBB
