accessing
sourcePointer

	^ (bytes size - 4 to: bytes size) inject: 0 into: [ :pointer :each |
		  pointer << 8 + (bytes at: each) ]
