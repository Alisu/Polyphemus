tests
testTheVMAcceptsTheMemoryWeBuild

	"The registers are not merely set, they are checked by their owner: #setHiddenRootsObj:
	validates the class table it is given, and would fail on a memory we had described
	wrongly. Reaching a class through the table is the proof it is right."

	| memory |
	memory := dumped memory.

	self assert: memory oldSpaceStart equals: dumped raw heapStart.
	self assert: memory specialObjectsOop equals: dumped raw specialObjectsOop.
	"An object's class index is its class's hash: 3075 for nil in the older images, 2051 in Pharo 14's."
	self
		assert: (memory classIndexOf: memory nilObject)
		equals: (memory rawHashBitsOf: (memory fetchClassOfNonImm: memory nilObject)).
	self assert: (memory fetchClassOfNonImm: memory nilObject) > memory oldSpaceStart
