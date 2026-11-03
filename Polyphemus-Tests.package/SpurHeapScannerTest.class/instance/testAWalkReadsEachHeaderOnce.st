tests
testAWalkReadsEachHeaderOnce

	"#152: a walk over millions of objects is as slow as its reads. One read per header, and a
	few more for an overflow word or a candidate special objects array."

	| space walk |
	space := CountingAddressSpace on: (self spaceFor: self aFewObjects).
	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + (self heapBytesFor: self aFewObjects) size.

	self assert: walk objectCount equals: self aFewObjects size.
	self assert: space reads <= (self aFewObjects size * 2)
