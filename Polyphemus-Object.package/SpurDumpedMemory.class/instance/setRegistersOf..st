building the memory
setRegistersOf: aMemory

	"The registers an image header would supply, worked out from the heap and set through
	VMMaker's own setters. Eden is sized so that its arithmetic puts old space on the heap."

	| freeListsObject |
	freeListsObject := raw scanner objectAfter: raw heapStart + 32.
	aMemory memory: raw mappingStart.
	self setWhatVMMakerHasNoSetterFor: aMemory freeLists: freeListsObject.
	aMemory edenBytes: raw heapStart - raw mappingStart
		- aMemory coInterpreter interpreterAllocationReserveBytes.
	aMemory
		setHeapBase: raw mappingStart
		memoryLimit: raw mappingLimit
		endOfMemory: raw liveEnd.
	aMemory lastHash: 1.
	aMemory specialObjectsOop: raw specialObjectsOop.
	aMemory setHiddenRootsObj: (raw scanner objectAfter: freeListsObject)
