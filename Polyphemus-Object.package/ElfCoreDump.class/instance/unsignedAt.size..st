reading
unsignedAt: anAddress size: aCount

	"A little endian unsigned integer read out of the dump, or nil when it is not there."

	^ (self bytesAt: anAddress count: aCount) ifNotNil: [ :bytes |
		  self unsignedFrom: bytes at: 1 size: aCount ]
