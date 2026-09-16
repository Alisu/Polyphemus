building the memory
setUpNewSpaceOf: aMemory

	"New space gets the geometry the VM would have given it, and is then declared empty.

	How much of eden was in use is a variable of the VM's C state, not a fact about the
	heap, so a dump does not carry it. Reading past the last live object there would
	invent objects out of whatever the allocator had not overwritten yet, so nothing is
	enumerated in new space at all.

	Young objects are still perfectly readable one at a time -- in the dump we test
	against, the *running process itself* is one of them. They are simply missing from
	the answers to enumerating questions, which is a limitation to state rather than to
	paper over."

	aMemory scavenger
		newSpaceStart: mappingStart
		newSpaceBytes: heapStart - mappingStart
		survivorBytes: heapStart - mappingStart // aMemory scavengerDenominator.
	aMemory instVarNamed: 'freeStart' put: aMemory scavenger eden start.
	aMemory instVarNamed: 'pastSpaceStart' put: aMemory scavenger pastSpace start
