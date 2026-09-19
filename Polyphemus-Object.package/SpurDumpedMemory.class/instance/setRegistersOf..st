building the memory
setRegistersOf: aMemory

	"Set the registers an image header would supply, derived from the heap.
	initializeObjectMemory: is not called because it writes to the memory."

	| freeListsObject |
	aMemory memory: mappingStart.
	aMemory instVarNamed: 'newSpaceStart' put: mappingStart.
	aMemory instVarNamed: 'newSpaceLimit' put: heapStart.
	aMemory instVarNamed: 'oldSpaceStart' put: heapStart.
	aMemory instVarNamed: 'freeOldSpaceStart' put: liveEnd.
	aMemory instVarNamed: 'endOfMemory' put: mappingLimit.
	aMemory instVarNamed: 'nilObj' put: heapStart.
	aMemory instVarNamed: 'falseObj' put: heapStart + 16.
	aMemory instVarNamed: 'trueObj' put: heapStart + 32.
	aMemory instVarNamed: 'lastHash' put: 1.
	aMemory specialObjectsOop: specialObjectsOop.

	freeListsObject := self scanner objectAfter: heapStart + 32.
	"#setHiddenRootsObj: checks the class table it finds: that the first page is the right
	 size and that the root pages are valid. It is the VM auditing our reconstruction."
	aMemory setHiddenRootsObj: (self scanner objectAfter: freeListsObject).
	aMemory
		instVarNamed: 'freeLists'
		put: (aMemory firstIndexableField: freeListsObject).
	aMemory instVarNamed: 'freeListsMask' put: 0.
	self setUpNewSpaceOf: aMemory
