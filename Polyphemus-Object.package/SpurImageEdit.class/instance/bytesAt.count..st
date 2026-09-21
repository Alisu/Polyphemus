editing
bytesAt: anAddress count: aCount

	"The bytes the file holds there, as the heap addresses them."

	^ (1 to: aCount) collect: [ :each |
		  self raw space unsignedAt: anAddress + each - 1 size: 1 ]
