tests
testTheHeapSpansEveryMappingItGrewInto

	"A VM grows its heap into mappings right after the first. Stopping at one cuts off the end,
	where the free space is -- damage invisible until something asks about free space."

	| largest |
	largest := (ElfCoreDump on: self dumpFile) loadableSegments detectMax: [ :each |
		           each sizeInFile ].

	self assert: dumped raw mappingLimit > (largest address + largest sizeInFile).
	self assert: dumped raw liveEnd < dumped raw mappingLimit
