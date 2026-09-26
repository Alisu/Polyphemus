*Polyphemus-Edition-Pharo10
placeSpacesIn: aMemory freeLists: aFreeListsObject
	"VMMaker v10.0.0 lays new space from the heap's base with old space after it, sized by
	eden: eden is sized so that its arithmetic puts old space on the heap."

	aMemory memory: raw mappingStart.
	self setWhatVMMakerHasNoSetterFor: aMemory freeLists: aFreeListsObject.
	aMemory edenBytes: raw heapStart - raw mappingStart
		- aMemory coInterpreter interpreterAllocationReserveBytes.
	aMemory
		setHeapBase: raw mappingStart
		memoryLimit: raw mappingLimit
		endOfMemory: raw liveEnd
