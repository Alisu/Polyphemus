building the memory
setRegistersOf: aMemory

	"What the image header would have told the VM, worked out from the heap instead.

	`initializeObjectMemory:` is the VM's own version of this, and it is not called: it
	writes a segment bridge, rebuilds the free lists and starts the collector's machinery,
	all of which mutate the memory being read. What it does do is confirm the layout this
	relies on -- it asserts that nil, false and true are the first three objects and that
	the free lists and the hidden roots follow them, which is exactly how they are found
	here."

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
