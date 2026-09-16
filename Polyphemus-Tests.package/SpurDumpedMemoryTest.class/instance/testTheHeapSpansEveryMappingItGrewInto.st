tests
testTheHeapSpansEveryMappingItGrewInto

	"A VM takes its heap in one mapping and grows it by asking for more memory immediately
	after. Stopping at the largest mapping cuts the end off the heap -- and the end is where
	the allocator keeps the space it has not handed out, so the damage is invisible until
	something asks about free space."

	| largest |
	largest := (ElfCoreDump on: self dumpFile) loadableSegments detectMax: [ :each |
		           each sizeInFile ].

	self assert: dumped mappingLimit > (largest address + largest sizeInFile).
	self assert: dumped liveEnd < dumped mappingLimit
