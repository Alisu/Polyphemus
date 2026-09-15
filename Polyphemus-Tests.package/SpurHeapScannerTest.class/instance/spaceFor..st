building a heap
spaceFor: aCollectionOfSpecs

	^ ByteArrayAddressSpace
		  on: (self heapBytesFor: aCollectionOfSpecs)
		  at: self baseAddress
