tests
testTheHeapSpansEveryMappingItGrewInto

	"A VM grows its heap into mappings right after the first. Stopping at one cuts off the end,
	where the free space is -- damage invisible until something asks about free space. So no
	mapping starts where ours stops: it would have been one the heap grew into."

	| segments |
	segments := (ElfCoreDump on: self dumpFile) loadableSegments.
	self deny: (segments anySatisfy: [ :each |
			 each address = dumped raw mappingLimit and: [ each sizeInFile > 0 ] ]).
	self assert: dumped raw liveEnd < dumped raw mappingLimit
