tests
testEmptyMemoryIsNotAHeap

	"Zeros have the class index of free space; they are neither objects nor free chunks, and a walk
	stops at the first, saying so (#211). Untouched memory is not the most convincing heap in a dump."

	| space walk |
	space := ByteArrayAddressSpace
		         on: (ByteArray new: 65536)
		         at: self baseAddress.
	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + 65536.

	self assert: walk objectCount equals: 0.
	self assert: walk freeChunkCount equals: 0.
	self assert: walk reason equals: #zeroedMemory.
	self deny: ((SpurHeapScanner on: space)
			 looksLikeAHeapFrom: self baseAddress
			 upTo: self baseAddress + 65536)
