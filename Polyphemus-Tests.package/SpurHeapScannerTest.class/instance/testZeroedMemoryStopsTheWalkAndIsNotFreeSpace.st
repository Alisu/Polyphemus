tests
testZeroedMemoryStopsTheWalkAndIsNotFreeSpace

	"#211: a header of zero has the class index of free space, and was stepped over as a free chunk
	of two words: a wiped page then walked to its end as a sound heap. No free chunk of a sound
	heap has a header of zero (none among 925,184 stepped in a real core): it is damage, and said."

	| specs space walk |
	specs := self aFewObjects , #( #( 18 2 1 ) #( 0 0 0 ) #( 0 0 0 ) #( 18 2 1 ) ).
	space := self spaceFor: specs.
	walk := (SpurHeapScanner on: space) walkFrom: self baseAddress upTo: self baseAddress + space size.

	self assert: walk reason equals: #zeroedMemory.
	self assert: walk stoppedAt equals: ((self addressesOf: specs) at: self aFewObjects size + 2) key.
	self assert: walk freeChunkCount equals: 0
