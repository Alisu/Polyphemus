tests
testARegionOfARunningProcessIsReadWhereItsAddressIs

	"A process's memory is read at its addresses: a region's offset is its address, all of it there."

	| region |
	region := ElfCoreSegment ofProcessAt: 16r10000 size: 16r2000.
	self assert: region isLoadable.
	self assert: region address equals: 16r10000.
	self assert: region fileOffset equals: 16r10000.
	self assert: region sizeInFile equals: 16r2000.
	self assert: (region holdsAddress: 16r11FFF).
	self deny: (region holdsAddress: 16r12000)
