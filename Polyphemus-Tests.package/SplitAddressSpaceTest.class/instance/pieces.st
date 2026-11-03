building
pieces

	"Three pieces of 64 bytes, far apart, each byte its offset in the piece plus the piece's number
	times 64."

	^ (0 to: 2) collect: [ :number |
		  CountingAddressSpace on: (ByteArrayAddressSpace
				   on: ((1 to: 64) collect: [ :each | number * 64 + each - 1 ]) asByteArray
				   at: 16r10000 + (number * 16r100000)) ]
