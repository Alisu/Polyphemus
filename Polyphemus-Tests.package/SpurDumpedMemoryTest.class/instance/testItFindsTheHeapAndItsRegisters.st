tests
testItFindsTheHeapAndItsRegisters

	"Nothing in a dump names any of these. The heap is found by shape, its live end by
	walking it, and the special objects array by its contents."

	self assert: dumped raw heapStart isNotNil.
	self assert: dumped raw specialObjectsOop isNotNil.
	self assert: dumped raw liveEnd > dumped raw heapStart.
	self assert: dumped raw specialObjectsOop > dumped raw heapStart
