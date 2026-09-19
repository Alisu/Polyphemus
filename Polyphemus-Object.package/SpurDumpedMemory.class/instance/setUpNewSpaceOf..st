building the memory
setUpNewSpaceOf: aMemory

	"Give new space the VM's geometry and declare it empty: eden's fill level is not in a
	dump. Young objects come from #youngObjectsWalk instead."

	aMemory scavenger
		newSpaceStart: mappingStart
		newSpaceBytes: heapStart - mappingStart
		survivorBytes: heapStart - mappingStart // aMemory scavengerDenominator.
	aMemory instVarNamed: 'freeStart' put: aMemory scavenger eden start.
	aMemory instVarNamed: 'pastSpaceStart' put: aMemory scavenger pastSpace start
