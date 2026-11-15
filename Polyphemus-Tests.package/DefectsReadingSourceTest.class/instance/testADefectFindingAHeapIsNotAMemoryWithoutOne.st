tests
testADefectFindingAHeapIsNotAMemoryWithoutOne
	<readsAnUnsoundHeap>

	"#118: a memory in which no heap is found fails the heap rung, and an address is in no new
	space of it. A bug of our own looking for the heap is neither: here the bytes fail to read."

	| space |
	space := self defective: (ByteArrayAddressSpace on: (ByteArray new: 4096) at: 16r10000) in: #bytesAt:count:.

	self should: [ (SpurRawHeap on: space from: 16r10000 to: 16r11000) readability canRead: #heap ] raise: ZeroDivide.
	self should: [ (SpurRawHeap on: space from: 16r10000 to: 16r11000) isInNewSpace: 16r10008 ] raise: ZeroDivide
