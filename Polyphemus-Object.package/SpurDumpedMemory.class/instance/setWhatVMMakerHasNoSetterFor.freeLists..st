building the memory
setWhatVMMakerHasNoSetterFor: aMemory freeLists: aFreeListsObject

	"VMMaker only sets these inside initializeObjectMemory:, which writes to the memory, so
	they are written directly -- here and nowhere else. A newer VMMaker should be checked here."

	aMemory instVarNamed: 'nilObj' put: raw heapStart.
	aMemory instVarNamed: 'falseObj' put: raw heapStart + 16.
	aMemory instVarNamed: 'trueObj' put: raw heapStart + 32.
	aMemory
		instVarNamed: 'freeLists'
		put: (aMemory firstIndexableField: aFreeListsObject).
	aMemory instVarNamed: 'freeListsMask' put: 0
