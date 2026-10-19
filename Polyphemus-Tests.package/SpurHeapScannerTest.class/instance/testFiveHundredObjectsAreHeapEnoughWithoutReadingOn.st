tests
testFiveHundredObjectsAreHeapEnoughWithoutReadingOn

	"Five hundred live objects in a row are a heap: looking for more read every object to the
	end, which made each reading walk its whole heap twice. Past them, memory that refuses."

	| bytes space |
	bytes := self heapBytesFor: ((1 to: 500) collect: [ :index | { 17. 1. index \\ 4 + 1 } ]).
	space := SplitAddressSpace withAll: {
			         (ByteArrayAddressSpace on: bytes at: self baseAddress).
			         (TripwireAddressSpace from: self baseAddress + bytes size size: 4096) }.

	self assert: ((SpurHeapScanner on: space)
			 looksLikeAHeapFrom: self baseAddress
			 upTo: self baseAddress + bytes size + 4096)
