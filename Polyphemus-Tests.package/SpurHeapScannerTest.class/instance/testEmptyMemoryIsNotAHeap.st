tests
testEmptyMemoryIsNotAHeap

	"Zeros read as free chunk after free chunk, for as far as you care to walk. Counting those
	as objects would make untouched memory the most convincing heap in the dump."

	| space walk |
	space := ByteArrayAddressSpace
		         on: (ByteArray new: 65536)
		         at: self baseAddress.
	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + 65536.

	self assert: walk objectCount equals: 0.
	self assert: walk freeChunkCount > 100.
	self deny: ((SpurHeapScanner on: space)
			 looksLikeAHeapFrom: self baseAddress
			 upTo: self baseAddress + 65536)
