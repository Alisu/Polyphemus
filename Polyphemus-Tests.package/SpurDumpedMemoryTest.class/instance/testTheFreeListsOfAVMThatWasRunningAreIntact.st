tests
testTheFreeListsOfAVMThatWasRunningAreIntact

	"Stepping over every object and following the allocator's lists count the same free space,
	so a VM that was running normally needs no rebuild -- and no write to the evidence."

	| byTheHeap byTheLists |
	byTheHeap := dumped raw heapWalk.
	byTheLists := dumped raw freeListWalk.

	self assert: byTheLists problems asArray equals: #(  ).
	self assert: byTheLists chunkCount equals: byTheHeap freeChunkCount.
	self assert: byTheLists bytes equals: byTheHeap freeBytes.
	self assert: dumped raw freeListsAreIntact
