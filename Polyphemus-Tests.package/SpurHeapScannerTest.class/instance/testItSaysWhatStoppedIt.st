tests
testItSaysWhatStoppedIt

	"A walk that stops is more useful when it says why. A class index of zero is the commonest
	thing to land on -- zeroed memory -- and it is not the same failure as a header that
	claims an object longer than the region holding it."

	| bytes space walk |
	bytes := self heapBytesFor: { #( 17 1 1 ). #( 18 1 1 ) }.
	bytes at: 17 put: 0; at: 18 put: 0; at: 19 put: 0.

	space := ByteArrayAddressSpace on: bytes at: self baseAddress.
	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + bytes size.

	self assert: walk objectCount equals: 1.
	self assert: walk reason equals: #classIndexOfZero.
	self deny: walk reachedTheLimit
