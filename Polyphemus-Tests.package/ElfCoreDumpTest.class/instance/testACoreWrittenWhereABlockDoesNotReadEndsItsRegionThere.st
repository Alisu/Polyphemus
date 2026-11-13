tests
testACoreWrittenWhereABlockDoesNotReadEndsItsRegionThere

	"#182: a block that did not read was written as zeros, the region at its full size in the
	header; a reader took the zeros for memory. The region ends in the file where reading did."

	<readsAnUnsoundHeap>
	| block regions base written dump |
	block := 4194304.
	base := 16r10000000.
	regions := RegionsDouble new.
	regions region: base bytes: (ByteArray new: block withAll: 16rAA) writable: false.
	regions region: base + (2 * block) bytes: (ByteArray new: block withAll: 16rBB) writable: false.
	written := PolyphemusEdition current scratch / 'polyphemus-test-written.core'.
	(ElfCoreWriter on: regions)
		write: { (ElfCoreSegment ofProcessAt: base size: 3 * block) }
		to: written.
	dump := ElfCoreDump on: written.

	self assert: (dump unsignedAt: base + block - 8 size: 8) equals: 16rAAAAAAAAAAAAAAAA.
	self deny: (dump hasAddress: base + block).
	self deny: (dump hasAddress: base + (2 * block))