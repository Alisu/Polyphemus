tests
testTheFreeListsOfAVMThatWasRunningAreIntact

	"Two ways of counting the free space -- stepping over every object, and following the
	allocator's own lists -- arriving at the same number.

	This is what says whether the lists need rebuilding. On a VM that was running normally
	there is nothing to rebuild, and rebuilding regardless would mean writing to the
	evidence for no reason at all."

	| byTheHeap byTheLists |
	byTheHeap := dumped raw heapWalk.
	byTheLists := dumped raw freeListWalk.

	self assert: byTheLists problems asArray equals: #(  ).
	self assert: byTheLists chunkCount equals: byTheHeap freeChunkCount.
	self assert: byTheLists bytes equals: byTheHeap freeBytes.
	self assert: dumped raw freeListsAreIntact
