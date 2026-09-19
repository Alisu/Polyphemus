tests
testTheVMAcceptsTheMemoryWeBuild

	"The registers are not merely set, they are checked by their owner: #setHiddenRootsObj:
	validates the class table it is given, and would fail on a memory we had described
	wrongly. Reaching a class through the table is the proof it is right."

	| memory |
	memory := dumped memory.

	self assert: memory oldSpaceStart equals: dumped raw heapStart.
	self assert: memory specialObjectsOop equals: dumped raw specialObjectsOop.
	self assert: (memory classIndexOf: memory nilObject) equals: 3075.
	self assert: (memory fetchClassOfNonImm: memory nilObject) > memory oldSpaceStart
