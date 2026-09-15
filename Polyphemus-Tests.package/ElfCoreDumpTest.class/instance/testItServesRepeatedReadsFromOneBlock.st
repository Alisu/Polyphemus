tests
testItServesRepeatedReadsFromOneBlock

	"Reads near each other come from a block already in hand rather than from the file. A heap
	walk is nothing but such reads -- a few words per object, millions of objects, always
	forwards -- so this is the difference between a walk that finishes and one that does not.

	What has to be true is that caching changes nothing about the answers, including at the
	edges of a region and past them."

	| dump |
	dump := ElfCoreDump on: dumpFile.

	16r7F0000000 to: 16r7F00001FF do: [ :address |
		self assert: (dump byteAt: address) equals: 16rBB ].

	self assert: (dump byteAt: 16r7F0000200) equals: 16rCC.
	self assert: (dump byteAt: 16r7F000027F) equals: 16rCC.
	self assert: (dump byteAt: 16r7F0000280) isNil.
	self assert: (dump unsignedAt: 16r7F0000000 size: 8) equals: 16rBBBBBBBBBBBBBBBB
