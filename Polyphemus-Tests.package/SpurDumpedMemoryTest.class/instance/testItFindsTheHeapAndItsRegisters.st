tests
testItFindsTheHeapAndItsRegisters

	"Nothing in a dump names any of these. The heap is found by shape, its live end by
	walking it, and the special objects array by its contents."

	self assert: dumped heapStart isNotNil.
	self assert: dumped specialObjectsOop isNotNil.
	self assert: dumped liveEnd > dumped heapStart.
	self assert: dumped specialObjectsOop > dumped heapStart
